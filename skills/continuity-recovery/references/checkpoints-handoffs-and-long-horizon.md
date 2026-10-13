# Checkpoints, Handoffs, and Long-Horizon Work

Read this reference for multi-milestone work, planned interruption, resumed tasks, Teamwork/subagent returns, or a new known-good boundary after recovery.

## Checkpoint threshold

Create or refresh a checkpoint when at least one is true:

- a milestone's acceptance claims were verified;
- a consequential change is about to begin;
- interruption, compaction, or handoff is expected;
- a failed strategy was invalidated and a new path selected;
- external state or authority changed materially;
- recovery established a new known-good state.

Do not checkpoint every command, edit, or conversational turn.

## Checkpoint contract

```text
CHECKPOINT DATE / ENVIRONMENT
WORKSPACE OR ARTIFACT ANCHOR
GOAL / ACTIVE ACCEPTANCE CLAIMS
VERIFIED STATE + EVIDENCE POINTERS
UNVERIFIED OR STALE STATE
CHANGES SINCE PRIOR CHECKPOINT
FAILED STRATEGY CLASSES
CURRENT BLOCKER / EXTERNAL STATE
NEXT SAFE ACTION
STOP / ESCALATION CONDITION
```

Use a commit/revision, working-tree digest, artifact version, deployment identifier, provider observation, or another available anchor appropriate to the task. Do not invent precision the environment cannot provide.

## Known-good semantics

`LAST KNOWN-GOOD` means the recorded claims were supported at that anchor. It does not mean every system property was verified, production was safe, or later state can be discarded.

If current state differs from the checkpoint:

1. preserve the current state;
2. identify which changes are understood, user-owned, agent-owned, or external when evidence permits;
3. find the first divergence;
4. decide whether to keep, repair, ask, escalate, or recommend rollback.

Never reset to the checkpoint merely because it is familiar.

## Long-horizon compression

Preserve milestones only as:

- completed acceptance claims and evidence;
- current phase;
- remaining material claims;
- decisions that still constrain work;
- failed strategy classes that prevent repetition;
- current blockers and external state;
- next safe action.

Do not reproduce the project plan, backlog, worker schedule, or full history. Native `/plan` and Teamwork own those structures.

## Handoff intake

A narrative handoff is a claim set, not proof. Reconcile:

| Handoff claim | Actual evidence |
|---|---|
| files changed | current diff/artifact state |
| commands run | available command output/log/record |
| tests passed | result, scope, environment, timing |
| external action completed | provider/system observation and authorization record |
| work remaining | acceptance-to-evidence gap |

Partial or missing evidence lowers the state; it does not make the worker untrusted by default.

## Handoff output

Return:

```text
WHAT WAS DONE
- material artifact/state changes

WHAT WAS VERIFIED
- claim, oracle, environment, date

WHAT REMAINS
- acceptance gaps and unverified boundaries

WHAT FAILED OR BECAME STALE
- strategy classes and invalidated evidence

NEXT SAFE ACTION
- exactly one bounded action

STOP / ESCALATION CONDITION
- condition requiring owner, Risk, or block
```

Link to the canonical state and source evidence. Do not paste transcripts or duplicate another skill's ledger.

## Multi-agent coexistence

Teamwork and subagents own role assignment, scheduling, worker lifecycle, isolated workspaces, and file ownership. Continuity may:

- verify that claimed outputs exist;
- reconcile worker claims with actual shared state;
- merge semantic conclusions into the one canonical record;
- identify conflicting claims or stale evidence;
- preserve the next safe action across handoffs.

Continuity must not spawn a parallel hierarchy, allocate files, vote across agents, or create one state file per worker.

When concurrent state is still changing, avoid declaring a stable checkpoint. Use native synchronization/ownership signals, then reconcile the settled artifacts.
