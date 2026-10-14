#Requires -Version 5.1
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'recipients.ps1')
$passed = 0; $failed = 0
$checks = [ordered]@{
    deduplicates_case_insensitively = { @(Get-NotificationRecipients @('ALPHA', 'alpha', ' ALPHA ')).Count -eq 1 }
    preserves_first_spelling_and_order = { (@(Get-NotificationRecipients @(' Beta ', 'Alpha')) -join '|') -ceq 'Beta|Alpha' }
    ignores_empty_recipients = { @(Get-NotificationRecipients @('', '  ', $null)).Count -eq 0 }
}
foreach ($name in $checks.Keys) {
    if (& $checks[$name]) { $passed++; Write-Host "PASS: $name" }
    else { $failed++; Write-Host "FAIL: $name" }
}
Write-Host "RESULT: $passed passed, $failed failed, 3 total"
if ($failed -gt 0) { throw 'Demo defect remains. Expected baseline: 2 passed, 1 failed. Success: 3 passed, 0 failed.' }
