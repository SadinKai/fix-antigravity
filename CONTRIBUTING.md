# Contributing

Thank you for helping improve Fix Antigravity.

## Before opening an issue

- Search existing issues.
- State which skill, file, Antigravity surface, and version are involved.
- Separate observed behavior from your interpretation.
- Include the smallest reproducible prompt or configuration that is safe to share.
- Remove credentials, personal paths, private repository details, and conversation data.

Use a security report rather than a public issue for vulnerabilities or sensitive-information exposure; see [SECURITY.md](SECURITY.md).

## Changes

The four packages are intentionally specialized. Changes should preserve their ownership boundaries and proportional behavior. Do not introduce a fifth orchestrator or make every task activate every skill.

For a skill change:

1. Explain the reproduced problem and the affected contract.
2. Make the smallest justified change.
3. Add or update focused evaluation cases without weakening unrelated expectations.
4. Run the package validator and parse all evaluator JSON.
5. Report what was actually tested and any residual uncertainty.

Documentation changes must keep each package's `SKILL.md` authoritative. Installer changes must be exercised in an isolated directory, including clean, repeat, conflict, and malformed-configuration cases.

## Pull requests

Keep pull requests focused. Describe the motivation, affected files, tests run, and compatibility impact. Do not include generated logs, local backups, personal qualification reports, or unrelated cleanup. A passing local test does not establish production readiness or grant authority for consequential actions.

By contributing, you agree that your contribution may be distributed under the project's [MIT License](LICENSE).
