# RandomDayGuard v0.4.11-alpha - Initial Clean Public Baseline

RandomDayGuard is a separately installable guard addon for RandomDay Mod dedicated servers. It watches the Abiotic Factor dedicated-server evidence layer through UE4SS Lua, AMP/Hostinger/Wine-compatible paths, and Saved-folder/log-derived evidence.

## Included

- Standalone UE4SS Lua entrypoints at `RandomDayGuard/Scripts/main.lua` and `RandomDayGuard/scripts/main.lua`
- Immediate live-defense layer from server logs before baseline completion
- Bounded baseline scan layer with progress, checkpoint, partial, manifest, and completed baseline outputs
- Review-first defaults: `auto_ban=false`, `write_admin_ini=false`, and `review_only_mode=true`
- Clean Admin.ini output only when explicitly enabled: `BannedPlayer=<ID>`
- Session evidence, crash/restart context, log continuity, object registry, world-state files, warning reports, raid context, and AMP restart marker support

## Evidence Boundary

RandomDayGuard uses Saved-folder and log-derived evidence only. It does not claim live object damage, container use, item duplication, exact player coordinates, live ping, object ownership, memory inspection, or client anti-cheat behavior unless those facts are visible in readable server evidence.
