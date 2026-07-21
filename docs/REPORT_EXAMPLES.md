# Examples of the five Guard reports

These examples were produced from the sample data included with the release;
the names and account numbers are invented. They show the tested report fields,
calculations, and route boundaries. A real report replaces them with information
collected from that server and says when a fact was not available.

Each report has one job. Server health does not repeat player history, the
daily review is not sent every few minutes, and quiet player or case routes do
not receive filler messages. A current report may be ready while the bounded
historical scan is still progressing; in that case the report names the gap
instead of presenting older history as complete.

## Server status

> **Server Status: Online After Restart**
>
> **Current state:** Online
>
> **Available since:** 14:07
>
> **Restart completed:** 14:06
>
> **Downtime:** 3 minutes, 12 seconds
>
> **Restart reason:** Scheduled game update
>
> **Monitoring:** Active. Last successful check: 14:09
>
> **Game log:** Available and updating
>
> **Historical scan:** 312 of 355 files reviewed
>
> **Backups:** Last verified: 13:00. Next expected: 15:00. Failures today: 0
>
> **Action:** None. The server recovered normally.

Server status is for the server's current operation: startup, restart recovery,
downtime, backups, the scheduler, and Guard health. It does not contain player
sessions or case details.

## Daily rollup

> **Daily Review: 19 July 2026**
>
> **Server availability:** Online for 23 hours, 47 minutes. Offline for 13
> minutes.
>
> **Restarts:** 2 total: 1 scheduled and 1 unexpected.
>
> **Backups:** 23 successful. 1 missing or failed. Latest successful backup:
> 23:00.
>
> **Player activity:** 3 unique players. 7 sessions: 6 completed normally and 1
> interrupted.
>
> **Case activity:** 1 new case, 2 updated cases, 1 case needing attention, and
> 0 critical cases.
>
> **Evidence coverage:** 6 of 7 expected source groups were available. The
> 04:00 backup log was unavailable.
>
> **Day summary:** The server remained available for most of the day. One
> unexpected interruption ended a player session early. Monitoring resumed
> after recovery, and one case is ready for review.
>
> **Action:** Review case `RDG-20260719-004`. No other immediate action is
> required.

The daily rollup is written once for its calendar date. It combines the day
across quiet periods and restarts without becoming another server-status ping.

## Player activity

> **Player Activity: Alex**
>
> **Account:** `76561198000000400`
>
> **First observed:** 12 July 2026
>
> **Latest session:** Joined at 10:02, left at 11:18, lasted 1 hour 16 minutes,
> and ended normally.
>
> **Today:** 3 connections, 2 completed sessions, 1 interrupted session, and 2
> rapid reconnects within 10 minutes.
>
> **Previous 7 days:** 9 sessions, 6 hours 18 minutes of recorded play, and 0
> previous cases.
>
> **Observed:** Alex returned twice shortly after an interrupted session. The
> recorded activity is complete enough to preserve as history, but it does not
> by itself explain why the reconnects occurred.
>
> **Action:** Continue monitoring. No immediate action is required.

Player activity is sent only when supported player or session information
changes. A quiet period does not create a player message.

## Case review

> **Case Review: RDG-20260719-004**
>
> **Subject:** Alex
>
> **Account:** `76561198000000400`
>
> **Status:** Administrator review requested
>
> **Review rating:** 90 - High priority
>
> **Why the case opened:** The account made repeated connection attempts after
> an interrupted session, and the server recorded the login requests directly.
>
> **Confirmed observations:**
> - A login request was recorded at 18:42.
> - Four attempts were recorded within 6 minutes.
> - Two sessions ended without a normal departure record.
> - The same account was observed on 12 July and 17 July.
>
> **Relevant history:** No previous case is recorded for this account.
>
> **Unknown:** The available records do not establish the reason for the
> reconnects, the player's intent, or whether the world state changed.
>
> **Recommended action:** Compare the session times with the server log and the
> recorded world activity before deciding whether any action is needed.

Case review contains named review material, its confirmed observations, its
limits, and a specific review step. Historical presence alone does not create a
new case.

## Critical Guard

> **Critical Guard: Report Writing Stopped**
>
> **Started:** 21:14
>
> **Affected function:** Player report writer
>
> **Impact:** New player summaries cannot be completed.
>
> **Server:** Remains online.
>
> **Monitoring:** Evidence collection continues, but readable reports are
> delayed.
>
> **Last successful report:** 21:09
>
> **Failure:** The report output could not be saved.
>
> **Likely reason:** The destination was unavailable or rejected the write.
>
> **Action:** Check the Guard runtime output location. Do not restart the game
> server unless monitoring also stops.

When the problem clears, the same route records the recovery:

> **Critical Guard Resolved: Report Writing Restored**
>
> **Resumed:** 21:22
>
> **Interruption:** 8 minutes
>
> **Result:** Evidence collected during the interruption was preserved and the
> delayed reports were completed.

Critical Guard is failure-only. Routine status, daily history, player activity,
and ordinary expected-empty results remain in their own reports.

## When a route is quiet

A quiet route records a direct result without sending filler to Discord:

> **Checked; nothing for this report.** The required records were available and
> no matching player activity, case, or Guard failure occurred during this
> report window.

That is a complete empty result. It is different from a missing report, where a
required source could not be checked or the readable output could not be
created.

Every readable report follows the same path:

```text
collected evidence -> normalized values -> dictionary mapping -> route calculations -> readable report -> Discord notification
```

Use the [operations playbook](OPERATIONS_PLAYBOOK.md) to review current reports
and the [output schema](OUTPUT_SCHEMA_REFERENCE.md) for the technical field
reference.
