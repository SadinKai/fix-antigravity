[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = [IO.Path]::GetFullPath((Split-Path -Parent $PSScriptRoot))
$installScript = Join-Path $repositoryRoot 'scripts\install.ps1'
$verifyScript = Join-Path $repositoryRoot 'scripts\verify-install.ps1'
$temporaryRoot = Join-Path ([IO.Path]::GetTempPath()) "fix-antigravity-$([Guid]::NewGuid().ToString('N'))"
$utf8NoBom = New-Object Text.UTF8Encoding($false)
$utf8WithBom = New-Object Text.UTF8Encoding($true)
$passed = 0

function Assert-True {
    param(
        [Parameter(Mandatory)][bool]$Condition,
        [Parameter(Mandatory)][string]$Message
    )
    if (-not $Condition) { throw "ASSERTION FAILED: $Message" }
}
function Assert-Throws {
    param(
        [Parameter(Mandatory)][scriptblock]$Operation,
        [Parameter(Mandatory)][string]$Message
    )
    $threw = $false
    try { & $Operation }
    catch { $threw = $true }
    if (-not $threw) { throw "ASSERTION FAILED: $Message" }
}

try {
    New-Item -ItemType Directory -Path $temporaryRoot | Out-Null

    # WhatIf previews without creating the selected target.
    $previewRoot = Join-Path $temporaryRoot 'preview\skills'
    & $installScript -TargetSkillRoot $previewRoot -WhatIf
    Assert-True (-not (Test-Path -LiteralPath $previewRoot)) 'WhatIf should not create the target skill root.'
    $passed++

    # Clean installation and verification.
    $cleanRoot = Join-Path $temporaryRoot 'clean\skills'
    & $installScript -TargetSkillRoot $cleanRoot
    & $verifyScript -TargetSkillRoot $cleanRoot
    Assert-True ((Get-ChildItem -LiteralPath $cleanRoot -Recurse -File).Count -eq 43) 'Clean install should contain exactly 43 package files.'
    $passed++

    # Repeat installation is idempotent and creates no backups.
    & $installScript -TargetSkillRoot $cleanRoot
    $repeatBackups = @(Get-ChildItem -LiteralPath (Split-Path -Parent $cleanRoot) -Recurse -Force | Where-Object Name -Like '*.backup.*')
    Assert-True ($repeatBackups.Count -eq 0) 'Identical repeat install should not create backups.'
    $passed++

    # Existing manifest remains valid and preserves unrelated properties and entries.
    $manifestRoot = Join-Path $temporaryRoot 'manifest'
    $manifestSkillRoot = Join-Path $manifestRoot 'skills'
    $manifestPath = Join-Path $manifestRoot 'skills.json'
    New-Item -ItemType Directory -Path $manifestRoot | Out-Null
    [IO.File]::WriteAllText($manifestPath, "{`"schema`":7,`"entries`":[{`"path`":`"C:/unrelated-skill`"}]}", $utf8WithBom)
    & $installScript -TargetSkillRoot $manifestSkillRoot -RegisterManifest -ManifestPath $manifestPath
    & $verifyScript -TargetSkillRoot $manifestSkillRoot -CheckManifest -ManifestPath $manifestPath
    $manifest = [IO.File]::ReadAllText($manifestPath) | ConvertFrom-Json
    Assert-True ($manifest.schema -eq 7) 'Unrelated manifest properties should be preserved.'
    Assert-True (@($manifest.entries | Where-Object path -eq 'C:/unrelated-skill').Count -eq 1) 'Unrelated manifest entries should be preserved.'
    Assert-True (@($manifest.entries).Count -eq 5) 'Exactly four package entries should be added.'
    $passed++

    # Conflicts fail closed before any package mutation; explicit replacement makes a backup.
    $conflictRoot = Join-Path $temporaryRoot 'conflict\skills'
    $conflictingPackage = Join-Path $conflictRoot 'perfect-code-v2'
    New-Item -ItemType Directory -Path $conflictingPackage -Force | Out-Null
    [IO.File]::WriteAllText((Join-Path $conflictingPackage 'SKILL.md'), 'user-owned conflict', $utf8NoBom)
    Assert-Throws { & $installScript -TargetSkillRoot $conflictRoot } 'Conflict should stop installation without -ReplaceConflicts.'
    Assert-True ([IO.File]::ReadAllText((Join-Path $conflictingPackage 'SKILL.md')) -eq 'user-owned conflict') 'Conflicting content should remain unchanged after failed preflight.'
    Assert-True (-not (Test-Path -LiteralPath (Join-Path $conflictRoot 'evidence-research'))) 'Preflight failure should prevent partial installation.'
    & $installScript -TargetSkillRoot $conflictRoot -ReplaceConflicts
    & $verifyScript -TargetSkillRoot $conflictRoot
    $recoveryRoot = Join-Path (Split-Path -Parent $conflictRoot) 'fix-antigravity-recovery'
    $packageBackups = @(Get-ChildItem -LiteralPath $recoveryRoot -Recurse -Directory | Where-Object Name -EQ 'backup')
    Assert-True ($packageBackups.Count -eq 1) 'Explicit package replacement should create one recoverable backup.'
    Assert-True ((Get-ChildItem -LiteralPath $conflictRoot -Directory).Count -eq 4) 'Only four intended packages should remain in the discovery root.'
    $passed++

    # Invalid manifest is rejected before package installation.
    $invalidRoot = Join-Path $temporaryRoot 'invalid'
    $invalidSkillRoot = Join-Path $invalidRoot 'skills'
    $invalidManifest = Join-Path $invalidRoot 'skills.json'
    New-Item -ItemType Directory -Path $invalidRoot | Out-Null
    [IO.File]::WriteAllText($invalidManifest, '{ invalid json', $utf8NoBom)
    Assert-Throws { & $installScript -TargetSkillRoot $invalidSkillRoot -RegisterManifest -ManifestPath $invalidManifest } 'Invalid manifest should stop preflight.'
    Assert-True (-not (Test-Path -LiteralPath $invalidSkillRoot)) 'Invalid manifest should cause no package mutation.'
    Assert-True ([IO.File]::ReadAllText($invalidManifest) -eq '{ invalid json') 'Invalid manifest should not be overwritten.'
    $passed++

    # Integrated rule is opt-in, idempotent, and conflict-safe.
    $integratedRoot = Join-Path $temporaryRoot 'integrated'
    $integratedSkillRoot = Join-Path $integratedRoot 'skills'
    $rulePath = Join-Path $integratedRoot 'rules\four-skill-stack.md'
    & $installScript -TargetSkillRoot $integratedSkillRoot -EnableIntegrated -RulePath $rulePath
    & $verifyScript -TargetSkillRoot $integratedSkillRoot -Integrated -RulePath $rulePath
    & $installScript -TargetSkillRoot $integratedSkillRoot -EnableIntegrated -RulePath $rulePath
    [IO.File]::AppendAllText($rulePath, "`n# local change`n", $utf8NoBom)
    Assert-Throws { & $installScript -TargetSkillRoot $integratedSkillRoot -EnableIntegrated -RulePath $rulePath } 'Changed rule should be treated as a conflict.'
    & $installScript -TargetSkillRoot $integratedSkillRoot -EnableIntegrated -RulePath $rulePath -ReplaceConflicts
    & $verifyScript -TargetSkillRoot $integratedSkillRoot -Integrated -RulePath $rulePath
    $ruleBackups = @(Get-ChildItem -LiteralPath (Join-Path $integratedRoot 'fix-antigravity-recovery') -Recurse -File | Where-Object Name -EQ 'backup')
    Assert-True ($ruleBackups.Count -eq 1) 'Explicit rule replacement should create one recoverable backup.'
    $passed++

    Write-Host "PASS: $passed isolated installer scenarios"
    [pscustomobject]@{ Suite = 'existing smoke'; Passed = $passed; Failed = 0; Skipped = 0 }
}
finally {
    $resolvedTemporary = [IO.Path]::GetFullPath($temporaryRoot)
    $resolvedSystemTemp = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd('\') + '\'
    if ($resolvedTemporary.StartsWith($resolvedSystemTemp, [StringComparison]::OrdinalIgnoreCase) -and (Test-Path -LiteralPath $resolvedTemporary)) {
        Remove-Item -LiteralPath $resolvedTemporary -Recurse -Force
    }
}
