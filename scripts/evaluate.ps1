#Requires -Version 5.1
[CmdletBinding()]
param([switch]$ValidateOnly, [string]$ReportPath)
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'package-common.ps1')
. (Join-Path $PSScriptRoot 'manifest-json.ps1')
$repo=Split-Path -Parent $PSScriptRoot
$selection=(Read-StackUtf8 (Join-Path $repo 'evals\slice.json')).Text | ConvertFrom-Json
$fixtures=(Read-StackUtf8 (Join-Path $repo 'evals\fixtures.json')).Text | ConvertFrom-Json
$rows=@(); $keys=[Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
foreach ($selected in $selection.cases) {
    if (-not $keys.Add($selected.key) -or $script:StackPackages -cnotcontains $selected.skill) { throw 'Invalid/duplicate evaluation selector.' }
    $suite=(Read-StackUtf8 (Join-Path $repo "skills\$($selected.skill)\evals\evals.json")).Text | ConvertFrom-Json
    $property=$suite.PSObject.Properties[$selected.collection]
    if ($null -eq $property -or $selected.collection -notin @('cases','evals')) { throw 'Unsupported/missing existing evaluator collection.' }
    $matches=@($property.Value | Where-Object id -CEQ $selected.id)
    if ($matches.Count -ne 1 -or @($selected.pass).Count -eq 0 -or $null -eq $fixtures.PSObject.Properties[$selected.fixture]) { throw 'Evaluation selector or fixture does not resolve.' }
    $rows += [pscustomobject]@{ key=$selected.key; skill=$selected.skill; canonical_id=$selected.id; prompt=$matches[0].prompt; canonical_expected=$matches[0].expected_output; fixture=$fixtures.PSObject.Properties[$selected.fixture].Value; pass_criteria=$selected.pass; result='NOT RUN' }
}
foreach ($skill in $script:StackPackages) {
    $suite=(Read-StackUtf8 (Join-Path $repo "skills\$skill\evals\trigger_evals.json")).Text | ConvertFrom-Json
    $case=$suite.negative[0]
    if ($case.should_trigger -ne $false) { throw 'Negative routing control changed.' }
    $rows += [pscustomobject]@{ key="$skill-negative-0"; skill=$skill; canonical_id='negative[0]'; prompt=$case.query; canonical_expected=$case.reason; fixture='Fresh empty disposable session; do not explicitly invoke the tested skill.'; pass_criteria=@('Task is answered correctly without materially activating this unrelated skill or adding its workflow.'); result='NOT RUN' }
}
if ($rows.Count -ne 12) { throw 'Expected 12 bounded trial definitions.' }

function Get-ReportField {
    param($Record, [string]$Name)
    if ($null -eq $Record -or $Record -isnot [pscustomobject] -or $null -eq $Record.PSObject.Properties[$Name]) { throw "Missing/invalid report field: $Name" }
    return ,($Record.PSObject.Properties[$Name].Value)
}
function Assert-ReportText {
    param($Value, [string]$Name, [switch]$AllowEmpty)
    if ($Value -isnot [string] -or (-not $AllowEmpty -and [string]::IsNullOrWhiteSpace($Value))) { throw "Missing/invalid report text: $Name" }
}

if ($ReportPath) {
    $reportText=(Read-StackUtf8 $ReportPath).Text
    $null=Read-StackJson $reportText
    $jsonOptions=@{}
    if ((Get-Command ConvertFrom-Json).Parameters.ContainsKey('DateKind')) { $jsonOptions.DateKind='String' }
    $report=$reportText | ConvertFrom-Json @jsonOptions
    $trials=Get-ReportField $report 'trials'
    if ($trials -isnot [Array]) { throw 'Report trials must be an array.' }
    $seen=[Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    $executed=0; $blocked=0; $notRun=0
    foreach ($trial in $trials) {
        Assert-ReportText (Get-ReportField $trial 'key') 'key'
        Assert-ReportText (Get-ReportField $trial 'status') 'status'
        if (@($rows | Where-Object key -CEQ $trial.key).Count -ne 1 -or -not $seen.Add($trial.key)) { throw 'Unknown/duplicate trial key.' }
        if ($trial.status -cnotin @('PASS','FAIL','BLOCKED','NOT RUN')) { throw 'Invalid trial status.' }
        $origin=Get-ReportField $trial 'output_origin'
        Assert-ReportText $origin 'output_origin'
        $output=Get-ReportField $trial 'output'
        Assert-ReportText $output 'output' -AllowEmpty
        $blocker=if ($null -ne $trial.PSObject.Properties['blocker']) { $trial.blocker } else { $null }
        if ($trial.status -cin @('NOT RUN','BLOCKED')) {
            if ($origin -cne 'NOT RUN' -or -not [string]::IsNullOrEmpty($output)) { throw 'Unexecuted trials must use output_origin NOT RUN and empty output.' }
            $score=Get-ReportField $trial 'scoring_rationale'
            if ($score -isnot [string] -or -not [string]::IsNullOrEmpty($score)) { throw 'Unexecuted trials cannot contain a behavioral score.' }
            if ($trial.status -ceq 'BLOCKED') {
                Assert-ReportText (Get-ReportField $trial 'reviewer') 'reviewer'
                $prerequisite=Get-ReportField $blocker 'prerequisite'
                Assert-ReportText $prerequisite 'blocker.prerequisite'
                if ($prerequisite -cnotin @('AUTHORITY','ISOLATION','COST','HOST','INPUT')) { throw 'Invalid blocker prerequisite.' }
                foreach ($field in @('reason','required_to_unblock')) { Assert-ReportText (Get-ReportField $blocker $field) ("blocker.$field") }
                $evidence=Get-ReportField $blocker 'evidence'
                if ($evidence -isnot [Array] -or $evidence.Count -eq 0) { throw 'Blocker evidence must be a nonempty array of structured observations.' }
                foreach ($item in $evidence) {
                    $kind=Get-ReportField $item 'kind'
                    Assert-ReportText $kind 'blocker.evidence.kind'
                    if ($kind -cnotin @('OWNER DECISION','CONFIGURATION','COMMAND RESULT','ARTIFACT')) { throw 'Invalid blocker evidence kind.' }
                    foreach ($field in @('source','observation')) { Assert-ReportText (Get-ReportField $item $field) ("blocker.evidence.$field") }
                    if ($kind -ceq 'COMMAND RESULT') {
                        Assert-ReportText (Get-ReportField $item 'command') 'blocker.evidence.command'
                        $exitCode=Get-ReportField $item 'exit_code'
                        if ($exitCode -isnot [int] -and $exitCode -isnot [long]) { throw 'Command evidence requires an integer exit_code.' }
                    }
                    if ($kind -ceq 'ARTIFACT') {
                        $digest=Get-ReportField $item 'sha256'
                        Assert-ReportText $digest 'blocker.evidence.sha256'
                        if ($digest -cnotmatch '^[0-9a-fA-F]{64}$') { throw 'Artifact evidence requires a SHA-256 digest.' }
                    }
                }
                $blocked++
            }
            else {
                if ($null -ne $blocker) { throw 'Use BLOCKED, not NOT RUN, when recording blocker evidence.' }
                $notRun++
            }
        }
        else {
            if ($origin -cne 'MODEL GENERATED') { throw 'Executed PASS/FAIL requires MODEL GENERATED output provenance.' }
            if ($null -ne $blocker) { throw 'Executed PASS/FAIL cannot also claim a pre-execution blocker.' }
            foreach ($field in @('date','model','host_version','surface','os','permissions','skill_configuration','package_hashes','input','output','scoring_rationale','reviewer','failures','residuals')) {
                Assert-ReportText (Get-ReportField $trial $field) $field
            }
            $date=[DateTimeOffset]::MinValue
            if (-not [DateTimeOffset]::TryParse($trial.date, [Globalization.CultureInfo]::InvariantCulture, [Globalization.DateTimeStyles]::None, [ref]$date)) { throw 'Executed trial date must be a valid recorded date/time.' }
            if ($trial.package_hashes -cnotmatch '[0-9a-fA-F]{64}') { throw 'Executed trial package_hashes must include SHA-256 evidence.' }
            $executed++
        }
    }
    if ($seen.Count -ne $rows.Count) { throw 'Report must include all selected cases, including NOT RUN cases.' }
    Write-Host 'PASS: report completeness only; a human must judge behavior against artifacts. No automatic behavioral pass was assigned.'
    return [pscustomobject]@{ Validation='COMPLETENESS ONLY'; SelectedTrials=$rows.Count; ExecutedModelTrials=$executed; CompletedModelTrials=$executed; BlockedTrials=$blocked; NotRunTrials=$notRun; BehavioralPassAssigned=$false }
}
if ($ValidateOnly) { Write-Host 'PASS: 12 evaluation selectors/fixtures resolve; model trials NOT RUN.'; return }
[pscustomobject]@{ status='NOT RUN'; definitions=12; attempted_model_trials=0; warning='Prepared inputs and human rubrics are not model outputs or pass results.'; trials=$rows } | ConvertTo-Json -Depth 32
