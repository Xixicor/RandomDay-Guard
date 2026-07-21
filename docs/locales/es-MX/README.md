# RandomDayGuard - Mexican (MX)

**v0.4.12-alpha**

RandomDayGuard convierte evidencia acotada de un servidor dedicado de Abiotic
Factor en reportes claros para quien administra el servidor. Mantiene separados
el estado del servidor, el resumen diario, la actividad de jugadores, la
revisión de casos y los fallos críticos.

## Instalar

Sigue la [guía de instalación](../../../INSTALL.md). La carpeta debe quedar en
`ue4ss/Mods/RandomDayGuard` y `mods.txt` debe contener `RandomDayGuard : 1`.
Evita instalaciones anidadas y carpetas `Scripts` duplicadas.

## Comprobar el primer reporte

Abre `runtime/current/startup_status.json`, después
`runtime/final_logs/latest_dossier.json` y finalmente
`runtime/final_logs/route_proof.json`. Cada ruta debe indicar `full`,
`limited_expected_empty` o `missing`. El reporte legible y la fuente citada
deben pertenecer al mismo ciclo.

## Configurar y revisar

Los valores públicos iniciales son `review_only_mode = true`,
`auto_ban = false` y `write_admin_ini = false`. Lee [Inicio](../../START_HERE.md),
[Operaciones](../../OPERATIONS_PLAYBOOK.md), [Configuración](../../CONFIG_PROFILES.md)
y [Solución de problemas](../../TROUBLESHOOTING.md). La evidencia estructurada
es el registro técnico; la traducción facilita su lectura.

Los comandos, rutas, claves y estados se conservan en inglés para coincidir
exactamente con la instalación.

## Versión alfa y dos rutas de información

Ésta es una versión alfa. Ya probamos las rutas documentadas de recolección, reportes y recuperación; seguimos mejorando la compatibilidad, la cobertura histórica y la calidad de los reportes.

La ruta actual usa el log activo, el estado actual de inicio y del programador, y las sesiones actuales, por lo que puede escribir reportes actuales de inmediato. La ruta histórica revisa logs conservados, nombres de PlayerData, evidencia y casos existentes en pasos limitados.

`runtime/current/report_worker_status.json`

Compara `scan_cursor` y `last_progress_ts` en `runtime/current/report_worker_status.json` durante varios ciclos. Si avanzan, el escaneo funciona. Si permanecen iguales mientras los reportes actuales avanzan, el escaneo histórico está detenido; los datos actuales siguen siendo útiles, pero las conclusiones que necesitan historia anterior quedan limitadas.

[Solución de problemas](../../TROUBLESHOOTING.md)
