# Native Antigravity and Cross-Skill Coexistence

Read this reference before choosing persistence, resuming native sessions, consuming Teamwork/subagent artifacts, or using hooks as recovery signals.

This reference uses public capability contracts verified against official Antigravity documentation on 2026-10-04. Availability and exact behavior can vary by surface, OS, plan, version, permissions, and rollout. Recheck official documentation when those facts control a consequential decision.

## Skills and invocation

Antigravity discovers skills from their name and description, reads `SKILL.md` on activation, and exposes manual `/<skill-name>` invocation on documented surfaces. This package is `continuity-recovery`; its explicit Antigravity invocation is `/continuity-recovery`.

Progressive disclosure supports a lean core with optional package-relative references. Missing references must not disable the self-contained recovery lifecycle.

Official source: <https://www.antigravity.google/docs/skills?tab=ide>

## Session and context transport

`/resume`, `--continue`, and `--conversation` restore native conversation/session context on supported CLI surfaces. Native compaction, history, and session caches remain platform-owned.

Continuity does not edit the documented workspace-keyed session cache or treat a resumed transcript as canonical semantic truth. After resume, reconcile the canonical state with the actual workspace and environment.

Official sources: <https://www.antigravity.google/docs/cli/commands/resume/> and <https://www.antigravity.google/docs/cli/headless/>

## Artifacts and storage

Native artifacts are structured deliverables for review and asynchronous collaboration. Prefer an existing reviewable progress/state artifact when the active workflow already uses one. Otherwise use one visible task-scoped workspace artifact or a compact response checkpoint; do not create hidden platform storage.

Official source: <https://antigravity.google/docs/artifacts>

## `/plan`

`/plan` owns codebase exploration, requirements discovery, structured project planning, and plan review. Continuity consumes the approved goal, acceptance, constraints, and plan status. It may mark a premise stale and recommend reopening the native plan when evidence invalidates it, but it does not create a competing roadmap.

Official source: <https://www.antigravity.google/docs/slash-commands>

## `/boost`, Teamwork, and subagents

Native mechanisms own agent topology, orchestration, task assignment, worker lifecycle, isolated workspaces, file ownership, and verification roles. Teamwork already uses structured request, plan, progress, and handoff artifacts for long-horizon work.

Continuity consumes those artifacts as claims, reconciles them with actual outputs, and updates one semantic state. It does not create one ledger per agent, coordinate workers, or use agent count as evidence.

Official sources: <https://antigravity.google/docs/boost>, <https://antigravity.google/docs/teamwork>, and <https://www.antigravity.google/docs/subagents/>

## Hooks

Hooks may provide deterministic signals such as tool completion/error, repeated tool signatures, invocation boundaries, or stop events. A hook may record or flag the signal; it should not decide semantic recovery.

```text
hook signal -> Continuity inspects actual effects -> failure classification -> recovery action
```

Do not require a new hook for this skill. Use configured hooks when present and authorized.

Official source: <https://antigravity.google/docs/hooks>

## Rules and permissions

Rules own persistent directory/global constraints. Permissions own Deny/Ask/Allow action boundaries and can differ by OS/surface. Continuity records the applicable constraint or authority state; it never treats a state entry as permission or uses recovery prose to bypass a denial/approval boundary.

Official sources: <https://www.antigravity.google/docs/rules/> and <https://antigravity.google/docs/permissions>

## Browser and MCP

Browser and MCP can expose actual external or runtime state. Validate provenance, timestamp, environment, permission, and whether a call mutated state. A tool failure or inaccessible provider is not negative evidence.

Official source: <https://www.antigravity.google/docs/mcp>

## Model and effort

The host/user selects the model and reasoning effort. Gemini 3.8 Flash High may support the target workflow, but effort does not make stale state current or a summary true. This skill is capability-based and does not override model selection.

Official sources: <https://www.antigravity.google/docs/models/> and <https://www.antigravity.google/docs/cli/headless/>

## Cross-skill contracts

### Perfect Code V2

Consume only decision-relevant engineering state: goal/acceptance, constraints, changed artifacts, verified checks and environments, live/invalidated hypotheses, failed strategy classes, remaining claims, and completion state. Perfect Code keeps engineering methodology and verification ownership.

### Evidence Research

Store only the accepted claim, status, provenance pointer, research date, validity scope, refresh condition, and task impact. Evidence Research retains the source packet and refresh work.

### Risk & Change Assurance

Record authority, risk-gate state, rollback anchor, stop condition, and observed result. Risk owns whether a consequential action may proceed, how rollback is authorized, and whether residual risk is accepted.

## Composition invariants

- Maintain one canonical task state and one current verified repository/system state.
- Reference the Evidence owner for each material external claim, the Perfect Code owner for each material engineering change, and the Risk owner for the consequential decision.
- Reuse valid owned evidence instead of repeating work. A partner may return newer evidence, but it must not silently overwrite another owner's conclusion; reconcile the explicit supersession here.
- Record engineering, research, continuity, consequential-gate, and overall-task status separately. A local `COMPLETE` never promotes another layer.
- If the consequential gate is `STOP / BLOCKED`, overall status remains `BLOCKED` or `PARTIAL` even when engineering, research, and continuity are complete.

## Graceful degradation

- Without a persistent artifact, output a compact checkpoint and note reduced restart resilience.
- Without Teamwork/subagents, reconcile serial work normally.
- Without browser/MCP or an external system, preserve the unknown and return `BLOCKED` when it controls the decision.
- Without another core skill, keep its boundary and report the exact unowned downstream decision.
- Without a relevant reference, use the in-core lifecycle and never invent missing instructions.
