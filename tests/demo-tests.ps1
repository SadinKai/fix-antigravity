#Requires -Version 5.1
[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
$repo=Split-Path -Parent $PSScriptRoot
. (Join-Path $repo 'scripts\package-common.ps1')
. (Join-Path $PSScriptRoot 'test-support.ps1')
try {
    Invoke-TestCase 'demo baseline has exactly the intended failure' 'demo oracle' {
        $demo=Join-Path $script:TestRoot 'baseline'
        Copy-Item -LiteralPath (Join-Path $repo 'examples\first-success\fixture') -Destination $demo -Recurse
        $output = @(); $threw=$false
        try { $output=@(& (Join-Path $demo 'test.ps1') 6>&1) } catch { $threw=$true }
        Assert-Test $threw 'Defective baseline unexpectedly passed.'
        # Independently inspect the three observable properties, even when a
        # terminating script prevents assignment of its buffered output.
        . (Join-Path $demo 'recipients.ps1')
        Assert-Test (@(Get-NotificationRecipients @('ALPHA','alpha',' ALPHA ')).Count -eq 3) 'Wrong seeded defect.'
        Assert-Test ((@(Get-NotificationRecipients @(' Beta ','Alpha')) -join '|') -ceq 'Beta|Alpha') 'Baseline ordering regressed.'
        Assert-Test (@(Get-NotificationRecipients @('', ' ', $null)).Count -eq 0) 'Baseline blank handling regressed.'
    }
    Invoke-TestCase 'human reference repair passes all three unchanged tests' 'demo oracle' {
        $demo=Join-Path $script:TestRoot 'reference'
        Copy-Item -LiteralPath (Join-Path $repo 'examples\first-success\fixture') -Destination $demo -Recurse
        $oracleHash=Get-StackHash (Join-Path $demo 'test.ps1')
        Copy-Item -LiteralPath (Join-Path $repo 'examples\first-success\reference-answer.ps1') -Destination (Join-Path $demo 'recipients.ps1') -Force
        & (Join-Path $demo 'test.ps1')
        Assert-Test ((Get-StackHash (Join-Path $demo 'test.ps1')) -ceq $oracleHash) 'Oracle was modified.'
    }
}
finally { Remove-TestTree }
$failed=@($script:TestResults | Where-Object Status -eq 'FAIL').Count
[pscustomobject]@{ Suite='demo'; Passed=$script:TestResults.Count-$failed; Failed=$failed; Skipped=0 }
if ($failed -gt 0) { throw 'Demo oracle validation failed.' }
