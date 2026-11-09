# Creative Universe — Kronk Booth demo brief

This repository's GitHub Issues are disabled, so this document is the handoff brief for the Claude Code session opened in this repo.

## Goal

Create a safe, stable Booth demonstration that Creative Universe can link to as the Kronk Booth project preview.

Booth is a korner within Kronk, not a separate product repository. Do not fork or duplicate the Kronk platform.

## Before coding

1. Read `CLAUDE.md`, `CONTRIBUTING.md`, and the Booth space documentation under `docs/spaces/`.
2. Inspect the current Booth implementation and identify which capabilities are real, in progress, or planned.
3. Follow this repository's workflow: branch from `shadow`, open a PR into `shadow`, and do not commit directly to `main`.

## Demo requirements

- Provide a dedicated visitor-friendly Booth demo route or safe demo environment within the existing app.
- Use fictional/seeded content only.
- Do not expose real member accounts, private media, private messages, or production credentials.
- Do not connect public visitor interactions to production writes.
- Demonstrate the music discovery, listening and artist experience that is actually in scope for Booth.
- Clearly label simulated integrations and capabilities that are not yet implemented.
- Keep the visual identity and interaction patterns consistent with Kronk.
- Make the demo responsive and provide an obvious way to reset/restart the demo.

## Delivery

Document the demo route, deployment method and exact URL. Run the repository checks and verify the deployed route before calling it ready.

Report:
- branch and PR;
- what is working versus simulated;
- exact demo URL, or the deployment blocker;
- test/check results;
- privacy/access considerations;
- exact URL to use in the Creative Universe project record.
