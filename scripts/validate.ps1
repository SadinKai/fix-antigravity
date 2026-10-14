#Requires -Version 5.1
[CmdletBinding()]
param([switch]$StructureOnly)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'package-common.ps1')
. (Join-Path $PSScriptRoot 'manifest-json.ps1')
$repo=Split-Path -Parent $PSScriptRoot
$checks=0; $behavioral=0; $triggers=0; $links=0; $scripts=0
Write-Host "Runtime: PowerShell $($PSVersionTable.PSVersion), $($PSVersionTable.PSEdition)"
$manifest=Read-StackChecksums (Join-Path $repo 'checksums.sha256')
Assert-StackInventory -Root (Join-Path $repo 'skills') -Expected $manifest
$checks++
foreach ($name in $script:StackPackages) {
    $root=Join-Path $repo "skills\$name"
    $core=(Read-StackUtf8 (Join-Path $root 'SKILL.md')).Text
    if ($core -notmatch '(?s)\A---\r?\n(.*?)\r?\n---\r?\n') { throw "Skill frontmatter missing: $name" }
    $front=$Matches[1]
    if ($front -notmatch ('(?m)^name: ' + [regex]::Escape($name) + '\r?$') -or $front -notmatch '(?m)^description: \S.+') { throw "Skill identity/description invalid: $name" }
    # Restricted known metadata format, not a general YAML validator.
    $metadata=(Read-StackUtf8 (Join-Path $root 'agents\openai.yaml')).Text
    if ($metadata -notmatch '\Ainterface:\r?\n' -or $metadata -notmatch '(?m)^  display_name: "[^"\r\n]+"\r?$' -or $metadata -notmatch '(?m)^  short_description: "[^"\r\n]+"\r?$' -or $metadata -notmatch ('(?m)^  default_prompt: "[^"\r\n]*\$' + [regex]::Escape($name) + '[^"\r\n]*"\r?$')) { throw "Metadata contract invalid: $name" }
    $checks += 2
    foreach ($file in @('evals.json','trigger_evals.json')) {
        $text=(Read-StackUtf8 (Join-Path $root "evals\$file")).Text
        $null=Read-StackJson $text
        $data=$text | ConvertFrom-Json
        if ($data.skill_name -cne $name) { throw 'Evaluator skill identity mismatch.' }
        if ($file -eq 'evals.json') {
            $collections=@($data.PSObject.Properties | Where-Object Name -in @('cases','evals'))
            if ($collections.Count -ne 1 -or $collections[0].Value -isnot [Array]) { throw 'Expected one cases/evals array.' }
            $ids=[Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
            foreach ($case in $collections[0].Value) {
                if ([string]::IsNullOrWhiteSpace($case.id) -or -not $ids.Add($case.id) -or [string]::IsNullOrWhiteSpace($case.prompt) -or [string]::IsNullOrWhiteSpace($case.expected_output) -or @($case.expectations).Count -eq 0) { throw "Malformed/duplicate behavioral case: $name" }
                $behavioral++
            }
        }
        else {
            $queries=[Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
            foreach ($group in @('positive','negative')) {
                foreach ($case in $data.$group) {
                    if ([string]::IsNullOrWhiteSpace($case.query) -or -not $queries.Add($case.query) -or $case.should_trigger -isnot [bool] -or $case.should_trigger -ne ($group -eq 'positive')) { throw "Malformed/duplicate trigger case: $name" }
                    $triggers++
                }
            }
        }
        $checks++
    }
}
Assert-StackRule (Join-Path $repo 'integration\four-skill-stack.md')
$checks++
$files=@(Get-ChildItem -LiteralPath $repo -File -Force)
foreach ($directory in @('scripts','tests','docs','examples','evals','skills','.github')) {
    $path=Join-Path $repo $directory
    if (Test-Path -LiteralPath $path) { $files += @(Get-ChildItem -LiteralPath $path -Recurse -File -Force) }
}
foreach ($file in $files) {
    if ($file.Extension -eq '.ps1') {
        $tokens=$null; $errors=$null
        $null=[Management.Automation.Language.Parser]::ParseFile($file.FullName,[ref]$tokens,[ref]$errors)
        if ($errors.Count -gt 0) { throw "PowerShell parse failure: $($file.Name): $($errors[0].Message)" }
        $scripts++
    }
    if ($file.Extension -eq '.md') {
        $text=[IO.File]::ReadAllText($file.FullName)
        foreach ($match in [regex]::Matches($text,'\[[^\]\r\n]*\]\(([^)\r\n]+)\)')) {
            $target=$match.Groups[1].Value.Trim().Trim('<','>')
            if ($target -match '^[a-zA-Z][a-zA-Z0-9+.-]*:' -or $target.StartsWith('#')) { continue }
            $local=[Uri]::UnescapeDataString(($target -split '#',2)[0])
            if (-not (Test-Path -LiteralPath (Join-Path $file.DirectoryName $local))) { throw "Broken relative link in $($file.Name): $target" }
            $links++
        }
    }
}
if ($behavioral -ne 258 -or $triggers -ne 106) { throw 'Canonical evaluation inventory changed.' }
& (Join-Path $PSScriptRoot 'evaluate.ps1') -ValidateOnly -ReportPath (Join-Path $repo 'evals\report-template.json') | Out-Null
$checks++
Write-Host "PASS: $checks structural groups; 43 files; $behavioral behavioral and $triggers trigger definitions; $links local links; $scripts PowerShell parse checks."
$summaries=@()
if (-not $StructureOnly) {
    foreach ($test in @('install-smoke.ps1','hardening-tests.ps1','demo-tests.ps1','correction-tests.ps1')) { $summaries += & (Join-Path $repo "tests\$test") }
}
[pscustomobject]@{ Runtime=$PSVersionTable.PSVersion.ToString(); StructuralGroups=$checks; PackageFiles=43; BehavioralDefinitions=$behavioral; TriggerDefinitions=$triggers; RelativeLinks=$links; ScriptsParsed=$scripts; Suites=$summaries; LiveModelTrials='NOT RUN'; HostedCI='NOT RUN' }
Write-Host 'PASS: requested deterministic validation completed. No model-compliance or hosted-CI claim.'
