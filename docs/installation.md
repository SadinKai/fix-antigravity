# Installation

## Supported paths

Google's Antigravity documentation currently distinguishes these locations:

| Surface | Global skills | Workspace skills | Modular rules |
|---|---|---|---|
| Antigravity IDE / Google Antigravity 2.0 | `~/.gemini/config/skills/<skill>/` | `.agents/skills/<skill>/` | `~/.gemini/config/rules/*.md` |
| Antigravity CLI | `~/.gemini/antigravity-cli/skills/<skill>/` | `.agents/skills/<skill>/` | `~/.gemini/antigravity-cli/rules/*.md` |

The CLI and IDE may evolve. Confirm paths in the documentation for your installed version: [Agent skills](https://www.antigravity.google/docs/skills?tab=ide), [workflow migration](https://www.antigravity.google/docs/migration/workflows-to-skills/), and [rules](https://antigravity.google/docs/rules/).

The local qualification environment also contained `~/.gemini/config/skills.json` and a global `~/.gemini/GEMINI.md`. Those are observations, not universal requirements. Folder discovery is the default documented installation path. This project never overwrites `GEMINI.md`; manifest registration is an explicit compatibility option only.

## Download

After publication, clone the repository URL shown on its GitHub page, then enter the checkout:

```powershell
git clone https://github.com/SadinKai/fix-antigravity.git
Set-Location .\fix-antigravity
```

A downloaded archive from the same repository works as well.

## Mode A: individual skills

### Safe installer — IDE / 2.0 global default

Preview, install, and verify:

```powershell
.\scripts\install.ps1 -WhatIf
.\scripts\install.ps1
.\scripts\verify-install.ps1
```

### Antigravity CLI global

```powershell
$skillRoot = Join-Path $HOME '.gemini\antigravity-cli\skills'
.\scripts\install.ps1 -TargetSkillRoot $skillRoot
.\scripts\verify-install.ps1 -TargetSkillRoot $skillRoot
```

### Workspace-local

Run from this repository and supply the target workspace explicitly:

```powershell
$skillRoot = 'C:\path\to\your-project\.agents\skills'
.\scripts\install.ps1 -TargetSkillRoot $skillRoot
.\scripts\verify-install.ps1 -TargetSkillRoot $skillRoot
```

Start a fresh Antigravity session after installation. Use the discovery or invocation mechanism supported by your version. Current Antigravity documentation describes slash invocation such as `/perfect-code-v2`; the `$perfect-code-v2` value in package metadata belongs to OpenAI/Codex-compatible hosts and is not Antigravity slash syntax.

## Mode B: integrated stack

Integrated mode also installs the portable operating contract as a modular rule. This is separately opted into:

```powershell
.\scripts\install.ps1 -EnableIntegrated
.\scripts\verify-install.ps1 -Integrated
```

For CLI-global rules, override the path:

```powershell
$skillRoot = Join-Path $HOME '.gemini\antigravity-cli\skills'
$rulePath = Join-Path $HOME '.gemini\antigravity-cli\rules\four-skill-stack.md'
.\scripts\install.ps1 -TargetSkillRoot $skillRoot -EnableIntegrated -RulePath $rulePath
.\scripts\verify-install.ps1 -TargetSkillRoot $skillRoot -Integrated -RulePath $rulePath
```

The rule includes the YAML frontmatter required by Antigravity modular rules. It does not edit `GEMINI.md`, bypass permissions, or create an orchestrator.

## Existing conflicts

The installer compares complete package trees. An identical package is skipped. A changed or extra file is a conflict and stops the whole preflight before installation begins.

Review the conflict, then opt into replacement only if appropriate:

```powershell
.\scripts\install.ps1 -ReplaceConflicts
```

The previous package or rule is moved to a timestamped sibling backup before the new copy is activated. Replacement is never silent. `-WhatIf` previews planned mutations.

## Optional manifest registration

Only use this when your installation requires `skills.json`:

```powershell
.\scripts\install.ps1 -RegisterManifest
.\scripts\verify-install.ps1 -CheckManifest
```

The installer parses the existing JSON before any mutation, preserves unrelated properties and entries, adds only missing package paths, and creates a backup before a changed manifest is written. Invalid JSON stops preflight. It never replaces the manifest wholesale with a project-owned template.

## Manual installation

Copy the four directories under `skills/` into the appropriate global or workspace skill root. Preserve every file and directory. If integrated behavior is desired, copy `integration/four-skill-stack.md` into the appropriate modular rules directory. Do not paste it over an existing rule or `GEMINI.md`.

Compare installed files with [`checksums.sha256`](../checksums.sha256) or run the verifier with explicit paths.

## Removal

First verify the target and inspect any backups. Then remove only these four exact package directories from the skill root:

- `perfect-code-v2`
- `evidence-research`
- `continuity-recovery`
- `risk-change-assurance`

If integrated mode was enabled, remove only the `four-skill-stack.md` rule that matches this repository. If you opted into manifest registration, parse `skills.json`, remove only entries for these installed package paths, and preserve every unrelated entry and property. The project intentionally does not automate removal because deciding whether an installed package, edited rule, or manifest entry is still user-owned requires review.
