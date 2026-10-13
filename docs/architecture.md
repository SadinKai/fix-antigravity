# Architecture

## One stack, four owners

The stack separates responsibility by the kind of truth a task needs. It does not add a meta-agent.

```text
Native Antigravity orchestration
  ├─ Perfect Code V2 ............... engineering truth
  ├─ Evidence Research ............. external factual truth
  ├─ Continuity & Recovery ......... semantic task-state truth
  └─ Risk & Change Assurance ....... consequential-transition truth
```

Antigravity remains responsible for conversation and session behavior, plans, agent and tool selection, permissions, sandboxing, browser and MCP access, and execution. Each skill keeps its own authoritative instructions in `skills/<slug>/SKILL.md`.

## Lead and supporting skills

Choose one lead from the primary task driver. Add a supporting skill only when its domain is materially involved:

- implementation, diagnosis, verification, or code audit → Perfect Code V2;
- current, disputed, version-sensitive, or high-stakes external claims → Evidence Research;
- interruption, handoff, long horizon, stale state, divergence, or repeated failed strategies → Continuity & Recovery;
- security boundaries or consequential transitions → Risk & Change Assurance.

A skill stays dormant when its domain is not material. A typo fix does not need a continuity ledger or risk case. A pure external fact does not need an engineering lifecycle. Explicit invocation does not justify disproportionate procedure.

## Ownership boundaries

Owners exchange evidence without taking over each other's decisions:

- Evidence Research can establish a current external requirement, but cannot turn uncertainty into an internal operational gate owned by Risk.
- Perfect Code can establish that code and tests satisfy an engineering claim, but cannot grant deployment authority.
- Continuity records a risk gate and reconciles its validity; it does not replace the risk decision.
- Risk uses engineering and external evidence, but does not rewrite code or manufacture missing authority.

One owner per layer prevents parallel ledgers and contradictory completion claims. Evidence can be reused by pointer when its source, scope, time, and validity conditions still apply.

## Independent status vector

Integrated work tracks participating layers independently:

```text
ENGINEERING = COMPLETE | INCOMPLETE | BLOCKED
RESEARCH = COMPLETE | INCOMPLETE | BLOCKED
CONTINUITY = COMPLETE | INCOMPLETE | BLOCKED
CONSEQUENTIAL GATE = PROCEED | PROCEED WITH CONTROLS | STOP / BLOCKED
OVERALL TASK = COMPLETE | PARTIAL | BLOCKED | INCOMPLETE
```

These states are not interchangeable. Engineering may be complete while research remains unresolved. All implementation checks may pass while the consequential gate is blocked by missing authority. In that case the overall task is not complete.

## Integrated operating contract

[`integration/four-skill-stack.md`](../integration/four-skill-stack.md) is an optional `always_on` Antigravity rule. It asks the model to evaluate all four skills for each request, load materially relevant skills, keep others dormant, preserve one lead, and respect ownership boundaries.

The rule supplies persistent instructions. It does not guarantee model routing, supersede higher-priority instructions, or bypass native security and permission enforcement. Users who prefer explicit control can install only the skill packages and omit the rule.
