# Reconciliation and Evidence Validity

Read this reference when recorded state conflicts with reality, work resumes after disruption, or a change may have invalidated earlier evidence.

## Establish the authoritative inputs

Use this precedence for conflicts:

1. latest explicit user or owner direction within current authority;
2. current observable repository, artifact, tool, environment, and external state;
3. current governing risk/permission decision;
4. evidence whose validity conditions still hold;
5. canonical state;
6. narrative summaries and remembered conversation context.

This ordering does not authorize destructive action. Actual unexplained changes win as facts to preserve and investigate, not as permission to overwrite or accept them.

## Reconciliation table

For material state, compare:

| Recorded claim | Current observation | Evidence/time/scope | Divergence | Consequence | State update |
|---|---|---|---|---|---|

Examples:

- State says a file is unchanged; the working tree shows modifications. Preserve the modifications, inspect authorship/context if possible, classify `EXTERNAL MUTATION` when the state still exists but changed outside the current path, and correct the state.
- State says a test passed; code or configuration changed afterward. Mark only affected verification stale.
- Handoff says deployment succeeded; provider status is unavailable. Preserve `EXECUTED` only if supported and keep `OBSERVED` unverified.
- State records dependency version X; the installed lockfile records Y. Current local evidence governs the local claim.

## Find the first divergence

Trace backward from the observed failure until reaching the last supported state. The first divergence is the earliest point where a material premise, artifact, check, authority, or external condition stopped matching reality.

Do not start by rewriting the latest symptom. The first divergence often identifies whether the failure is causal, implementation, oracle, tool, state, authority, or external.

If ordering is uncertain, preserve competing possibilities and choose the next observation that best separates them.

## Evidence dependency mapping

Invalidate by dependency, not by panic. For each prior claim ask:

- Which artifact, version, configuration, environment, provider state, or time window did this evidence depend on?
- Did the changed state lie on that dependency path?
- Did the check occur before or after the last meaningful change?
- Did the oracle directly exercise the claim, or only a proxy?

Use four validity states where useful:

- `CURRENT`: all recorded validity conditions still hold.
- `STALE`: a relevant condition changed; refresh or rerun is required.
- `SUPERSEDED`: stronger or newer applicable evidence replaced it.
- `UNKNOWN`: provenance or conditions are insufficient to determine validity.

Do not rerun unrelated checks. Preserve valid evidence and target the smallest set needed to restore the acceptance claim.

## External mutation versus state loss

Use `EXTERNAL MUTATION` when state is present and observable but changed outside the current reasoning or execution path. Identify the changed artifact and first divergence, record whether the change is authorized/expected/tracked when evidence permits, preserve the mutation, and invalidate only claims that depend on the changed state.

Use `STATE LOSS` only when required semantic state is missing or unavailable and reconstruction is necessary. A dirty working tree, unexpected uncommitted edit, changed file, or out-of-band environment update is not state loss by itself. Never revert an external mutation merely to restore the recorded checkpoint.

## External evidence

Evidence Research owns source truth and refresh. Continuity evaluates only whether the recorded refresh condition has been crossed.

Examples of refresh triggers:

- target software or model version changes;
- provider rollout, status, policy, or API behavior changes;
- action date moves beyond a time-sensitive validity window;
- configuration, region, plan, platform, or jurisdiction changes;
- the original source becomes unavailable or is materially revised;
- current observations contradict the accepted claim.

When triggered, mark the affected task conclusion stale and request a bounded refresh. Do not re-create the source investigation inside the continuity record.

## Partial tool effects

A failed or interrupted tool may still mutate state. Before retrying:

1. inspect exit status and available output;
2. inspect produced/changed artifacts and external side effects;
3. distinguish no effect, partial effect, complete effect with failed reporting, and unknown effect;
4. update the state and choose a recovery action.

Never assume `tool error` means `nothing happened`.

## Contradictory records

When two records disagree, do not merge them into a convenient story. Compare their timestamps, anchors, sources, authors/owners, scopes, and supersession history. Use actual state or a discriminating observation to resolve them. If no safe observation exists, keep the contradiction visible and return `BLOCKED` or `UNVERIFIED`.

## Closure after reconciliation

Reconciliation is complete when:

- current goal and constraints are explicit;
- actual material state has been inspected;
- first divergence and primary failure class are identified or honestly unresolved;
- stale evidence and states are marked;
- user changes and known-good work are preserved;
- one recovery action, one next safe action, and a stop condition are recorded.

It does not require the whole task to be complete.
