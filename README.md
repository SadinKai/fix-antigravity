# Fix Antigravity

**Four opt-in Antigravity skills for repository-grounded coding, evidence-based research, interrupted-task recovery, and consequential-change review.**

For developers using Antigravity on existing repositories who want inspectable evidence and clear responsibility boundaries. A tested patch is not authorization to deploy; an old checkpoint is not proof that today's tree is unchanged. Native Antigravity remains the orchestrator.

Created by **Sadin K**. Independent community project; not an official or endorsed Google, OpenAI, Gemini, or Antigravity product. [MIT license](LICENSE).

## Choose your setup first

Automation targets **Windows PowerShell 5.1 and PowerShell 7**, with no extra modules. Git is needed for cloning, not installing an archive. See [tested scope](docs/compatibility.md).

| Surface | Global skills | Global modular rules |
|---|---|---|
| IDE / app | ~/.gemini/config/skills | ~/.gemini/config/rules |
| CLI | ~/.gemini/antigravity-cli/skills | ~/.gemini/antigravity-cli/rules |
| Workspace | project/.agents/skills | Select the documented scope for your installed host |

Choose **individual mode** for explicit/autonomous per-skill use. Choose **integrated mode** to add persistent applicability guidance; unrelated skills still remain dormant. It is not a fifth skill or deterministic enforcement.

## Quick start

Clone and enter the checkout, or extract an inspected archive. Moving main is not a version guarantee; see [release guidance](docs/releases.md). This hardening patch remains local/unreleased until reviewed and published.

~~~powershell
git clone https://github.com/SadinKai/fix-antigravity.git
Set-Location .\fix-antigravity
~~~

Choose **one** target before installing:

~~~powershell
# IDE / app:
$skillRoot = Join-Path $HOME '.gemini\config\skills'
# CLI instead:
# $skillRoot = Join-Path $HOME '.gemini\antigravity-cli\skills'
# Workspace instead, outside this checkout:
# $skillRoot = 'C:\work\your-project\.agents\skills'
.\scripts\install.ps1 -TargetSkillRoot $skillRoot -WhatIf
.\scripts\install.ps1 -TargetSkillRoot $skillRoot
.\scripts\verify-install.ps1 -TargetSkillRoot $skillRoot
~~~

For integrated mode, select the matching rule scope:

~~~powershell
$rulePath = Join-Path $HOME '.gemini\config\rules\four-skill-stack.md'
# CLI instead:
# $rulePath = Join-Path $HOME '.gemini\antigravity-cli\rules\four-skill-stack.md'
.\scripts\install.ps1 -TargetSkillRoot $skillRoot -EnableIntegrated -RulePath $rulePath -WhatIf
.\scripts\install.ps1 -TargetSkillRoot $skillRoot -EnableIntegrated -RulePath $rulePath
.\scripts\verify-install.ps1 -TargetSkillRoot $skillRoot -Integrated -RulePath $rulePath
~~~

Start a fresh host session. Conflicts stop before writes unless explicitly reviewed and replaced. New staging/backups are rejected inside the selected root and documented discovery layouts; unknown custom indexing requires owner review. No GEMINI.md or permission setting is changed. [Installation and recovery](docs/installation.md) explain restrictions and partial effects.

## Try one observable result

[The first-success demo](examples/first-success/README.md) copies a tiny notification-recipient defect into a disposable workspace. Baseline: **2 tests passed, 1 failed**. A correct repair passes **all 3 unchanged tests**, preserving first spelling/order and ignoring blanks.

Ask /perfect-code-v2 to repair that copy. The repository gate checks the baseline and a **human-written reference repair**. AI execution is manual / **NOT RUN** in the example; passing tests alone does not prove invocation or model quality.

## Four responsibilities

| Skill | Owns | Does not own |
|---|---|---|
| [Perfect Code V2](skills/perfect-code-v2/SKILL.md) | Repository diagnosis, implementation, engineering verification | External factual authority, operational authorization |
| [Evidence Research](skills/evidence-research/SKILL.md) | Sources, freshness, applicability, contradictions | Code changes or another owner's consequential gate |
| [Continuity & Recovery](skills/continuity-recovery/SKILL.md) | One semantic task state and reconciliation | Native sessions, planning, worker scheduling |
| [Risk & Change Assurance](skills/risk-change-assurance/SKILL.md) | Causal risk case and consequential-transition gate | Granting authority, deployment or permission bypass |

The self-contained cores remain authoritative; optional references add depth. A typo should not produce a ledger, and one green layer cannot silently promote another.

## Evidence and limits

- [Checksums](checksums.sha256) cover all 43 canonical files. Exact inventories include hidden files; unsafe paths and links/junctions are rejected. Parity is not authenticity if content and manifest are both substituted.
- Run the [deterministic contributor gate](CONTRIBUTING.md): .\scripts\validate.ps1. It uses isolated temporary fixtures, never real user configuration.
- The 258 behavioral and 106 trigger definitions are **not passing model results**. [The bounded evaluation protocol](docs/evaluation.md) contains 12 selected trial definitions, explicit rubrics and **NOT RUN** results.
- Hosted CI is pending until reviewed changes are pushed and actually run. No green badge or comparative performance claim is asserted.
- Recovery is per destination, not one transaction across packages/rules/configuration. Review partial effects and preserved artifacts.
- Skills are model instructions, not deterministic enforcement. Keep native permissions and user authorization.
- macOS/Linux automation, fresh live discovery/routing and general model compliance are not established by local Windows checks.

[Usage](docs/usage-guide.md) · [Examples](examples/example-workflows.md) · [Architecture](docs/architecture.md) · [Troubleshooting](docs/troubleshooting.md) · [Compatibility](docs/compatibility.md) · [Evaluation](docs/evaluation.md) · [Release process](docs/releases.md) · [Security](SECURITY.md) · [Contributing](CONTRIBUTING.md)
