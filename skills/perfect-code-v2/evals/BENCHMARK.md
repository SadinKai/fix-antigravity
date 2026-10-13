# Perfect Code V2 Evaluation Plan

These evals make V2 behavior testable. They do not establish improvement until controlled runs are performed.

## Comparisons

Use matched conditions:

1. same model/harness without Perfect Code;
2. same model/harness with Perfect Code V1;
3. same model/harness with Perfect Code V2;
4. targeted ablations when diagnosing a result, such as removing the coverage-loop routing or fresh-context option.

Keep prompt, repository state, model/effort, tools, permissions, environment, and time-sensitive dependencies equivalent. Record any unavoidable difference.

## Trigger evaluation

Use `trigger_evals.json` over repeated runs when the platform supports stochastic routing. Measure:

- true-positive and true-negative activation;
- false positives and false negatives;
- whether TRIVIAL in-scope work remains proportionate after explicit invocation;
- confusion with pure research, non-code artifacts, narrow domain workflows, and read-only consequence assessment.

Do not improve trigger score by making the description a broad catchall.

Confirm `/perfect-code-v2` manual invocation on Antigravity. Separately, on hosts that support the optional `agents/openai.yaml` metadata contract, confirm that literal `$perfect-code-v2` invocation remains valid. Do not score `$perfect-code-v2` as Antigravity syntax, and do not test an undocumented alias as if it were supported. Keep the `name`, metadata file, package layout, reference paths, and evaluator entry points unchanged.

## Behavioral evaluation

Use `evals.json` with realistic repository fixtures. Judge observable behavior and artifacts, not whether the response repeats skill vocabulary.

Primary measures:

- acceptance-claim coverage;
- material defect recall and false-positive burden;
- root-cause accuracy;
- relevant failure-space coverage and disclosed residuals;
- hypothesis revision after contrary evidence;
- oracle fitness and recognition of weak/partial evidence;
- regressions and unnecessary change surface;
- strategy change after no-progress;
- state and completion-claim accuracy;
- native Antigravity coexistence without duplicate planning/orchestration;
- simple-task overhead;
- user correction required.

Secondary measures:

- tool/context/token use;
- elapsed time;
- number of agent passes;
- readability and maintainability of the result.

Higher cost is acceptable only when it yields material quality or assurance. More tokens, tools, tests, findings, or passes are not success metrics by themselves.

## Audit evaluation

Use seeded defects plus naturally occurring findings. Seed across neighboring call paths, downstream transformations, state/lifecycle, negative paths, concurrency, migration completeness, security reachability, configuration, dependencies, and runtime behavior.

Score separately:

- defect found;
- causal path correct;
- evidence valid;
- impact calibrated;
- false positive avoided;
- unsearched surface disclosed.

Do not treat historical PR comments as complete ground truth. Have an independent evaluator validate seeded and novel findings.

## Strategy and oracle evaluation

Instrument whether an attempt produced new evidence. When the first hypothesis is wrong or two similar attempts fail, score whether the agent changes hypothesis, evidence source, tool, abstraction, decomposition, or reviewer rather than making cosmetic retries.

For green-test scenarios, inspect whether the suite ran the intended scope and whether a plausible wrong implementation still passes. Score lower completion claims as correct when the oracle is genuinely unavailable.

## Long-horizon and native coexistence

For interruption/resumption cases, mutate relevant workspace state between phases. Evaluate whether the agent reconciles actual state rather than trusting stale history.

For `/plan`, `/boost`, Teamwork, and subagent cases, evaluate contract use and duplicated ownership. Native mechanisms may be simulated in a fixture if the evaluation harness cannot invoke them; label simulation separately from live validation.

## Reference fallback evaluation

Run the same representative STANDARD and COMPLEX tasks under four package-availability conditions:

1. all references available;
2. one relevant optional reference unavailable;
3. several optional references unavailable;
4. only `SKILL.md` available.

In every condition, evaluate whether the agent still classifies depth, establishes acceptance, inspects the repository, preserves constraints and scope, selects causal context, uses bounded hypotheses only when justified, chooses a claim-appropriate oracle, works in causal slices, switches away from non-progress, verifies proportionately, labels evidence state, discloses residuals, and closes on evidence. Missing references may reduce specialized detail, but must not cause invented reference content, an unnecessary stop, or loss of the core lifecycle.

## Experimental discipline

- Use multiple task classes and held-out prompts.
- Repeat runs where feasible and report variance.
- Blind the evaluator to condition when practical.
- Keep model and tool budgets matched unless the experiment explicitly tests a budget.
- Record pre-existing failures and environment limitations.
- Inspect trigger and process failures, not only final output.
- Do not tune the skill to one example or to evaluation wording.
- Prefer changes that improve several task classes without degrading simple-task proportionality.

An eval passes only when the behavior is evidenced. Regex or phrase matching may validate structure, but it must not stand in for engineering quality.
