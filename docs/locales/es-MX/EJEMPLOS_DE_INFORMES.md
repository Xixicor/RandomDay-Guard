<a id="examples-of-the-five-guard-reports"></a>
# Ejemplos de los cinco informes de Guard

> **Fuente canónica en inglés:** [REPORT_EXAMPLES.md](../../REPORT_EXAMPLES.md). Esta documentación localizada conserva comandos, rutas, claves, valores de estado, hashes y nombres de archivos exactos. Si la redacción técnica difiere, utilice la fuente en inglés.


Estos ejemplos se produjeron a partir de los datos de muestra incluidos en la versión; los nombres y números de cuentas son inventados. Muestran los campos del informe probados, los cálculos y los límites de la ruta. Un informe real los reemplaza con información recopilada de ese servidor e indica cuándo un hecho no estaba disponible.

Cada informe tiene una función. El estado del servidor no repite el historial del jugador, la revisión diaria no se envía cada pocos minutos y las rutas silenciosas del jugador o del caso no reciben mensajes de relleno. Es posible que esté listo un informe actual mientras el escaneo histórico limitado aún está progresando; en ese caso, el informe menciona la brecha en lugar de presentar el historial anterior como completo.

<a id="server-status"></a>
## Estado del servidor

> **Estado del servidor: En línea después del reinicio**  **Estado actual:** En línea **Disponible desde:** 14:07  **Reinicio completado:** 14:06  **Tiempo de inactividad:** 3 minutos, 12 segundos **Motivo del reinicio:** Actualización programada del juego **Monitoreo:** Activo. Última comprobación exitosa: 14:09 **Registro del juego:** Disponible y actualizándose **Escaneo histórico:** 312 de 355 archivos revisados ​​**Copias de seguridad:** Última verificación: 13:00. Próxima prevista: 15:00. Fallos hoy: 0 **Acción:** Ninguna. El servidor se recuperó normalmente.

El estado del servidor es para la operación actual del servidor: inicio, recuperación de reinicio, tiempo de inactividad, copias de seguridad, el programador y estado de Guard. No contiene sesiones de jugadores ni detalles de casos.

<a id="daily-rollup"></a>
## Resumen diario

> **Revisión diaria: 19 de julio de 2026**  **Disponibilidad del servidor:** En línea durante 23 horas y 47 minutos. Desconectado durante 13 minutos.  **Reinicios:** 2 en total: 1 programado y 1 inesperado.  **Copias de seguridad:**23 exitoso. 1 falta o falló. Última copia de seguridad exitosa: 23:00.  **Actividad del jugador:**3 jugadores únicos. 7 sesiones: 6 realizadas con normalidad y 1 interrumpida.  **Actividad del caso:** 1 caso nuevo, 2 casos actualizados, 1 caso que necesita atención y 0 casos críticos.  **Cobertura de evidencia:** 6 de 7 grupos de fuentes esperados estaban disponibles. El registro de respaldo de las 04:00 no estaba disponible.  **Resumen del día:**El servidor permaneció disponible durante la mayor parte del día. Una interrupción inesperada puso fin antes de tiempo a la sesión de un jugador. El seguimiento se reanudó después de la recuperación y un caso está listo para su revisión.  **Acción:** Caso de revisión `RDG-20260719-004`. No se requiere ninguna otra acción inmediata.

El resumen diario se escribe una vez para su fecha del calendario. Combina el día en períodos de tranquilidad y se reinicia sin convertirse en otro ping de estado del servidor.

<a id="player-activity"></a>
## Actividad del jugador

> **Actividad del jugador: Alex**  **Cuenta:** `76561198000000400`  **Primera observación:** 12 de julio de 2026 **Última sesión:** Se unió a las 10:02, se fue a las 11:18, duró 1 hora y 16 minutos y finalizó normalmente.  **Hoy:** 3 conexiones, 2 sesiones completadas, 1 sesión interrumpida y 2 reconexiones rápidas en 10 minutos.  **7 días anteriores:** 9 sesiones, 6 horas 18 minutos de juego grabado y 0 casos previos.  **Observado:** Alex regresó dos veces poco después de una sesión interrumpida. La actividad registrada es lo suficientemente completa como para conservarla como historia, pero por sí sola no explica por qué ocurrieron las reconexiones.  **Acción:**Continuar monitoreando. No se requiere ninguna acción inmediata.

La actividad del jugador se envía solo cuando cambia la información del jugador admitido o de la sesión. Un período de silencio no crea un mensaje de jugador.

<a id="case-review"></a>
## Revisión de caso

> **Revisión de caso: RDG-20260719-004**  **Asunto:** Alex **Cuenta:** `76561198000000400`  **Estado:** Revisión del administrador solicitada **Calificación de la revisión:** 90 - Alta prioridad **Por qué se abrió el caso:** La cuenta realizó repetidos intentos de conexión después de una sesión interrumpida y el servidor registró las solicitudes de inicio de sesión directamente.  **Observaciones confirmadas:** - Se registró una solicitud de inicio de sesión a las 18:42. - Se registraron cuatro intentos en 6 minutos. - Dos sesiones finalizaron sin un registro de salida normal. - El mismo relato se observó los días 12 y 17 de julio.  **Historial relevante:**No se registra ningún caso previo para esta cuenta.  **Desconocido:** Los registros disponibles no establecen el motivo de las reconexiones, la intención del jugador o si el estado del mundo cambió.  **Acción recomendada:** Compare los tiempos de sesión con el registro del servidor y la actividad mundial registrada antes de decidir si se necesita alguna acción.

La revisión del caso contiene material de revisión nombrado, sus observaciones confirmadas, sus límites y un paso de revisión específico. La presencia histórica por sí sola no crea un caso nuevo.

<a id="critical-guard"></a>
## Guardia crítica

> **Critical Guard: redacción de informes detenida**  **Iniciada:** 21:14  **Función afectada:** Informe del jugador escritor **Impacto:** No se pueden completar los resúmenes de nuevos jugadores.  **Servidor:**Permanece en línea.  **Monitoreo:** La recopilación de pruebas continúa, pero los informes legibles se retrasan.  **Último informe exitoso:** 21:09  **Error:** No se pudo guardar el resultado del informe.  **Motivo probable:** El destino no estaba disponible o rechazó la escritura.  **Acción:** Verifique la ubicación de salida del tiempo de ejecución de Guard. No reinicie el servidor del juego a menos que también se detenga la supervisión.

Cuando el problema desaparece, la misma ruta registra la recuperación:

> **Guardia crítica resuelta: redacción de informes restaurada**  **Reanudada:** 21:22  **Interrupción:** 8 minutos **Resultado:** Se conservaron las pruebas recopiladas durante la interrupción y se completaron los informes retrasados.

Critical Guard es solo para fallas. El estado de rutina, el historial diario, la actividad del jugador y los resultados ordinarios esperados-vacíos permanecen en sus propios informes.

<a id="when-a-route-is-quiet"></a>
## Cuando una ruta está tranquila

Una ruta silenciosa registra un resultado directo sin enviar relleno a Discord:

> **Comprobado; nada para este informe.** Los registros requeridos estaban disponibles y no se produjo ninguna actividad del jugador, caso o falla de guardia durante esta ventana de informe.

Ese es un resultado completamente vacío. Es diferente de un informe faltante, donde no se pudo verificar una fuente requerida o no se pudo crear el resultado legible.

Cada informe legible sigue la misma ruta:

```text
collected evidence -> normalized values -> dictionary mapping -> route calculations -> readable report -> Discord notification
```

Utilice el [libro de operaciones](MANUAL_DE_OPERACIONES.md) para revisar los informes actuales y el [esquema de salida](REFERENCIA_DEL_ESQUEMA_DE_SALIDA.md) para el campo técnico. referencia.
