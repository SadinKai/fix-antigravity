# First success: one duplicate notification defect

Requires Windows PowerShell 5.1 or PowerShell 7; no extra modules or network calls.
This is a tiny demonstration, not evidence of general agent reliability.

From the Fix Antigravity checkout, copy only the defective fixture into a new,
uniquely named disposable workspace:

```powershell
$demo = Join-Path ([IO.Path]::GetTempPath()) ('fix-antigravity-demo-' + [Guid]::NewGuid().ToString('N'))
Copy-Item -LiteralPath .\examples\first-success\fixture -Destination $demo -Recurse
$shell = (Get-Process -Id $PID).Path
& $shell -NoProfile -File (Join-Path $demo 'test.ps1')
```

Expected baseline: **2 passed, 1 failed**, exit code **1**. `ALPHA`, `alpha`, and
` ALPHA ` must produce one recipient; the first spelling and ordering must remain.
No notification is sent: the function only returns synthetic recipient names.

Open `$demo` as the Antigravity workspace after installing the skills and starting
a fresh session. The AI step is **manual / NOT RUN in the published example**:

```text
/perfect-code-v2 Fix the duplicate notification-recipient defect in this disposable
workspace. Run test.ps1 to establish the baseline, preserve the documented order,
first spelling and blank-input behavior, change only recipients.ps1, and rerun the
unchanged tests. Report only checks actually executed. Keep the task proportionate.
```

Rerun the same command in the same shell. Success is **3 passed, 0 failed**, exit
code **0**, with only `recipients.ps1` changed. Inspect the diff and test file;
weakening the oracle is not success. The relevant owner is Perfect Code V2; other
skills should remain dormant unless the actual task creates a material need.

The repository's validation gate separately tests a **human-written reference
repair** against this oracle. That validates the demonstration, not AI invocation,
routing or model quality. The reference answer is deliberately outside `fixture/`.
Keep or remove only the exact generated demo folder after reviewing its contents;
do not use a broad temporary-directory cleanup command.

See [evaluation protocol](../../docs/evaluation.md) for actual behavioral trials.
