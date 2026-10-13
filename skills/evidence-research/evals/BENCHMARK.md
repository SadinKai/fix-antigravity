# Evidence Research Evaluation Plan

These evaluators define intended behavior. They do not establish improvement until executed under controlled conditions.

## Matched comparisons

Compare under the same model, effort, Antigravity version/surface, prompt, tool access, permissions, date, and source snapshot:

1. native Antigravity without Evidence Research;
2. native Antigravity with Evidence Research;
3. targeted ablations when diagnosing a result, such as removing contradiction or freshness guidance;
4. a semantically irrelevant-skill control when testing skill-induced interference.

Record unavoidable differences. For live-current questions, preserve the query date and source versions. Use frozen source fixtures for repeatability and separate live runs for currency.

## Trigger evaluation

Use `trigger_evals.json` over repeated runs where routing is stochastic. Measure:

- true-positive and true-negative activation;
- false positives and false negatives;
- explicit `/evidence-research` invocation;
- confusion with stable facts, local deterministic evidence, routine coding, creative work, and already-fresh evidence;
- whether implicit activation stays specific rather than becoming automatic browsing.

Do not improve recall by broadening the description into a general reasoning trigger.

## Behavioral evaluation

Use `evals.json` with source fixtures and, where authorized, live sources. Judge the produced evidence packet, not whether the response repeats skill terminology.

Primary measures:

- atomic claim coverage and correct claim scope;
- citation entailment: the source actually supports the nearby claim;
- source authority, independence, and applicability;
- correct publication/access date, version, environment, platform, and jurisdiction fields;
- freshness and refresh-condition quality;
- contradiction discovery, preservation, discrimination, and conditional resolution;
- correct `DOCUMENTED`, `REPORTED`, `REPRODUCED`, `OBSERVED`, `VENDOR-CLAIMED`, `INFERRED`, and `UNKNOWN` basis;
- correct `VERIFIED`, `PARTIALLY VERIFIED`, `CONDITIONAL`, `UNRESOLVED`, and `BLOCKED` outcome;
- false-absence rate;
- unsupported certainty and stale-memory substitution;
- search steps without information gain;
- stopping accuracy;
- handoff fidelity and ownership boundaries.

Secondary measures:

- source/tool/context volume;
- elapsed time;
- duplicate evidence lineages;
- unnecessary activation on negative controls;
- user correction required.

More sources, searches, tokens, agents, or prose are not success metrics.

## Source-quality fixtures

Construct fixtures where:

- a secondary article accurately points to a primary source;
- several pages copy one unsupported community claim;
- an official page is stale or scoped differently;
- the first search result is wrong;
- the source mentions the topic but does not support the conclusion;
- a quote is technically accurate but context reverses its implication.

Score source lineage, applicability, and exact claim wording independently.

## Freshness and software-status fixtures

Include dated documentation, changelogs, installed versions, rollout notes, open/closed issues, advisories, and runtime observations. Mutate the target version or decision date between runs to test whether evidence is refreshed instead of reused blindly.

Do not treat a changelog as rollout proof, an open issue as latest-version reproduction, or a closed issue as universal resolution.

## Contradiction fixtures

Provide:

- two authoritative sources with different version or environment scope;
- current documentation conflicting with observed installed behavior;
- historical issue evidence conflicting with a later release note;
- unresolved sources where no discriminating evidence is accessible.

Score whether the agent identifies the exact difference, seeks the highest-information evidence, resolves conditionally when justified, and otherwise returns `UNRESOLVED`.

## Citation and absence checks

Have an independent evaluator inspect each material sentence against its cited passage and conditions. For absence scenarios, record the searchable universe and whether the method could detect the item if present.

A correct `NOT FOUND` or `BLOCKED` should score higher than an unsupported `DOES NOT EXIST`.

## Search and stopping instrumentation

Record for each acquisition step:

- claim targeted;
- source family and lineage;
- expected information gain;
- new evidence obtained;
- hypothesis or status changed;
- reason to continue, switch, or stop.

When repeated same-family searches add no evidence, score a source-family/query/version/environment/evidence-type switch. Penalize arbitrary minimum search/source counts and research that continues after the decision is sufficiently supported.

## Integration evaluation

- **Perfect Code:** sends a bounded API/version/dependency question and receives only a source/date/version/scope/direct-support/conflict/confidence/freshness packet. Evidence Research must not edit the repository or choose the implementation.
- **Risk & Change Assurance:** receives current advisory/provider/policy facts; Risk retains consequence and authorization.
- **Continuity & Recovery:** retains an evidence pointer and refresh condition, not a duplicate research store.
- **Native Antigravity:** `/plan`, `/boost`, Teamwork, subagents, browser, MCP, rules, hooks, permissions, and artifacts keep their documented owners.

## Reference-fallback evaluation

Run representative STANDARD and COMPLEX cases with:

1. all references available;
2. one relevant reference unavailable;
3. several references unavailable;
4. only `SKILL.md` available.

The agent must still frame atomic claims, select applicable sources, record provenance/freshness, distinguish evidence from inference, expose contradictions, switch from non-progress, return calibrated statuses, and stop honestly. Missing references may reduce specialized detail but must not cause invented content or abandonment of the core method.

## Gemini 3.8 Flash High failure patterns

Specifically score resistance to:

- first-plausible conclusion;
- confirmation-only search;
- source authority overconfidence;
- stale-memory substitution;
- citation mismatch;
- excessive low-information search;
- failure to change source family;
- contradiction suppression;
- version/configuration blindness;
- activity mistaken for evidence.

## Experimental discipline

- Use held-out questions and source fixtures.
- Repeat stochastic runs and report variance.
- Blind evaluators to condition when practical.
- Keep tool and reasoning budgets matched unless budget is the tested variable.
- Publish failures and ambiguous cases, not only aggregate passes.
- Separate structural/static validation from executed model behavior.
- Re-run live-current cases after material product/model/version changes.

No benchmark result should be reported unless the runs were actually executed and their environment is recorded.
