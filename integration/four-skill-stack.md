---
trigger: always_on
description: Routes tasks through the Four-Skill Stack while preserving native Antigravity orchestration and proportionality.
---

# Fix Antigravity Operating Contract

## Operational Skill Stack Enforcement

The installed operational stack consists of four specialized skills:

1. `perfect-code-v2` — **Engineering Truth**
2. `evidence-research` — **External Factual Truth**
3. `continuity-recovery` — **Semantic Task-State Truth**
4. `risk-change-assurance` — **Consequential-Transition / Risk Truth**

**Operating rule: Always consult the four-skill stack when processing a new user task. Invoke the skills relevant to the task and follow their own routing and applicability rules. Never silently bypass the stack in favor of unstructured reasoning.**

### 1. Per-task applicability gate

For every user request, evaluate the task against all four skills:

- Determine whether each skill's domain is materially involved.
- If materially involved, load and follow the corresponding authoritative `SKILL.md`.
- If not materially involved, treat that skill as dormant for the task.
- Do not silently skip a materially relevant skill.
- Do not invoke irrelevant skills merely to manufacture work.
- Do not replace a skill's workflow with an improvised or summarized imitation.
- Preserve proportionality: trivial tasks remain trivial.

### 2. Ownership boundaries and routing

- **Engineering implementation, diagnosis, audit, and verification → `perfect-code-v2` lead.** It owns repository-grounded diagnosis, software changes, architecture within the task, testing and verification strategy, engineering failure-space coverage, requirement-to-evidence mapping, and engineering completion claims. It must not claim tests passed unless they ran.
- **External factual research, versioning, and external claims → `evidence-research`.** It owns claim decomposition, source selection and independence, provenance, freshness, applicability, contradiction handling, evidence sufficiency, and calibrated confidence. It provides evidence and uncertainty; it does not grant authorization or own consequential-action gates.
- **Long-running state, handoff, interruption, and recovery → `continuity-recovery`.** It owns canonical semantic task state, reconciliation against repository and environment reality, divergence identification, failure classification, and the next safe recovery action.
- **Security, authorization, destructive mutation, and consequential transitions → `risk-change-assurance`.** It owns the risk case: threat assurance, consequence control, authority evidence, blast radius, rollback viability, controls, observation and stop conditions, and the explicit gate decision.

Boundary invariants:

- A locally successful test does not authorize a production change.
- Absence of evidence is not proof of absence.
- A projected consequence is not an observed fact.
- When evidence or authorization required for a consequential action is missing, apply the appropriate `STOP / BLOCKED` gate instead of executing the action.

### 3. Composition model

When multiple domains are materially involved, use:

- one lead based on the primary task driver;
- specialized support only where materially justified;
- one canonical task-state owner when Continuity is active;
- one owner per material external claim;
- one engineering owner per material change; and
- one authorization gate for consequential transitions.

Partners reuse valid owned evidence by pointer rather than repeating work. They do not silently overwrite another owner's conclusion. Newer applicable evidence supersedes stale evidence through an explicit owner update and, when active, canonical-state reconciliation. Native Antigravity remains the orchestrator.

Track participating layers independently:

```text
ENGINEERING = COMPLETE | INCOMPLETE | BLOCKED
RESEARCH = COMPLETE | INCOMPLETE | BLOCKED
CONTINUITY = COMPLETE | INCOMPLETE | BLOCKED
CONSEQUENTIAL GATE = PROCEED | PROCEED WITH CONTROLS | STOP / BLOCKED
OVERALL TASK = COMPLETE | PARTIAL | BLOCKED | INCOMPLETE
```

Layer completion is not overall completion. If engineering, research, and continuity are complete while the consequential gate is `STOP / BLOCKED`, the overall task is `BLOCKED` or `PARTIAL`, never overall verified or complete.

### 4. Instruction hierarchy and safety

1. Higher-priority system, environment, and security instructions.
2. Explicit user instructions.
3. Repository and project instructions.
4. This operating contract and the active skill instructions.

Never weaken or bypass Antigravity's native safety, sandbox, permission controls, or user prompts.
