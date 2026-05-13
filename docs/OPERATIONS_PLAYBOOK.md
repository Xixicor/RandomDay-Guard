# Operations Playbook

## First Run

Verify:

- `runtime/runtime_version.json`
- `runtime/current/poll_status.json`
- `runtime/current/live_defense_state.json`
- `runtime/scan_progress.json`

Live defense is working when `poll_id` increases, login/join/leave events appear, and `poll_in_flight` clears between polls.

## Long Baseline Scan

Large servers may take time to scan. Watch:

- `runtime/scan_progress.json`
- `runtime/scan_checkpoint.json`
- `runtime/object_registry_partial.json`
- `runtime/world_state/current/world_state_latest.json`

Partial files are expected before the full baseline completes.

## After Restart

Check that `runtime/current/poll_status.json` resumes and `runtime/runtime_version.json` has the current boot ID. Previous evidence should remain separate from current boot state.

## Reviewing Evidence

Use warning reports, account evidence, session evidence, lifecycle evidence, and world-state summaries together. Do not treat lifecycle context or object counts alone as player-caused or ban-eligible.
