#Requires -Version 5.1
[CmdletBinding()]
param()
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
. (Join-Path $repo 'scripts\package-common.ps1')
. (Join-Path $repo 'scripts\manifest-json.ps1')
. (Join-Path $PSScriptRoot 'test-support.ps1')
$install = Join-Path $repo 'scripts\install.ps1'
$verify = Join-Path $repo 'scripts\verify-install.ps1'
$evaluate = Join-Path $repo 'scripts\evaluate.ps1'
$newline = [Environment]::NewLine

function New-CorrectionSource {
    param([switch]$Complete)
    $root = Join-Path $script:TestRoot ('source-' + [Guid]::NewGuid().ToString('N'))
    $null = New-Item -ItemType Directory -Path $root
    $parts = @('scripts','skills','integration','checksums.sha256')
    if ($Complete) {
        $parts = @('scripts','skills','integration','evals','docs','tests','examples','.github')
        $parts += @(Get-ChildItem -LiteralPath $repo -File -Force | ForEach-Object Name)
    }
    foreach ($part in $parts) { Copy-Item -LiteralPath (Join-Path $repo $part) -Destination $root -Recurse }
    return $root
}
function Assert-CorrectionUnchanged {
    param([string]$Path, [string]$Snapshot)
    Assert-Test ((Get-StackSnapshot $Path) -ceq $Snapshot) 'Unexpected filesystem/configuration/recovery mutation.'
}
function New-CorrectionReport {
    return ((Read-StackUtf8 (Join-Path $repo 'evals\report-template.json')).Text | ConvertFrom-Json)
}
function Test-CorrectionReport {
    param($Report)
    $path = Join-Path $script:TestRoot ([Guid]::NewGuid().ToString('N') + '.json')
    Write-TestFile $path ($Report | ConvertTo-Json -Depth 16)
    $before = Get-StackSnapshot $path
    try { return (& $evaluate -ValidateOnly -ReportPath $path) }
    finally { Assert-CorrectionUnchanged $path $before }
}
function Set-CorrectionBlocked {
    param($Trial)
    $Trial.status = 'BLOCKED'; $Trial.output_origin = 'NOT RUN'; $Trial.reviewer = 'Synthetic validator fixture reviewer'
    $Trial.blocker = [pscustomobject]@{
        prerequisite = 'ISOLATION'
        reason = 'Synthetic isolation check did not establish a disposable host context.'
        required_to_unblock = 'Provide an owner-approved isolated host workspace.'
        evidence = @([pscustomobject]@{ kind='COMMAND RESULT'; source='synthetic probe transcript'; observation='Synthetic probe returned isolation unavailable.'; command='synthetic-isolation-probe'; exit_code=2 })
    }
}
function Set-CorrectionExecuted {
    param($Trial, [string]$Status = 'PASS')
    # Schema fixtures only. These are NOT actual model outputs or trial evidence.
    $Trial.status = $Status; $Trial.output_origin = 'MODEL GENERATED'
    foreach ($property in $Trial.PSObject.Properties) {
        if ($property.Name -notin @('key','status','output_origin','blocker')) { $Trial.($property.Name) = 'SYNTHETIC VALIDATOR FIXTURE - NOT A MODEL TRIAL' }
    }
    $Trial.date = '2026-10-14T00:00:00Z'
    $Trial.package_hashes = 'synthetic-package=' + ('a' * 64)
}

try {
    # Fix 1: process cwd and PowerShell location deliberately disagree.
    foreach ($relative in @('skills','new\skills','nested\..\destination\.\skills')) {
        Invoke-TestCase "relative safe/nonexistent/dot target: $relative" 'path resolution' {
            $parent = Join-Path $script:TestRoot ([Guid]::NewGuid().ToString('N'))
            $caller = Join-Path $parent 'caller'; $native = Join-Path $parent 'native'
            Write-TestFile (Join-Path $caller 'preserved.txt') 'caller data'
            Write-TestFile (Join-Path $native 'skills\preserved.txt') 'unrelated native-cwd data'
            if ($relative -eq 'skills') { $null = New-Item -ItemType Directory -Path (Join-Path $caller 'skills') }
            $nativeBefore = Get-StackSnapshot $native
            $processBefore = [Environment]::CurrentDirectory
            Push-Location -LiteralPath $caller
            try {
                [Environment]::CurrentDirectory = $native
                $expected = [IO.Path]::GetFullPath((Join-Path $caller $relative))
                Assert-Test ((Get-StackFullPath $relative) -ceq $expected) 'Relative path used process cwd.'
                & $install -TargetSkillRoot $relative
                & $verify -TargetSkillRoot $relative
                Assert-Test (Test-Path -LiteralPath (Join-Path $expected 'perfect-code-v2\SKILL.md')) 'Intended target not installed.'
                Assert-CorrectionUnchanged $native $nativeBefore
            }
            finally { [Environment]::CurrentDirectory = $processBefore; Pop-Location }
        }
    }
    foreach ($relative in @('.\skills','.','..','.\nested\skills','.\skills\..\skills')) {
        Invoke-TestCase "relative source equality/overlap rejected: $relative" 'path resolution' {
            $source = New-CorrectionSource
            $native = Join-Path $script:TestRoot ([Guid]::NewGuid().ToString('N'))
            Write-TestFile (Join-Path $native 'skills\perfect-code-v2\SKILL.md') 'do not replace native-cwd content'
            $before = Get-StackSnapshot $script:TestRoot
            $processBefore = [Environment]::CurrentDirectory
            Push-Location -LiteralPath $source
            try {
                [Environment]::CurrentDirectory = $native
                $null = Assert-TestThrows { & (Join-Path $source 'scripts\install.ps1') -TargetSkillRoot $relative -ReplaceConflicts } 'overlap'
                Assert-CorrectionUnchanged $script:TestRoot $before
            }
            finally { [Environment]::CurrentDirectory = $processBefore; Pop-Location }
        }
    }
    Invoke-TestCase 'all relative configuration/recovery paths retain caller filesystem meaning' 'path resolution' {
        $caller = Join-Path $script:TestRoot 'relative-config'; $native = Join-Path $script:TestRoot 'relative-config-native'
        Write-TestFile (Join-Path $caller 'config\skills.json') '{}'
        Write-TestFile (Join-Path $native 'sentinel') 'native untouched'
        $before = Get-StackSnapshot $native; $processBefore = [Environment]::CurrentDirectory
        Push-Location -LiteralPath $caller
        try {
            [Environment]::CurrentDirectory = $native
            & $install -TargetSkillRoot '.\skills' -EnableIntegrated -RulePath '.\rules\stack.md' -RegisterManifest -ManifestPath '.\config\skills.json' -BackupRoot '.\private-recovery'
            & $verify -TargetSkillRoot '.\skills' -Integrated -RulePath '.\rules\stack.md' -CheckManifest -ManifestPath '.\config\skills.json'
            Assert-Test (Test-Path -LiteralPath (Join-Path $caller 'private-recovery')) 'Recovery path not resolved against caller.'
            Assert-CorrectionUnchanged $native $before
        }
        finally { [Environment]::CurrentDirectory = $processBefore; Pop-Location }
    }
    Invoke-TestCase 'non-filesystem relative location fails before writes' 'path resolution' {
        $before = Get-StackSnapshot $script:TestRoot
        Push-Location 'Variable:\'
        try { $null = Assert-TestThrows { & $install -TargetSkillRoot 'nonexistent-target' } 'FileSystem provider' }
        finally { Pop-Location }
        Assert-CorrectionUnchanged $script:TestRoot $before
    }

    # Fix 2: every path is a generated fixture, including synthetic profile layouts.
    $layouts = @('.agents\skills','.agent\skills','.gemini\config\skills','.gemini\antigravity-cli\skills','.gemini\antigravity\skills','.gemini\antigravity-cli\plugins\fixture\skills')
    foreach ($layout in $layouts) {
        Invoke-TestCase "recovery rejected beneath documented layout: $layout" 'recovery isolation' {
            $parent = Join-Path $script:TestRoot ([Guid]::NewGuid().ToString('N'))
            $target = Join-Path $parent 'active\skills'; $unsafe = Join-Path $parent ("other-profile\$layout\retained")
            Write-TestFile (Join-Path $target 'perfect-code-v2\SKILL.md') 'active user package'
            Write-TestFile (Join-Path $unsafe 'preserved-backup.txt') 'existing backup'
            Write-TestFile (Join-Path $parent 'skills.json') '{}'
            Write-TestFile (Join-Path $parent 'rules\stack.md') 'user rule'
            $before = Get-StackSnapshot $parent
            $null = Assert-TestThrows { & $install -TargetSkillRoot $target -BackupRoot $unsafe -ReplaceConflicts -RegisterManifest -ManifestPath (Join-Path $parent 'skills.json') -EnableIntegrated -RulePath (Join-Path $parent 'rules\stack.md') } 'BackupRoot'
            Assert-CorrectionUnchanged $parent $before
        }
    }
    foreach ($spelling in @('other\.agents\skills','other\.AGENTS\SKILLS\RETAINED','other\.agents\spare\..\skills\retained')) {
        Invoke-TestCase "equal/case/dot recovery root rejected: $spelling" 'recovery isolation' {
            $parent = Join-Path $script:TestRoot ([Guid]::NewGuid().ToString('N'))
            Write-TestFile (Join-Path $parent 'user-data.txt') 'preserved'
            $before = Get-StackSnapshot $parent
            $null = Assert-TestThrows { & $install -TargetSkillRoot (Join-Path $parent 'active\skills') -BackupRoot (Join-Path $parent $spelling) } 'BackupRoot'
            Assert-CorrectionUnchanged $parent $before
        }
    }
    foreach ($spelling in @('private-recovery','other\.agents\skills-archive','other\prefix.agents\skills')) {
        Invoke-TestCase "legitimate recovery and substring control: $spelling" 'recovery isolation' {
            $parent = Join-Path $script:TestRoot ([Guid]::NewGuid().ToString('N'))
            $target = Join-Path $parent 'active\skills'; $recovery = Join-Path $parent $spelling
            Write-TestFile (Join-Path $target 'perfect-code-v2\SKILL.md') 'old package bytes'
            $old = Get-StackSnapshot (Join-Path $target 'perfect-code-v2')
            & $install -TargetSkillRoot $target -BackupRoot $recovery -ReplaceConflicts
            & $verify -TargetSkillRoot $target
            $backups = @(Get-ChildItem -LiteralPath $recovery -Directory -Recurse | Where-Object Name -eq 'backup')
            Assert-Test ($backups.Count -eq 1 -and (Get-StackSnapshot $backups[0].FullName) -ceq $old) 'Prior package not preserved.'
            Assert-Test (@(Get-ChildItem -LiteralPath $target -Directory).Count -eq 4) 'Recovery became a selected-root skill candidate.'
        }
    }
    Invoke-TestCase 'replacement helper rejects unsafe staging root before writes' 'recovery isolation' {
        $parent = Join-Path $script:TestRoot 'helper-root'
        $source = Join-Path $parent 'source'; $active = Join-Path $parent 'active'
        Write-TestFile $source 'new'; Write-TestFile $active 'old'
        $before = Get-StackSnapshot $parent
        $null = Assert-TestThrows { Invoke-StackReplacement -Source $source -Destination $active -RecoveryRoot (Join-Path $parent 'other\.agents\skills\retained') -OriginalSnapshot (Get-StackSnapshot $active) -NewSnapshot (Get-StackSnapshot $source) } 'BackupRoot'
        Assert-CorrectionUnchanged $parent $before
    }
    Invoke-TestCase 'abandoned staged package remains outside selected discovery root' 'recovery isolation' {
        $parent = Join-Path $script:TestRoot 'abandoned-stage'; $source=Join-Path $parent 'source'; $active=Join-Path $parent 'skills\perfect-code-v2'; $recovery=Join-Path $parent 'private-recovery'
        Write-TestFile (Join-Path $source 'SKILL.md') 'new core'
        Write-TestFile (Join-Path $active 'SKILL.md') 'old core'
        $old = Get-StackSnapshot $active
        $null = Assert-TestThrows { Invoke-StackReplacement -Source $source -Destination $active -RecoveryRoot $recovery -OriginalSnapshot $old -NewSnapshot (Get-StackSnapshot $source) -FaultInjector { param($stage,$path) if($stage -eq 'StageVerify') { throw 'Injected stage verification failure' } } } 'Replacement failed'
        Assert-CorrectionUnchanged $active $old
        Assert-Test (@(Get-ChildItem -LiteralPath (Split-Path -Parent $active) -Recurse -Filter SKILL.md).Count -eq 1) 'Staging leaked into selected discovery root.'
        Assert-Test (@(Get-ChildItem -LiteralPath $recovery -Recurse -Filter SKILL.md).Count -eq 1) 'Expected retained staged fixture absent.'
    }

    # Fix 3: valid installed packages plus a fifth candidate; no real active roots.
    $names = @('name: perfect-code-v2','name: "perfect-code-v2"',"name: 'perfect-code-v2'",'name: perfect-code-v2 # preserved older copy','name  :  "perfect-code-v2" # outside scalar')
    foreach ($nameLine in $names) {
        Invoke-TestCase "five-directory duplicate rejected: $nameLine" 'candidate identity' {
            $parent=Join-Path $script:TestRoot ([Guid]::NewGuid().ToString('N')); $target=Join-Path $parent 'skills'
            $null=New-Item -ItemType Directory -Path $target
            foreach($name in $script:StackPackages) { Copy-Item -LiteralPath (Join-Path $repo "skills\$name") -Destination $target -Recurse }
            Write-TestFile (Join-Path $target 'legacy-copy\SKILL.md') ((@('---',$nameLine,'description: duplicate fixture','---','body')) -join $newline)
            Assert-Test (@(Get-ChildItem -LiteralPath $target -Directory).Count -eq 5) 'Duplicate precondition not established.'
            $before=Get-StackSnapshot $parent
            $null=Assert-TestThrows { & $install -TargetSkillRoot $target -ReplaceConflicts } 'Duplicate skill'
            $null=Assert-TestThrows { & $verify -TargetSkillRoot $target } 'Duplicate skill'
            Assert-CorrectionUnchanged $parent $before
        }
    }
    $badFronts = @(
        'no frontmatter',
        ((@('---','name: perfect-code-v2','description: missing delimiter')) -join $newline),
        ((@('---','name:','description: empty name','---')) -join $newline),
        ((@('---','name: "perfect-code-v2','description: malformed quote','---')) -join $newline),
        ((@('---','name: unrelated','name: perfect-code-v2','description: ambiguous','---')) -join $newline),
        ((@('---','name: *identity','description: alias','---')) -join $newline),
        ((@('---','name: "\u0070erfect-code-v2"','description: unsupported escape','---')) -join $newline),
        ((@('---','"name": perfect-code-v2','description: unsupported key','---')) -join $newline),
        ((@('---','  name: perfect-code-v2','  description: indented','---')) -join $newline),
        ((@('---','name: "perfect-code-v2 # literal"','description: literal hash','---')) -join $newline),
        ((@('---','name: unrelated','description: [unterminated','---')) -join $newline),
        ((@('---','name: null','description: implicitly null identity','---')) -join $newline),
        ((@('---','name: true','description: implicitly boolean identity','---')) -join $newline),
        ((@('---','name: ""','description: empty quoted identity','---')) -join $newline),
        ((@('---','name: unrelated','description: |','---')) -join $newline)
    )
    $index=0
    foreach($front in $badFronts) {
        $index++
        Invoke-TestCase "malformed/ambiguous candidate $index fails closed without mutation" 'candidate identity' {
            $parent=Join-Path $script:TestRoot ([Guid]::NewGuid().ToString('N')); $target=Join-Path $parent 'skills'
            $null=New-Item -ItemType Directory -Path $target
            foreach($name in $script:StackPackages) { Copy-Item -LiteralPath (Join-Path $repo "skills\$name") -Destination $target -Recurse }
            Write-TestFile (Join-Path $target 'unrelated\SKILL.md') $front
            $before=Get-StackSnapshot $parent
            $null=Assert-TestThrows { & $install -TargetSkillRoot $target }
            $null=Assert-TestThrows { & $verify -TargetSkillRoot $target }
            Assert-CorrectionUnchanged $parent $before
        }
    }
    foreach($front in @(
        ((@('---','name: "unrelated" # accepted','description: "literal # description"','---','name: perfect-code-v2')) -join $newline),
        ((@('---',"name: 'unrelated'",'description: >-','  name: perfect-code-v2 is just description text','---')) -join $newline),
        ((@('---','description: name defaults to folder','---')) -join $newline)
    )) {
        Invoke-TestCase 'unrelated quoted/block/default identity accepted and retained' 'candidate identity' {
            $parent=Join-Path $script:TestRoot ([Guid]::NewGuid().ToString('N')); $target=Join-Path $parent 'skills'; $core=Join-Path $target 'unrelated\SKILL.md'
            Write-TestFile $core $front; $before=Get-StackSnapshot $core
            Assert-Test ((Get-StackCandidateIdentity $core 'unrelated') -ceq 'unrelated') 'Quoted/default identity misparsed.'
            & $install -TargetSkillRoot $target
            & $verify -TargetSkillRoot $target
            Assert-CorrectionUnchanged $core $before
        }
    }
    Invoke-TestCase 'quoted hash and escapes are scalar content, not comments' 'candidate identity' {
        Assert-Test ((Read-StackYamlScalar '"a # b" # comment') -ceq 'a # b') 'Quoted hash was stripped.'
        Assert-Test ((Read-StackYamlScalar "'a''#b' # comment") -ceq "a'#b") 'Single-quoted escape/hash misparsed.'
        Assert-Test ((Read-StackYamlScalar '"a\"#b"') -ceq 'a"#b') 'Escaped quote misparsed.'
        Assert-Test ((Read-StackYamlScalar 'unrelated#literal') -ceq 'unrelated#literal') 'Plain non-comment hash stripped.'
    }

    # Fix 4: byte-exact production installations and full-state rejection checks.
    foreach($bom in @($false,$true)) {
        foreach($delta in @(0,1)) {
            Invoke-TestCase "encoded manifest boundary BOM=$bom overflow=$delta" 'manifest bytes' {
                $parent=Join-Path $script:TestRoot ([Guid]::NewGuid().ToString('N')); $target=Join-Path $parent 'skills'; $path=Join-Path $parent 'skills.json'; $rule=Join-Path $parent 'rules\stack.md'; $recovery=Join-Path $parent 'private-recovery'
                Write-TestFile (Join-Path $target 'perfect-code-v2\SKILL.md') 'user package'
                Write-TestFile $rule 'user rule'
                Write-TestFile (Join-Path $recovery 'preserved.txt') 'prior recovery data'
                $empty=Merge-StackManifest -Text '{"padding":""}' -Paths @(Get-StackManifestPaths $target)
                $baseLength=(ConvertTo-StackUtf8Bytes -Text $empty.Text -Bom $bom).Length
                $text='{"padding":"' + ('a' * ($script:StackUtf8ByteLimit-$baseLength+$delta)) + '"}'
                Write-TestFile $path $text $bom
                Assert-Test ((Get-Item -LiteralPath $path).Length -lt $script:StackUtf8ByteLimit) 'Input must fit before registration.'
                $before=Get-StackSnapshot $parent
                if($delta -eq 1) {
                    $null=Assert-TestThrows { & $install -TargetSkillRoot $target -EnableIntegrated -RulePath $rule -RegisterManifest -ManifestPath $path -BackupRoot $recovery -ReplaceConflicts } '1048577 bytes'
                    Assert-CorrectionUnchanged $parent $before
                }
                else {
                    & $install -TargetSkillRoot $target -EnableIntegrated -RulePath $rule -RegisterManifest -ManifestPath $path -BackupRoot $recovery -ReplaceConflicts
                    Assert-Test ((Get-Item -LiteralPath $path).Length -eq $script:StackUtf8ByteLimit) 'Final file is not exactly at the encoded limit.'
                    Assert-Test ((Read-StackUtf8 $path).Bom -eq $bom) 'BOM choice changed.'
                    & $verify -TargetSkillRoot $target -Integrated -RulePath $rule -CheckManifest -ManifestPath $path
                    $after=Get-StackSnapshot $parent
                    & $install -TargetSkillRoot $target -EnableIntegrated -RulePath $rule -RegisterManifest -ManifestPath $path -BackupRoot $recovery
                    Assert-CorrectionUnchanged $parent $after
                }
            }
        }
    }
    Invoke-TestCase 'reported Unicode-heavy manifest fails preflight with all state preserved' 'manifest bytes' {
        $parent=Join-Path $script:TestRoot 'unicode-limit'; $target=Join-Path $parent 'skills'; $path=Join-Path $parent 'skills.json'; $rule=Join-Path $parent 'rules\stack.md'
        Write-TestFile $path ('{"padding":"' + (([string][char]0x20ac) * 349500) + '"}')
        Write-TestFile (Join-Path $target 'perfect-code-v2\SKILL.md') 'old package'
        Write-TestFile $rule 'old rule'; Write-TestFile (Join-Path $parent 'private-recovery\sentinel') 'old recovery'
        Assert-Test ((Get-Item -LiteralPath $path).Length -eq 1048514) 'Reported input not reproduced.'
        $before=Get-StackSnapshot $parent
        $null=Assert-TestThrows { & $install -TargetSkillRoot $target -EnableIntegrated -RulePath $rule -RegisterManifest -ManifestPath $path -BackupRoot (Join-Path $parent 'private-recovery') -ReplaceConflicts } 'Encoded output exceeds'
        Assert-CorrectionUnchanged $parent $before
    }
    Invoke-TestCase 'small JSON expands beyond byte limit during helper registration, not input read' 'manifest bytes' {
        $parent=Join-Path $script:TestRoot 'registration-expansion'; $path=Join-Path $parent 'skills.json'
        Write-TestFile $path '{}'; $before=Get-StackSnapshot $parent
        # Generic merge-helper boundary; the installer itself requests only four.
        $paths=@(1..5500 | ForEach-Object { 'C:/fixture/' + ('x' * 180) + $_ })
        $null=Assert-TestThrows { Merge-StackManifest -Text (Read-StackUtf8 $path).Text -Paths $paths } 'Encoded output exceeds'
        Assert-CorrectionUnchanged $parent $before
    }
    Invoke-TestCase 'strict encoding failure does not mutate configuration' 'manifest bytes' {
        $parent=Join-Path $script:TestRoot 'encoding-failure'; $path=Join-Path $parent 'skills.json'
        Write-TestFile $path '{}'; $before=Get-StackSnapshot $parent
        $null=Assert-TestThrows { ConvertTo-StackUtf8Bytes -Text ([string][char]0xd800) }
        Assert-CorrectionUnchanged $parent $before
    }
    Invoke-TestCase 'real locked manifest activation preserves original and bounded backup bytes' 'manifest bytes' {
        $parent=Join-Path $script:TestRoot 'locked-manifest'; $path=Join-Path $parent 'skills.json'; $recovery=Join-Path $parent 'private-recovery'
        Write-TestFile $path '{"custom":true}' $true; $old=Get-StackSnapshot $path
        $merged=Merge-StackManifest -Text (Read-StackUtf8 $path).Text -Paths @('C:/fixture/new')
        $bytes=ConvertTo-StackUtf8Bytes -Text $merged.Text -Bom $true
        $lock=[IO.File]::Open($path,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::Read)
        try { $null=Assert-TestThrows { Invoke-StackReplacement -Bytes $bytes -Destination $path -RecoveryRoot $recovery -OriginalSnapshot $old -NewSnapshot ('FILE:' + (Get-StackBytesHash $bytes)) } 'Replacement failed' }
        finally { $lock.Dispose() }
        Assert-CorrectionUnchanged $path $old
        $backups=@(Get-ChildItem -LiteralPath $recovery -File -Recurse | Where-Object Name -eq 'backup')
        Assert-Test ($backups.Count -eq 1 -and (Get-StackSnapshot $backups[0].FullName) -ceq $old) 'Verified original backup lost.'
    }

    # Fix 5: entirely synthetic schema fixtures, never actual model trial results.
    Invoke-TestCase 'blank NOT RUN report has zero executed/completed/blocked trials' 'report states' {
        $result=Test-CorrectionReport (New-CorrectionReport)
        Assert-Test ($result.ExecutedModelTrials -eq 0 -and $result.CompletedModelTrials -eq 0 -and $result.BlockedTrials -eq 0 -and $result.NotRunTrials -eq 12 -and -not $result.BehavioralPassAssigned) 'NOT RUN accounting incorrect.'
    }
    Invoke-TestCase 'honest pre-execution BLOCKED report accepted without invented output/date/run ID' 'report states' {
        $report=New-CorrectionReport; Set-CorrectionBlocked $report.trials[0]
        $result=Test-CorrectionReport $report
        Assert-Test ($result.BlockedTrials -eq 1 -and $result.NotRunTrials -eq 11 -and $result.ExecutedModelTrials -eq 0 -and $result.CompletedModelTrials -eq 0) 'Blocker incorrectly counted as execution.'
        Assert-Test ($report.trials[0].output -ceq '' -and $report.trials[0].date -ceq '' -and $report.run_id -ceq 'UNASSIGNED') 'Missing evidence was fabricated.'
        $report.trials[0].blocker.evidence += @(
            [pscustomobject]@{kind='OWNER DECISION';source='synthetic owner message';observation='Synthetic owner withheld trial authority.'},
            [pscustomobject]@{kind='CONFIGURATION';source='synthetic isolation configuration';observation='Synthetic context was not isolated.'},
            [pscustomobject]@{kind='ARTIFACT';source='synthetic fixture receipt';observation='Synthetic receipt records unavailable isolation.';sha256=('b' * 64)}
        )
        $result=Test-CorrectionReport $report
        Assert-Test ($result.BlockedTrials -eq 1 -and $result.ExecutedModelTrials -eq 0) 'Structured blocker evidence kinds miscounted.'
    }
    Invoke-TestCase 'mixed blocked/executed/unrun report counts only synthetic executed fixtures' 'report states' {
        $report=New-CorrectionReport; Set-CorrectionBlocked $report.trials[0]; Set-CorrectionExecuted $report.trials[1]; Set-CorrectionExecuted $report.trials[2] 'FAIL'
        $result=Test-CorrectionReport $report
        Assert-Test ($result.ExecutedModelTrials -eq 2 -and $result.CompletedModelTrials -eq 2 -and $result.BlockedTrials -eq 1 -and $result.NotRunTrials -eq 9 -and -not $result.BehavioralPassAssigned) 'Mixed accounting incorrect.'
    }
    $badReports = [ordered]@{
        'blocked claims PASS' = { param($r) Set-CorrectionBlocked $r.trials[0]; $r.trials[0].status='PASS' }
        'executed without output' = { param($r) Set-CorrectionExecuted $r.trials[0]; $r.trials[0].output='' }
        'executed with NOT RUN provenance' = { param($r) Set-CorrectionExecuted $r.trials[0]; $r.trials[0].output_origin='NOT RUN' }
        'blocker evidence absent' = { param($r) Set-CorrectionBlocked $r.trials[0]; $r.trials[0].blocker.evidence=@() }
        'blocker evidence is arbitrary sentence' = { param($r) Set-CorrectionBlocked $r.trials[0]; $r.trials[0].blocker.evidence='isolation unavailable' }
        'blocker unsupported prerequisite' = { param($r) Set-CorrectionBlocked $r.trials[0]; $r.trials[0].blocker.prerequisite='ANYTHING' }
        'blocker no actionable prerequisite' = { param($r) Set-CorrectionBlocked $r.trials[0]; $r.trials[0].blocker.required_to_unblock='' }
        'blocker evidence no observation' = { param($r) Set-CorrectionBlocked $r.trials[0]; $r.trials[0].blocker.evidence[0].observation='' }
        'command blocker has noninteger exit' = { param($r) Set-CorrectionBlocked $r.trials[0]; $r.trials[0].blocker.evidence[0].exit_code='failed' }
        'artifact blocker missing digest' = { param($r) Set-CorrectionBlocked $r.trials[0]; $r.trials[0].blocker.evidence[0].kind='ARTIFACT' }
        'BLOCKED claims model output' = { param($r) Set-CorrectionBlocked $r.trials[0]; $r.trials[0].output='invented output' }
        'NOT RUN claims output' = { param($r) $r.trials[0].output='invented output' }
        'NOT RUN has behavioral score' = { param($r) $r.trials[0].scoring_rationale='passed' }
        'NOT RUN conceals blocker' = { param($r) Set-CorrectionBlocked $r.trials[0]; $r.trials[0].status='NOT RUN' }
        'executed with blocker' = { param($r) Set-CorrectionBlocked $r.trials[0]; Set-CorrectionExecuted $r.trials[0] }
        'executed invalid date' = { param($r) Set-CorrectionExecuted $r.trials[0]; $r.trials[0].date='invented time' }
        'executed missing package evidence' = { param($r) Set-CorrectionExecuted $r.trials[0]; $r.trials[0].package_hashes='unknown' }
    }
    foreach($name in $badReports.Keys) {
        $mutate=$badReports[$name]
        Invoke-TestCase "contradictory/incomplete report rejected: $name" 'report states' {
            $report=New-CorrectionReport; & $mutate $report
            $null=Assert-TestThrows { Test-CorrectionReport $report }
        }
    }
    Invoke-TestCase 'report discriminator/digest arrays are rejected rather than coerced' 'report states' {
        foreach($fieldName in @('key','status','output_origin','kind','sha256')) {
            $report=New-CorrectionReport; Set-CorrectionBlocked $report.trials[0]
            if($fieldName -in @('key','status','output_origin')) { $report.trials[0].($fieldName)=@($report.trials[0].($fieldName)) }
            else {
                $report.trials[0].blocker.evidence=@([pscustomobject]@{kind='ARTIFACT';source='synthetic receipt';observation='synthetic missing prerequisite';sha256=('b' * 64)})
                $item=$report.trials[0].blocker.evidence[0]
                $item.($fieldName)=@($item.($fieldName))
            }
            $null=Assert-TestThrows { Test-CorrectionReport $report }
        }
    }

    # Optional gate repair: full production structural path, only temporary mutations.
    Invoke-TestCase 'real report template passes the main structural gate' 'template gate' {
        $result=& (Join-Path $repo 'scripts\validate.ps1') -StructureOnly
        Assert-Test ($result.PackageFiles -eq 43 -and $result.LiveModelTrials -ceq 'NOT RUN') 'Main gate did not validate the real template.'
    }
    foreach($fault in @('malformed','incomplete')) {
        Invoke-TestCase "temporary $fault report template fails main gate without side effects" 'template gate' {
            $source=New-CorrectionSource -Complete
            $path=Join-Path $source 'evals\report-template.json'
            if($fault -eq 'malformed') { Write-TestFile $path '{invalid JSON' }
            else { $report=New-CorrectionReport; $report.trials=@($report.trials | Select-Object -Skip 1); Write-TestFile $path ($report | ConvertTo-Json -Depth 16) }
            $before=Get-StackSnapshot $source
            $null=Assert-TestThrows { & (Join-Path $source 'scripts\validate.ps1') -StructureOnly }
            Assert-CorrectionUnchanged $source $before
        }
    }
    Invoke-TestCase 'cleanup refuses a separate fixture and never follows its junction' 'cleanup safety' {
        $outside=Join-Path ([IO.Path]::GetTempPath()) ('fix-antigravity-cleanup-sentinel-' + [Guid]::NewGuid().ToString('N'))
        $null=New-Item -ItemType Directory -Path $outside
        $sentinel=Join-Path $outside 'sentinel.txt'
        [IO.File]::WriteAllText($sentinel,'untouched separate fixture')
        try {
            $before=Get-StackSnapshot $outside
            $null=Assert-TestThrows { Remove-TestTree $outside } 'Unsafe test cleanup target'
            Assert-CorrectionUnchanged $outside $before
            $link=Join-Path $script:TestRoot 'cleanup-junction'
            $null=New-Item -ItemType Junction -Path $link -Target $outside
            Remove-TestTree $link
            Assert-Test (-not(Test-Path -LiteralPath $link)) 'Junction itself not removed.'
            Assert-CorrectionUnchanged $outside $before
        }
        finally {
            $full=Get-StackFullPath $outside; $temp=(Get-StackFullPath ([IO.Path]::GetTempPath())).TrimEnd('\','/')
            if ((Split-Path -Parent $full) -ne $temp -or [IO.Path]::GetFileName($full) -notmatch '^fix-antigravity-cleanup-sentinel-[0-9a-f]{32}$') { throw 'Unsafe sentinel fixture cleanup.' }
            Assert-StackNoLink $full
            [IO.File]::Delete($sentinel); [IO.Directory]::Delete($full,$false)
        }
    }
}
finally { Remove-TestTree }
$failed=@($script:TestResults | Where-Object Status -eq 'FAIL').Count
$passed=@($script:TestResults | Where-Object Status -eq 'PASS').Count
$categories=@($script:TestResults | Group-Object Category | ForEach-Object { [pscustomobject]@{ Category=$_.Name; Passed=@($_.Group | Where-Object Status -eq 'PASS').Count; Failed=@($_.Group | Where-Object Status -eq 'FAIL').Count } })
[pscustomobject]@{ Suite='corrections'; Runtime=$PSVersionTable.PSVersion.ToString(); Passed=$passed; Failed=$failed; Skipped=0; Categories=$categories }
if($failed -gt 0) { throw "$failed correction regressions failed ($passed passed)." }
