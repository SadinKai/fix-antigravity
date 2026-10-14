# Installation, updates and recovery

Read [compatibility/input limits](compatibility.md). Automation targets Windows PowerShell 5.1 and PowerShell 7; no external module is needed. Review scripts first. Follow organizational execution policy; never pipe a remote script into a shell.

## Acquire and choose

~~~powershell
git clone https://github.com/SadinKai/fix-antigravity.git
Set-Location .\fix-antigravity
# IDE / app:
$skillRoot = Join-Path $HOME '.gemini\config\skills'
# CLI instead:
# $skillRoot = Join-Path $HOME '.gemini\antigravity-cli\skills'
# Workspace instead, outside this checkout:
# $skillRoot = 'C:\work\your-project\.agents\skills'
~~~

An inspected archive works too. Main moves; [release guidance](releases.md) explains commit pinning and actual release status. CLI and IDE global roots differ. [Official paths](https://www.antigravity.google/docs/skills?tab=ide) govern your host version.

Destinations/recovery storage must not overlap the checkout, active roots or each other. Links/junctions are refused; do not blindly replace user-managed links.

Relative filesystem parameters use the caller's current PowerShell filesystem location, including nonexistent targets and normalized dot segments, not the process working directory. Relative paths from a non-filesystem provider fail before writes. The same resolver is used by verification, snapshots and recovery helpers.

## Individual mode

~~~powershell
.\scripts\install.ps1 -TargetSkillRoot $skillRoot -WhatIf
.\scripts\install.ps1 -TargetSkillRoot $skillRoot
.\scripts\verify-install.ps1 -TargetSkillRoot $skillRoot
~~~

Preview performs read-only preflight and creates no installation/configuration/backups. Malformed sources/configuration still fail in preview. Identical packages are skipped; conflicts require explicit review/replacement.

## Integrated mode (opt-in)

~~~powershell
$rulePath = Join-Path $HOME '.gemini\config\rules\four-skill-stack.md'
# CLI instead:
# $rulePath = Join-Path $HOME '.gemini\antigravity-cli\rules\four-skill-stack.md'
.\scripts\install.ps1 -TargetSkillRoot $skillRoot -EnableIntegrated -RulePath $rulePath -WhatIf
.\scripts\install.ps1 -TargetSkillRoot $skillRoot -EnableIntegrated -RulePath $rulePath
.\scripts\verify-install.ps1 -TargetSkillRoot $skillRoot -Integrated -RulePath $rulePath
~~~

The unchanged always_on contract is guidance, not enforcement. No GEMINI.md or permission setting is changed. Start a fresh host session and try [the disposable demo](../examples/first-success/README.md). Filesystem PASS does not establish discovery/activation.

Antigravity invocation: /perfect-code-v2, /evidence-research, /continuity-recovery, /risk-change-assurance. Dollar-prefixed metadata is host-specific.

## Update and conflicts

Acquire an inspected approved revision separately. Verify its manifest; do not change hashes to accept unexpected content. Preserve customizations and stop competing writers. Use the same exact skill/rule/manifest paths as before.

A changed/extra installed file is a user-installation conflict. Invalid source inventory is a source-integrity failure that replacement never bypasses. After inspecting differences:

~~~powershell
.\scripts\install.ps1 -TargetSkillRoot $skillRoot -ReplaceConflicts -WhatIf
.\scripts\install.ps1 -TargetSkillRoot $skillRoot -ReplaceConflicts
.\scripts\verify-install.ps1 -TargetSkillRoot $skillRoot
~~~

Include matching integrated options when updating that rule; manifest options only when actually required.

## Recovery artifacts

Default root: parent-of-selected-skill-root/fix-antigravity-recovery. Explicit and default recovery roots are validated against the selected target and documented workspace/global/legacy/plugin layouts, including the recovery path's own ancestry. Unsafe overlap fails before writes. See [the supported boundary](compatibility.md#recovery-and-candidate-boundaries); this cannot enumerate arbitrary custom indexing roots.

Each unique target-name.timestamp.GUID operation directory contains:

- restore-info.json: exact destination, original/replacement snapshots and UTC date.
- backup: verified prior copy, when one existed.
- previous: preserved active original after deactivation, when applicable.
- staged/failed-activation: possible retained failure artifacts.

Keep receipts/backups private. No old backup is automatically deleted. Historical in-root duplicate candidates block pending manual review; they are not silently migrated.

Staging and backup verification precede active moves. On failure the installer inspects actual effects, attempts restoration without overwriting unexpected content, and verifies before claiming recovery. Failed restoration identifies artifacts for manual action. Earlier successful destinations are **not** rolled back automatically.

## Restore a previous installation

1. Stop competing writers. Read the exact restore-info.json; confirm destination, source revision, backup contents and ownership.
2. Dot-source scripts/package-common.ps1 from the inspected checkout. Compare Get-StackSnapshot of backup with the receipt's originalSnapshot; stop on mismatch.
3. Stage a copy outside discovery roots and verify that snapshot. Preserve the current active destination separately before replacing it; never overwrite unexplained changes.
4. Move only that exact active destination to a new unique recovery location, then copy the verified prior package/rule/configuration to the exact destination. If either step fails, stop and inspect actual effects; preserved copies remain recovery sources.
5. Verify restored bytes against originalSnapshot. For an older version use its matching manifest/verifier; the newer verifier may correctly reject the restored version.
6. Restart and inspect host discovery separately. Restore additional packages only when their receipts/compatibility require it.

A backup's existence alone does not prove rollback viability. Do not use broad cleanup commands.

## Optional observed manifest compatibility

Folder discovery is default. Only when your installation actually requires the observed entries/path format:

~~~powershell
.\scripts\install.ps1 -TargetSkillRoot $skillRoot -RegisterManifest -ManifestPath 'C:\exact\config\skills.json' -WhatIf
.\scripts\install.ps1 -TargetSkillRoot $skillRoot -RegisterManifest -ManifestPath 'C:\exact\config\skills.json'
.\scripts\verify-install.ps1 -TargetSkillRoot $skillRoot -CheckManifest -ManifestPath 'C:\exact\config\skills.json'
~~~

Empty object roots work. Strict bounded JSON is validated; unrelated subtrees/entries remain verbatim and are checked through a semantic round trip before writes. UTF-8 BOM choice is preserved. The final encoded bytes, including the BOM, must fit 1,048,576 bytes before any requested package/rule/configuration operation starts; those same bytes are staged and written. Merged files use verified recovery; malformed/oversized inputs are rejected, not repaired. See [limits](compatibility.md).

## Manual installation and removal

Copy the four complete package directories into the matching root. Never leave staging/backups containing SKILL.md there. Preserve local work. Copy the contract to a modular rule only if wanted; never overwrite GEMINI.md. Verify explicit paths.

For removal, review ownership and preserve modifications, then remove only these exact package directories: perfect-code-v2, evidence-research, continuity-recovery, risk-change-assurance. Remove only this project's matching rule and registrations if installed. Preserve unrelated skills/rules/properties and recovery artifacts. No broad cleanup or automatic uninstall is provided.
