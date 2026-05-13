RandomDayGuard v0.4.11-alpha

What it is:
A separately installable AMP / Hostinger / Abiotic Factor dedicated-server guard addon for the RandomDay Mod.

Install path:
AbioticFactor/Binaries/Win64/ue4ss/Mods/RandomDayGuard/

Enable in mods.txt:
RandomDayGuard : 1

First setup order:
1. Stop the server.
2. Extract the ZIP into ue4ss/Mods/.
3. Confirm this folder is RandomDayGuard/.
4. Set SavedRoot.txt only if auto-detection fails.
5. Keep enforcement disabled for first run.
6. Start the server.
7. Check poll_status.json.

SavedRoot.txt:
Set this to AbioticFactor/Saved if auto-detection fails.
Do not point it directly to a world folder.

First settings to keep:
review_only_mode=true
auto_ban=false
write_admin_ini=false

After startup check:
runtime/runtime_version.json
runtime/current/poll_status.json
runtime/current/live_defense_state.json
runtime/scan_progress.json
runtime/world_state/current/world_state_latest.json

Healthy poll:
scheduler_status=running
poll_id increases
poll_in_flight=false between polls

Baseline scan:
The first scan can take time. It should write scan_progress.json and scan_checkpoint.json while live defense keeps running.

Admin.ini:
Only clean BannedPlayer=<ID> lines are written, and only when enforcement is explicitly enabled.

Evidence standard:
Direct facts require direct readable server evidence. Indirect signals are stored as review context.
