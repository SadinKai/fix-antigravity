# Troubleshooting

## Discovery or routing

Confirm host/version and [matching root](compatibility.md); run the verifier with identical explicit paths, confirm root-level SKILL.md, then restart. Filesystem PASS is not activation proof. Do not guess manifest registrations.

Historical backup/duplicate candidates are preserved and block pending review. Move reviewed copies outside discovery roots manually; never delete them to silence validation. New recovery storage is printed during replacement.

For integrated mode, verify matching -Integrated/-RulePath and always_on frontmatter. Rules are guidance, not guaranteed routing. Trivial tasks should remain trivial.

## Preview or source validation

Record $PSVersionTable. Use Windows PowerShell 5.1 or PowerShell 7. Preview is read-only; malformed sources/configuration still fail. Never alter checksums to accept unknown files. -ReplaceConflicts does not bypass source-integrity checks.

Links/junctions/hard links, unsafe path overlap and unexpected files are intentional boundaries. Preserve ownership and choose ordinary reviewed directories; do not blindly delete links/extras.

## Replacement or restoration failure

Stop retrying. Inspect the exact active destination, printed recovery directory and restore-info.json. RESTORATION NOT VERIFIED is not rollback success. Preserve backup/previous/staging and unexpected active content. Follow [restoration](installation.md#restore-a-previous-installation).

Earlier destinations may already be updated; installation is not one transaction. Interrupted processes can leave an active target absent/changed despite preserved copies. Reconcile effects before retry.

## Optional manifest rejection

Folder discovery needs no registration. The observed compatibility mode accepts object roots and entries arrays with unique string paths. Empty objects work; ambiguous, malformed, unsupported encoding/depth inputs are not repaired. See [JSON limits](compatibility.md). Keep the original until ownership and correction are reviewed.

## Permission or execution policy

Use native approvals and organizational policy. Never bypass Deny/Ask, sandbox, filesystem, URL, MCP or project controls. No permission changes or remote-script piping are required. Reviewed manual installation remains possible.

## Demo failure

The seeded baseline is 2 passed, 1 failed. Ask the agent to repair the disposable copy only. Success is 3 unchanged tests passed. Human-reference validation does not establish AI execution.

For contribution problems run [the gate](../CONTRIBUTING.md). For vulnerabilities use [private reporting](../SECURITY.md), never public exploit details.
