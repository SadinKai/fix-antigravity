# Evidence Packet Contract

Read this reference when the result will be reused, handed to another skill, or contains multiple material claims.

The packet is a compact decision artifact, not a transcript, link dump, or general task plan.

## Header

```text
QUESTION:
DECISION BEING INFORMED:
RESEARCH DATE:
DECISION/ACTION DATE:
DEPTH: SIMPLE | STANDARD | COMPLEX | CRITICAL
REQUIRED CONFIDENCE:
SCOPE / EXCLUSIONS:
```

## Per-claim record

```text
CLAIM ID:
CLAIM:
PRIORITY:
STATUS: VERIFIED | PARTIALLY VERIFIED | CONDITIONAL | UNRESOLVED | BLOCKED
BASIS: DOCUMENTED | REPORTED | REPRODUCED | OBSERVED | VENDOR-CLAIMED | CORROBORATED | INFERRED | UNKNOWN
STATEMENT ROLE: FACT | INFERENCE | RECOMMENDATION | RISK PROJECTION | UNRESOLVED PROPOSITION

EVIDENCE:
- source title and publisher/origin
- direct URL or artifact pointer
- publication/update date, when available
- accessed/observed date
- version/environment/platform/jurisdiction/scope
- exact direct support (concise quote or faithful paraphrase)
- source tier and relationship when material: SAME DOCUMENT | SAME SOURCE/PUBLISHER | SAME AUTHORITY | GENUINELY INDEPENDENT | SECONDARY REPORTING | COPIED/REPEATED | LOCAL OBSERVATION | REPRODUCED BEHAVIOR

APPLICABILITY:
INFERENCE, IF ANY:
CONTRADICTIONS / COUNTEREVIDENCE:
CONFIDENCE: HIGH | MEDIUM | LOW
CAVEATS:
REFRESH CONDITION:
```

Use one record per independently supportable material claim. Group immaterial supporting details rather than creating a giant ledger.

For a lifecycle-sensitive claim, keep semantic classification separate from local arithmetic or ordering. Add this compact sub-record only when material:

```text
LIFECYCLE PROPOSITION:
- subject
- version/release or homogeneous range
- property being claimed
- direct evidence for that property
- classification and confidence
- final wording

SEPARATE NUMERIC MEASURES, IF USED:
- version/patch delta
- total release count
- count by evidenced lifecycle category
- derivation and evidence boundary
```

Do not use a numeric measure as category evidence. A count by category includes only individually evidenced members or a range directly evidenced as homogeneous. If final wording combines propositions, verify each relationship or split the sentence.

For a freshness-sensitive claim, add this sub-record only for dimensions that could materially change the proposition:

```text
FRESHNESS / APPLICABILITY:
- claim target
- source date, version, scope, rollout/deployment, runtime, platform/mode
- target version, scope, rollout/deployment, runtime, platform/mode
- supersession relationship and evidence
- result: CURRENT AND APPLICABLE | CURRENT BUT NOT APPLICABLE | CURRENT WITH TARGET STATE UNKNOWN | FUTURE / NOT YET APPLICABLE | HISTORICAL AND APPLICABLE TO TARGET | SUPERSEDED FOR TARGET | SUPERSEDED OUTSIDE TARGET | SCOPE OR APPLICABILITY UNKNOWN
- final target-bound wording
```

Do not equate the latest source, announced version, available release, supported version, or generally available behavior with the version or behavior deployed to the target. Omit immaterial dimensions, but preserve every mismatch or unknown that can change the conclusion.

For a consequential cross-skill handoff, add this compact ownership record when material:

```text
DECISION OWNERSHIP HANDOFF:
- evidence conclusion and status
- conditional implications of each live alternative
- recommendation, if any: explicitly labeled RECOMMENDATION
- downstream decision owner: RISK & CHANGE ASSURANCE | AUTHORIZATION OWNER | OTHER NAMED OWNER | UNRESOLVED
- downstream decision, if already supplied by its owner, plus provenance pointer
```

Evidence Research creates the evidence conclusion and implications. It records a Risk decision, authorization decision, or consequential gate only when that decision was already supplied by its owner. If an applicable external source explicitly establishes a requirement or gate, record it as a sourced external requirement, not as an internally issued Risk decision. Keep the sourced requirement, internal decision, and provenance distinct.

`CORROBORATED` requires the relationship label; it does not mean independent by default. Keep recommendations and risk projections in their statement roles and tie them to the facts or inferences that support them. Prefer `the source states`, `the evidence supports`, `this implies`, `this creates a risk of`, and `this remains unverified` over stronger wording when the evidence is conditional. A refresh condition must be future-actionable from the research date.

## Confidence calibration

- **HIGH:** direct, applicable evidence is strong enough for the decision; material contradiction is resolved or absent within the searched scope.
- **MEDIUM:** evidence is useful and reasonably applicable, but a material independence, scope, environment, or coverage limit remains.
- **LOW:** evidence is indirect, weakly applicable, anecdotal, incomplete, or substantially uncertain.

Confidence is not a source-count formula. One decisive governing observation can be stronger than many indirect sources. A `VERIFIED` claim still states its conditions; high confidence does not mean universal truth.

## Overall result

```text
OVERALL CONCLUSION:
ALTERNATIVES / CONDITIONAL RESULTS:
UNRESOLVED GAPS:
BLOCKERS:
REFRESH CONDITION:
```

The overall status may be lower than individual claim statuses when the decision depends on an unresolved claim.

## Perfect Code handoff

Perfect Code should receive:

- the exact engineering question;
- each material claim and status;
- source/date/version/environment/scope;
- direct evidence versus inference;
- contradictions and applicability;
- confidence and unresolved boundary;
- refresh condition.

Do not include implementation instructions unless they are explicitly part of a sourced external contract. Perfect Code decides how evidence affects the repository.

## Risk handoff

Risk & Change Assurance should receive current factual inputs and their validity: advisory status, affected/fixed versions, governing guidance, provider behavior, contradictory evidence, confidence, conditional implications, and refresh condition. Do not convert evidence into a consequence/control decision, gate, authorization, or acceptable risk. Preserve any later Risk decision by pointer without rewriting the source fact or unresolved evidence status.

## Continuity handoff

Continuity & Recovery should retain a pointer or compact accepted claim with status, research date, validity scope, and refresh condition. Avoid copying full source text or creating a second independent evidence ledger.

## Compression rules

- Keep citations close to the claims they support.
- Preserve decision-changing caveats; omit browsing narration.
- Do not paste entire pages, long transcripts, or duplicate source descriptions.
- If a claim is unresolved, state what evidence would resolve it.
- If access failed, distinguish unavailable evidence from negative evidence.
