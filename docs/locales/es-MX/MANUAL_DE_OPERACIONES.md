<a id="operations-playbook"></a>
# Manual de operaciones

> **Fuente canónica en inglés:** [OPERATIONS_PLAYBOOK.md](../../OPERATIONS_PLAYBOOK.md). Esta documentación localizada conserva comandos, rutas, claves, valores de estado, hashes y nombres de archivos exactos. Si la redacción técnica difiere, utilice la fuente en inglés.


Este es el orden de lectura normal para RandomDayGuard. No necesita saber JSON, Git, sumas de verificación o herramientas de línea de comandos para revisar un servidor en buen estado.

<a id="daily-operator-flow"></a>
## Flujo diario de operadores

1. Abrir `runtime/final_logs/server_status_latest.txt`. Le indica si Guard está monitoreando la ejecución actual del servidor, cuándo se completó el último ciclo, cuántos jugadores están conectados y si una fuente o escaneo está incompleto.
2. Abrir `runtime/final_logs/daily_rollup_latest.txt` una vez al día. Resume sesiones del mismo día, salidas, casos de trabajo con nombre, inventario de identidad y cobertura de fuentes sin repetir cada registro individual.
3. Abrir `runtime/final_logs/player_activity_latest.txt` solo cuando el servidor tuvo una sesión activa, de entrada o de salida durante el día.
4. Abrir `runtime/final_logs/case_review_latest.txt` solo cuando nombra un tema actual. El informe proporciona la cuenta, el estado de revisión, la puntuación, la fuente de identidad y los registros que se abrirán a continuación.
5. Abrir `runtime/final_logs/critical_guard_latest.txt` solo cuando Guard informa una falla en su propio inicio, ciclo de monitoreo o redacción de informes.

Si una ruta no tiene nada que informar, Guard registra un resultado esperado vacío. Se trata de una comprobación completa, no de un informe faltante.

<a id="what-to-read-inside-a-report"></a>
## Qué leer dentro de un informe

Lea estas secciones en orden:

1. **Resumen**: lo que cubre este informe.
2. **Lo que observó Guard**: marcas de tiempo, recuentos, cuentas, sesiones o valores de estado reales recopilados para esta ruta.
3. **Qué significa** - la interpretación en lenguaje sencillo de esos registros.
4. **Lo que permanece desconocido** - una fuente o límite de escaneo que afecta el resultado.
5. **Siguiente paso recomendado** - si monitorear, revisar un sujeto nombrado o reparar Guard.
6. **Límite de evidencia** - el límite del informe alcance.

El registro técnico y las referencias de fuentes aparecen al final para los lectores que necesitan inspeccionar la evidencia estructurada exacta.

<a id="when-a-report-is-missing"></a>
## Cuando falta un informe

Abrir `runtime/final_logs/route_proof.json` solo cuando falta un informe legible o dice que falta su prueba actual. Cada ruta tiene uno de estos resultados:

| Resultado | Significado |
|---|---|
| `full` | El guardia completó la ruta con evidencia actual de propiedad de la ruta. |
| `limited_expected_empty` | El guardia completó la ruta y no encontró ningún evento calificador, ni registró un límite de madurez designado. |
| `missing` | No se completó una fuente requerida, una verificación de linaje o una escritura de informe emparejado. |

Para una ruta faltante, siga la fuente nombrada o escriba el error en el informe. No cambie primero rutas no relacionadas ni configuraciones de notificación.

<a id="after-a-crash-or-restart"></a>
## Después de una falla o reinicio

1. Lea el estado del servidor para conocer la nueva marca de tiempo de ejecución del servidor y el último ciclo de monitoreo completado.
2. Lea Critical Guard para un inicio actual o una falla en la encuesta.
3. Lea la actividad del jugador solo si una sesión del mismo día se unió, abandonó o regresó después del ciclo de vida. cambiar.
4. Conserve el registro fuente citado antes de cambiar la configuración.

<a id="before-enabling-optional-adminini-writes"></a>
## Antes de habilitar las escrituras Admin.ini opcionales

El paquete predeterminado observa e informa sin cambiar `Admin.ini`. Los operadores avanzados pueden habilitar la ruta de aplicación opcional después de probarla con una copia del archivo. Luego, Guard requiere una ID de cuenta numérica limpia, protege las cuentas confiables, crea y verifica una copia de seguridad, rechaza los cambios simultáneos, lee el archivo guardado y restaura la copia de seguridad si falla la verificación. Consulte [`ADMIN_INI_ENFORCEMENT.md`](CUMPLIMIENTO_DE_ADMIN_INI.md) para conocer el procedimiento completo de configuración y prueba.

<a id="related-guides"></a>
## Guías relacionadas

- [`START_HERE.md`](COMIENCE_AQU%C3%8D.md)
- [`REPORT_EXAMPLES.md`](EJEMPLOS_DE_INFORMES.md)
- [`PLAYER_REVIEW_WORKFLOW.md`](FLUJO_DE_TRABAJO_DE_REVISI%C3%93N_DEL_REPRODUCTOR.md)
- [`TROUBLESHOOTING.md`](SOLUCI%C3%93N_DE_PROBLEMAS.md)
- [`OUTPUT_SCHEMA_REFERENCE.md`](REFERENCIA_DEL_ESQUEMA_DE_SALIDA.md)
