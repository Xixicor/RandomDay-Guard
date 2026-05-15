RandomDayGuard v0.4.11-alpha — Guía rápida ES-MX

Ruta de instalación:
AbioticFactor/Binaries/Win64/ue4ss/Mods/RandomDayGuard/

Activar en mods.txt:
RandomDayGuard : 1

SavedRoot.txt:
Pon aquí la carpeta AbioticFactor/Saved si la auto-detección falla.
No apuntes directo a la carpeta del mundo.

Primeros settings:
review_only_mode=true
auto_ban=false
write_admin_ini=false

Después del arranque revisa:
runtime/current/poll_status.json
runtime/account_evidence.json
runtime/evidence/session_events.jsonl
runtime/scan_progress.json
runtime/world_state/current/world_state_latest.json

Poll sano:
scheduler_status=running
poll_id sube
poll_in_flight=false entre polls

Admin.ini:
Sólo se escriben líneas limpias BannedPlayer=<ID>, y sólo si enforcement está activado.
