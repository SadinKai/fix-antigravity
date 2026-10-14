#Requires -Version 5.1
[CmdletBinding()]
param(
    [string]$TargetSkillRoot = (Join-Path $HOME '.gemini\config\skills'),
    [switch]$Integrated,
    [string]$RulePath = (Join-Path $HOME '.gemini\config\rules\four-skill-stack.md'),
    [switch]$CheckManifest,
    [string]$ManifestPath = (Join-Path $HOME '.gemini\config\skills.json')
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'package-common.ps1')
. (Join-Path $PSScriptRoot 'manifest-json.ps1')
$repositoryRoot = Get-StackFullPath (Split-Path -Parent $PSScriptRoot)
$expected = Read-StackChecksums (Join-Path $repositoryRoot 'checksums.sha256')
Assert-StackInventory -Root (Join-Path $repositoryRoot 'skills') -Expected $expected
$root = Get-StackFullPath $TargetSkillRoot
Assert-StackNoLink $root
foreach ($name in $script:StackPackages) { Assert-StackInventory -Root (Join-Path $root $name) -Expected (Get-StackPackageMap $expected $name) }
Assert-StackUniqueSkills $root
if ($Integrated) {
    $RulePath = Get-StackFullPath $RulePath
    Assert-StackNoLink $RulePath
    Assert-StackRule $RulePath
    if ((Get-StackHash $RulePath) -cne (Get-StackHash (Join-Path $repositoryRoot 'integration\four-skill-stack.md'))) { throw 'Integrated rule differs from this source revision.' }
}
if ($CheckManifest) {
    $ManifestPath = Get-StackFullPath $ManifestPath
    $node = Read-StackJson (Read-StackUtf8 $ManifestPath).Text
    $keys = Assert-StackManifest $node
    foreach ($path in Get-StackManifestPaths $root) { if (-not $keys.Contains((Get-StackManifestKey $path))) { throw 'Manifest is missing a requested package path.' } }
}
Write-Host 'PASS: all 43 package files match the exact inventory and SHA-256 manifest (including hidden files).'
if ($Integrated) { Write-Host 'PASS: integrated rule matches this revision.' }
if ($CheckManifest) { Write-Host 'PASS: compatibility manifest is valid and contains all four paths.' }
Write-Host 'Host discovery, activation, and model behavior are not established by this filesystem check.'
