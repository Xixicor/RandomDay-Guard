RandomDayGuard v0.4.11-alpha

Install path:
AbioticFactor/Binaries/Win64/ue4ss/Mods/RandomDayGuard/

Enable in mods.txt:
RandomDayGuard : 1

SavedRoot.txt:
Set this to AbioticFactor/Saved if auto-detection fails.
Do not point it directly to a world folder.

First settings to check:
review_only_mode=true
auto_ban=false
write_admin_ini=false

After startup check:
runtime/current/poll_status.json
runtime/current/live_defense_state.json
runtime/scan_progress.json
runtime/world_state/current/world_state_latest.json

Healthy poll:
scheduler_status=running
poll_id increases
poll_in_flight=false between polls

Admin.ini:
Only clean BannedPlayer=<ID> lines are written, and only when enforcement is explicitly enabled.

Evidence standard:
RandomDayGuard records what the server exposes through logs and Saved files. Indirect evidence is stored as context for review, not as direct proof.
