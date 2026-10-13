# Evidence-Directed Coverage Loop

Read this reference for substantial audits, ambiguous failures, multi-component changes, migrations, or any task where local inspection can miss a consequential neighboring surface.

This protocol searches a failure space. It is not a fixed checklist and does not require inspecting every category.

## 1. Define the audit or change claim

State:

- observable acceptance claim;
- affected environment and version;
- important invariants and non-goals;
- consequence if wrong;
- evidence that would be strong enough;
- unavailable systems or authority that limit the conclusion.

Use one claim per materially different outcome. “Repository is correct” is not an actionable claim.

## 2. Build a risk-weighted surface map

Start from the behavior, not from a file list. Select surfaces capable of causing or invalidating the claim:

- entry points and callers;
- control and call paths;
- data producers, transformations, stores, and consumers;
- state transitions and lifecycle edges;
- concurrency, ordering, retries, cancellation, and idempotency;
- errors, cleanup, partial failure, and recovery;
- interfaces, schemas, dependencies, configuration, and generated boundaries;
- authentication, authorization, trust, and tenant boundaries;
- build, deployment, rollback, environment, and external systems;
- runtime, browser, observability, and operational behavior.

Prioritize each selected surface by a practical combination of:

- consequence if defective;
- reachability from the task;
- uncertainty;
- architectural coupling;
- weakness or absence of evidence.

Do not map everything. Record a deliberately excluded surface only when it could materially change confidence.

## 3. Keep a bounded hypothesis portfolio

Use competing hypotheses when the cause is ambiguous, the first explanation is weakly evidenced, or the consequence is material.

| ID | Hypothesis | Support | Counterevidence | Confidence | Falsifier | Best separating observation |
|---|---|---|---|---|---|---|
| H1 | Concrete causal explanation | Direct observations | Evidence against it | low/medium/high | Observation that would reject it | Next high-information check |

Prefer a few materially different causal explanations over many wording variants. Include non-code causes when plausible: configuration, environment, stale data, dependency behavior, test defect, concurrency, deployment, or tool failure.

Retire a hypothesis when decisive evidence falsifies it. Do not quietly resurrect it without new evidence.

## 4. Choose discriminating evidence

Ask: **Which next observation most changes the relative plausibility of the live hypotheses or directly proves an acceptance claim?**

Useful evidence can include:

- minimal reproduction or characterization;
- focused unit/integration/contract/end-to-end test;
- type checker, static analyzer, linter, build, or schema validator;
- call/data/control-flow evidence;
- trace, log, debugger, profiler, or load observation;
- browser/DevTools evidence;
- fault injection, concurrency stress, property, fuzz, differential, or metamorphic test;
- repository history or version comparison;
- authoritative external documentation or observed upstream behavior.

Select by fitness to the claim. A deterministic check is not automatically useful if it encodes the same wrong assumption or does not reach the behavior.

## 5. Investigate in causal slices

A causal slice is the smallest connected surface that can establish or falsify the current claim. It may cross files or services. A file is not automatically a slice.

For each slice:

1. state the question;
2. acquire only causally relevant context;
3. obtain an observation;
4. update hypotheses and coverage;
5. decide whether to close, expand, or change strategy.

Do not collect context merely because it is available. Expand to a neighboring surface when a value, state, responsibility, side effect, or failure can cross that boundary.

## 6. Maintain a proportional coverage ledger

For COMPLEX or CRITICAL work, record only fields that change decisions:

| Acceptance claim | Surface examined | Hypothesis/status | Evidence and validity | Oracle strength | Material unsearched surface | Residual/status |
|---|---|---|---|---|---|---|

Optional detail when necessary:

- counterevidence;
- validated/invalidated assumption;
- evidence source, time, environment, and version;
- next discriminating observation;
- reason a material surface was excluded.

For STANDARD work, this can be a few notes. For TRIVIAL work, do not create a ledger.

The ledger is temporary engineering state. If the task spans sessions, compaction, or multiple agents, hand the useful state to Continuity & Recovery rather than creating another persistent store.

## 7. Strategy-switch gate

An attempt advances the task only if it produces at least one of:

- new discriminating evidence;
- a falsified or materially strengthened hypothesis;
- a verified acceptance claim;
- a newly exposed relevant surface;
- a concrete environmental or authority blocker.

If the same strategy class yields no such progress, stop repeating it. Diagnose the stall and change one or more of:

- causal hypothesis;
- evidence source or oracle;
- tool;
- abstraction level;
- subsystem decomposition;
- environment;
- reviewer/context.

Do not use an arbitrary retry count as the primary rule. Two similar failures are a strong warning, but a second attempt may be justified if it tests a genuinely new condition.

If no safe discriminating action is available, report `BLOCKED` or `UNVERIFIED`.

## 8. Audit finding contract

A material finding should include:

- claim and affected outcome;
- reachable trigger or causal path;
- direct evidence and its scope;
- relevant counterevidence;
- impact and reversibility;
- reproduction/test/trace when feasible;
- confidence;
- unverified boundary.

Do not inflate finding count with style preferences or unsupported possibilities. Findings without evidence remain hypotheses.

## 9. Closure

Close when:

- material acceptance claims are mapped to evidence;
- relevant selected surfaces were examined;
- important contrary hypotheses were tested or remain explicitly unresolved;
- the oracle strength is proportionate to consequence;
- material unsearched surface and environmental limitations are disclosed;
- the last meaningful change was checked;
- no known material finding remains silently open.

Coverage is not “all files read.” It is a defensible account of the consequential failure space searched and the residual space not established.
