# Compatibility and verification scope

## Automation

Declared target: **Windows PowerShell 5.1 and PowerShell 7**, built-in facilities only. Local qualification runtimes: **5.1.26100.9444** and **7.6.5**. The gate prints actual versions and counts; [the verification report](hardening-verification.md) records fresh results separately from history.

macOS/Linux automation is not qualified; reviewed manual package copying remains possible. Selected source/destination links, junctions and hard links are intentionally rejected, not followed. Preserve user-managed links and choose ordinary reviewed directories.

## Host contract versus behavior

Official paths rechecked on 2026-10-14:

| Surface | Global skills | Workspace skills | Modular rules |
|---|---|---|---|
| IDE / app | ~/.gemini/config/skills | .agents/skills | ~/.gemini/config/rules |
| CLI | ~/.gemini/antigravity-cli/skills | .agents/skills | ~/.gemini/antigravity-cli/rules |

Sources: [skills](https://www.antigravity.google/docs/skills?tab=ide), [rules](https://www.antigravity.google/docs/rules/), [permissions](https://antigravity.google/docs/permissions).

The skills documentation also specifies legacy workspace .agent/skills, legacy IDE ~/.gemini/antigravity/skills and CLI plugin ~/.gemini/antigravity-cli/plugins/<name>/skills. These are recovery exclusions, not an assertion of live discovery qualification.

Manual invocation is /skill-name on supported Antigravity surfaces. Dollar-prefixed prompts are optional OpenAI/Codex metadata, not Antigravity syntax. No undocumented V1 alias is provided.

| Evidence | Boundary |
|---|---|
| Local deterministic gate | Filesystem, serialization, recovery, metadata, links, parser and fixture checks |
| Prepared hosted workflow | NOT RUN until reviewed changes are pushed |
| CLI 1.2.11 version/help | Interface inspected, not activation or behavior |
| Fresh isolated host discovery after hardening | NOT RUN |
| Selected live model trials | NOT RUN |
| Full 258 behavioral / 106 trigger trials | NOT RUN in this pass |
| Dedicated scanners / PSScriptAnalyzer | Unavailable; no dedicated PASS |
| Limited pattern check | Not a scanner or comprehensive history audit |

The CLI is available, but a new safely isolated execution context and spending boundary were not established. No live adapter is enabled. A sandbox flag alone does not prove Windows isolation. The [documented model slug](https://antigravity.google/docs/cli/headless/) establishes availability, not skill performance.

## Input limits

Canonical paths use portable ASCII names, forward slashes and SHA-256. Unexpected files/empty directories, ambiguous/duplicate/case-colliding entries, absolute/traversal/device/ADS paths and links fail closed. No metadata exclusions exist inside packages.

Filesystem destinations also reject trailing dots/spaces, device names, ADS, wildcard-bearing segments and extended/device aliases that could bypass ordinary Windows path comparisons. Snapshots cover file bytes and directory inventory, not ACLs, timestamps or alternate-stream metadata.

Filesystem parameters are resolved once to absolute paths against PowerShell's current FileSystem location before mutation. Relative non-filesystem provider paths are rejected; nonexistent filesystem targets are supported. Provider-qualified and ambiguous device spellings are not accepted.

Optional skills.json registration retains an **observed compatibility format**: object root, entries array, objects with string path. It is not claimed as a universal current official requirement; folder discovery needs no registration.

JSON files: strict UTF-8 with/without UTF-8 BOM, maximum **1,048,576 encoded bytes including BOM**, and nesting depth 64. The final merged/encoded manifest is checked before any installation write; its validated byte array is the one staged/written. Unsupported input or output is rejected before writes. Duplicate keys/equivalent paths and malformed entries are not repaired. Unrelated subtrees and original entries are retained verbatim and checked after parsing the merged result, preserving numeric/date lexemes.

## Recovery and candidate boundaries

Recovery checks cover the selected root, skills ancestors of selected targets, documented global roots, and whole-segment workspace/global/CLI-plugin layouts in the recovery path itself. Windows comparisons are case-insensitive; dot segments are normalized. Similarly named but separate directories are not rejected by substring matching. No historical backup is migrated or deleted.

Additional custom discovery roots cannot all be enumerated. The owner must establish that recovery storage is not indexed by another configuration. Filesystem layout checks are not live host indexing/activation proof.

Duplicate checks inspect candidate SKILL.md files in the selected active skill root, not private recovery directories or every installation on the machine. The dependency-free identity reader accepts a bounded top-level mapping: plain keys; plain, single-quoted and double-quoted scalar values; trailing comments outside scalars; doubled single quotes and quote/backslash double-quote escapes. Name is an explicit lowercase/hyphen identifier or defaults to a valid folder name when omitted; nonempty description is required. Literal/folded description blocks are supported. Quoted hashes remain content. Implicitly typed plain scalars require quoting/manual review. Missing/malformed frontmatter, duplicate keys, nested mappings, aliases, tags, quoted keys, unsupported escapes and ambiguous identities require manual review rather than silently passing. This is not general YAML validation.

Recovery still has no hostile-concurrent-filesystem guarantee. Stop competing writers; process interruption may require manual recovery. ACL/alternate-stream preservation and cross-volume recovery are not qualified by the deterministic suite.
