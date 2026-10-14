#Requires -Version 5.1
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param(
    [string]$TargetSkillRoot = (Join-Path $HOME '.gemini\config\skills'),
    [switch]$EnableIntegrated,
    [string]$RulePath = (Join-Path $HOME '.gemini\config\rules\four-skill-stack.md'),
    [switch]$RegisterManifest,
    [string]$ManifestPath = (Join-Path $HOME '.gemini\config\skills.json'),
    [switch]$ReplaceConflicts,
    [string]$BackupRoot
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'package-common.ps1')
. (Join-Path $PSScriptRoot 'manifest-json.ps1')
$repositoryRoot = Get-StackFullPath (Split-Path -Parent $PSScriptRoot)
$sourceRoot = Join-Path $repositoryRoot 'skills'
$targetRoot = Get-StackFullPath $TargetSkillRoot

# All input, inventory, conflict, and path checks precede the first write.
$manifest = Read-StackChecksums (Join-Path $repositoryRoot 'checksums.sha256')
Assert-StackInventory -Root $sourceRoot -Expected $manifest
$otherTargets = @()
if ($EnableIntegrated) { $RulePath = Get-StackFullPath $RulePath; $otherTargets += $RulePath }
if ($RegisterManifest) { $ManifestPath = Get-StackFullPath $ManifestPath; $otherTargets += $ManifestPath }
foreach ($path in (@($targetRoot) + $otherTargets)) {
    Assert-StackNoLink $path
    if ((Test-StackWithin $path $repositoryRoot) -or (Test-StackWithin $repositoryRoot $path)) { throw 'Installation destinations must not overlap this source checkout.' }
    if ((Get-StackFullPath ([IO.Path]::GetPathRoot($path))) -eq $path) { throw 'A filesystem root is not a valid destination.' }
}
for ($i = 0; $i -lt $otherTargets.Count; $i++) {
    if ((Test-StackWithin $otherTargets[$i] $targetRoot) -or (Test-StackWithin $targetRoot $otherTargets[$i])) { throw 'Skill root and configuration destinations must not overlap.' }
    for ($j = 0; $j -lt $i; $j++) {
        if ((Test-StackWithin $otherTargets[$i] $otherTargets[$j]) -or (Test-StackWithin $otherTargets[$j] $otherTargets[$i])) { throw 'Rule and manifest destinations must not overlap.' }
    }
}
if (Test-Path -LiteralPath $targetRoot -PathType Leaf) { throw 'TargetSkillRoot must be a directory.' }
Assert-StackUniqueSkills $targetRoot
$recoveryRoot = Get-StackRecoveryRoot -TargetRoot $targetRoot -RequestedRoot $BackupRoot -OtherTargets $otherTargets
if ((Test-StackWithin $recoveryRoot $repositoryRoot) -or (Test-StackWithin $repositoryRoot $recoveryRoot)) { throw 'BackupRoot must not overlap the source checkout.' }
$operations = @()
foreach ($name in $script:StackPackages) {
    $source = Join-Path $sourceRoot $name; $destination = Join-Path $targetRoot $name
    $operations += [pscustomobject]@{ Name = $name; Source = $source; Bytes = $null; Destination = $destination; Original = (Get-StackSnapshot $destination); New = (Get-StackSnapshot $source); RequiresReplace = $true }
}
if ($EnableIntegrated) {
    if ([IO.Path]::GetFileName($RulePath) -ieq 'GEMINI.md') { throw 'The installer never replaces GEMINI.md; select a modular rule file.' }
    $sourceRule = Join-Path $repositoryRoot 'integration\four-skill-stack.md'
    Assert-StackRule $sourceRule
    if (Test-Path -LiteralPath $RulePath -PathType Container) { throw 'RulePath must be a file.' }
    $operations += [pscustomobject]@{ Name = 'integrated rule'; Source = $sourceRule; Bytes = $null; Destination = $RulePath; Original = (Get-StackSnapshot $RulePath); New = (Get-StackSnapshot $sourceRule); RequiresReplace = $true }
}
if ($RegisterManifest) {
    if (Test-Path -LiteralPath $ManifestPath -PathType Container) { throw 'ManifestPath must be a file.' }
    $original = Get-StackSnapshot $ManifestPath
    $inputText = if ($original -ceq 'MISSING') { [pscustomobject]@{ Text = '{}'; Bom = $false } } else { Read-StackUtf8 $ManifestPath }
    $merged = Merge-StackManifest -Text $inputText.Text -Paths @(Get-StackManifestPaths $targetRoot)
    # These exact bounded bytes are hashed, staged and written; include the BOM.
    [byte[]]$bytes = ConvertTo-StackUtf8Bytes -Text $merged.Text -Bom $inputText.Bom
    $operations += [pscustomobject]@{ Name = 'compatibility manifest'; Source = $null; Bytes = $bytes; Destination = $ManifestPath; Original = $original; New = ('FILE:' + (Get-StackBytesHash $bytes)); RequiresReplace = $false }
}
$conflicts = @($operations | Where-Object { $_.RequiresReplace -and $_.Original -cne 'MISSING' -and $_.Original -cne $_.New })
if ($conflicts.Count -gt 0 -and -not $ReplaceConflicts) { throw "Conflicts detected; no writes made. Inspect targets before using -ReplaceConflicts: $($conflicts.Name -join ', ')" }

foreach ($operation in $operations) {
    if ($operation.Original -ceq $operation.New) { Write-Host "Identical; skipped: $($operation.Name)"; continue }
    if ($PSCmdlet.ShouldProcess($operation.Destination, "Stage, verify, preserve and activate $($operation.Name); recovery root: $recoveryRoot")) {
        # Recheck source inventory immediately before each operation. Staged
        # snapshots are checked before any active target is moved.
        Assert-StackInventory -Root $sourceRoot -Expected $manifest
        Invoke-StackReplacement -Source $operation.Source -Bytes $operation.Bytes -Destination $operation.Destination -RecoveryRoot $recoveryRoot -OriginalSnapshot $operation.Original -NewSnapshot $operation.New
    }
}
if ($WhatIfPreference) { Write-Host 'Preview complete; no installation or backup writes performed.' }
else { Write-Host 'Requested operations processed. Run verify-install.ps1 with matching parameters. Multiple destinations are not one transaction.' }
