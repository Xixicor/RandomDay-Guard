<a id="glossary"></a>
# Glosario

> **Fuente canónica en inglés:** [GLOSSARY.md](../../GLOSSARY.md). Esta documentación localizada conserva comandos, rutas, claves, valores de estado, hashes y nombres de archivos exactos. Si la redacción técnica difiere, utilice la fuente en inglés.


| Término | Significado simple | Significado técnico exacto |
|---|---|---|
| Registro activo | El registro del servidor actual utilizado para evidencia nueva. | Requerido `active_log` fuente; se necesita legibilidad más el linaje actual para completar la ruta. |
| ID de arranque | Un inicio de proceso de vigilancia. | Identificador de tiempo de ejecución actual utilizado para rechazar el arranque anterior errors/reports. |
| ID de época | Un intervalo de continuidad del servidor. | Identificador que abarca el tiempo de ejecución normal hasta que la lógica de continuidad inicia otra época. |
| ID de encuesta | Una oportunidad de encuesta limitada. | Campo de ciclo monótono positivo; zero/missing no puede completar una ruta. |
| Actualidad de la fuente | Si la fuente actual y el linaje de la encuesta coinciden. | `fresh_current_poll` o `stale_or_unproven` con marcas de tiempo y estado de registro activo. |
| Contabilidad de origen | Inventario de disponibilidad y límites de evidencia. | `randomdayguard.source-accounting/v1` con ocho clases de fuentes y current/historical alcance. |
| `available` | Se encontró y leyó una fuente. | Estado de la fuente terminal con `available=true`, `readable=true`. |
| `expected_empty` | Una fuente opcional fue verificada y legítimamente absent/empty. | Estado de fuente legible del terminal; nunca fabrica un tema. |
| `partial` | El trabajo limitado tiene resultados útiles pero incompletos. | No terminal source/accounting estado; reanudar al trabajador propietario. |
| `deferred` | El trabajo está pendiente intencionalmente. | Estado de fuente no terminal; no es un error ni una finalización. |
| `unavailable` | La fuente no se puede utilizar actualmente. | Brecha terminal; una brecha de fuente requerida hace que la contabilidad no esté disponible. |
| `malformed` | Existe una fuente pero no es estructuralmente válida. | Brecha de terminal que preserva los detalles de validación y cierra las escrituras dependientes. |
| `permission_denied` | El sistema operativo rechazó explícitamente el acceso. | Brecha de terminal distinta de missing/unavailable. |
| `error` | Error de una operación limitada inesperadamente. | Error del terminal que requiere la recuperación indicada; ningún detalle secreto pertenece a los informes públicos. |
| `complete` | Todas las fuentes contabilizadas son terminales sin espacios. | Estado contable de la fuente de nivel superior. |
| `complete_with_gaps` | La evidencia actual requerida funciona; quedan brechas terminales opcionales. | Estado contable de nivel superior; las rutas siguen aplicando sus propios requisitos. |
| `full` | Una ruta completada con su contrato no vacío requerido. | Enumeración de prueba de ruta con salidas del ciclo actual completadas. |
| `limited_expected_empty` | Una ruta completada y no se encontró ninguna elegible subject/failure. | Enumeración de prueba de ruta con `completed=true`, `expected_empty=true`. |
| `missing` | La prueba de finalización de ruta está ausente o falló. | Enumeración de prueba de ruta con `completed=false`; nunca elegible para la bandeja de salida. |
| Informe estructurado | Salida de ruta legible por máquina. | `<route>_latest.json` usando `randomdayguard.report/v1`. |
| Informe traducido | Representación legible por humanos de la misma ruta. | `<route>_latest.txt` con orden fijo de referencias observadas a la fuente. |
| Prueba de ruta | Libro de finalización de rutas cruzadas. | `route_proof.json` enlace version/boot/epoch/poll/freshness/output rutas. |
| Evidencia actual | Observación propiedad del ciclo activo. | Alcance `current`; no reconstruido a partir del antiguo filenames/reports. |
| Evidencia histórica | Contexto retenido de ciclos anteriores o escaneo lento. | Alcance `historical`; puede informar la revisión pero no puede afirmar la presencia actual. |
| Solo revisión | Producir evidencia de revisión sin Admin.ini. | valor predeterminado `review_only_mode=true`, `auto_ban=false`, `write_admin_ini=false`. |
| verificación de seguridad de la lista de baneos | Una pregunta que Guard debe responder antes de que pueda cambiar `Admin.ini`. | Debe confirmar la cuenta y la puntuación, excluir cuentas confiables y duplicados, verificar una copia de seguridad, detectar cambios externos, guardar la actualización deseada y verificar o restaurar de forma segura el archivo completo. |
| bandeja de salida local | Transferencia opcional de notificación neutral del proveedor. | JSON archivos con `delivery_backend="none"` y `delivery_attempted=false`. |
| línea de base | Instantánea de contexto del archivo guardado limitado y completado. | Manifest/object/world el estado se reutiliza solo cuando es compatible y lo suficientemente actualizado. |
| Punto de control | Reanudar posición para trabajo de escaneo incompleto. | `scan_checkpoint.json`; la eliminación no es la recuperación predeterminada. |
| Índice reconstruible | Resumen que se puede regenerar. | Daily/weekly/forensic/final resultado de la revisión; la evidencia de la fuente sigue siendo autorizada. |
| Límite de evidencia | Límite de lo que una fuente puede admitir. | Explícitas `does_not_prove`, incógnitas, solidez de la identidad y reglas de alcance. |

Las definiciones canónicas para esquemas se encuentran en [`OUTPUT_SCHEMA_REFERENCE.md`](REFERENCIA_DEL_ESQUEMA_DE_SALIDA.md); Los términos de configuración se encuentran en [`CONFIG_FIELD_CATALOG.md`](CAT%C3%81LOGO_DE_CAMPOS_DE_CONFIGURACI%C3%93N.md).
