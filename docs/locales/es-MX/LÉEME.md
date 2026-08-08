# RandomDayGuard - Mexican (MX)

> [!IMPORTANT]
> ## Estado del proyecto — concluyeron las pruebas de RandomDay
>
> La operación de pruebas de RandomDay terminó y el servidor público de pruebas cerrará pronto.
>
> Durante esta operación, RandomDay y RandomDayGuard funcionaron juntos a través de rotaciones repetidas de perfiles, reinicios normales e interrumpidos del servidor, comprobaciones de recuperación y reversión, integración con mods extendidos, recopilación de evidencia del servidor y revisión de informes del operador.
>
> Con esto obtuvimos el conocimiento que buscábamos: cómo se comportan los perfiles rotativos del sandbox durante ciclos de vida reales de un servidor dedicado; cómo interactúa RandomDay con los mods extendidos compatibles; y hasta qué punto RandomDayGuard puede convertir la evidencia escrita por el servidor en monitoreo útil y prudente, sin presentar vacíos o suposiciones como hechos.
>
> **Conjunto usado en el servidor de pruebas:**
>
> - RandomDay compilación privada de desarrollo `v0.41.76`
> - RandomDayGuard compilación privada de desarrollo `v0.46.130`
> - Chaotic Spawn Engine / DynamicSpawns `0.8.5 Hotfix 1`
> - Lethal Lasers `1.0 UE4SS`
> - ANTE Up `0.26`
> - Encounter Director integration — una extensión de DynamicSpawns propiedad de RandomDay, no un mod distribuido por separado
> - UE4SS `v3.0.1 Beta #0` (Git `01e0a584`; Nexus `v3.0.1-940-g01e0a584`)
> - servidor dedicado de Abiotic Factor `1.4.0.27939`
>
> Los paquetes publicados actualmente siguen siendo RandomDay `v0.3.16-alpha` y RandomDayGuard `v0.4.12-alpha`.
>
> El desarrollo de ambos proyectos queda pausado por ahora. Las versiones y la documentación existentes seguirán disponibles, y quizá volvamos cuando sintamos de nuevo el deseo de continuar el trabajo.
>
> Este conjunto documenta lo que se usó durante la operación; no es un requisito de versión mínima ni una garantía de compatibilidad con versiones posteriores del juego, el cargador o los mods. El último ciclo registrado formalmente usó Abiotic Factor `1.4.0.27939`.

**v0.4.12-alpha**

RandomDayGuard convierte evidencia acotada de un servidor dedicado de Abiotic
Factor en reportes claros para quien administra el servidor. Mantiene separados
el estado del servidor, el resumen diario, la actividad de jugadores, la
revisión de casos y los fallos críticos.

## Instalar

Sigue la [guía de instalación](INSTALACI%C3%93N.md). La carpeta debe quedar en
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
`auto_ban = false` y `write_admin_ini = false`. Lee [Inicio](COMIENCE_AQU%C3%8D.md),
[Operaciones](MANUAL_DE_OPERACIONES.md), [Configuración](PERFILES_DE_CONFIGURACI%C3%93N.md)
y [Solución de problemas](SOLUCI%C3%93N_DE_PROBLEMAS.md). La evidencia estructurada
es el registro técnico; la traducción facilita su lectura.

Los comandos, rutas, claves y estados se conservan en inglés para coincidir
exactamente con la instalación.

## Versión alfa y dos rutas de información

Ésta es una versión alfa. Ya probamos las rutas documentadas de recolección, reportes y recuperación; seguimos mejorando la compatibilidad, la cobertura histórica y la calidad de los reportes.

La ruta actual usa el log activo, el estado actual de inicio y del programador, y las sesiones actuales, por lo que puede escribir reportes actuales de inmediato. La ruta histórica revisa logs conservados, nombres de PlayerData, evidencia y casos existentes en pasos limitados.

`runtime/current/report_worker_status.json`

Compara `scan_cursor` y `last_progress_ts` en `runtime/current/report_worker_status.json` durante varios ciclos. Si avanzan, el escaneo funciona. Si permanecen iguales mientras los reportes actuales avanzan, el escaneo histórico está detenido; los datos actuales siguen siendo útiles, pero las conclusiones que necesitan historia anterior quedan limitadas.

[Solución de problemas](SOLUCI%C3%93N_DE_PROBLEMAS.md)

## Biblioteca de documentación completa

Todos los documentos públicos de Markdown están disponibles en este idioma con nombres de archivos localizados.

- [Abrir el índice de documentación localizada](DOCUMENTACI%C3%93N.md)
