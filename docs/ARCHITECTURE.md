# Architecture

RandomDayGuard has two evidence layers.

Layer 1 is immediate live defense. It starts after UE4SS loads `main.lua`, config is read, the Saved root is found, and active log tailing reaches a safe offset. The poll loop must return quickly, increment `poll_id`, clear `poll_in_flight`, and reschedule. Live defense uses new log lines for identity, joins, leaves, lifecycle context, warning bursts, and reconnect patterns.

Layer 2 is the baseline scan. It runs after the active log is caught up and processes Saved files in bounded chunks. It writes `scan_progress.json`, `scan_checkpoint.json`, partial object/world outputs, and final object/world baseline outputs.

Boot order:

1. Load runtime and write bootstrap diagnostics.
2. Load config.
3. Resolve Saved root from direct-known evidence.
4. Initialize active log tailing and canonical log dedupe.
5. Start or resume a server epoch.
6. Write admin and PlayerData indexes.
7. Write current-state placeholders.
8. Start the poll loop.
9. Start scan job only after the live gate opens.

Recursive discovery is allowed only in scan-job discovery phases. It must not run from startup, log tailing, status writing, Saved root probing, or poll scheduling.

Baseline outputs are evidence summaries, not player-action proof. Object and class deltas become review context only when correlated with mapped account/session evidence.
