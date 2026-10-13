[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param(
    [Parameter()]
    [string]$TargetSkillRoot = (Join-Path $HOME '.gemini\config\skills'),

    [Parameter()]
    [switch]$EnableIntegrated,

    [Parameter()]
    [string]$RulePath = (Join-Path $HOME '.gemini\config\rules\four-skill-stack.md'),

    [Parameter()]
    [switch]$RegisterManifest,

    [Parameter()]
    [string]$ManifestPath = (Join-Path $HOME '.gemini\config\skills.json'),

    [Parameter()]
    [switch]$ReplaceConflicts
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$packageNames = @(
    'perfect-code-v2',
    'evidence-research',
    'continuity-recovery',
    'risk-change-assurance'
)

$repositoryRoot = [IO.Path]::GetFullPath((Split-Path -Parent $PSScriptRoot))
$sourceSkillRoot = Join-Path $repositoryRoot 'skills'
$sourceRule = Join-Path $repositoryRoot 'integration\four-skill-stack.md'
$checksumPath = Join-Path $repositoryRoot 'checksums.sha256'
$targetSkillRootFull = [IO.Path]::GetFullPath($TargetSkillRoot)
$sourceSkillRootFull = [IO.Path]::GetFullPath($sourceSkillRoot)

if ($targetSkillRootFull.TrimEnd('\', '/') -eq $sourceSkillRootFull.TrimEnd('\', '/')) {
    throw 'The installation target cannot be the repository source directory.'
}

function Get-FileMap {
    param([Parameter(Mandatory)][string]$Root)

    $map = @{}
    if (-not (Test-Path -LiteralPath $Root -PathType Container)) {
        return $map
    }

    foreach ($file in Get-ChildItem -LiteralPath $Root -Recurse -File) {
        $relative = $file.FullName.Substring(([IO.Path]::GetFullPath($Root)).TrimEnd('\').Length + 1).Replace('\', '/')
        $map[$relative] = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
    }
    return $map
}

function Test-TreesIdentical {
    param(
        [Parameter(Mandatory)][string]$Left,
        [Parameter(Mandatory)][string]$Right
    )

    $leftMap = Get-FileMap -Root $Left
    $rightMap = Get-FileMap -Root $Right
    if ($leftMap.Count -ne $rightMap.Count) { return $false }

    foreach ($key in $leftMap.Keys) {
        if (-not $rightMap.ContainsKey($key) -or $rightMap[$key] -ne $leftMap[$key]) {
            return $false
        }
    }
    return $true
}

function Get-BackupPath {
    param([Parameter(Mandatory)][string]$OriginalPath)

    $stamp = Get-Date -Format 'yyyyMMdd-HHmmssfff'
    $candidate = "$OriginalPath.backup.$stamp"
    if (Test-Path -LiteralPath $candidate) {
        $candidate = "$candidate.$([Guid]::NewGuid().ToString('N').Substring(0, 8))"
    }
    return $candidate
}

function Read-JsonObject {
    param([Parameter(Mandatory)][string]$Path)

    try {
        $text = [IO.File]::ReadAllText($Path)
        $value = $text | ConvertFrom-Json
    }
    catch {
        throw "Manifest JSON is invalid: $Path. $($_.Exception.Message)"
    }

    if ($null -eq $value -or $value -is [Array]) {
        throw "Manifest root must be a JSON object: $Path"
    }
    return $value
}

function Get-ManifestPackagePaths {
    param([Parameter(Mandatory)][string]$SkillRoot)

    $defaultRoot = [IO.Path]::GetFullPath((Join-Path $HOME '.gemini\config\skills')).TrimEnd('\', '/')
    $actualRoot = [IO.Path]::GetFullPath($SkillRoot).TrimEnd('\', '/')
    $paths = @{}
    foreach ($packageName in $packageNames) {
        if ($actualRoot -eq $defaultRoot) {
            $paths[$packageName] = "~/.gemini/config/skills/$packageName"
        }
        else {
            $paths[$packageName] = (Join-Path $actualRoot $packageName).Replace('\', '/')
        }
    }
    return $paths
}

# Preflight repository integrity before considering any mutation.
if (-not (Test-Path -LiteralPath $checksumPath -PathType Leaf)) {
    throw "Checksum manifest is missing: $checksumPath"
}

$expectedSource = @{}
foreach ($line in Get-Content -LiteralPath $checksumPath) {
    if ($line -match '^([0-9a-fA-F]{64})\s{2}(skills/.+)$') {
        $expectedSource[$Matches[2]] = $Matches[1].ToLowerInvariant()
    }
}
if ($expectedSource.Count -ne 43) {
    throw "Expected 43 package checksums, found $($expectedSource.Count)."
}

foreach ($entry in $expectedSource.GetEnumerator()) {
    $sourcePath = Join-Path $repositoryRoot ($entry.Key.Replace('/', '\'))
    if (-not (Test-Path -LiteralPath $sourcePath -PathType Leaf)) {
        throw "Release package file is missing: $($entry.Key)"
    }
    $actual = (Get-FileHash -LiteralPath $sourcePath -Algorithm SHA256).Hash.ToLowerInvariant()
    if ($actual -ne $entry.Value) {
        throw "Release package checksum mismatch: $($entry.Key)"
    }
}

$packageStates = @{}
foreach ($packageName in $packageNames) {
    $source = Join-Path $sourceSkillRoot $packageName
    $target = Join-Path $targetSkillRootFull $packageName
    if (-not (Test-Path -LiteralPath $source -PathType Container)) {
        throw "Source package is missing: $source"
    }

    if (-not (Test-Path -LiteralPath $target)) {
        $packageStates[$packageName] = 'Missing'
    }
    elseif (-not (Test-Path -LiteralPath $target -PathType Container)) {
        $packageStates[$packageName] = 'Conflict'
    }
    elseif (Test-TreesIdentical -Left $source -Right $target) {
        $packageStates[$packageName] = 'Identical'
    }
    else {
        $packageStates[$packageName] = 'Conflict'
    }
}

$ruleState = 'NotRequested'
if ($EnableIntegrated) {
    if (-not (Test-Path -LiteralPath $sourceRule -PathType Leaf)) {
        throw "Integrated rule source is missing: $sourceRule"
    }
    if (-not (Test-Path -LiteralPath $RulePath)) {
        $ruleState = 'Missing'
    }
    elseif (-not (Test-Path -LiteralPath $RulePath -PathType Leaf)) {
        $ruleState = 'Conflict'
    }
    elseif ((Get-FileHash -LiteralPath $sourceRule -Algorithm SHA256).Hash -eq (Get-FileHash -LiteralPath $RulePath -Algorithm SHA256).Hash) {
        $ruleState = 'Identical'
    }
    else {
        $ruleState = 'Conflict'
    }
}

$manifest = $null
$manifestChanged = $false
$manifestPackagePaths = $null
if ($RegisterManifest) {
    if (Test-Path -LiteralPath $ManifestPath) {
        if (-not (Test-Path -LiteralPath $ManifestPath -PathType Leaf)) {
            throw "Manifest path is not a file: $ManifestPath"
        }
        $manifest = Read-JsonObject -Path $ManifestPath
    }
    else {
        $manifest = [pscustomobject]@{ entries = @() }
    }

    if (-not ($manifest.PSObject.Properties.Name -contains 'entries')) {
        $manifest | Add-Member -NotePropertyName entries -NotePropertyValue @()
    }
    elseif ($null -eq $manifest.entries) {
        $manifest.entries = @()
    }
    elseif ($manifest.entries -isnot [Array]) {
        $manifest.entries = @($manifest.entries)
    }

    foreach ($existingEntry in @($manifest.entries)) {
        if ($null -eq $existingEntry -or -not ($existingEntry.PSObject.Properties.Name -contains 'path') -or $existingEntry.path -isnot [string]) {
            throw "Every manifest entry must be an object with a string path: $ManifestPath"
        }
    }

    $manifestPackagePaths = Get-ManifestPackagePaths -SkillRoot $targetSkillRootFull
    $existingPaths = @($manifest.entries | ForEach-Object { $_.path })
    foreach ($packageName in $packageNames) {
        $neededPath = $manifestPackagePaths[$packageName]
        if ($existingPaths -notcontains $neededPath) {
            $manifest.entries = @($manifest.entries) + [pscustomobject]@{ path = $neededPath }
            $manifestChanged = $true
        }
    }
}

$conflicts = @($packageStates.GetEnumerator() | Where-Object Value -eq 'Conflict' | ForEach-Object Key)
if ($ruleState -eq 'Conflict') { $conflicts += "rule:$RulePath" }
if ($conflicts.Count -gt 0 -and -not $ReplaceConflicts) {
    throw "Conflicts detected; no changes were made. Review these targets or rerun with -ReplaceConflicts: $($conflicts -join ', ')"
}

# Apply only after every requested input and conflict has passed preflight.
foreach ($packageName in $packageNames) {
    $state = $packageStates[$packageName]
    $source = Join-Path $sourceSkillRoot $packageName
    $target = Join-Path $targetSkillRootFull $packageName

    if ($state -eq 'Identical') {
        Write-Host "Identical; skipped: $packageName"
        continue
    }

    $action = if ($state -eq 'Conflict') { 'Back up and replace package' } else { 'Install package' }
    if ($PSCmdlet.ShouldProcess($target, $action)) {
        New-Item -ItemType Directory -Path $targetSkillRootFull -Force | Out-Null
        $temporary = Join-Path $targetSkillRootFull ".installing.$packageName.$([Guid]::NewGuid().ToString('N'))"
        Copy-Item -LiteralPath $source -Destination $temporary -Recurse
        $backup = $null
        try {
            if ($state -eq 'Conflict') {
                $backup = Get-BackupPath -OriginalPath $target
                Move-Item -LiteralPath $target -Destination $backup
                Write-Host "Backed up: $target -> $backup"
            }
            Move-Item -LiteralPath $temporary -Destination $target
            Write-Host "Installed: $packageName"
        }
        catch {
            if (Test-Path -LiteralPath $temporary) {
                Remove-Item -LiteralPath $temporary -Recurse -Force
            }
            if ($null -ne $backup -and -not (Test-Path -LiteralPath $target) -and (Test-Path -LiteralPath $backup)) {
                Move-Item -LiteralPath $backup -Destination $target
            }
            throw
        }
    }
}

if ($EnableIntegrated) {
    if ($ruleState -eq 'Identical') {
        Write-Host "Identical; skipped integrated rule: $RulePath"
    }
    else {
        $action = if ($ruleState -eq 'Conflict') { 'Back up and replace integrated rule' } else { 'Install integrated rule' }
        if ($PSCmdlet.ShouldProcess($RulePath, $action)) {
            $ruleParent = Split-Path -Parent ([IO.Path]::GetFullPath($RulePath))
            New-Item -ItemType Directory -Path $ruleParent -Force | Out-Null
            if ($ruleState -eq 'Conflict') {
                $ruleBackup = Get-BackupPath -OriginalPath $RulePath
                Move-Item -LiteralPath $RulePath -Destination $ruleBackup
                Write-Host "Backed up: $RulePath -> $ruleBackup"
            }
            Copy-Item -LiteralPath $sourceRule -Destination $RulePath
            Write-Host "Installed integrated rule: $RulePath"
        }
    }
}

if ($RegisterManifest) {
    if (-not $manifestChanged) {
        Write-Host "Manifest already contains all requested entries: $ManifestPath"
    }
    elseif ($PSCmdlet.ShouldProcess($ManifestPath, 'Merge four skill paths into manifest')) {
        $manifestParent = Split-Path -Parent ([IO.Path]::GetFullPath($ManifestPath))
        New-Item -ItemType Directory -Path $manifestParent -Force | Out-Null
        $manifestTemporary = Join-Path $manifestParent ".installing.skills.$([Guid]::NewGuid().ToString('N')).json"
        $json = $manifest | ConvertTo-Json -Depth 32
        $utf8NoBom = New-Object Text.UTF8Encoding($false)
        [IO.File]::WriteAllText($manifestTemporary, $json + [Environment]::NewLine, $utf8NoBom)
        $null = Read-JsonObject -Path $manifestTemporary

        if (Test-Path -LiteralPath $ManifestPath) {
            $manifestBackup = Get-BackupPath -OriginalPath $ManifestPath
            Copy-Item -LiteralPath $ManifestPath -Destination $manifestBackup
            Write-Host "Backed up manifest: $ManifestPath -> $manifestBackup"
        }
        Move-Item -LiteralPath $manifestTemporary -Destination $ManifestPath -Force
        Write-Host "Merged manifest entries: $ManifestPath"
    }
}

Write-Host 'Installation operation complete. Run scripts\verify-install.ps1 with matching parameters.'
