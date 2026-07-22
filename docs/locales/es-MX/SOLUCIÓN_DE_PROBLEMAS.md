<a id="troubleshooting"></a>
# Solución de problemas

> **Fuente canónica en inglés:** [TROUBLESHOOTING.md](../../TROUBLESHOOTING.md). Esta documentación localizada conserva comandos, rutas, claves, valores de estado, hashes y nombres de archivos exactos. Si la redacción técnica difiere, utilice la fuente en inglés.


Utilice esta página cuando Guard no se carga, no se puede recopilar una fuente, no aparece un informe o la prueba de ruta contradice lo que esperaba. Comience con el árbol de decisiones y siga una rama. Utilice la [referencia de estado y error](REFERENCIA_DE_ESTADO_Y_ERROR.md) solo después de conocer la capa fallida.

Conserve los archivos de ejecución actuales antes de cambiar la configuración o reinstalar. Un artefacto obsoleto o faltante identifica una etapa fallida; los reinicios repetidos pueden borrar esa evidencia.

<a id="choose-the-failure-path"></a>
## Elija la ruta de falla

<a id="1-decide-whether-guard-loaded"></a>
### 1. Decida si Guard cargó

- **No existe `runtime/` archivos:** siga a [Restaurar los archivos de tiempo de ejecución que faltan](#restore-missing-runtime-files). Verifique la ruta de instalación, el cargador canónico, `enabled.txt` y `mods.txt` antes de investigar los informes.
- **Existen archivos de estado actuales:** Guard cargado lo suficiente como para escribir el estado. Continúe con el paso 2; reinstalar no es la primera respuesta.

<a id="2-decide-whether-the-scheduler-is-advancing"></a>
### 2. Decida si el programador está avanzando

Abrir:

```text
runtime/current/startup_status.json
runtime/current/poll_status.json
```

- **Los contadores y las marcas de tiempo avanzan:** continúe con el paso 3.
- **`poll_id` es estático, `poll_in_flight` permanece verdadero o el estado del programador no se está ejecutando:** siga a [Recupera un bucle de sondeo atascado](#recover-a-stuck-poll-loop).
- **El análisis de la línea de base está pendiente mientras el progreso del programador continúa:** esto es una precaución, no automáticamente un inicio fallido. Investigue solo si se detiene el trabajo pendiente o el progreso del análisis.

<a id="3-classify-route-proof"></a>
### 3. Clasifique la prueba de ruta

Abrir `runtime/final_logs/route_proof.json` e inspeccione cada ruta por separado.

- **`full`:** compare el texto inesperado con el actual `source_references` y el linaje actuales. No cambie la entrega porque la redacción por sí sola parece incorrecta.
- **`limited_expected_empty`:** confirme que la contabilidad de origen admite un resultado vacío legítimo. No cree un reproductor o caso sintético.
- **`missing`:** siga a [Diagnosticar una ruta faltante](#diagnose-a-missing-route).

<a id="4-classify-source-coverage"></a>
### 4. Clasifique la cobertura de fuente

- **`partial`, `deferred`, `unavailable`, `malformed`, `permission_denied`, o `error`:** siga a [Interprete la cobertura de fuente incompleta](#interpret-incomplete-source-coverage), luego busque el código exacto en [Referencia de estado y error](REFERENCIA_DE_ESTADO_Y_ERROR.md).
- **La fuente estructurada está actual pero la salida traducida o pendiente es anterior:** diagnostica la transferencia de finalización, no el punto final de entrega. Conserve ambas marcas de tiempo e inspeccione el informe y el estado de envío antes de cambiar la configuración de entrega.

<a id="5-follow-the-matching-branch"></a>
### 5. Siga la rama coincidente

- Identidad incompleta: [Asigne un jugador no asignado](#map-an-unmapped-player).
- Falta continuidad diaria: [Restaurar un resumen diario faltante](#restore-a-missing-daily-rollup).
- La prueba de cumplimiento aprobada explícitamente no escribió: [Diagnosticar una Admin.ini escritura](#diagnose-a-blocked-adminini-write).
- ZIP error de extracción: [Resolver un problema de Windows colisión de caso de extracción](#resolve-a-windows-extraction-folder-collision).
- Error en la comprobación del dispositivo, paquete o repositorio: [Revisión de validación y lanzamiento](VALIDACI%C3%93N_Y_PUBLICACI%C3%93N.md#avoid-validation-environment-pitfalls).

<a id="6-stop-with-one-proved-outcome"></a>
### 6. Deténgase con un resultado comprobado

Un paso para la solución de problemas finaliza cuando:

- la ruta es actual y `full`;
- la ruta es actual y `limited_expected_empty` por un motivo determinado;
- se registra un bloqueador exacto, la ruta de evidencia y la siguiente acción o
- la reversión restauró el estado conocido anterior y conservó la evidencia fallida.

“El servidor está funcionando”, un latido creciente o HTTP el éxito por sí solo no prueba que se completó la ruta del informe.

<a id="diagnose-a-missing-route"></a>
## Diagnosticar una ruta faltante

Abrir `runtime/final_logs/route_proof.json` y comparar `server_status`, `daily_rollup`, `player_activity`, `case_review` y `critical_guard`.

1. Leer el motivo, el linaje, el tiempo de generación y la duración de la ruta referencias de fuentes.
2. Confirme que la fuente estructurada nombrada existe y pertenece al mismo ciclo.
3. Compare su mtime con la salida traducida y el sobre pendiente.
4. Si los registros finales son más recientes que la salida traducida o pendiente, registre el envío de finalización obsoleto y repare esa transferencia primero.
5. Si toda la salida local está actualizada pero no hay entrega, entonces inspeccione la configuración de la ruta y el estado del remitente.

No promueva el estado del programador ni una notificación exitosa a la prueba de cinco rutas.

<a id="interpret-incomplete-source-coverage"></a>
## Interprete la cobertura de fuente incompleta

| Estado | Qué hacer |
|---|---|
| `partial` | Utilice solo evidencia recopilada y evite afirmaciones de cobertura completa. |
| `deferred` | Confirme el trabajo limitado posterior avanza antes de cambiar la configuración. |
| `unavailable` | Registre el límite del entorno; corrija solo un problema de ruta o permiso comprobado. |
| `malformed` | Conserve la fuente y el error de análisis; no adivine los valores faltantes. |
| `permission_denied` | Otorgue solo el permiso de lectura limitado requerido. |
| `error` | Conserve los detalles y diagnostique la etapa nombrada antes de confiar en la ruta. |

<a id="restore-missing-runtime-files"></a>
## Restaurar los archivos de tiempo de ejecución que faltan

Confirme:

```text
mods.txt contains RandomDayGuard : 1
RandomDayGuard/enabled.txt exists
RandomDayGuard/Scripts/main.lua exists
```

La raíz de instalación correcta es:

```text
AbioticFactor/Binaries/Win64/ue4ss/Mods/RandomDayGuard/
```

Rechace este diseño anidado:

```text
Mods/RandomDayGuard/RandomDayGuard/Scripts/main.lua
```

Si los archivos son correctos pero UE4SS no inició Guard, conserve `UE4SS.log` y compare su marca de tiempo de inicio con el inicio real del proceso del juego.

<a id="resolve-a-windows-extraction-folder-collision"></a>
## Resolver una colisión de carpetas de extracción de Windows

Una versión anterior usaba directorios de programas cuyos nombres diferían sólo por las mayúsculas. Algunos extractores de Windows combinan esos nombres cuando ZIP se coloca sobre una carpeta existente.

1. Elimine solo la extracción temporal fallida, no el mod instalado ni su evidencia.
2. Cree un nuevo directorio temporal vacío.
3. Extraiga la versión actual allí.
4. Confirme que produce una RandomDayGuard carpeta y un directorio de programas.
5. Si Windows aún informa una colisión, descargue la versión nuevamente e informe la versión y el extractor utilizado.

Nunca extraiga una nueva versión de la carpeta instalada. Siga el procedimiento de actualización de carpeta limpia en [`../INSTALL.md`](INSTALACI%C3%93N.md).

<a id="load-the-expected-version"></a>
## Cargue la versión esperada

Compruebe el marcador de origen y el marcador de compilación:

```sh
grep -n "local VERSION" RandomDayGuard/Scripts/main.lua
cat RandomDayGuard/BUILD_MARKER.txt
```

Si no están de acuerdo:

1. Detenga el servidor.
2. Haga una copia de seguridad de la carpeta instalada, la configuración revisada y la evidencia del tiempo de ejecución.
3. Preparación e inspección del paquete deseado.
4. Reemplace solo los archivos de datos y programas administrados por paquetes.
5. Confirme que el cargador canónico existe y que no se agregó ningún duplicado en minúsculas.
6. Comience una vez y vuelva a leer los marcadores actuales antes de juzgar la salida del tiempo de ejecución.

<a id="correct-a-missing-saved-root"></a>
## Corrija una raíz guardada que falta

Abrir `runtime/saved_path_probe.json`. Coloque la ruta absoluta verificada al Factor Abiótico completo `Saved/` en `SavedRoot.txt`; no apunte sólo a un directorio mundial. Una ruta fuera de la raíz limitada debe permanecer rechazada.

<a id="recover-a-stalled-historical-scan"></a>
## Recuperar un análisis histórico estancado

El monitoreo actual y el descubrimiento histórico son independientes. Un archivo grande puede necesitar muchos ciclos acotados, por lo que una observación sin cambios no es suficiente para declararlo estancado.

1. Abrir `runtime/current/report_worker_status.json`.
2. Registre `scan_cursor`, los archivos descubiertos, los archivos completados y `last_progress_ts`.
3. Espere al menos dos oportunidades normales de trabajo de informes y compare los mismos campos nuevamente.
4. Si el cursor, el conteo completado o el tiempo de progreso avanzan, el escaneo aún está funcionando. Déjelo delimitado.
5. Si todos los campos de progreso permanecen sin cambios mientras los ID de la encuesta y los informes actuales continúan avanzando, conserve el archivo de estado y verifique la clase de origen nombrada por la fase de trabajo. Repare esa ruta de origen o lea el error antes de volver a intentarlo.

Un análisis histórico detenido limita las conclusiones que necesitan registros más antiguos. No invalida un informe actual cuyo registro activo y prueba del ciclo actual estén actualizados.

<a id="recover-a-stuck-poll-loop"></a>
## Recupera un bucle de sondeo atascado

Abrir:

```text
runtime/current/poll_status.json
runtime/poll_error.txt
```

Registre `poll_id`, `poll_completed_count`, `poll_in_flight`, `poll_stage`, `scheduler_status` y marcas de tiempo dos veces en un intervalo acotado.

- Si los contadores avanzan, el bucle no está atascado; diagnosticar la etapa posterior del trabajador.
- Si `poll_in_flight=true` permanece sin cambios, conserva la última etapa de progreso y el error antes de reiniciar.
- Si el programador se detuvo, inspecciona el error anterior y la transferencia de inicio.

No agregue un segundo propietario de bucle para compensar un ciclo de vida estancado.

<a id="start-the-scan-after-log-backlog"></a>
## Inicie el escaneo después del registro acumulado

En `runtime/current/poll_status.json`, compare:

```text
active_log_caught_up
active_log_unread_bytes
log_backlog_pending
```

El escaneo histórico debe esperar mientras el registro activo tenga bytes sin leer. Confirmar que las encuestas posteriores reducen el trabajo atrasado. Un conteo fijo no leído con encuestas en avance es un problema de cola de fuente; una encuesta fija es un problema del programador.

<a id="preserve-scan-progress-after-a-crash"></a>
## Conservar el progreso del análisis después de una falla

Conservar y comparar:

```text
runtime/scan_checkpoint.json
runtime/scan_progress.json
runtime/baselines/file_manifest.tsv
```

Compruebe si falta el punto de control o el manifiesto, si la raíz o el mundo guardados cambiaron o si el punto de control se marcó como obsoleto. No elimine una línea de base válida para que el progreso parezca más nuevo.

<a id="map-an-unmapped-player"></a>
## Asigne un jugador no asignado

Compare la evidencia de la sesión con el registro autorizado:

```text
runtime/evidence/session_events.jsonl
Saved/Logs/AbioticFactor.log
```

Busque una relación completa `Login request` entre el nombre para mostrar, `ConnectID` y `UniqueId`. Si no existe una identidad de conexión aceptada, mantenga la fila como de solo revisión. Un nombre para mostrar o PlayerData nombre de archivo por sí solo no es una identidad exigible.

<a id="diagnose-a-blocked-adminini-write"></a>
## Diagnosticar una Admin.ini escritura

Ejecutar una prueba de cumplimiento solo con aprobación explícita y un archivo de prueba desechable, nunca con un archivo de servidor activo. Primero confirme que la configuración de prueba le pide a Guard que escriba:

```lua
review_only_mode = false
auto_ban = true
write_admin_ini = true
```

Luego lea el motivo del error registrado. Guard debe identificar una cuenta, proteger a los moderadores y las cuentas confiables, encontrar suficiente evidencia específica de la cuenta, crear y verificar una nueva copia de seguridad, confirmar que ningún otro programa cambió el archivo, guardar la actualización prevista y comparar el archivo guardado completo con el resultado previsto. Si algún paso falla o no se puede verificar, deje la lista de prohibiciones sin cambios. Consulte [Admin.ini cumplimiento](CUMPLIMIENTO_DE_ADMIN_INI.md).

<a id="restore-a-missing-daily-rollup"></a>
## Restaurar un resumen diario faltante

Confirme que `forensic_rollup.enabled = true` y luego inspeccione:

```text
runtime/current/forensic_today.json
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

Si faltan, verifique el estado de inicio, sondeo, informe del trabajador y contabilidad de origen en ese orden. El resumen diario es un registro de continuidad por día, no una notificación repetida del estado del servidor.

<a id="look-up-an-exact-status-or-error"></a>
## Busque un estado o error exacto

Utilice [Referencia de estado y error](REFERENCIA_DE_ESTADO_Y_ERROR.md) para conocer la ruta completa y el origen, PlayerData, cumplimiento, inicio, programador, informe y notificación. Mantener las tablas de búsqueda separadas evita que esta página de reparación se convierta en un segundo manual de esquema.

<a id="related-docs"></a>
## Documentos relacionados

- [comience aquí](COMIENCE_AQU%C3%8D.md)
- [Manual de operaciones](MANUAL_DE_OPERACIONES.md)
- [Referencia de estado y error](REFERENCIA_DE_ESTADO_Y_ERROR.md)
- [Revisión de validación y lanzamiento](VALIDACI%C3%93N_Y_PUBLICACI%C3%93N.md)
