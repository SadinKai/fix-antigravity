Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$script:TestResults = [Collections.Generic.List[object]]::new()
$script:TestRoot = Join-Path ([IO.Path]::GetTempPath()) ('fix-antigravity-tests-' + [Guid]::NewGuid().ToString('N'))
$null = New-Item -ItemType Directory -Path $script:TestRoot

function Assert-Test {
    param([bool]$Condition, [string]$Message)
    if (-not $Condition) { throw "ASSERTION FAILED: $Message" }
}
function Assert-TestThrows {
    param([scriptblock]$Action, [string]$Pattern = '.')
    $message = $null
    try { & $Action | Out-Null } catch { $message = $_.Exception.Message }
    if ($null -eq $message -or $message -notmatch $Pattern) { throw "Expected failure matching '$Pattern'; got '$message'." }
    return $message
}
function Invoke-TestCase {
    param([string]$Name, [string]$Category, [scriptblock]$Action)
    try { & $Action | Out-Null; $script:TestResults.Add([pscustomobject]@{ Name = $Name; Category = $Category; Status = 'PASS' }); Write-Host "PASS: $Name" }
    catch { $script:TestResults.Add([pscustomobject]@{ Name = $Name; Category = $Category; Status = 'FAIL' }); Write-Host "FAIL: $Name -- $($_.Exception.Message)" }
}
function Write-TestFile {
    param([string]$Path, [string]$Text, [bool]$Bom = $false)
    if (-not (Test-StackWithin $Path $script:TestRoot)) { throw 'Fixture write escaped generated test root.' }
    $null = [IO.Directory]::CreateDirectory((Split-Path -Parent $Path))
    [IO.File]::WriteAllText($Path, $Text, (New-Object Text.UTF8Encoding($Bom)))
}
function Remove-TestTree {
    param([string]$Path = $script:TestRoot)
    # Native single-shell cleanup: validate the exact generated target, never
    # recurse through junctions, and never delete a broad temp/workspace root.
    $full = Get-StackFullPath $Path
    $temp = (Get-StackFullPath ([IO.Path]::GetTempPath())).TrimEnd('\', '/')
    $owned = Get-StackFullPath $script:TestRoot
    if ((Split-Path -Parent $owned) -ne $temp -or [IO.Path]::GetFileName($owned) -notmatch '^fix-antigravity-tests-[0-9a-f]{32}$' -or -not (Test-StackWithin $full $owned)) { throw 'Unsafe test cleanup target.' }
    try { $attributes = [IO.File]::GetAttributes($full) }
    catch [IO.FileNotFoundException] { return }
    catch [IO.DirectoryNotFoundException] { return }
    if (($attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
        if (($attributes -band [IO.FileAttributes]::Directory) -ne 0) { [IO.Directory]::Delete($full, $false) } else { [IO.File]::Delete($full) }
    }
    elseif (($attributes -band [IO.FileAttributes]::Directory) -ne 0) {
        foreach ($child in Get-ChildItem -LiteralPath $full -Force) { Remove-TestTree $child.FullName }
        [IO.Directory]::Delete($full, $false)
    }
    else { [IO.File]::SetAttributes($full, [IO.FileAttributes]::Normal); [IO.File]::Delete($full) }
}
