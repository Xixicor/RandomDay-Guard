# Contributing

RandomDayGuard accepts focused, reproducible improvements to parsers,
documentation, tests, and public-safe validation. Keep every change bounded to
the public project contract and preserve review-first behavior: Guard must leave
`Admin.ini` unchanged when a required safety check cannot be confirmed.

## Prepare a safe workspace

1. Fork or clone the repository and create a focused branch.
2. Install a supported Python 3 interpreter. Install a Lua compiler when you
   change Lua so `luac -p` can check syntax.
3. Read the [documentation home](docs/README.md),
   [architecture](docs/ARCHITECTURE.md), and
   [evidence boundary](docs/EVIDENCE_BOUNDARY.md) for the area you will change.
4. Inspect `git status` before editing and preserve unrelated work.
5. Use synthetic or sanitized fixtures only.

Never submit private server logs, Saved folders, player identifiers,
`Admin.ini`, private notification endpoints, credentials, private paths, runtime output, or copied
live evidence.

## Make a focused change

- Follow existing naming, formatting, safety checks, and module ownership.
- Keep one canonical documentation owner for each procedure or exact fact.
- Update user documentation and examples when behavior or public output changes.
- Add a regression test for a bug fix when practical.
- Do not weaken account confirmation, trusted-account protection, backup
  verification, outside-change detection, saved-file comparison, recovery, or
  review-only defaults to make a test pass.

## Run the relevant checks

For documentation-only changes, run:

```powershell
python -B tools\generate_documentation_audit.py --check
python -B -m unittest discover tests -p "test_documentation*.py"
git diff --check
```

For source, configuration, packaging, or test changes, also run the applicable
checks from [Validation and release review](docs/VALIDATION_AND_RELEASE.md),
including Lua syntax checks, repository validation, public-pipeline tests, and
the full unit-test suite. Report every skipped or unavailable check; do not
describe it as passed.

## Submit the change for review

Open a focused pull request only after reviewing the complete diff. Include:

- the problem and intended behavior;
- exact files and public contracts changed;
- commands run and their results;
- privacy, compatibility, and enforcement impact; and
- remaining limitations or follow-up work.

Do not include generated runtime evidence or release archives unless the change
explicitly requires and validates them. A contribution does not authorize a
release, deployment, live-server test, enforcement action, or publication on a
third-party site.

Report vulnerabilities through [the private security
route](SECURITY.md), not a public issue or ordinary pull request.
