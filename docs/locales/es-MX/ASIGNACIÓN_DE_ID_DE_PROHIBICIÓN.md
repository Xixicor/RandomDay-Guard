<a id="ban-id-mapping"></a>
# Asignación de ID de prohibición

> **Fuente canónica en inglés:** [BAN_ID_MAPPING.md](../../BAN_ID_MAPPING.md). Esta documentación localizada conserva comandos, rutas, claves, valores de estado, hashes y nombres de archivos exactos. Si la redacción técnica difiere, utilice la fuente en inglés.


Utilice esta página al convertir el nombre de un jugador en una `Admin.ini` línea de prohibición segura.

<a id="core-rule"></a>
## Regla principal

Un nombre para mostrar no es un ID de prohibición.

`Admin.ini` utiliza:

```ini
BannedPlayer=<raw numeric player ID>
```

<a id="evidence-hierarchy"></a>
## Jerarquía de evidencia

| Clasificación | Fuente | Uso |
|---:|---|---|
| 1 | Registro del servidor `Login request` | Mejor asignación de nombre a ID |
| 2 | `Player_<ID>.sav` | Confirma que el ID existe |
| 3 | Existente `Admin.ini` | Existente bans/moderators |
| 4 | Notificación externa o actividad del panel de alojamiento | Time/name contexto únicamente; no prueba de identificación |
| 5 | UE4SS focus/player líneas | Presence/context solo |
| 6 | Registros de contenedor o ciclo de vida del sistema | Contexto del ciclo de vida del host únicamente; no prueba de identificación |

<a id="extract-the-clean-id"></a>
## Extraiga la identificación limpia

Ejemplo sin procesar:

```text
ConnectID=2535422284688820_+_|0002d07b...
```

Limpiar `Admin.ini` valor:

```ini
BannedPlayer=2535422284688820
```

No pegar `_+_|...`.

<a id="verify-with-playerdata"></a>
## Verifique con PlayerData

Verificar para:

```text
Saved/SaveGames/Server/Worlds/<WorldName>/PlayerData/Player_<ID>.sav
```

Significado:

```text
The ID exists in the world save.
```

Limitación:

```text
PlayerData may not prove the display name unless another source maps it.
```

<a id="when-not-to-ban"></a>
## Cuándo no prohibir

No asigne un ID de prohibición cuando:

```text
the name only appears in an external notification
the name only appears in hosting-panel activity
UE4SS shows a name but no ConnectID
only system lifecycle or container logs exist
the ID is trusted or moderator
```

<a id="evidence-table-template"></a>
## Plantilla de tabla de evidencia

```text
display_name:
server_time:
log_file:
line_number:
log_name:
connect_id_raw:
ban_id:
unique_id:
playerdata_file:
decision:
notes:
```

<a id="related-docs"></a>
## Documentos relacionados

* [`ADMIN_INI_ENFORCEMENT.md`](CUMPLIMIENTO_DE_ADMIN_INI.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](FLUJO_DE_TRABAJO_DE_REVISI%C3%93N_DEL_REPRODUCTOR.md)
