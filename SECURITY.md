# Security Policy

## Private reporting

GitHub private vulnerability reporting for SadinKai/fix-antigravity was **enabled and verified through the live API on 2026-10-14**, after confirming authenticated repository-admin authority.

Use [Report a vulnerability](https://github.com/SadinKai/fix-antigravity/security/advisories/new). Never put secrets, exploit details, private repository data or personal information in a public issue. If the form is unavailable, withhold details: the owner must restore Settings -> Security -> Advanced Security -> Private vulnerability reporting. Do not use a public exploit-report fallback.

Include the affected file/version, impact/preconditions, minimal synthetic reproduction and safe workaround if known. Never include live credentials. No response/remediation SLA is promised; maintenance is community-led.

## Scope and realistic limits

Reports may cover instruction-boundary failures, unsafe installation/recovery, configuration corruption, credential exposure or unauthorized consequential behavior. Skills do not replace native permissions or user authorization.

The installer performs local filesystem operations, not network transmission, credential retrieval, permission-policy modification or downloaded-code execution. Integrated routing and compatibility registration are opt-in. Backups may contain private configuration; never attach or commit them.

Checksums establish parity, not trusted provenance if substituted too. Tooling rejects observed links/junctions, unsafe paths, unknown files and malformed configuration. It is not a hostile-concurrent-filesystem security boundary; stop competing installers/writers during replacement.

Recovery is verified per destination, not a multi-destination transaction. Interrupted processes or failed restoration may require [manual recovery](docs/installation.md). The deterministic gate is not a comprehensive security audit; [verification limits](docs/compatibility.md) disclose unavailable scanners and host/model evidence.
