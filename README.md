# Fix Antigravity

**Four complementary AI agent skills for reliable coding, evidence-based research, task continuity, and risk-aware changes.**

A composable skill stack for AI-assisted engineering that connects implementation, evidence, continuity, and consequential-change assurance without creating another orchestration layer.

Created by **Sadin K**, Fix Antigravity is an independent community project—not an official Google, OpenAI, Gemini, or Antigravity product.

Many difficult tasks mix several different questions: *Is the code correct? Is the external claim current? What state survived an interruption? Is this action authorized and reversible?* This project gives each question a clear owner while leaving Antigravity's native orchestration in control.

- [Perfect Code V2](skills/perfect-code-v2/SKILL.md) — engineering that proves its work.
- [Evidence Research](skills/evidence-research/SKILL.md) — research with receipts.
- [Continuity & Recovery](skills/continuity-recovery/SKILL.md) — know what changed and what survived.
- [Risk & Change Assurance](skills/risk-change-assurance/SKILL.md) — know the risk before crossing the line.

The stack is proportionate: relevant skills activate, unrelated skills stay dormant, and a small task should remain small.

[Installation](docs/installation.md) · [Architecture](docs/architecture.md) · [Usage](docs/usage-guide.md) · [Examples](examples/example-workflows.md) · [Troubleshooting](docs/troubleshooting.md) · [Contributing](CONTRIBUTING.md) · [Security](SECURITY.md) · [License status](#license-status)

## Quick start

Clone or download this repository, open PowerShell in its root, preview the installation, then install and verify:

```powershell
.\scripts\install.ps1 -WhatIf
.\scripts\install.ps1
.\scripts\verify-install.ps1
```

That installs the four skills for individual use. To opt into the persistent integrated operating contract:

```powershell
.\scripts\install.ps1 -EnableIntegrated
.\scripts\verify-install.ps1 -Integrated
```

The default paths target Antigravity IDE / Google Antigravity 2.0 global configuration. CLI-only and workspace-local paths differ; read [Installation](docs/installation.md) before choosing a target. The installer never edits `GEMINI.md`, never replaces a conflict silently, and does not require manifest registration on configurations that discover skill folders directly.

## Why this exists

An all-purpose agent can blur distinct forms of truth. A good patch is not proof that a product claim is current. A recovered conversation is not proof that the working tree is unchanged. A successful local test is not authorization to deploy.

This stack separates four responsibilities:

| Responsibility | Owner | Core question |
|---|---|---|
| Engineering | Perfect Code V2 | Does the implementation or audit satisfy the repository-grounded contract? |
| External evidence | Evidence Research | What do current, applicable sources actually support? |
| Semantic continuity | Continuity & Recovery | What is the current verified task state, and where did it diverge? |
| Consequential transition | Risk & Change Assurance | Is the next elevated action authorized, controlled, observable, and recoverable? |

Install the packages alone when you want explicit or autonomous per-skill use. Enable the optional operating contract when you want every new task evaluated for applicability across the stack. The contract is persistent routing guidance, not a fifth skill and not a mathematical guarantee of model behavior.

## The four skills

### Perfect Code

**Engineering that proves its work.**

Perfect Code V2 grounds engineering in the real repository: establish acceptance, trace root causes and causal surfaces, make the smallest justified change, choose an oracle appropriate to the claim, verify proportionately, and disclose residual uncertainty. It is useful for non-trivial implementation, debugging, refactoring, optimization, and code audits. It does not own external research, long-horizon task memory, operational authorization, or orchestration.

[Read the authoritative skill](skills/perfect-code-v2/SKILL.md)

### Evidence Research

**Research with receipts.**

Evidence Research decomposes questions into claims and evaluates source provenance, independence, freshness, version and rollout applicability, contradictions, absence evidence, and confidence. It is useful for current APIs, releases, advisories, product comparisons, disputed claims, and external facts that inform engineering or risk decisions. It reports evidence and conditional implications; it does not implement code or seize ownership of another skill's gate.

[Read the authoritative skill](skills/evidence-research/SKILL.md)

### Continuity & Recovery

**Know what changed and what survived.**

Continuity & Recovery maintains one semantic task state when interruption, handoff, long horizons, changed repositories, or failed strategies make conversational memory insufficient. It reconciles the record against reality, finds the first divergence, distinguishes external mutation from state loss, invalidates stale evidence selectively, and chooses the next safe recovery action. It is not a second planner, transcript archive, or session manager.

[Read the authoritative skill](skills/continuity-recovery/SKILL.md)

### Risk & Change Assurance

**Know the risk before crossing the line.**

Risk & Change Assurance evaluates a specific security-sensitive or consequential transition. It checks authority, causal threat paths, blast radius, reversibility, controls, rollback evidence, observation, and stop conditions, then returns an explicit gate: `PROCEED`, `PROCEED WITH CONTROLS`, or `STOP / BLOCKED`. It does not grant authority, execute a deployment, or bypass native permissions.

[Read the authoritative skill](skills/risk-change-assurance/SKILL.md)

## What makes the stack different

- **Clear ownership.** Each layer has a defined truth domain, reducing duplicate work and conflicting conclusions.
- **Native orchestration.** Antigravity selects tools, sessions, plans, and agents; the stack adds no supervisory skill.
- **Independent states.** Engineering, research, continuity, and the consequential gate can finish differently. One green layer cannot silently promote another.
- **Evidence-based verification.** Completion language follows the oracle that actually ran, not the intended procedure.
- **Preserved uncertainty.** Observations, source claims, inferences, projections, and unknowns stay distinct.
- **Fail-closed elevated actions.** Missing authority or material evidence blocks the transition without turning ordinary local work into a critical ceremony.

These are design goals and behaviors covered by the included evaluation scenarios. They are not guarantees for every model, prompt, tool, or environment.

## Example workflows

| Scenario | Active skills | Why |
|---|---|---|
| Diagnose and minimally fix a repository bug | Perfect Code V2 | Repository evidence, root cause, implementation, and tests are the task. |
| Verify whether an API behavior changed in the latest release | Evidence Research | The claim is external, current, and version-sensitive. |
| Resume an interrupted change after the working tree moved | Continuity & Recovery + Perfect Code V2 | State must be reconciled before engineering safely resumes. |
| Review a proposed production migration with no proven rollback | Risk & Change Assurance, with engineering/evidence support as needed | The next state boundary is consequential and rollback evidence is material. |
| Research a dependency, implement an adaptation, then consider deployment | Perfect Code V2 lead + Evidence Research + Risk & Change Assurance; Continuity if long-running | Each owner supplies one layer; deployment remains separately gated. |

See [example workflows](examples/example-workflows.md) for usable prompts and expected routing. Mentioning a skill in a prompt requests it; only the agent's observable behavior and output establish how it was used.

## Integrity

[`checksums.sha256`](checksums.sha256) records the release-candidate hashes of all 43 canonical package files. The verification script checks installed package files against this manifest and reports missing, changed, or unexpected files without printing their contents.

## Limitations and honest expectations

- Skills improve a workflow; they do not guarantee correctness.
- Tool execution depends on the environment, installed Antigravity version, and permission policy.
- A test must actually run before it can be reported as passed.
- Local success does not authorize production, publication, deletion, payment, messaging, or other consequential action.
- Users should inspect changes, preserve appropriate backups, and keep native security controls enabled.
- Skill discovery, slash invocation, global paths, and rule behavior can differ across Antigravity versions and other agents.
- The supplied PowerShell automation has been designed for Windows; manual installation remains available on other platforms.

## Community project

Fix Antigravity was created by **Sadin K** as an independent community project. It is not an official Google, OpenAI, Gemini, or Antigravity project and is not endorsed by their maintainers. Product names are used only to describe compatibility and intended use.

## License status

Fix Antigravity is available under the [MIT License](LICENSE), with `Copyright (c) 2026 Sadin K`. The license permits use, copying, modification, distribution, sublicensing, and commercial use provided the copyright and permission notice are retained. The software is provided without warranty.
