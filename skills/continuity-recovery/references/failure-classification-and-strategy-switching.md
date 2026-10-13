# Failure Classification and Strategy Switching

Read this reference after repeated failure, ambiguous tool results, or when choosing retry, strategy change, rollback, escalation, blocked, or infeasible.

## Classify before acting

| Failure class | Diagnostic question | Evidence to seek | Default direction |
|---|---|---|---|
| Bad hypothesis | Did the assumed cause predict the observation? | falsifier, counterexample, causal trace | invalidate and change hypothesis |
| Bad implementation | Is the approach supported but its execution wrong? | focused reproduction, diff, trace, check | correct the implementation and verify |
| Bad oracle | Could the check pass/fail while the claim is false/true? | independent oracle, actual exercised scope | replace or strengthen the check |
| Tool failure | Did the tool return complete, trustworthy results and known effects? | exit status, logs, artifacts, side effects | establish effects before retry |
| Platform/harness failure | Did the host, browser, MCP, process, or fixture prevent valid observation? | independent capability/status evidence | use native alternative or block |
| State loss | Is required semantic state actually missing or unavailable, requiring reconstruction? | repository, artifacts, explicit constraints | reconstruct and lower unsupported state |
| External mutation | Does state still exist but differ because it changed outside the current reasoning/execution path? | diff, timestamps, provenance, environment observations | preserve, reconcile, and invalidate only dependent evidence |
| External blocker | Is success waiting on an external condition? | access/provider/environment/owner status | block with a concrete unblock condition |
| Authority loss | Is the action still authorized? | current approval, permission, risk decision | ask or escalate; do not act |
| Infeasible | Do requirements and constraints provably conflict? | contradiction proof or decisive limitation | report infeasible and bounded alternatives |

More than one class may contribute, but choose the primary class controlling the next action.

Prefer the narrowest class supported by evidence. An out-of-band file or environment change is `EXTERNAL MUTATION`, not `STATE LOSS`, when the changed state remains available for inspection. Do not combine labels merely to express uncertainty; record the unresolved classification separately if evidence cannot discriminate.

## Progress test

An attempt advances the task only if it yields at least one of:

- new discriminating evidence;
- a hypothesis materially strengthened or invalidated;
- an acceptance claim resolved;
- a relevant surface narrowed or exposed;
- a current blocker or authority boundary established;
- a verified state advanced.

Activity, token volume, repeated commands, additional agents, or a new paraphrase do not count by themselves.

## Retry gate

Use `RETRY WITH NEW EVIDENCE` only when all are true:

1. the previous attempt's actual effects are known enough;
2. a new condition, evidence source, input, or corrected implementation changes the expected result or information value;
3. the retry is safe and authorized;
4. success/failure has a clear oracle;
5. a stop condition prevents a loop.

A transient tool failure may justify a bounded retry if the environment changed or the tool provides a meaningful new observation. A second materially identical failure should trigger explicit recovery unless there is decisive evidence for another retry.

## Meaningful strategy change

`CHANGE STRATEGY` must change one or more causal dimensions:

- causal hypothesis;
- evidence source or oracle;
- tool or acquisition path;
- abstraction level;
- subsystem decomposition;
- environment or fixture;
- independent reviewer/context;
- experimental setup.

Renaming, rewriting the same code shape, rerunning the same command, or asking another agent the same broad question is not a strategy change.

Record the invalidated strategy class so it is not rediscovered after compaction or handoff.

## Action selection

- `RETRY WITH NEW EVIDENCE`: same broad strategy, materially new condition or observation.
- `CHANGE STRATEGY`: prior causal or evidence path no longer has information value.
- `ROLL BACK`: current state is unsafe or invalid and an approved known-good anchor exists. Recommendation is not authority.
- `ASK`: a bounded owner choice or missing input controls the path.
- `ESCALATE`: consequence, authorization, specialized authority, or risk exceeds the current owner.
- `BLOCKED`: an external condition prevents the required evidence or action but may change.
- `INFEASIBLE`: decisive evidence shows the current goal and constraints conflict.
- `COMPLETE`: current evidence supports acceptance and no material unresolved defect remains within scope.

## Blocked versus infeasible

For `BLOCKED`, record:

- the unavailable condition;
- evidence of the block;
- useful partial work preserved;
- the exact unblock event or owner action;
- the next safe action after unblocking.

For `INFEASIBLE`, record:

- the conflicting requirement/constraint;
- decisive evidence;
- why retries or waiting do not resolve it;
- feasible partial outcomes or which requirement must change.

If the evidence is incomplete, use `UNVERIFIED`, `ASK`, or `BLOCKED`, not `INFEASIBLE`.

## Rollback boundary

Before any rollback, establish target, known-good anchor, affected user changes, reversibility, backup/restore path, current authorization, and verification after rollback. Hand consequential decisions to Risk & Change Assurance. Never use rollback to erase unexplained changes or hide a failed strategy.
