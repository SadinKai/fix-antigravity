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

function New-SourceFixture {
    $fixture = Join-Path $script:TestRoot ([Guid]::NewGuid().ToString('N') + '\source')
    $null = New-Item -ItemType Directory -Path $fixture -Force
    foreach ($part in @('scripts', 'skills', 'integration', 'checksums.sha256')) { Copy-Item -LiteralPath (Join-Path $repo $part) -Destination $fixture -Recurse -Force }
    return $fixture
}
function Test-RejectedSource {
    param([scriptblock]$Mutate)
    $fixture = New-SourceFixture
    & $Mutate $fixture
    $destinationParent = Join-Path (Split-Path -Parent $fixture) 'destination'
    $destination = Join-Path $destinationParent 'skills'
    $null = Assert-TestThrows { & (Join-Path $fixture 'scripts\install.ps1') -TargetSkillRoot $destination }
    Assert-Test (-not (Test-Path -LiteralPath $destinationParent)) 'Invalid source caused destination/recovery writes.'
}

try {
    Invoke-TestCase 'filesystem roots remain absolute and containment handles root separator' 'unit' {
        $driveRoot=[IO.Path]::GetPathRoot($script:TestRoot)
        Assert-Test ((Get-StackFullPath $driveRoot) -ceq $driveRoot) 'Filesystem root became drive-relative.'
        Assert-Test (Test-StackWithin $script:TestRoot $driveRoot) 'Root containment lost a path separator.'
    }
    Invoke-TestCase 'preview absent target, repeated, no writes' 'integration' {
        $parent = Join-Path $script:TestRoot 'preview'
        1..2 | ForEach-Object { & $install -TargetSkillRoot (Join-Path $parent 'skills') -WhatIf }
        Assert-Test (-not (Test-Path -LiteralPath $parent)) 'Preview created files/directories.'
    }
    Invoke-TestCase 'preview valid target and normal verifier' 'integration' {
        $parent = Join-Path $script:TestRoot 'valid'
        $target = Join-Path $parent 'skills'
        & $install -TargetSkillRoot $target
        & $verify -TargetSkillRoot $target
        $before = Get-StackSnapshot $parent
        1..2 | ForEach-Object { & $install -TargetSkillRoot $target -WhatIf }
        Assert-Test ((Get-StackSnapshot $parent) -ceq $before) 'Valid-target preview changed state.'
    }
    Invoke-TestCase 'preview conflicting target with and without replacement' 'integration' {
        $parent = Join-Path $script:TestRoot 'conflict-preview'
        $target = Join-Path $parent 'skills'
        Write-TestFile (Join-Path $target 'perfect-code-v2\SKILL.md') 'user customization'
        $before = Get-StackSnapshot $parent
        $null = Assert-TestThrows { & $install -TargetSkillRoot $target -WhatIf } 'Conflicts'
        & $install -TargetSkillRoot $target -ReplaceConflicts -WhatIf
        Assert-Test ((Get-StackSnapshot $parent) -ceq $before) 'Conflict preview changed state.'
    }
    Invoke-TestCase 'checksum mismatch preview does not write' 'integration' {
        $fixture = New-SourceFixture
        [IO.File]::AppendAllText((Join-Path $fixture 'skills\perfect-code-v2\SKILL.md'), 'changed')
        $parent = Join-Path (Split-Path -Parent $fixture) 'preview'
        $null = Assert-TestThrows { & (Join-Path $fixture 'scripts\install.ps1') -TargetSkillRoot (Join-Path $parent 'skills') -WhatIf }
        Assert-Test (-not (Test-Path -LiteralPath $parent)) 'Invalid checksum preview wrote state.'
    }

    $invalidSources = [ordered]@{
        missing = { param($f) Remove-TestTree (Join-Path $f 'skills\perfect-code-v2\SKILL.md') }
        changed = { param($f) [IO.File]::AppendAllText((Join-Path $f 'skills\perfect-code-v2\SKILL.md'), 'changed') }
        extra = { param($f) Write-TestFile (Join-Path $f 'skills\perfect-code-v2\extra.md') 'unlisted' }
        hidden = { param($f) $p = Join-Path $f 'skills\perfect-code-v2\hidden.md'; Write-TestFile $p 'unlisted'; [IO.File]::SetAttributes($p, [IO.FileAttributes]::Hidden) }
        hidden_directory = { param($f) $p = Join-Path $f 'skills\perfect-code-v2\hidden\extra.md'; Write-TestFile $p 'unlisted'; [IO.File]::SetAttributes((Split-Path -Parent $p), [IO.FileAttributes]::Hidden) }
        empty_directory = { param($f) $null = New-Item -ItemType Directory -Path (Join-Path $f 'skills\perfect-code-v2\empty') }
        duplicate = { param($f) $p=Join-Path $f 'checksums.sha256'; $lines=[IO.File]::ReadAllLines($p); [IO.File]::AppendAllText($p, $lines[0] + [Environment]::NewLine) }
        case_collision = { param($f) $p=Join-Path $f 'checksums.sha256'; $lines=[IO.File]::ReadAllLines($p); [IO.File]::AppendAllText($p, $lines[0].ToUpperInvariant().Replace('SKILLS/', 'skills/') + [Environment]::NewLine) }
        malformed = { param($f) [IO.File]::AppendAllText((Join-Path $f 'checksums.sha256'), 'not a checksum') }
        invalid_hash = { param($f) $p=Join-Path $f 'checksums.sha256'; $text=[IO.File]::ReadAllText($p); Write-TestFile $p ('z' + $text.Substring(1)) }
        wrong_count = { param($f) $p=Join-Path $f 'checksums.sha256'; $lines=[IO.File]::ReadAllLines($p); Write-TestFile $p ($lines[1..42] -join [Environment]::NewLine) }
        traversal = { param($f) $p=Join-Path $f 'checksums.sha256'; Write-TestFile $p ([IO.File]::ReadAllText($p).Replace('continuity-recovery/agents/openai.yaml', '../escape')) }
        absolute = { param($f) $p=Join-Path $f 'checksums.sha256'; Write-TestFile $p ([IO.File]::ReadAllText($p).Replace('continuity-recovery/agents/openai.yaml', 'C:/escape')) }
        alternate_separator = { param($f) $p=Join-Path $f 'checksums.sha256'; Write-TestFile $p ([IO.File]::ReadAllText($p).Replace('continuity-recovery/agents/openai.yaml', 'continuity-recovery\agents\openai.yaml')) }
        device_name = { param($f) $p=Join-Path $f 'checksums.sha256'; Write-TestFile $p ([IO.File]::ReadAllText($p).Replace('continuity-recovery/agents/openai.yaml', 'continuity-recovery/CON.md')) }
        ads = { param($f) $p=Join-Path $f 'checksums.sha256'; Write-TestFile $p ([IO.File]::ReadAllText($p).Replace('continuity-recovery/agents/openai.yaml', 'continuity-recovery/file:stream')) }
        trailing_dot = { param($f) $p=Join-Path $f 'checksums.sha256'; Write-TestFile $p ([IO.File]::ReadAllText($p).Replace('continuity-recovery/agents/openai.yaml', 'continuity-recovery/file.')) }
        junction = { param($f) $original=Join-Path $f 'skills\perfect-code-v2'; $outside=Join-Path (Split-Path -Parent $f) 'outside'; Copy-Item -LiteralPath $original -Destination $outside -Recurse; Remove-TestTree $original; $null = New-Item -ItemType Junction -Path $original -Target $outside }
        hard_link = { param($f) $original=Join-Path $f 'skills\perfect-code-v2\SKILL.md'; $outside=Join-Path (Split-Path -Parent $f) 'keep.txt'; Copy-Item -LiteralPath $original -Destination $outside; Remove-TestTree $original; $null = New-Item -ItemType HardLink -Path $original -Target $outside }
    }
    foreach ($name in $invalidSources.Keys) {
        $mutation = $invalidSources[$name]
        Invoke-TestCase "source rejects $name before writes" 'inventory' { Test-RejectedSource $mutation }
    }
    Invoke-TestCase 'installed hidden extra fails verification and remains a conflict' 'integration' {
        $target = Join-Path $script:TestRoot 'installed-extra\skills'
        & $install -TargetSkillRoot $target
        $extra = Join-Path $target 'perfect-code-v2\hidden.md'
        Write-TestFile $extra 'preserved user extra'; [IO.File]::SetAttributes($extra, [IO.FileAttributes]::Hidden)
        $before = Get-StackSnapshot (Split-Path -Parent $target)
        $null = Assert-TestThrows { & $verify -TargetSkillRoot $target }
        $null = Assert-TestThrows { & $install -TargetSkillRoot $target } 'Conflicts'
        Assert-Test ((Get-StackSnapshot (Split-Path -Parent $target)) -ceq $before) 'Conflict mutated user content.'
    }
    Invoke-TestCase 'upgrade backups outside discovery, exactly four identities, restorable' 'integration' {
        $target = Join-Path $script:TestRoot 'upgrade\skills'
        & $install -TargetSkillRoot $target
        $old = Join-Path $target 'perfect-code-v2\SKILL.md'; [IO.File]::AppendAllText($old, 'user change')
        $oldHash = Get-StackHash $old
        $oldSnapshot = Get-StackSnapshot (Split-Path -Parent $old)
        & $install -TargetSkillRoot $target -ReplaceConflicts
        & $verify -TargetSkillRoot $target
        Assert-Test ((Get-ChildItem -LiteralPath $target -Directory -Force).Count -eq 4) 'Unexpected discovery folders.'
        $backups = @(Get-ChildItem -LiteralPath (Join-Path (Split-Path -Parent $target) 'fix-antigravity-recovery') -Recurse -Directory | Where-Object Name -eq 'backup')
        Assert-Test ($backups.Count -eq 1) 'Expected one verified package backup.'
        Assert-Test (-not (Test-StackWithin $backups[0].FullName $target)) 'Backup inside discovery root.'
        $restored = Join-Path $script:TestRoot 'restored-package'
        Copy-Item -LiteralPath $backups[0].FullName -Destination $restored -Recurse
        Assert-Test ((Get-StackHash (Join-Path $restored 'SKILL.md')) -ceq $oldHash) 'Backup did not restore original bytes.'
        $current = Join-Path $target 'perfect-code-v2'
        Move-Item -LiteralPath $current -Destination (Join-Path (Split-Path -Parent $target) 'current-before-restore')
        Copy-Item -LiteralPath $restored -Destination $current -Recurse
        Assert-Test ((Get-StackSnapshot $current) -ceq $oldSnapshot) 'Actual destination restoration did not preserve the complete prior tree.'
    }
    Invoke-TestCase 'legacy duplicate backup is preserved and blocks before writes' 'integration' {
        $target = Join-Path $script:TestRoot 'legacy\skills'
        Write-TestFile (Join-Path $target 'perfect-code-v2.backup.old\SKILL.md') "---`nname: perfect-code-v2`n---`nold"
        $before = Get-StackSnapshot (Split-Path -Parent $target)
        $null = Assert-TestThrows { & $install -TargetSkillRoot $target -ReplaceConflicts } 'Duplicate skill'
        Assert-Test ((Get-StackSnapshot (Split-Path -Parent $target)) -ceq $before) 'Legacy backup moved or deleted.'
    }
    Invoke-TestCase 'backup root inside discovery is rejected before writes' 'integration' {
        $target = Join-Path $script:TestRoot 'bad-backup\skills'
        $null = Assert-TestThrows { & $install -TargetSkillRoot $target -BackupRoot (Join-Path $target 'backups') } 'BackupRoot'
        Assert-Test (-not (Test-Path -LiteralPath (Split-Path -Parent $target))) 'Bad backup path caused writes.'
    }
    Invoke-TestCase 'destination junction is not followed' 'integration' {
        $outside = Join-Path $script:TestRoot 'target-outside'; $null = New-Item -ItemType Directory -Path $outside
        $link = Join-Path $script:TestRoot 'target-link'; $null = New-Item -ItemType Junction -Path $link -Target $outside
        $null = Assert-TestThrows { & $install -TargetSkillRoot $link } 'Links/junctions'
        Assert-Test (@(Get-ChildItem -LiteralPath $outside -Force).Count -eq 0) 'Junction destination modified.'
    }

    foreach ($point in @('StageCopy', 'StageVerify', 'BackupCopy', 'BackupVerify', 'Deactivate', 'Activate', 'ActivationVerify')) {
        Invoke-TestCase "rule fault $point preserves/restores original" 'fault injection' {
            $parent = Join-Path $script:TestRoot ('fault-' + $point)
            $source = Join-Path $parent 'new-rule.md'; $destination = Join-Path $parent 'rules\active.md'
            Write-TestFile $source 'new rule'; Write-TestFile $destination 'original rule'
            $original = Get-StackSnapshot $destination
            $faultAt = $point
            $inject = { param($stage, $path) if ($stage -eq $faultAt) { throw [IO.IOException]::new("Injected $faultAt") } }.GetNewClosure()
            $null = Assert-TestThrows { Invoke-StackReplacement -Source $source -Destination $destination -RecoveryRoot (Join-Path $parent 'recovery') -OriginalSnapshot $original -NewSnapshot (Get-StackSnapshot $source) -FaultInjector $inject } 'Replacement failed'
            Assert-Test ((Get-StackSnapshot $destination) -ceq $original) 'Original not preserved/restored.'
        }
    }
    foreach ($point in @('Restore', 'RestoreVerify')) {
        Invoke-TestCase "rule $point failure is accurately reported with backup" 'fault injection' {
            $parent = Join-Path $script:TestRoot ('fault-' + $point)
            $source = Join-Path $parent 'new-rule.md'; $destination = Join-Path $parent 'rules\active.md'
            Write-TestFile $source 'new rule'; Write-TestFile $destination 'original rule'
            $original = Get-StackSnapshot $destination
            $faultAt = $point
            $inject = { param($stage, $path) if ($stage -eq 'Activate' -or $stage -eq $faultAt) { throw [IO.IOException]::new("Injected $stage") } }.GetNewClosure()
            $null = Assert-TestThrows { Invoke-StackReplacement -Source $source -Destination $destination -RecoveryRoot (Join-Path $parent 'recovery') -OriginalSnapshot $original -NewSnapshot (Get-StackSnapshot $source) -FaultInjector $inject } 'RESTORATION NOT VERIFIED'
            $backups = @(Get-ChildItem -LiteralPath (Join-Path $parent 'recovery') -Recurse -File | Where-Object Name -eq 'backup')
            Assert-Test ($backups.Count -eq 1 -and (Get-StackSnapshot $backups[0].FullName) -ceq $original) 'Manual recovery backup not preserved.'
        }
    }
    Invoke-TestCase 'rule access denied during stage preserves original' 'fault injection' {
        $parent=Join-Path $script:TestRoot 'access-denied'; $source=Join-Path $parent 'source'; $destination=Join-Path $parent 'active'
        Write-TestFile $source 'new'; Write-TestFile $destination 'old'; $old=Get-StackSnapshot $destination
        $null=Assert-TestThrows { Invoke-StackReplacement -Source $source -Destination $destination -RecoveryRoot (Join-Path $parent 'recovery') -OriginalSnapshot $old -NewSnapshot (Get-StackSnapshot $source) -FaultInjector { param($stage,$path) if ($stage -eq 'StageCopy') { throw [UnauthorizedAccessException]::new('Injected denied access') } } } 'denied access'
        Assert-Test ((Get-StackSnapshot $destination) -ceq $old) 'Denied staging affected active rule.'
    }

    Invoke-TestCase 'missing replacement source preserves active rule' 'fault injection' {
        $parent=Join-Path $script:TestRoot 'missing-source'; $destination=Join-Path $parent 'active'
        Write-TestFile $destination 'old'; $old=Get-StackSnapshot $destination
        $null=Assert-TestThrows { Invoke-StackReplacement -Source (Join-Path $parent 'absent') -Destination $destination -RecoveryRoot (Join-Path $parent 'recovery') -OriginalSnapshot $old -NewSnapshot 'FILE:missing' } 'Replacement failed'
        Assert-Test ((Get-StackSnapshot $destination) -ceq $old) 'Missing source affected original.'
    }
    Invoke-TestCase 'move with partial effect then error is reconciled and restored' 'fault injection' {
        $parent=Join-Path $script:TestRoot 'partial-move'; $source=Join-Path $parent 'source'; $destination=Join-Path $parent 'active'; $recovery=Join-Path $parent 'recovery'
        Write-TestFile $source 'new'; Write-TestFile $destination 'old'; $old=Get-StackSnapshot $destination
        $inject={ param($stage,$path) if ($stage -eq 'Deactivate') { $op=@(Get-ChildItem -LiteralPath $recovery -Directory)[0]; Move-Item -LiteralPath $path -Destination (Join-Path $op.FullName 'previous'); throw 'Injected moved-then-error' } }.GetNewClosure()
        $null=Assert-TestThrows { Invoke-StackReplacement -Source $source -Destination $destination -RecoveryRoot $recovery -OriginalSnapshot $old -NewSnapshot (Get-StackSnapshot $source) -FaultInjector $inject } 'restored and verified'
        Assert-Test ((Get-StackSnapshot $destination) -ceq $old) 'Partial move was not restored.'
    }
    Invoke-TestCase 'unexpected activation content is preserved for manual recovery' 'fault injection' {
        $parent=Join-Path $script:TestRoot 'unexpected-active'; $source=Join-Path $parent 'source'; $destination=Join-Path $parent 'active'; $recovery=Join-Path $parent 'recovery'
        Write-TestFile $source 'new'; Write-TestFile $destination 'old'; $old=Get-StackSnapshot $destination
        $inject={ param($stage,$path) if ($stage -eq 'Activate') { [IO.File]::WriteAllText($path,'concurrent user content'); throw 'Injected activation race' } }
        $null=Assert-TestThrows { Invoke-StackReplacement -Source $source -Destination $destination -RecoveryRoot $recovery -OriginalSnapshot $old -NewSnapshot (Get-StackSnapshot $source) -FaultInjector $inject } 'RESTORATION NOT VERIFIED'
        Assert-Test ([IO.File]::ReadAllText($destination) -ceq 'concurrent user content') 'Unexpected user content was overwritten.'
        $backup=@(Get-ChildItem -LiteralPath $recovery -Recurse -File | Where-Object Name -eq 'backup')[0]
        Assert-Test ((Get-StackSnapshot $backup.FullName) -ceq $old) 'Recovery original lost.'
    }
    Invoke-TestCase 'directory activation failure restores package and leaves no discoverable staging' 'fault injection' {
        $parent=Join-Path $script:TestRoot 'package-fault'; $source=Join-Path $parent 'source'; $destination=Join-Path $parent 'skills\perfect-code-v2'
        Write-TestFile (Join-Path $source 'SKILL.md') 'new core'; Write-TestFile (Join-Path $destination 'SKILL.md') 'old core'; Write-TestFile (Join-Path $destination 'user file.txt') 'preserved extra'
        $old=Get-StackSnapshot $destination
        $null=Assert-TestThrows { Invoke-StackReplacement -Source $source -Destination $destination -RecoveryRoot (Join-Path $parent 'recovery') -OriginalSnapshot $old -NewSnapshot (Get-StackSnapshot $source) -FaultInjector { param($stage,$path) if ($stage -eq 'Activate') { throw 'Injected activation failure' } } } 'restored and verified'
        Assert-Test ((Get-StackSnapshot $destination) -ceq $old) 'Package not restored.'
        Assert-Test (@(Get-ChildItem -LiteralPath (Split-Path -Parent $destination) -Directory -Force).Count -eq 1) 'Staging discovered in skill root.'
    }
    Invoke-TestCase 'source and destination overlap rejected before writes' 'integration' {
        $before=Get-StackSnapshot (Join-Path $repo 'skills')
        $null=Assert-TestThrows { & $install -TargetSkillRoot (Join-Path $repo 'skills') } 'overlap'
        Assert-Test ((Get-StackSnapshot (Join-Path $repo 'skills')) -ceq $before) 'Canonical files changed.'
    }

    foreach ($segment in @('skills.', 'skills ', 'skills:stream', 'skills[1]', 'CON')) {
        Invoke-TestCase "ambiguous destination segment '$segment' rejected before writes" 'integration' {
            $parent=Join-Path $script:TestRoot ('ambiguous-destination-' + [Guid]::NewGuid().ToString('N'))
            $null=Assert-TestThrows { & $install -TargetSkillRoot (Join-Path $parent $segment) } 'filesystem path'
            Assert-Test (-not (Test-Path -LiteralPath $parent)) 'Ambiguous destination caused writes.'
        }
    }

    foreach ($bom in @($false, $true)) {
        Invoke-TestCase "empty manifest merge and idempotence, UTF8 BOM=$bom" 'manifest integration' {
            $parent = Join-Path $script:TestRoot ('manifest-' + $bom); $path=Join-Path $parent 'skills.json'; $target=Join-Path $parent 'skills'
            Write-TestFile $path '{}' $bom
            & $install -TargetSkillRoot $target -RegisterManifest -ManifestPath $path
            & $verify -TargetSkillRoot $target -CheckManifest -ManifestPath $path
            Assert-Test ((Read-StackUtf8 $path).Bom -eq $bom) 'Encoding BOM changed.'
            $before=Get-StackSnapshot $parent
            & $install -TargetSkillRoot $target -RegisterManifest -ManifestPath $path
            Assert-Test ((Get-StackSnapshot $parent) -ceq $before) 'Manifest repeat was not idempotent.'
        }
    }
    $invalidJson = @('null', '[]', '42', 'true', '"text"', '{bad}', '{"entries":null}', '{"entries":{}}', '{"entries":[null]}', '{"entries":[{"path":42}]}', '{"entries":[{"path":""}]}', '{"entries":[{"path":"C:/same"},{"path":"C:\\same/"}]}', '{"entries":[],"entries":[]}', '{"a":1,"\u0061":2}', '{"entries":[],}', '{"entries":[]} trailing')
    $index = 0
    foreach ($json in $invalidJson) {
        $index++
        Invoke-TestCase "invalid manifest input $index fails before writes" 'manifest integration' {
            $parent=Join-Path $script:TestRoot ('invalid-json-' + $index); $path=Join-Path $parent 'skills.json'; $target=Join-Path $parent 'skills'
            Write-TestFile $path $json
            $before=Get-StackSnapshot $parent
            $null=Assert-TestThrows { & $install -TargetSkillRoot $target -RegisterManifest -ManifestPath $path }
            Assert-Test ((Get-StackSnapshot $parent) -ceq $before) 'Invalid manifest mutated original/configuration.'
        }
    }
    Invoke-TestCase 'deep JSON and precise scalar lexemes survive semantic round trip' 'unit' {
        $nested='{"leaf":"retained"}'; 1..36 | ForEach-Object { $nested='{"child":' + $nested + '}' }
        $text='{"entries":[{"path":"C:/other","custom":900719925474099312345}],"nested":' + $nested + ',"date":"2026-10-14T00:00:00Z","number":1.234567890123456789012345,"A":1,"a":2}'
        $merged=Merge-StackManifest -Text $text -Paths @('C:/new')
        $before=Read-StackJson $text; $after=Read-StackJson $merged.Text
        foreach ($key in @('nested','date','number','A','a')) { Assert-Test ($before.Members[$key].Raw -ceq $after.Members[$key].Raw) 'Unrelated data changed.' }
        Assert-Test ($before.Members['entries'].Items[0].Raw -ceq $after.Members['entries'].Items[0].Raw) 'Existing entry changed.'
    }
    Invoke-TestCase 'unsupported JSON depth fails closed' 'unit' {
        $nested='0'; 1..66 | ForEach-Object { $nested='{"child":' + $nested + '}' }
        $null=Assert-TestThrows { Merge-StackManifest -Text ('{"nested":' + $nested + '}') -Paths @('C:/new') } 'depth 64'
    }
    Invoke-TestCase 'deep unrelated JSON survives actual installation' 'manifest integration' {
        $parent=Join-Path $script:TestRoot 'deep-install'; $path=Join-Path $parent 'skills.json'; $target=Join-Path $parent 'skills'
        $nested='{"leaf":900719925474099312345}'; 1..36 | ForEach-Object { $nested='{"child":'+$nested+'}' }
        Write-TestFile $path ('{"custom":'+$nested+'}') $true
        $old=Read-StackJson (Read-StackUtf8 $path).Text
        & $install -TargetSkillRoot $target -RegisterManifest -ManifestPath $path
        & $verify -TargetSkillRoot $target -CheckManifest -ManifestPath $path
        $current=Read-StackJson (Read-StackUtf8 $path).Text
        Assert-Test ($old.Members['custom'].Raw -ceq $current.Members['custom'].Raw) 'Deep unrelated property lost.'
    }
    Invoke-TestCase 'unsupported UTF16 encoding fails without mutation' 'manifest integration' {
        $parent=Join-Path $script:TestRoot 'utf16'; $path=Join-Path $parent 'skills.json'; $target=Join-Path $parent 'skills'
        Write-TestFile $path '{}'
        [IO.File]::WriteAllText($path,'{}',[Text.Encoding]::Unicode)
        $old=Get-StackSnapshot $parent
        $null=Assert-TestThrows { & $install -TargetSkillRoot $target -RegisterManifest -ManifestPath $path } 'UTF-8'
        Assert-Test ((Get-StackSnapshot $parent) -ceq $old) 'Unsupported encoding modified original.'
    }
    foreach ($point in @('StageCopy','Activate')) {
        Invoke-TestCase "manifest write fault $point preserves original bytes" 'fault injection' {
            $parent=Join-Path $script:TestRoot ('manifest-fault-' + $point); $path=Join-Path $parent 'skills.json'
            Write-TestFile $path '{"custom":true}' $true; $old=Get-StackSnapshot $path
            $merged=Merge-StackManifest -Text (Read-StackUtf8 $path).Text -Paths @('C:/new')
            $bytes=[Text.Encoding]::UTF8.GetBytes($merged.Text)
            $faultAt = $point
            $inject={ param($stage,$unused) if ($stage -eq $faultAt) { throw [IO.IOException]::new('Injected write failure') } }.GetNewClosure()
            $null=Assert-TestThrows { Invoke-StackReplacement -Bytes $bytes -Destination $path -RecoveryRoot (Join-Path $parent 'recovery') -OriginalSnapshot $old -NewSnapshot ('FILE:' + (Get-StackBytesHash $bytes)) -FaultInjector $inject } 'Replacement failed'
            Assert-Test ((Get-StackSnapshot $path) -ceq $old) 'Manifest original bytes changed after failure.'
        }
    }
}
finally { Remove-TestTree }
$failed=@($script:TestResults | Where-Object Status -eq 'FAIL').Count
$passed=@($script:TestResults | Where-Object Status -eq 'PASS').Count
$categories=@($script:TestResults | Group-Object Category | ForEach-Object { [pscustomobject]@{ Category=$_.Name; Passed=@($_.Group | Where-Object Status -eq 'PASS').Count; Failed=@($_.Group | Where-Object Status -eq 'FAIL').Count } })
[pscustomobject]@{ Suite='hardening'; Runtime=$PSVersionTable.PSVersion.ToString(); Passed=$passed; Failed=$failed; Skipped=0; Categories=$categories }
if ($failed -gt 0) { throw "$failed hardening regression cases failed ($passed passed)." }
