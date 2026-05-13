RandomDayGuard v0.4.11-alpha

RandomDayGuard is a separately installable AMP / Hostinger / Abiotic Factor dedicated-server guard addon for the RandomDay Mod.

Install this folder at:
AbioticFactor/Binaries/Win64/ue4ss/Mods/RandomDayGuard/

Required UE4SS entrypoints are both included:
- Scripts/main.lua
- scripts/main.lua

Enable in mods.txt:
RandomDayGuard : 1

SavedRoot.txt should point to the AbioticFactor/Saved folder if auto-detection fails.
Do not point SavedRoot.txt directly to a world folder.

Runtime output is written under RandomDayGuard/runtime/.
Default enforcement is review-only: auto_ban=false and write_admin_ini=false.
