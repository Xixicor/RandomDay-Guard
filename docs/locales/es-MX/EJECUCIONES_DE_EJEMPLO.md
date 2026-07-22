<a id="worked-operation-examples"></a>
# Ejemplos de operaciones trabajadas

> **Fuente canónica en inglés:** [EXAMPLE_RUNS.md](../../EXAMPLE_RUNS.md). Esta documentación localizada conserva comandos, rutas, claves, valores de estado, hashes y nombres de archivos exactos. Si la redacción técnica difiere, utilice la fuente en inglés.


Estos ejemplos utilizan valores inventados para explicar las transiciones de estado esperadas; no son compatibilidad en vivo ni evidencia de jugador.

<a id="successful-current-cycle"></a>
## Ciclo actual exitoso

Entradas: registro activo legible, version/boot/epoch, `poll_id=41`, encuesta actual completada, accounting/history/report raíces grabables, sin política de bloqueo de escaneo lento.

Esperado:

```text
server_status = full
player_activity = full or limited_expected_empty
case_review = full or limited_expected_empty
daily_rollup = full or limited_expected_empty
critical_guard = full or limited_expected_empty
```

Cada ruta habilitada tiene JSON/TXT salida y el mismo linaje en `route_proof.json`. El estado de la ruta depende de sus propios sujetos, no de un mensaje de éxito genérico.

<a id="expected-empty-player-and-case-routes"></a>
## Rutas de casos y reproductores vacíos esperados

Entradas: la prueba del ciclo actual está completa; sin filas de jugadores actuales o retenidos; no hay ningún caso retenido ni ninguna REVIEW/BAN-ELIGIBLE cuenta actual.

Esperado:

```text
player_activity.route_proof_status = limited_expected_empty
player_activity.expected_empty = true
player_activity.players = []

case_review.route_proof_status = limited_expected_empty
case_review.expected_empty = true
case_review.cases = []
```

Los informes traducidos dicen que no se observó ningún sujeto delimitado elegible. También dicen que esto no prueba que nadie haya conectado nunca o que no falte ningún contexto. No se crea ningún marcador de posición player/case.

<a id="partial-bounded-scan"></a>
## Escaneo limitado parcial

Entradas: actual nueva log/poll; `scan_checkpoint.json` o `scan_progress.json` existe; el escaneo está incompleto; default `slow_world_scan_blocks_current_reports=false`.

Esperado:

```text
world_save_scan.status = partial
source accounting = partial
server_status may still be full for fresh current state
historical routes name the scan limitation
```

Establezca `slow_world_scan_blocks_current_reports=true` solo cuando el operador quiera que esa fuente lenta opcional bloquee los informes actuales. La recuperación es para permitir que el trabajador de escaneo reanude, no para eliminar el punto de control.

<a id="missing-current-cycle-proof"></a>
## Falta la prueba del ciclo actual

Entradas: registro activo no disponible, `poll_id=0`, o boot/epoch/last-poll falta el linaje.

Esperado:

```text
current_cycle_proof_complete = false
all route proof statuses = missing
each configured route envelope status = suppressed_current_cycle
delivery_eligible = false
delivery_attempted = false
```

El sobre suprimido es un registro de auditoría, no una entrega en cola. Los registros finales antiguos siguen siendo únicamente históricos. Repare el primer campo lineage/source que falta y genere un ciclo más nuevo.

<a id="malformed-optional-adminini-source"></a>
## Fuente Admin.ini opcional con formato incorrecto

Entradas: `Admin.ini` existe pero falla la validación estructural limpia.

Esperado:

```text
admin_ini.status = malformed
source reference preserved
write/enforcement path closed
```

Conserve el archivo y restaurar un formato limpio revisado. Mantenga el texto explicativo en la evidencia en tiempo de ejecución; cada `Admin.ini` entrada de prohibición permanece solo `BannedPlayer=<ID>`.

<a id="required-active-log-probe-error"></a>
## Error de sonda de registro activo requerido

Entradas: la sonda de registro activo requerida y limitada falla con un error de lectura desinfectada.

Esperado:

```text
source_accounting.sources[active_log].status = error
source_accounting.sources[active_log].detail = "bounded active-log probe failed: <sanitized reason>"
coverage_status = unavailable
all route proof statuses = missing
```

`error` permanece en la fila de origen con su detalle limitado. El informe de nivel superior utiliza `unavailable`, y la prueba de ruta permanece `missing` hasta que un ciclo actual más reciente demuestre la fuente requerida.

<a id="incompatible-or-stale-baseline"></a>
## Línea base incompatible o obsoleta

Entradas: identidad package/source o stale/incompatible modificada. manifest.

Esperado: el estado de validación o tiempo de ejecución registra la incompatibilidad; El estado de escaneo no afirma que se haya completado la reutilización. Preservar la evidencia anterior, iniciar una reconstrucción de referencia explícita y esperar nuevas pruebas terminales. Una reconstrucción forzada sin un motivo registrado no es la recuperación predeterminada.

<a id="paired-report-write-failure"></a>
## Error de escritura de informe emparejado

Entradas: JSON la escritura tiene éxito pero TXT la escritura falla, o al revés.

Esperado:

```text
route_proof_status = missing
completed = false
coverage_status = unavailable
output_write_detail = "paired JSON/TXT write failed: <sanitized reason>"
next_action = repair both route output writes
```

El escritor, con su mejor esfuerzo, reescribe a ambos hermanos para converger en el error. Un hermano exitoso no puede seguir siendo un reclamo de éxito. El detalle de escritura limitada no crea un quinto valor de cobertura de nivel superior.

<a id="route-proof-write-failure"></a>
## Error de escritura a prueba de ruta

Entradas: se escribieron pares de rutas pero `route_proof.json` no se pueden reemplazar.

Esperado: todos los informes se reescriben `missing`, todos los resultados de las notificaciones son `route_proof_write_failed` y no se acepta ningún sobre. Una ruta configurada puede tener un `suppressed_current_cycle` sobre de auditoría con indicadores de entrega falsos. Repare la raíz de salida y regenere el mismo ciclo actual.

<a id="review-only-enforcement-example"></a>
## Ejemplo de aplicación de solo revisión

Configuración:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

Esperado: se pueden escribir puntuaciones, casos y recomendaciones; `Admin.ini` permanece sin cambios. Este es el valor predeterminado público.

<a id="approved-write-success-example"></a>
## Ejemplo de escritura exitosa

Solo una prueba aprobada por separado puede configurar los tres interruptores de escritura. También debe demostrar identidad numérica limpia, trust/moderator exclusión, umbral de elegibilidad, validez Admin.ini path/parse, éxito de la copia de seguridad, éxito de la escritura, igualdad de lectura y evidencia específica de la cuenta.

Esperado:

```text
runtime/backups/Admin_<timestamp>_<source-fingerprint>_<clean-ID>.ini
Admin.ini contains one clean BannedPlayer=<ID>
runtime/enforced_bans.jsonl and evidence mirror record success
```

El ejemplo exitoso no permite la aplicación automática para otras cuentas.

<a id="writereadback-failure-with-rollback"></a>
## Write/readback falla con la reversión

Entradas: cada se pasó la puerta de preescritura; la escritura o lectura de reemplazo falla; `rollback_on_readback_failure=true` y la copia de seguridad verificada está disponible.

Esperado: la evidencia de falla registra la etapa y `rollback_success`; los Admin.ini bytes originales se restauran y no se informa que la cuenta se haya aplicado correctamente. Si la reversión también falla, detenga las escrituras, conserve files/evidence y recupérelo manualmente desde la copia de seguridad.

<a id="local-outbox-example"></a>
## Ejemplo de bandeja de salida local

Entradas: notificación habilitada en `local_file_outbox` modo, ruta habilitada, prueba de ruta completa y `full` o explícitamente permitida. esperado-vacío.

Sobre esperado:

```text
schema = randomdayguard.notification/v1
completed_output = true
status = ready_for_local_consumer
delivery_eligible = true
delivery_backend = none
delivery_attempted = false
```

Para missing/ineligible salida, la misma ruta puede contener `status=suppressed_current_cycle`, `completed_output=false` y `delivery_eligible=false`. Cualquiera de los archivos demuestra una escritura local únicamente. No se incluye ni infiere ningún proveedor, transporte, entrega o recibo de lectura.

Ver [`OUTPUT_SCHEMA_REFERENCE.md`](REFERENCIA_DEL_ESQUEMA_DE_SALIDA.md), [`CONFIG_FIELD_CATALOG.md`](CAT%C3%81LOGO_DE_CAMPOS_DE_CONFIGURACI%C3%93N.md) y [`TROUBLESHOOTING.md`](SOLUCI%C3%93N_DE_PROBLEMAS.md).
