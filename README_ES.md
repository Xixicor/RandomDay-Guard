# RandomDayGuard — Guía para operadores

**RandomDayGuard** es un addon de guardia para servidores dedicados de **Abiotic Factor** que usan **RandomDay Mod**.

RandomDay Mod cambia la experiencia del servidor.  
RandomDayGuard vigila la capa de evidencia del servidor: logs, `Admin.ini`, PlayerData, guardados del mundo, backups, sesiones, reinicios, crashes y reconexiones.

Está pensado para servidores en:

- AMP
- Hostinger VPS
- Wine / rutas tipo Windows
- UE4SS Lua
- servidores dedicados donde el admin necesita revisar evidencia antes de actuar

---

## Qué te da

| Función | Para qué sirve |
|---|---|
| Defensa en vivo | Detecta entradas, salidas, reconexiones, crashes y churn sospechoso desde los logs. |
| Mapeo de identidad | Convierte nombre visible en cuenta / ban ID usando evidencia del login del servidor. |
| Escaneo de mundo | Construye contexto de objetos, clases, PlayerData, mundo y backups desde `Saved/`. |
| Resume de escaneo | Guarda progreso para no empezar desde cero después de crash o reinicio. |
| Actualización por cambios | Después del baseline, revisa archivos nuevos/cambiados en vez de leer todo otra vez. |
| Evidencia para admin | Escribe archivos claros para revisión, reportes y auditoría. |
| Enforcement opcional | Puede escribir `BannedPlayer=<ID>` en `Admin.ini`, sólo si tú lo activas. |

Por defecto viene en modo seguro:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

Eso significa: **registra evidencia y recomendaciones, pero no toca `Admin.ini` todavía**.
---

## Mapa de documentación

Usa la carpeta `docs/` como manual de operador. Abre el archivo que corresponde al trabajo que quieres hacer.

| Necesitas... | Lee esto |
|---|---|
| Primera instalación o primer arranque | `docs/START_HERE.md` |
| Elegir perfiles de configuración seguros | `docs/CONFIG_PROFILES.md` |
| Entender cada área de config | `docs/CONFIG_REFERENCE.md` |
| Saber dónde están los logs/output y qué archivos crecen | `docs/MEMORY_ECONOMY_AND_OUTPUTS.md` |
| Entender los campos exactos de cada output | `docs/OUTPUT_SCHEMA_REFERENCE.md` |
| Revisar un jugador/cuenta paso por paso | `docs/PLAYER_REVIEW_WORKFLOW.md` |
| Revisar crash abuse, patrones de bad actors y recuperación | `docs/BAD_ACTOR_PATTERNS_AND_RESILIENCE.md` |
| Entender cada señal de detección | `docs/DETECTION_SIGNALS.md` |
| Entender escritura segura de `Admin.ini` | `docs/ADMIN_INI_ENFORCEMENT.md` |
| Resolver problemas de carga, scan, mapping o validación | `docs/TROUBLESHOOTING.md` |
| Ver ejemplos realistas de corridas del servidor | `docs/EXAMPLE_RUNS.md` |
| Validar y construir el ZIP de release | `docs/VALIDATION_AND_RELEASE.md` |
| Respuestas rápidas | `docs/FAQ.md` |
| Manejar cambios de carpeta de mundo | `docs/WORLD_SAVE_FOLDER_CHANGES.md` |
| Entender estándar de evidencia | `docs/EVIDENCE_BOUNDARY.md` |
| Operación diaria del admin | `docs/OPERATIONS_PLAYBOOK.md` |

Orden recomendado para un admin nuevo:

```text
1. START_HERE.md
2. CONFIG_PROFILES.md
3. MEMORY_ECONOMY_AND_OUTPUTS.md
4. PLAYER_REVIEW_WORKFLOW.md
5. TROUBLESHOOTING.md
6. ADMIN_INI_ENFORCEMENT.md
7. BAD_ACTOR_PATTERNS_AND_RESILIENCE.md
8. FAQ.md
```

El README queda corto a propósito. Los detalles viven en `docs/` para que el operador pueda saltar directo al tema que necesita.


## Instalación rápida

1. Detén el servidor.
2. Borra la carpeta vieja `RandomDayGuard`.
3. Extrae el ZIP dentro de:

```text
AbioticFactor/Binaries/Win64/ue4ss/Mods/
```

4. Verifica que la ruta final sea:

```text
AbioticFactor/Binaries/Win64/ue4ss/Mods/RandomDayGuard/
```

5. Actívalo en `mods.txt`:

```text
RandomDayGuard : 1
```

6. Revisa `SavedRoot.txt`.
7. Inicia el servidor.
8. Abre:

```text
runtime/current/poll_status.json
```

Si reemplazas archivos mientras el servidor está prendido, UE4SS no necesariamente recarga el Lua nuevo. Lo seguro es: **detener, reemplazar, verificar, iniciar**.

---

## Lo primero que debes configurar

### 1. SavedRoot.txt

`SavedRoot.txt` debe apuntar a la carpeta `Saved/` del servidor.

Correcto:

```text
/AMP/<servidor>/AbioticFactor/Saved
```

o:

```text
Z:/AMP/<servidor>/AbioticFactor/Saved
```

Incorrecto:

```text
Saved/SaveGames/Server/Worlds/<WorldName>
```

Por qué: RandomDayGuard necesita ver `Logs`, `Admin.ini`, `Worlds`, `PlayerData` y `Backups`. Si apuntas directo al mundo, le escondes parte de la evidencia.

### 2. Enforcement

Déjalo así al principio:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

Con esto puedes probar si el guardia detecta sesiones, reconexiones, crashes y reportes sin modificar bans.

### 3. Whitelist / IDs de confianza

Antes de activar bans automáticos, agrega dueños y moderadores de confianza:

```lua
whitelist = {
    ["<trusted_account_id>"] = true,
}
```

---

## Guía de configuración

| Área de config | Úsala cuando... | Opciones importantes |
|---|---|---|
| `saved` | El guardia no encuentra `Saved/` o quieres controlar qué familias se escanean. | `root_candidates`, `direct_known_files`, `scan_world_saves`, `scan_player_data`, `scan_backups` |
| `log_tail` | Quieres detección en vivo de joins/leaves/crash-return. | `enabled`, `start_at_end_on_first_run`, `tail_backup_logs`, `max_lines_per_poll` |
| `scanning` | Quieres baseline, checkpoints, resume y refresh por cambios. | `full_scan_on_start`, `resume_incomplete_scan`, `reuse_completed_baseline`, `incremental_refresh_after_baseline` |
| `enforcement` | Quieres que el guardia escriba bans en `Admin.ini`. | `review_only_mode`, `auto_ban`, `write_admin_ini`, `require_clean_ban_id` |
| `crash_correlation` | Quieres revisar cuentas que se repiten alrededor de crashes. | `repeated_failure_review_count`, `repeated_failure_ban_count`, `post_crash_reconnect_grace_seconds` |
| `join_leave` | Quieres detectar churn o join-waves. | `join_wave_window_minutes`, `join_wave_min_accounts`, `churn_alone_never_bans` |
| `warning_bursts` | Quieres revisar bursts de warnings del servidor. | `actor_channel_failure`, `update_actor_to_worldsave`, `deployable_save_warning` |
| `retention` | Quieres controlar tamaño de logs y retención. | `detailed_retention_days`, `rotate_jsonl_when_bytes_exceed`, `keep_evidence_forever` |
| `world_state` | Quieres snapshots de mundo/sesión. | `write_boot_state`, `write_current_state`, `write_session_join_state` |
| `amp` | Quieres marker files para reinicio AMP después de bans. | `request_restart_after_ban`, `restart_marker_file`, `max_restarts_per_hour` |

---

## Perfiles recomendados

### Primera instalación segura

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
start_at_end_on_first_run = true
tail_backup_logs = false
resume_incomplete_scan = true
reuse_completed_baseline = true
```

Úsalo cuando apenas estás instalando y quieres comprobar que todo funciona.

### Sólo defensa en vivo

```lua
log_tail.enabled = true
scanning.full_scan_on_start = false
review_only_mode = true
```

Úsalo si quieres registrar sesiones, crashes y reconexiones inmediatamente, pero prefieres retrasar el escaneo pesado.

### Baseline completo

```lua
scanning.full_scan_on_start = true
scanning.resume_incomplete_scan = true
scanning.reuse_completed_baseline = true
scanning.incremental_refresh_after_baseline = true
```

Úsalo cuando quieres contexto de mundo/objetos y refresh por archivos cambiados.

### Prueba de enforcement

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

Úsalo para ver quién sería marcado como `REVIEW` o `BAN-ELIGIBLE` sin tocar `Admin.ini`.

### Enforcement activado

```lua
review_only_mode = false
auto_ban = true
write_admin_ini = true
require_clean_ban_id = true
preserve_existing_bans = true
preserve_moderators = true
```

Actívalo sólo después de confirmar:

- IDs de confianza configurados
- sesiones mapean bien
- reportes se ven correctos
- backups de `Admin.ini` funcionan
- entiendes los umbrales

---

## Cómo decide cosas

### Sesión normal

```text
El jugador entra.
El jugador sale limpio.
```

Resultado:

```text
Se guarda evidencia.
Status queda INFO.
No warning.
No ban.
```

### Reconexiones rápidas

```text
join -> leave -> join -> leave -> join
```

Resultado:

```text
sube rapid_rejoin_count
sube session_churn_score
puede pasar a REVIEW
```

Regla segura:

```lua
churn_alone_never_bans = true
```

O sea: churn por sí solo no debe banear.

### Crash-return

```text
Jugador activo.
Servidor crashea.
Mismo jugador vuelve rápido después del reinicio.
El patrón se repite.
```

Resultado:

```text
sube server_crash_overlap_count
sube post_crash_reconnect_count
sube crash_abuse_score
```

Puede ser `REVIEW` o `BAN-ELIGIBLE` si se repite y está ligado a la misma cuenta.

Regla segura:

```lua
single_crash_never_bans = true
```

### World actor save touch

Si el log o Saved evidencia algo como:

```text
UpdateActorToWorldSave
Deployed_Container_...
```

Resultado:

```text
Se guarda como contexto.
Sirve para correlación.
No prueba por sí solo que alguien abrió, robó, duplicó o dañó algo.
```

---

## Archivos de salida importantes

| Archivo | Qué te dice |
|---|---|
| `runtime/runtime_version.json` | Qué versión cargó realmente. |
| `runtime/current/poll_status.json` | Si el watchdog está vivo. |
| `runtime/current/live_defense_state.json` | Estado de defensa en vivo. |
| `runtime/account_evidence.json` | Perfiles/resumen de cuentas conocidas. |
| `runtime/account_evidence.tsv` | Lo mismo en tabla fácil de revisar. |
| `runtime/evidence/session_events.jsonl` | Eventos de login, join, leave y sesión. |
| `runtime/session_events.tsv` | Timeline de sesiones en tabla. |
| `runtime/scan_progress.json` | Fase y progreso del escaneo. |
| `runtime/scan_checkpoint.json` | Punto para resumir si hay crash/reinicio. |
| `runtime/object_registry_partial.json` | Registry parcial mientras escanea. |
| `runtime/object_registry.json` | Registry final después del baseline. |
| `runtime/world_state/current/world_state_latest.json` | Estado de mundo actual, parcial o completo. |
| `runtime/baselines/file_manifest.tsv` | Archivos usados para refresh por cambios. |
| `runtime/enforced_bans.jsonl` | Auditoría de bans escritos por el guardia. |

Estado sano:

```json
{
  "scheduler_status": "running",
  "poll_scheduled": true,
  "poll_in_flight": false
}
```

Si `poll_id` sube y `poll_in_flight` vuelve a `false`, el loop está vivo.

---

## Qué revisar en el primer arranque

- [ ] Servidor detenido antes de instalar.
- [ ] ZIP extraído en `ue4ss/Mods/RandomDayGuard`.
- [ ] `mods.txt` contiene `RandomDayGuard : 1`.
- [ ] `SavedRoot.txt` apunta a `Saved/` o está vacío para auto-detección.
- [ ] `runtime_version.json` existe.
- [ ] `poll_status.json` muestra `scheduler_status=running`.
- [ ] `poll_id` sube con el tiempo.
- [ ] `poll_in_flight` vuelve a `false`.
- [ ] `account_evidence.json` aparece cuando hay actividad.
- [ ] `session_events.jsonl` registra join/leave.
- [ ] `scan_progress.json` aparece cuando inicia escaneo.
- [ ] `world_state_latest.json` aparece.
- [ ] Enforcement sigue apagado hasta verificar.

---

## Carpeta de mundo único

RandomDayGuard soporta un solo mundo activo.

Layout típico:

```text
Saved/SaveGames/Server/Worlds/<WorldName>/
```

Dentro:

```text
WorldSave_*.sav
PlayerData/Player_*.sav
```

Config correcta:

```text
SavedRoot.txt -> Saved/
```

No pongas:

```text
SavedRoot.txt -> Saved/SaveGames/Server/Worlds/<WorldName>/
```

El guardia descubre mundos desde `Saved/`.

---

## Si cambia la carpeta del mundo

### Mismo mundo, nombre diferente

Ejemplo:

```text
Worlds/OldName/
Worlds/NewName/
```

Resultado esperado:

```text
reusar evidencia donde el fingerprint coincida
reescanear rutas que cambiaron
preservar evidencia anterior
```

### Mundo diferente o backup restaurado

Resultado esperado:

```text
crear nueva generación de baseline
preservar baseline anterior
no sobrescribir baseline viejo hasta completar el nuevo
```

### Había escaneo parcial y cambió el mundo

Resultado esperado:

```text
marcar checkpoint viejo como stale
preservar evidencia parcial
empezar baseline nuevo
```

### Había baseline completo y cambió el mundo

Resultado esperado:

```text
cargar baseline anterior para visibilidad
marcarlo como contexto de mundo previo
crear baseline nuevo de forma segura
```

---

## Guía rápida de Ban ID

El nombre visible no es el ban ID.

Mejor fuente:

```text
Login request
Name=<player>
ConnectID=<raw_id>
UniqueId=<platform_id>
```

Si `ConnectID` es:

```text
2535422284688820_+_|0002d07b...
```

`Admin.ini` usa:

```ini
BannedPlayer=2535422284688820
```

Nunca uses:

```ini
BannedPlayer=ExamplePlayer
```

Tampoco pegues el sufijo `_+_|...`.

---

## Docs de detalle

Para la siguiente capa de explicación:

```text
docs/OUTPUT_SCHEMA_REFERENCE.md        campos exactos dentro de los archivos runtime
docs/PLAYER_REVIEW_WORKFLOW.md         cómo revisar una cuenta sospechosa
docs/BAD_ACTOR_PATTERNS_AND_RESILIENCE.md  crash abuse, patrones de bad actors, sticky backups
docs/ADMIN_INI_ENFORCEMENT.md          escritura segura de bans y rollback
docs/TROUBLESHOOTING.md                problemas comunes
```


## Estándar de evidencia

RandomDayGuard es evidence-first: registra lo que el servidor expone en logs y archivos `Saved`.

Si la evidencia es indirecta, se guarda como contexto. Contexto puede ayudar en revisión, pero no es lo mismo que prueba directa.

Ejemplo: una referencia a `Deployed_Container_...` puede ayudar a entender el estado del mundo, pero por sí sola no dice quién abrió el contenedor ni qué hizo con él.

---

## Relación con RandomDay Mod

```text
RandomDay Mod corre la experiencia rotativa del servidor.
RandomDayGuard vigila, registra y protege la capa de evidencia del servidor dedicado.
```

---

## Aviso

RandomDayGuard es una utilidad comunitaria independiente para administración de servidores.

No está afiliado ni respaldado por Deep Field Games, Playstack, UE4SS, AMP, Hostinger ni proveedores de plataforma.
