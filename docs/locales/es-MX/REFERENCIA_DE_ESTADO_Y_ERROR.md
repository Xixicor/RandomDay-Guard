<a id="status-and-error-reference"></a>
# Referencia de estado y error

> **Fuente canónica en inglés:** [STATUS_AND_ERROR_REFERENCE.md](../../STATUS_AND_ERROR_REFERENCE.md). Esta documentación localizada conserva comandos, rutas, claves, valores de estado, hashes y nombres de archivos exactos. Si la redacción técnica difiere, utilice la fuente en inglés.


Utilice esta referencia después de que un síntoma se haya clasificado en [Solución de problemas](SOLUCI%C3%93N_DE_PROBLEMAS.md). Lea el archivo de estado estructurado nombrado por el error. Los códigos distintos representan distintos estados de seguridad y ciclo de vida; no los colapse en un resultado genérico "Error de protección".

<a id="route-and-source-states"></a>
## Estados de ruta y origen

| Valor | Significado | Respuesta del operador |
|---|---|---|
| `full` | El contrato de ruta completado con prueba de fuente del ciclo actual. | Lea el límite de evidencia de la ruta; no implica reparación. |
| `limited_expected_empty` | La ruta completada y la actividad faltante son legítimas para este ciclo. | No se debe crear ningún evento sintético player/case. |
| `missing` | Falta una salida requerida, un campo de linaje o una prueba de fuente. | Inspeccione el motivo de la ruta y el estado de la fuente nombrada. |
| `available` | La fuente nombrada era legible y utilizable. | No acción. |
| `expected_empty` | La fuente fue verificada y legítimamente no tenía filas. | No se realiza ninguna acción a menos que se esperara actividad de forma independiente. |
| `partial` / `complete_with_gaps` | Existe evidencia utilizable, pero las clases de fuentes nombradas están incompletas. | Limitar las conclusiones a la evidencia recopilada. |
| `deferred` | El trabajo limitado está programado para un trabajador posterior oportunidad. | Confirmar los avances del progreso antes de cambiar la configuración. |
| `unavailable` | El entorno no proporcionó la fuente. | Registrar el límite; corrija solo una ruta comprobada o un problema de permisos. |
| `malformed` | La fuente era legible pero falló la validación estructural. | Consérvela y corrija la fuente; no lo adivine. |
| `permission_denied` | La fuente existe pero no se pudo leer. | Otorgue solo el permiso de lectura limitado requerido. |
| `error` | La recopilación falló por el motivo registrado. | Conserve el error y diagnostique esa etapa. |

<a id="playerdata-and-inventory-codes"></a>
## PlayerData y códigos de inventario

| Código | Significado | Respuesta segura |
|---|---|---|
| `saved_root_unavailable` | No había ninguna raíz guardada verificada disponible para la canalización pública. | Corrija `SavedRoot.txt` y vuelva a verificar la sonda de ruta. |
| `unsafe_playerdata_root` | PlayerData descubrimiento resuelto fuera de la raíz guardada delimitada. | Corrija la ruta; nunca debilite el límite. |
| `playerdata_discovery_not_run` | El trabajador de descubrimiento limitado aún no se ha ejecutado. | Verifique el progreso del programador y del trabajador. |
| `playerdata_discovery_read_failed:*` | No se pudo leer la salida del descubrimiento. | Conserve el detalle del sufijo y verifique el comando de inventario limitado. |
| `inventory_command_open_failed` | El proceso de inventario no pudo ser iniciado. | Verifique que el tiempo de ejecución proporcione el puente de comando configurado. |
| `inventory_command_read_failed` | La salida del inventario falló durante la lectura. | Conserve la salida parcial y vuelva a ejecutarla solo después de que se solucione el error subyacente. |
| `inventory_command_close_failed` | Inventario completado sin un resultado de cierre confiable. | Trate la fuente como incompleto. |
| `identity_ledger_row_limit_exceeded` | La entrada de identidad duradera excedió su límite de seguridad pública. | Archivar y revisar el libro mayor; no lo trunques silenciosamente para convertirlo en prueba completa. |

<a id="adminini-enforcement-codes"></a>
## Admin.ini códigos de cumplimiento

Todos los códigos de esta sección están cerrados contra fallas. No autorizan una prohibición manual por sí mismos.

| Código | Significado | Respuesta segura |
|---|---|---|
| `admin_ini_write_disabled` / `admin_ini_disabled` | Las puertas de escritura seguras para el público están desactivadas. | Se espera en operación de solo revisión. |
| `admin_ini_backup_disabled` / `backup_safety_gate_disabled` | La política de copia de seguridad requerida no está activa. | Mantener las escrituras deshabilitadas. |
| `enforcement_disabled` / `ban_on_threshold_disabled` / `auto_ban_disabled` | Una puerta de cumplimiento explícita está desactivado. | Se espera en los valores predeterminados de solo revisión pública; no lo reinterpretes como un error de escritura. |
| `review_only_mode_enabled` | El modo de solo revisión bloquea intencionalmente la mutación. | Solo revisa la evidencia. |
| `duplicate_prevention_disabled` | Se deshabilitó la protección duplicada. | Mantener las escrituras deshabilitadas hasta que se restablezca la puerta de seguridad. |
| `readback_safety_gate_disabled` / `rollback_safety_gate_disabled` | La verificación posterior a la escritura o la protección de reversión se deshabilitaron. | Mantener las escrituras deshabilitadas; nunca pase por alto estas puertas. |
| `clean_id_safety_gate_disabled` / `account_specific_evidence_gate_disabled` | Se deshabilitó la aplicación de identidad limpia o evidencia específica de la cuenta. | Restaurar la puerta antes de cualquier prueba de aplicación. |
| `moderator_preservation_disabled` / `existing_ban_preservation_disabled` | Se deshabilitó la preservación de cuenta protegida o prohibición existente. | Mantener las escrituras deshabilitadas. |
| `clean_numeric_identity_required` | La ID propuesta no es el formulario de conexión aceptado completo ni la ID numérica limpia. | Obtener un mapeo verificado; nunca trunque un prefijo arbitrario. |
| `identity_strength_below_minimum` | La evidencia de identidad es más débil que el umbral configurado. | Solo revisa la evidencia. |
| `playerdata_verification_required` | La configuración requiere PlayerData confirmación y la cuenta no la tiene. | Mantenga el candidato solo para revisión; no infiera la propiedad de un nombre de archivo. |
| `trusted_or_moderator_identity` | La cuenta está protegida por un estado de confianza o moderador. | No se permite escritura. |
| `admin_ini_path_invalid` / `admin_ini_path_outside_saved_root` | La ruta de destino no es válida o se escapa de la raíz guardada. | Configuración correcta; nunca omita la protección de ruta. |
| `admin_ini_unavailable` | No se encontró ninguna configuración legible Admin.ini dentro de la raíz guardada. | Corrija la ruta delimitada o mantenga la aplicación deshabilitada. |
| `admin_ini_read_failed` | No se pudieron leer los bytes autorizados. | Deténgase antes de la mutación. |
| `admin_ini_parse_failed` | Admin.ini la validación falló sin un código estructural más específico. | Conserve el archivo e inspeccione su sección y estructura de líneas. |
| `admin_ini_contains_nul` | El archivo contiene NUL bytes y no se acepta como texto. | Conserve el archivo y repárelo fuera de Guard. |
| `admin_ini_duplicate_banned_players_section` | Existe más de una `[BannedPlayers]` sección. | Fusionar secciones manualmente mientras está detenido. |
| `admin_ini_banned_player_outside_section` | Aparece una fila de prohibición afuera `[BannedPlayers]`. | Corrija el diseño manualmente. |
| `admin_ini_invalid_banned_player_line` | Una línea de prohibición no es exactamente una fila de ID limpia y compatible. | Corrija la línea con formato incorrecto. |
| `admin_ini_backup_failed` | La copia de seguridad única no escribió ni leyó bytes idénticos. | No se permite ninguna mutación. |
| `admin_ini_external_change_detected` | Otro escritor cambió el archivo después de la instantánea de Guard. | Conserve los bytes externos y vuelva a intentarlo solo después de coordinar a los escritores. |
| `atomic_rename_unavailable` | Se solicitó el reemplazo atómico pero Lua no proporcionó `os.rename`. | No se confía en ninguna escritura; use un tiempo de ejecución compatible o mantenga la aplicación deshabilitada. |
| `admin_ini_write_failed` | El reemplazo controlado no se completó. | Inspeccione el error de reemplazo registrado y la copia de seguridad. |
| `post_write_verification_failed` | Los bytes de producción no igualaron al candidato. | Verifique `rollback_success` y `rollback_refused_external_change` antes de cualquier acción. |

<a id="startup-scheduler-and-backlog-states"></a>
## Estados de inicio, programación y trabajo pendiente

Estos valores son evidencia del ciclo de vida, no prueba de ruta. Léalos con los archivos actuales de encuesta, informe de trabajo y prueba de ruta.

| Valor | Significado | Respuesta segura |
|---|---|---|
| `not_started` | La etapa de inicio o programador nombrada no ha comenzado. | Durante el lanzamiento, espere el intervalo documentado; luego inspeccione la primera fase sin cambios. |
| `main_lua_loaded` / `starting` | El cargador canónico se ejecutó y Guard entró en inicio. | Continúe con las fases posteriores; esto por sí solo no es preparación. |
| `saved_root_found` / `log_tail_initialized` / `epoch_started` | Inicialización de fuente central y continuidad avanzada. | No se realiza ninguna acción a menos que la siguiente fase deje de avanzar. |
| `admin_state_written` / `playerdata_index_written` | Se exportaron los índices delimitados iniciales. | Sin acción; aún debe realizarse la transferencia del programador. |
| `watchdog_started` | Se registró el informe y el organismo de vigilancia de la encuesta. | A continuación, confirme el progreso del programador y la encuesta. |
| `ready_degraded` / `scan_running` | La guardia se está ejecutando mientras el análisis histórico limitado permanece pendiente. | Precaución, no falla; verificar el avance de los contadores de progreso. |
| `ready` | El inicio y el escaneo limitado actual alcanzaron el estado listo. | Verifique la prueba de ruta por separado. |
| `scan_failed` / `error` | El inicio o el escaneo terminaron con un error registrado. | Conserve el error nombrado o el archivo de estado y diagnostique esa etapa. |
| `running` | El programador posee oportunidades de encuestas futuras. | Confirme que `poll_id` y `poll_completed_count` avance. |
| `manual_only` | La programación en bucle no estaba disponible; solo se puede ejecutar el trabajo explícito. | Trate la operación desatendida como no disponible. |
| `stopped` | La operación del programador finalizó. | Inspeccione la parada anterior y la evidencia de error antes de reiniciar. |
| `active_log_caught_up` | No queda ningún registro activo sin leer. | Es posible que se realice un análisis histórico continuar. |
| `active_log_unavailable_nonblocking` | El registro activo estaba ausente, pero el inicio permaneció sin bloqueo. | Registre el límite de fuentes y verifique otras fuentes. |
| `active_log_read_failed` | El registro activo existía pero no se pudo leer. | Conserve el error y corrija solo la ruta comprobada o el problema de permisos. |
| `budget_exhausted` / `active_log_has_unread_bytes` | El pase de cola limitado se detuvo con el trabajo pendiente restante. | Confirmar que las encuestas posteriores reducen los no leídos recuento. |
| `offset_commit_failed_after_events_applied` | Los eventos se procesaron pero la persistencia duradera de compensación de registros falló. | La aplicación se aplaza; reparar el almacenamiento de compensación antes de depender de otro ciclo. |

<a id="scheduler-report-and-notification-codes"></a>
## Códigos de programación, informe y notificación

| Código o estado | Significado | Respuesta segura |
|---|---|---|
| `poll already in flight` | Llegó una segunda devolución de llamada mientras la encuesta actual era dueña del ciclo de vida. | Confirmar los avances de la encuesta existente; no agregue otro propietario del bucle. |
| `no_log_files_found` | No se descubrió ningún registro activo o de respaldo configurado. | Verifique la configuración de raíz y fuente guardada. |
| `current_poll_error` | El ciclo actual registró una falla en la fuente de sondeo. | Leer `runtime/current/poll_error.json`. |
| `cadence_deferred` | El despachador de finalización aún no vence. | Esperado hasta la próxima oportunidad limitada. |
| `reports_disabled` | La generación de informes públicos está deshabilitada. | Habilítelo solo si se pretende generar informes. |
| `local_outbox_write_failed` | No se pudo escribir un sobre local traducido. | Repare el directorio de salida del tiempo de ejecución; esto no es un error de transporte de notificación. |
| `source_accounting_disabled` | La prueba de ruta no puede reclamar una cobertura de origen completa. | Habilite la contabilidad de origen o acepte explícitamente la prueba faltante. |
| `route_disabled` | La ruta está deshabilitada intencionalmente. | No se espera ninguna entrega para esa ruta. |
| `poll_owner_between_polls` | El trabajador del informe está en cola para el intervalo entre sondeos propiedad del programador. | Se espera solo mientras las marcas de tiempo y los cursores continúan avanzando. |
| `unsafe_shell_path` | Un inventario limitado o una ruta de shell no superaron la validación segura de la plataforma. | Corrigir la ruta; nunca debilite las cotizaciones o la validación de rutas. |

<a id="related-procedures"></a>
## Procedimientos relacionados

- [Solución de problemas](SOLUCI%C3%93N_DE_PROBLEMAS.md) para clasificación y reparación de síntomas.
- [Revisión de validación y lanzamiento](VALIDACI%C3%93N_Y_PUBLICACI%C3%93N.md) para fallas de accesorios y paquetes.
- [Referencia del esquema de salida](REFERENCIA_DEL_ESQUEMA_DE_SALIDA.md) para contratos de campo completos.
