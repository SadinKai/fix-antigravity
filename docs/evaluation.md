# Bounded behavioral evaluation

## Evidence states

The [slice](../evals/slice.json) selects **8 existing behavioral cases**, supporting both canonical cases/evals schemas. The helper also selects each skill's first existing negative trigger control: **12 trial definitions**. [Fixtures](../evals/fixtures.json) are synthetic inputs, not real provider claims or model outputs.

All model results are **NOT RUN**. The [blank report template](../evals/report-template.json) is not an execution report.

~~~powershell
.\scripts\evaluate.ps1 -ValidateOnly
.\scripts\evaluate.ps1
.\scripts\evaluate.ps1 -ValidateOnly -ReportPath .\evals\report-template.json
~~~

These resolve existing selectors, prepare inputs/rubrics or check completeness. They do not call a model or assign behavioral PASS. The [first-success oracle](../examples/first-success/README.md) separately tests a human reference repair.

## Safe trial protocol

1. Establish an approved cost budget, exact available model/host/version, permissions and an actually isolated disposable workspace. Never use real production, accounts, databases, messages, payments or credentials.
2. Copy only the selected skills/fixture into that context; record package hashes, mode and reference availability. If a checked prerequisite is absent, record BLOCKED with its observations; use NOT RUN when no attempt/assessment is recorded.
3. Use the original prompt/expectation resolved by the helper, plus disclosed synthetic fixture inputs. Do not rewrite a case to fit a desired outcome.
4. Run engineering baselines and retain unchanged oracles. For the external-mutation case, the operator supplies a disposable already-tracked repository baseline, records real status/hashes, and makes both prescribed changes. Frozen descriptions cannot prove actual Git reconciliation.
5. Use fresh sessions for negative controls without explicit invocation. Inspect host activation evidence where available; the model's self-description alone is insufficient.
6. Record every attempt: failures, timeouts, refusals and ambiguous results. Each report contains all 12 selections; unattempted cases remain NOT RUN. Use separate complete reports for repetitions.
7. A reviewer judges all applicable criteria against actual artifacts, diffs, commands, outputs and side effects. Missing evidence cannot become PASS. Repeating skill vocabulary is not scoring.
8. Comparative claims require matched native-without-skill conditions, equivalent budgets/permissions/fixtures, repeated trials, variance, false triggers, failures and overhead.

Research fixtures are synthetic, not live-current evidence. Risk cases are hypothetical assessments with no operational target.

## Actual-trial report fields

Date; exact model/version label; host version/surface; OS; permissions; skill configuration/hashes; complete input; actual output or reviewed non-sensitive pointer; output_origin = MODEL GENERATED; status; per-criterion scoring rationale; reviewer; failures; residuals.

Keep sensitive raw logs private. Publish only reviewed synthetic/sanitized evidence. Completeness validation does not prove a human's score correct. Human-written answers cannot be represented as model trials.

## Report states and accounting

The main deterministic gate invokes the same report validator on the blank template.

- NOT RUN: output_origin is NOT RUN, output/scoring_rationale are empty, blocker is null. No executed/completed trial is counted.
- BLOCKED: no model execution is claimed; output_origin remains NOT RUN and output/scoring_rationale stay empty. Reviewer and a structured blocker are required. Missing date/model/run ID must not be invented. No executed/completed trial is counted.
- PASS / FAIL: a reported executed trial requires MODEL GENERATED provenance, nonempty captured output and all actual-trial fields above, a parseable recorded date/time and SHA-256 package evidence. A pre-execution blocker cannot also be present. This validates completeness, not behavioral truth.

A blocker contains prerequisite (AUTHORITY, ISOLATION, COST, HOST or INPUT), reason, required_to_unblock and a nonempty evidence array. Each evidence object requires kind (OWNER DECISION, CONFIGURATION, COMMAND RESULT or ARTIFACT), source and observation. COMMAND RESULT additionally needs command and integer exit_code; ARTIFACT needs a 64-hex SHA-256. A generic sentence in place of structured evidence fails. The reviewer must still verify whether the supplied observations actually establish the blocker.

With ReportPath the helper returns completeness-only accounting: SelectedTrials, ExecutedModelTrials, CompletedModelTrials, BlockedTrials and NotRunTrials, with BehavioralPassAssigned=false. Executed/completed counts describe supplied PASS/FAIL records, not independently observed runs. Without ReportPath, preparation still emits 12 NOT RUN definitions and zero attempted_model_trials. No model API is called.

Synthetic schema fixtures in deterministic tests simulate states only. They are not model-generated evidence; all 12 selected live trials remain NOT RUN.

## Interface and coverage limits

Official [headless CLI](https://antigravity.google/docs/cli/headless/) and [permissions](https://antigravity.google/docs/permissions) were inspected. Local CLI 1.2.11 exposes print/model/effort/output/mode/sandbox options, but flags do not establish Windows isolation or spending authority.

No undocumented evaluation API or automatic live adapter is assumed. A later adapter must test the actual supported interface and fail closed on unsafe execution. The deterministic gate needs no model account/network.

The slice covers engineering/restraint, source lineage/version conflict, external mutation/expired authority, missing authorization/unproven rollback and dormant controls. It does not replace all 258 behavioral/106 trigger scenarios, fallback matrices, repeated stochastic runs or cross-skill integration.
