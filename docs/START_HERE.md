# Start here: read the first Guard report

This guide starts after RandomDayGuard is installed and enabled. It proves one
useful result without asking a new operator to inspect source code, package
internals, or machine-only status files.

## What happens after the server starts

Guard waits for the game server and UE4SS to load, finds the server's available
records, and starts a bounded background scan. It can report current server
health while older history is still being indexed.

The first report should be **Server status**. It answers whether Guard is
completing monitoring cycles now, when the current server run began if that
timestamp is available, how much active/rotated log and scan coverage exists,
how many players are connected, which source groups are missing, and whether
an operator action is needed.

A background scan that is still progressing is a limitation on historical
coverage, not automatically a startup failure. Guard records the scan cursor,
files completed, files discovered, and last progress time. If those values stop
changing across repeated monitoring cycles, treat the historical path as
stalled and follow the scan branch in Troubleshooting. Do not discard current
log and session results solely because older history is incomplete.

## Read the first server-status report

1. Start the dedicated server normally.
2. Wait for the game server and UE4SS to finish starting.
3. Open RandomDayGuard's final reports folder and choose the newest readable
   server-status report.
4. Confirm the report contains:
   - **Summary**
   - **What Guard observed**
   - **What it means**
   - **What remains unknown**
   - **Recommended next step**
   - **Technical record**
5. In **What Guard observed**, confirm the latest monitoring cycle advances
   and the report names available log, scan, player, and source coverage.
6. If the next step says no intervention is needed, keep the report as the
   first successful result. If it names a missing source or stopped process,
   follow that exact symptom in [Troubleshooting](TROUBLESHOOTING.md).

The report may link to technical evidence for a deeper review. A normal
operator can read the report first and open those references only when the
plain result needs to be checked.

## Understand quiet reports

Player activity, case review, and Critical Guard are event-driven. A quiet
server should not produce a fictional player, case, or failure merely to fill a
channel. The readable result may say that the source was checked and nothing
belonged in that report.

Daily rollup is different: it provides one review per report date using the
same-day sessions, current review subjects, retained identity/case context,
scan progress, and source gaps that Guard can actually read. Facts absent from
the available server records remain unknown instead of being estimated.

## Test one ordinary player session

After the first server-status report is current:

1. Let one known player join and leave normally.
2. Wait for the next report cycle.
3. Open Player activity.
4. Confirm it identifies the account or display name available to Guard, the
   join and leave times, the clean or incomplete session result, prior history
   when available, and one next action.

The session report should contain the observed data. It should not be replaced
by a list of filenames or a generic statement that records exist.

## Continue

- [Five report examples](REPORT_EXAMPLES.md)
- [Operations playbook](OPERATIONS_PLAYBOOK.md)
- [Player review workflow](PLAYER_REVIEW_WORKFLOW.md)
- [Troubleshooting](TROUBLESHOOTING.md)
- [Complete documentation index](README.md)
