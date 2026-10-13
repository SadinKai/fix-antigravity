# Troubleshooting

## A skill is not discovered

1. Confirm the selected Antigravity surface and version.
2. Run `scripts/verify-install.ps1` with the same `-TargetSkillRoot` used for installation.
3. Confirm each package contains `SKILL.md` at its root.
4. Start a fresh Antigravity session.
5. Check the current [Antigravity skill paths](https://www.antigravity.google/docs/skills?tab=ide). CLI-global and IDE / 2.0-global roots differ.

Do not add manifest entries merely by guess. Use `-RegisterManifest` only if your installation actually requires the observed compatibility manifest.

## The integrated contract is ignored

Run:

```powershell
.\scripts\verify-install.ps1 -Integrated -RulePath 'C:\exact\path\to\four-skill-stack.md'
```

Confirm the rule is in the modular rule directory for the active surface and retains its YAML frontmatter with `trigger: always_on`. Restart the session. A valid rule is persistent guidance, not a guarantee that a model will route perfectly.

## Installer reports a conflict

A conflict means the target package or rule differs from this release, including extra files. Inspect both copies. Keep the existing version if it contains user work. If replacement is intentional, rerun with `-ReplaceConflicts`; the installer moves the prior copy to a timestamped backup first.

## Manifest parsing fails

The installer performs no mutation when the selected manifest is invalid during preflight. Repair the JSON with a parser or omit manifest registration when folder discovery is supported. Do not replace the file with a minimal project-only manifest; it may contain unrelated registrations or properties.

## Permission prompts appear

Use Antigravity's native permission flow. These skills and scripts do not bypass Deny, Ask, sandbox, filesystem, URL, MCP, or project controls. Choose a user-writable target or perform a reviewed manual install.

## Verification reports changed or unexpected files

Treat this as a real integrity difference. It can be a legitimate local customization, a partial install, or unwanted mutation. The verifier does not delete or repair it. Compare against `checksums.sha256`, preserve user changes, and reinstall only after deciding ownership.

## PowerShell execution policy blocks scripts

Review the scripts locally before choosing an execution-policy approach allowed by your organization. You can always follow the manual installation procedure. Do not download and pipe a remote script directly into PowerShell.

## A task becomes overly procedural

Check that only materially relevant skills activated. Each package requires proportional depth and explicitly keeps simple tasks simple. Integrated routing should leave unrelated skills dormant.
