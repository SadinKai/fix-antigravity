[CmdletBinding()]
param(
    [Parameter()]
    [string]$TargetSkillRoot = (Join-Path $HOME '.gemini\config\skills'),

    [Parameter()]
    [switch]$Integrated,

    [Parameter()]
    [string]$RulePath = (Join-Path $HOME '.gemini\config\rules\four-skill-stack.md'),

    [Parameter()]
    [switch]$CheckManifest,

    [Parameter()]
    [string]$ManifestPath = (Join-Path $HOME '.gemini\config\skills.json')
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
$checksumPath = Join-Path $repositoryRoot 'checksums.sha256'
$failures = [Collections.Generic.List[string]]::new()

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

if (-not (Test-Path -LiteralPath $checksumPath -PathType Leaf)) {
    throw "Checksum manifest is missing: $checksumPath"
}

$expected = @{}
foreach ($line in Get-Content -LiteralPath $checksumPath) {
    if ($line -match '^([0-9a-fA-F]{64})\s{2}skills/(.+)$') {
        $expected[$Matches[2]] = $Matches[1].ToLowerInvariant()
    }
}
if ($expected.Count -ne 43) {
    $failures.Add("Checksum manifest should contain 43 package files; found $($expected.Count).")
}

$targetRootFull = [IO.Path]::GetFullPath($TargetSkillRoot)
foreach ($entry in $expected.GetEnumerator()) {
    $installedPath = Join-Path $targetRootFull ($entry.Key.Replace('/', '\'))
    if (-not (Test-Path -LiteralPath $installedPath -PathType Leaf)) {
        $failures.Add("Missing: $($entry.Key)")
        continue
    }
    $actual = (Get-FileHash -LiteralPath $installedPath -Algorithm SHA256).Hash.ToLowerInvariant()
    if ($actual -ne $entry.Value) {
        $failures.Add("Changed: $($entry.Key)")
    }
}

foreach ($packageName in $packageNames) {
    $packageRoot = Join-Path $targetRootFull $packageName
    if (-not (Test-Path -LiteralPath $packageRoot -PathType Container)) { continue }
    foreach ($file in Get-ChildItem -LiteralPath $packageRoot -Recurse -File) {
        $relative = "$packageName/" + $file.FullName.Substring($packageRoot.Length + 1).Replace('\', '/')
        if (-not $expected.ContainsKey($relative)) {
            $failures.Add("Unexpected package file: $relative")
        }
    }
}

if ($Integrated) {
    $sourceRule = Join-Path $repositoryRoot 'integration\four-skill-stack.md'
    if (-not (Test-Path -LiteralPath $RulePath -PathType Leaf)) {
        $failures.Add("Integrated rule is missing: $RulePath")
    }
    elseif ((Get-FileHash -LiteralPath $sourceRule -Algorithm SHA256).Hash -ne (Get-FileHash -LiteralPath $RulePath -Algorithm SHA256).Hash) {
        $failures.Add("Integrated rule differs from this release: $RulePath")
    }
}

if ($CheckManifest) {
    if (-not (Test-Path -LiteralPath $ManifestPath -PathType Leaf)) {
        $failures.Add("Manifest is missing: $ManifestPath")
    }
    else {
        try {
            $manifest = [IO.File]::ReadAllText($ManifestPath) | ConvertFrom-Json
            if ($null -eq $manifest -or $manifest -is [Array] -or -not ($manifest.PSObject.Properties.Name -contains 'entries')) {
                throw 'Manifest root must be an object with an entries property.'
            }
            $actualPaths = @($manifest.entries | ForEach-Object {
                if ($null -eq $_ -or -not ($_.PSObject.Properties.Name -contains 'path') -or $_.path -isnot [string]) {
                    throw 'Every manifest entry must contain a string path.'
                }
                $_.path
            })
            $neededPaths = Get-ManifestPackagePaths -SkillRoot $targetRootFull
            foreach ($packageName in $packageNames) {
                if ($actualPaths -notcontains $neededPaths[$packageName]) {
                    $failures.Add("Manifest entry is missing for: $packageName")
                }
            }
        }
        catch {
            $failures.Add("Manifest cannot be validated: $($_.Exception.Message)")
        }
    }
}

if ($failures.Count -gt 0) {
    Write-Error ("Verification failed:`n- " + ($failures -join "`n- "))
    throw "Installation verification failed with $($failures.Count) issue(s)."
}

Write-Host "PASS: all 43 package files match checksums in $targetRootFull"
if ($Integrated) { Write-Host "PASS: integrated rule matches $RulePath" }
if ($CheckManifest) { Write-Host "PASS: manifest parses and contains all four package entries" }
