<a id="architecture-and-lifecycle"></a>
# Arquitectura y ciclo de vida

> **Fuente canónica en inglés:** [ARCHITECTURE.md](../../ARCHITECTURE.md). Esta documentación localizada conserva comandos, rutas, claves, valores de estado, hashes y nombres de archivos exactos. Si la redacción técnica difiere, utilice la fuente en inglés.


RandomDayGuard es un UE4SS guardián más un módulo de informes aislado. Lee archivos propiedad del servidor, mantiene el estado local delimitado y escribe evidencia local y revisa los resultados. panel de control, servicio de notificación, RandomDay o dependencia de red.

<a id="end-to-end-data-flow"></a>
## Flujo de datos de un extremo a otro

1. UE4SS carga el único punto de entrada canónico `RandomDayGuard/Scripts/main.lua`. Los paquetes actuales no incluyen un duplicado de variante en minúscula.
2. El cargador lee `config.lua`, los tres diccionarios de datos y el `SavedRoot.txt` opcional. La identidad de la versión debe coincidir con `VERSION`, `MANIFEST.json` y `BUILD_MARKER.txt`.
3. el descubrimiento de raíz guardada comprueba los candidatos conocidos delimitados y los archivos conocidos directos. Registra lo que era legible en `runtime/saved_path_probe.json`; encontrar un directorio por sí solo no es una cobertura de evidencia.
4. La capa inmediata sigue el registro del servidor activo desde un desplazamiento seguro. Normaliza el ciclo de vida, la sesión, la cuenta, la advertencia, la reconexión y otros eventos observados en evidencia de solo anexar más instantáneas actuales.
5. La capa lenta inventaria los archivos guardados en fragmentos delimitados. Escribe el progreso y los puntos de control, reanuda el trabajo incompleto, compara un manifiesto de archivo modificado y produce un object/world contexto parcial y luego final.
6. La lógica de revisión correlaciona solo la evidencia disponible. Los nombres de archivos débiles, los tiempos, los recuentos de clases, las coordenadas relativas, la deserción, un solo bloqueo o el ping permanecen en el contexto y no pueden autorizar la aplicación de la ley por sí solos.
7. Un trabajador de informe separado llama `Scripts/public_pipeline.lua`. Inventaria las clases fuente, registra el alcance actual versus el histórico, vincula el ciclo a version/boot/epoch/poll/source frescura, escribe cinco rutas específicas JSON/TXT pares y luego escribe `route_proof.json`.
8. Cuando se habilita explícitamente, la bandeja de salida local copia las referencias de un informe completo una vez que existe la prueba de ruta. Graba `delivery_backend="none"` y `delivery_attempted=false`; el transporte queda fuera de este producto.

<a id="ownership-and-asynchronous-boundaries"></a>
## Propiedad y límites asincrónicos

| Propietario | Trabajo acotado | No debe bloquear ni insinuar |
|---|---|---|
| Inicio | Configuración, raíz guardada, registro activo, época, índices, estado inicial. | Un marcador de carga exitoso no demuestra evidencia ni rutas. |
| Devolución de llamada de encuesta | Nuevos bytes de registro, actualizaciones de estado, event/session/account salidas, programación. | Descubrimiento recursivo lento o agotamiento de informes. |
| Trabajador de escaneo | Descubrimiento de manifiestos, análisis de archivos, punto de control, partial/final línea base. | Progreso del registro actual; parcial no es fracaso. |
| Reportar trabajador | Contabilidad de origen, traducción, pares de informes, prueba de ruta, bandeja de salida local. | Cumplimiento o entrega externa. |
| Aplicación opcional | Confirme la cuenta y la puntuación, proteja las cuentas confiables y los duplicados, verifique una copia de seguridad, rechace los cambios externos en los archivos y luego verifique el resultado guardado. | Una puntuación de informe, el estado de la ruta o la membresía del caso sin pasar por cualquier verificación de seguridad requerida. |

El bucle de sondeo se mantiene saludable solo mientras `poll_id` avanza, `poll_in_flight` devuelve falso y la programación permanece activa. Eso prueba el componente de la encuesta, no el proyecto de informe. Los escaneos lentos pueden ser `partial` o `deferred`; el valor predeterminado `slow_world_scan_blocks_current_reports=false` permite que las rutas actuales nuevas continúen mientras se nombra la limitación histórica.

<a id="state-and-lifecycle"></a>
## Estado y ciclo de vida

| Estado | Entrada | Terminal o siguiente estado | Error y recuperación |
|---|---|---|---|
| Inicio | UE4SS invoca el cargador. | Trabajadores en ejecución poll/scan/report con un ID de arranque y una época. | `startup_error` es evidencia crítica del arranque actual; reparar config/path/source y reiniciar. |
| Encuesta actual | Comienza la devolución de llamada limitada programada. | La encuesta completa registra la marca de tiempo y las reprogramaciones. | `poll_error` es evidencia crítica de arranque actual; restaurar el trabajo limitado y confirmar una encuesta más reciente. |
| Escaneo pendiente | Línea de base requerida o punto de control incompleto encontrado. | `partial`/`deferred`, luego `scan_complete`. | Reanudar punto de control; reconstruir solo cuando stale/incompatible se registre evidencia. |
| Contabilidad de origen | Informar los inventarios de los trabajadores ocho clases de origen. | `complete`, `complete_with_gaps`, `partial`, o `unavailable`. | Disabled/failed la contabilidad fuerza todas las rutas a `missing`. |
| Generación de rutas | El linaje del ciclo actual y la contabilidad de origen están disponibles. | `full`, `limited_expected_empty`, o `missing`. | El error de escritura emparejado JSON/TXT o a prueba de ruta converge la ruta hacia la `missing`. |
| bandeja de salida local | Una ruta está habilitada, completada y es elegible. | Pendiente sobre local y resultado del estado de la notificación. | Sin escritura o prueba incompleta significa que no hay sobre; no se infiere ninguna entrega. |
| Revisión de cumplimiento | La evidencia específica de la cuenta alcanza la puntuación configurada para la acción automática. | Recomendación de solo revisión o una actualización `Admin.ini` habilitada explícitamente. | Una verificación de seguridad fallida o no disponible detiene la actualización; una comparación final fallida restaura la copia de seguridad verificada cuando la recuperación está habilitada. |

<a id="current-and-historical-evidence"></a>
## Evidencia actual e histórica

La evidencia actual pertenece al boot/poll activo y nunca se reconstruye únicamente a partir de los nombres de archivos retenidos. La evidencia histórica incluye troncos rotados, duraderos.account/session historial, retenido cases/reports/evidence y escaneo limitado para guardar el mundo. Los informes exponen matrices y recuentos actuales e históricos separados. Un reinicio silencioso no debe borrar el contexto duradero y un registro histórico no debe presentarse como presencia actual.

<a id="completion-and-recovery-boundary"></a>
## Límite de finalización y recuperación

La finalización de una ruta requiere que coincidan la versión del ciclo actual, el ID de inicio, el ID de época, el ID de sondeo positivo, el nuevo estado del registro activo, ambas salidas de ruta y su entrada en `route_proof.json`. Las reclamaciones de notificación requieren además el sobre local del mismo ciclo; la entrega externa nunca forma parte de la prueba pública.

Si faltan informes finales o son más antiguos que el estado actual poll/source estado, continúa desde el primer linaje no coincidente o escritura fallida. No cambie rutas, textos o configuraciones de cumplimiento no relacionados. Consulte las [`OUTPUT_SCHEMA_REFERENCE.md`](REFERENCIA_DEL_ESQUEMA_DE_SALIDA.md), [`TROUBLESHOOTING.md`](SOLUCI%C3%93N_DE_PROBLEMAS.md) y [`SOURCE_MODULE_REFERENCE.md`](REFERENCIA_DEL_M%C3%93DULO_FUENTE.md).
