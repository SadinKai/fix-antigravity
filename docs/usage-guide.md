# Usage Guide

## 1. Verify discovery

After installation, start a fresh Antigravity session in a disposable or ordinary development workspace. Ask the agent to list the skill it would use and why before making changes. The answer is a routing observation, not proof by itself; inspect whether the resulting behavior follows the selected `SKILL.md`.

For manual Antigravity invocation, current documentation uses slash commands based on the skill name, for example:

```text
/perfect-code-v2 Diagnose this failing parser test. Inspect the repository, find the root cause, make the smallest justified fix, and report only checks that actually ran.
```

Equivalent names for the other packages are `/evidence-research`, `/continuity-recovery`, and `/risk-change-assurance`. Other hosts can expose different invocation syntax.

## 2. Try a bounded engineering task

Use a small test repository with a known failing test:

```text
Diagnose the failing date-parser test in this repository. Preserve existing behavior, make the smallest causal fix, run the focused test, inspect the final diff, and distinguish verified results from residual uncertainty.
```

Expected owner: Perfect Code V2. Research, continuity, and risk should remain dormant unless the actual task reveals a material need.

## 3. Try a research task

```text
Using authoritative current sources, determine whether version X of this API supports feature Y. Record version and date applicability, distinguish documented from reproduced behavior, surface contradictions, and cite each material claim.
```

Expected owner: Evidence Research. A current answer requires live source access; blocked access must not be reported as verification.

## 4. Try a safe consequential-action gate

Use a hypothetical; do not point the task at production:

```text
Do not execute anything. Assess this hypothetical production database migration: the schema change is tested locally, but ownership approval and a restored-backup drill are missing. State the next transition, authority evidence, blast radius, rollback evidence, controls, residuals, and explicit gate.
```

Expected owner: Risk & Change Assurance. Local tests can support engineering confidence but cannot supply missing authority or rollback evidence.

## 5. Try recovery

In a disposable repository, pause a task, make a separate benign change, and resume with:

```text
Resume this interrupted task. Reconcile the prior checkpoint against the current working tree, preserve unrelated changes, identify the first divergence, invalidate only stale evidence, and state the next safe action before modifying files.
```

Expected lead: Continuity & Recovery, with Perfect Code V2 supporting engineering after reconciliation.

## Individual versus integrated use

- **Individual mode:** invoke a named skill or let Antigravity discover it. The package's own description controls applicability.
- **Integrated mode:** the installed rule evaluates all four domains on new tasks. One skill leads; only materially relevant partners activate.

Integrated mode should make boundaries clearer, not make every response longer. Inspect the independent layer states on mixed tasks, especially before consequential actions.

## Interpreting outcomes

`COMPLETE`, `VERIFIED`, `BLOCKED`, and `PROCEED` are scoped terms. Read the accompanying environment, evidence, owner, and residuals. A package may be operating correctly when it refuses to promote an unsupported claim or blocks a state transition.
