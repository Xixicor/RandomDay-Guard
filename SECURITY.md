# Security policy

## Report a vulnerability privately

Use [GitHub private vulnerability
reporting](https://github.com/Xixicor/RandomDay-Guard/security/advisories/new) to
send a confidential report to the repository owner. If that form is not
available, use the [owner's public GitHub profile](https://github.com/Xixicor)
to request a private contact channel without including vulnerability details.

Do not open a public issue containing exploit steps, credentials, private
server paths, player identifiers, `Admin.ini`, Saved data, webhook URLs, or live
evidence files.

## Include useful evidence

Provide:

- the affected RandomDayGuard version or commit;
- the affected component and expected safe behavior;
- minimal reproduction steps using sanitized fixtures;
- the observed impact and whether it is repeatable; and
- any proposed mitigation that does not expose private data.

Do not send real secrets. Replace private paths, account identifiers, hostnames,
and tokens with clear placeholders while preserving the structure needed to
reproduce the issue.

## Expect review-first handling

A report is evidence for maintainer review, not authorization to access a
server, test a live target, publish exploit details, or weaken fail-closed
defaults. The owner will validate scope and coordinate any disclosure through
the private report.
