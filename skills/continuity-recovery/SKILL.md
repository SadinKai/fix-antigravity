---
name: continuity-recovery
description: Reconciles the canonical semantic state of long-running, interrupted, resumed, compacted, handed-off, contradictory, or repeatedly failing work against actual repositories, tools, and environments, then selects one safe recovery action. Use after context loss or resume, at meaningful long-horizon checkpoints, after multi-agent handoff, when task state or evidence is stale or conflicting, after materially similar strategies fail, or when deciding retry versus strategy change, rollback, escalation, blocked, infeasible, or complete. Do not use for simple one-turn questions, tiny deterministic edits, fresh standard work with stable context, generic requests to remember everything, or project planning and orchestration.
---

# Continuity & Recovery

Preserve only the semantic task truth needed to reconstruct the next correct and safe action. Recovery means reconciling that truth with observable reality before acting.

## Terms

- **Canonical state:** the one decision-relevant record for the task; it is not a transcript or a claim that the record defines reality.
- **Checkpoint:** a concise, dated, evidence-linked state known to be valid at a meaningful boundary.
- **Progress:** new evidence, a changed hypothesis, a resolved acceptance claim, a reduced relevant surface, an identified blocker, or an advanced verified state.
- **Divergence:** the first point where the recorded state, assumed state, claimed handoff, or intended path differs materially from current evidence.
- **External mutation:** state still exists but changed outside the current reasoning or execution path; it is not state loss.
- **Recovery:** reconciliation followed by a deliberate action choice; it is not automatic retry.
- **Blocked:** the outcome may become possible after an external condition, access, authority, or owner decision changes.
- **Infeasible:** evidence establishes that the current requirements and constraints cannot all be satisfied.

Never turn unknown into infeasible, blocked into failed, or an earlier completion state into a later one.

## Ownership and boundaries

Own semantic execution continuity: current goal and acceptance, non-negotiable constraints, current verified state, decisions, live and invalidated hypotheses, evidence validity, changed artifacts, checks, failed strategy classes, last known-good checkpoint, external state, blockers, next safe action, and stop/escalation conditions.

Do not become a second planner, project manager, transcript memory, engineering methodology, research archive, risk authority, rollback engine, context-compaction system, session manager, agent scheduler, or Teamwork orchestrator.

- Antigravity owns conversation/session transport, compaction, `/resume`, native artifacts, `/plan`, `/boost`, Teamwork, subagents, hooks, rules, permissions, browser, MCP, and process lifecycle.
- Perfect Code V2 owns engineering diagnosis, implementation, coverage, tests, verification, and engineering completion.
- Evidence Research owns external claim provenance, source evaluation, freshness research, and evidence packets.
- Risk & Change Assurance owns consequence, authorization, destructive or irreversible action, deployment/migration gates, rollback policy, and acceptance of residual risk. Continuity records and respects its decision; it never overrides it.

If a partner is unavailable, preserve its boundary and report the exact reduced state rather than impersonating it.

## Core guarantee and reference fallback

This `SKILL.md` is the authoritative, self-contained operating core. The activation gate, adaptive depth, canonical-state contract, reconciliation loop, failure classification, evidence invalidation, no-progress rule, recovery actions, status discipline, and ownership boundaries below remain mandatory even when references cannot be loaded.

References are package-relative, optional deeper guidance:

- [references/canonical-state-and-storage.md](references/canonical-state-and-storage.md) for field semantics, persistence selection, compaction, and secret-safe storage.
- [references/reconciliation-and-evidence-validity.md](references/reconciliation-and-evidence-validity.md) for divergence analysis and targeted evidence invalidation.
- [references/failure-classification-and-strategy-switching.md](references/failure-classification-and-strategy-switching.md) for recovery decisions and meaningful strategy changes.
- [references/checkpoints-handoffs-and-long-horizon.md](references/checkpoints-handoffs-and-long-horizon.md) for milestone checkpoints and handoff reconciliation.
- [references/native-antigravity-coexistence.md](references/native-antigravity-coexistence.md) for current native capability contracts.

When a relevant reference is unavailable, unreadable, omitted, or cannot be loaded at that moment, continue with the in-core rules, do not invent or reconstruct the missing content, and disclose only a material reduction in recovery assurance. Missing optional references reduce detail, not the correctness of the core workflow.

## Activation gate and adaptive depth

Activate when semantic state cannot safely be inferred from the current conversation alone, including resume after interruption or compaction, cross-session or multi-milestone work, handoff, contradictory/stale state, changed external conditions, or materially similar failed strategies.

| Depth | State behavior | Recovery behavior |
|---|---|---|
| **SIMPLE** | No persistent record. | Identify the issue, fix or retry once when justified, verify, and stop. |
| **STANDARD** | Keep minimal in-task notes only when they change the decision. | Reconcile the affected fact or assumption; do not create ceremony. |
| **COMPLEX** | Maintain one structured canonical state across milestones, assumptions, decisions, evidence validity, and verification. | Reconcile actual state, first divergence, failed strategy class, and next safe action. |
| **CRITICAL / LONG-HORIZON** | Use the full state, explicit checkpoints, authority boundaries, and evidence-linked resumption. | Freeze mutations, preserve evidence, invoke Risk when consequential, and resume only after reconciliation. |

Do not activate merely because a task is called complex. Keep it dormant for tiny edits, simple questions, stable uninterrupted work, creative tasks without continuity value, and cases where native workflow state is already sufficient and non-contradictory.

## One canonical semantic state

Create exactly one canonical record per qualifying task. Populate only fields that affect decisions:

```text
TASK ID / TITLE
GOAL
ACCEPTANCE / SUCCESS CONDITIONS
NON-NEGOTIABLE CONSTRAINTS
CURRENT PHASE
CURRENT VERIFIED STATE
DECISIONS: decision | rationale | superseded-by | evidence pointer
LIVE HYPOTHESES: hypothesis | support | counterevidence | confidence | falsifier
INVALIDATED HYPOTHESES
CHANGES MADE: artifact | change | status
REPOSITORY STATE: git clean/dirty | authorized/unauthorized | expected/unexpected | tracked/untracked | collateral changes
CHECKS / OBSERVATIONS: check | result | environment | date
EVIDENCE REFERENCES: claim | status | source pointer | research date | validity scope | refresh condition | task impact
FAILED STRATEGIES: strategy class | observed failure | evidence | material change afterward
LAST KNOWN-GOOD CHECKPOINT
CURRENT EXTERNAL STATE
BLOCKERS
NEXT SAFE ACTION
STOP / ESCALATION CONDITION
STATE UPDATED
```

This is a conceptual schema, not a requirement to populate empty fields. Never create separate decision, hypothesis, evidence, checkpoint, or recovery memories. Never use a transcript dump as state.

### Persistence selection

1. If the active native workflow already has a reviewable canonical progress/state artifact, update or reference that artifact rather than creating a competitor.
2. Otherwise, for COMPLEX or CRITICAL work, use one visible task-scoped Markdown artifact in the workspace or artifact location appropriate to the repository and owner intent. Record its path. Do not impose a permanent project-wide filename or hidden directory.
3. Do not edit Antigravity session caches, hidden context stores, conversation history, or platform internals.
4. If persistence is unavailable or inappropriate, emit a compact canonical checkpoint in the handoff/final response and state that restart resilience is reduced.
5. Never store passwords, API keys, tokens, private credentials, or unnecessary sensitive values. Store non-secret pointers when needed.

## Mandatory reconciliation loop

When recovering:

1. **Freeze new mutations.** Safe read-only inspection and repair of the canonical record remain allowed. Do not continue the stale plan.
2. **Read the contract.** Load the latest explicit user direction, goal, acceptance, constraints, canonical state, and applicable authority/risk decisions.
3. **Inspect reality.** Examine the actual repository, working tree, artifacts, tool results, environment, external state, and handoff outputs relevant to the claim.
4. **Compare state with reality.** Current observable state beats stale recorded state. Explicitly identify what changed and what remains valid. The latest explicit user direction supersedes older decisions. Preserve unexplained user or external changes; never discard, reset, or revert them merely because they were unexpected.
5. **Find the first divergence.** Identify the earliest assumption, decision, artifact, check, or external condition where the valid path stopped matching reality.
6. **Classify the failure.** Use the classes below before choosing an action.
7. **Invalidate selectively.** Mark affected hypotheses, checks, claims, and completion states stale; preserve evidence whose validity conditions still hold.
8. **Choose one recovery action.** State its rationale, evidence need, and stop condition.
9. **Record the changed truth.** Update the canonical state, including failed strategy class and evidence validity.
10. **Resume safely.** Continue only from the reconciled next safe action and within current authority.

If the actual state cannot be inspected enough to reconcile a material claim, return `BLOCKED` or the precise `UNVERIFIED` boundary. Do not fabricate continuity.

## Failure classification

Classify at least one primary failure type:

| Class | Meaning | Typical response |
|---|---|---|
| **BAD HYPOTHESIS** | The causal explanation was falsified or materially weakened. | Invalidate it and `CHANGE STRATEGY`. |
| **BAD IMPLEMENTATION** | The strategy remains supported, but execution is defective. | Correct the implementation and verify with an adequate oracle. |
| **BAD ORACLE** | The check is insufficient, wrong, stale, or shares the same false assumption. | Replace or strengthen the oracle before claiming progress. |
| **TOOL FAILURE** | A tool failed, truncated, partially completed, or returned ambiguous output. | Establish actual effects; retry only with changed conditions or new evidence. |
| **PLATFORM / HARNESS FAILURE** | Antigravity, browser, MCP, process, or harness prevented reliable work. | Preserve state and evidence; use an available native alternative or `BLOCKED`. |
| **STATE LOSS** | Required semantic state is actually missing or unavailable, so the next action cannot be derived without reconstruction. | Reconstruct from observable evidence and lower unsupported claims. |
| **EXTERNAL MUTATION** | Repository, artifact, or environment state still exists but changed outside the current reasoning/execution path. | Preserve the mutation, identify the first divergence, reconcile ownership and effects, and invalidate only dependent evidence. |
| **EXTERNAL BLOCKER** | A dependency, provider, credential, environment, or owner input is unavailable. | Preserve partial work and return `BLOCKED` with an unblock condition. |
| **AUTHORITY LOSS** | Required permission or approval is absent, expired, or contradicted. | Stop mutation and `ASK`, `ESCALATE`, or invoke Risk. |
| **INFEASIBLE** | Evidence shows the goal and constraints cannot currently all be satisfied. | Return `INFEASIBLE` with proof and feasible alternatives/partial work. |

## Evidence validity

Treat evidence as valid only within its recorded source, date, version, environment, configuration, and scope. Code, dependency, configuration, environment, provider, deployment, or time-sensitive changes can invalidate earlier checks or claims.

On change:

`identify affected evidence -> invalidate affected claims/checks -> preserve unaffected evidence -> refresh or rerun only what is necessary`

For external claims, retain only Evidence Research's accepted claim, status, provenance pointer, research date, validity scope, refresh condition, and task impact. Request refresh when a condition is crossed; do not copy the research report.

## No-progress and strategy-switch invariant

A materially identical retry is allowed only when new evidence, a changed condition, or an explicit user request gives it a justified expectation of information. Two materially similar failures are a strong recovery trigger, not an arbitrary retry quota.

These are not progress: repeated identical commands, paraphrases, self-review of unchanged evidence, or edits that change no causal assumption. When the same strategy class no longer advances the task, change at least one material dimension: hypothesis, evidence source or oracle, tool, abstraction level, decomposition, environment, reviewer, or experimental setup. A cosmetic rewrite is not a strategy change.

## Recovery actions

Choose exactly one current action:

- `RETRY WITH NEW EVIDENCE`
- `CHANGE STRATEGY`
- `ROLL BACK`
- `ASK`
- `ESCALATE`
- `BLOCKED`
- `INFEASIBLE`
- `COMPLETE`

`ROLL BACK` is a recommendation until user/owner authority, Risk, platform permissions, and an approved procedure authorize execution. Never silently roll back user changes.

Use `COMPLETE` only when acceptance is evidence-supported, current, and within the task's authority. Otherwise preserve the exact state and next safe action.

## Checkpoints and handoffs

Checkpoint only at meaningful validated boundaries: before consequential change, after a verified milestone, before interruption/handoff, or after recovery establishes a new known-good state. Record date, actual workspace/environment anchor, verified claims, unverified residuals, and evidence pointers.

For a handoff, reconcile claims against actual outputs before accepting them. Return only:

```text
WHAT WAS DONE
WHAT WAS VERIFIED
WHAT REMAINS
WHAT FAILED OR BECAME STALE
NEXT SAFE ACTION
STOP / ESCALATION CONDITION
```

Teamwork and subagents own assignment, scheduling, workspace isolation, and file ownership. Continuity consumes their artifacts and validates semantic truth; it does not coordinate workers.

## Completion states

Keep these states distinct when applicable:

`ACTIVE | BLOCKED | INFEASIBLE | IMPLEMENTED | VERIFIED | QUALIFIED | AUTHORIZED | EXECUTED | OBSERVED | COMPLETE`

Never infer a later state from an earlier one. `IMPLEMENTED` is not `VERIFIED`; `VERIFIED` is not `AUTHORIZED` or deployed; `EXECUTED` is not `OBSERVED`; interruption never implies completion. Risk owns consequential transitions and gates; Continuity records them.

For composed work, maintain one current verified repository/system state and one status per participating layer:

```text
ENGINEERING = COMPLETE | INCOMPLETE | BLOCKED
RESEARCH = COMPLETE | INCOMPLETE | BLOCKED
CONTINUITY = COMPLETE | INCOMPLETE | BLOCKED
CONSEQUENTIAL GATE = PROCEED | PROCEED WITH CONTROLS | STOP / BLOCKED
OVERALL TASK = COMPLETE | PARTIAL | BLOCKED | INCOMPLETE
```

Layer completion does not imply overall completion or authorization. In particular, completed engineering, research, and continuity with `CONSEQUENTIAL GATE = STOP / BLOCKED` yields an overall blocked or partial task, never an overall `VERIFIED` or `COMPLETE` state.

## Final response

Lead with the reconciled current state. State the first material divergence, evidence invalidated or preserved, selected recovery action, one next safe action, and any blocker or stop/escalation condition. Include the canonical state path or compact checkpoint when relevant.

Do not expose private chain-of-thought. Communicate decisions, evidence, state transitions, and residual uncertainty concisely.
