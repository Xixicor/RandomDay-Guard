# Changelog

## v0.4.11-alpha - Initial Clean Public Baseline

- Published RandomDayGuard as a separately installable Saved-folder and log-driven guard addon for RandomDay Mod dedicated servers.
- Added immediate live-defense evidence from server logs before baseline completion.
- Added bounded incremental Saved-folder scanning with progress, checkpoint, partial, and completed baseline outputs.
- Added account/session evidence, crash/restart lifecycle context, log continuity, object registry, world-state summaries, warning reports, raid context, and clean Admin.ini enforcement support.
- Packaged both UE4SS entrypoint paths: `Scripts/main.lua` and `scripts/main.lua`.
- Kept public defaults review-first: `auto_ban=false`, `write_admin_ini=false`, and `review_only_mode=true`.
- Documented evidence boundaries, ban-ID mapping, Hostinger/AMP install checks, single-world save support, and active-world-folder change behavior.
