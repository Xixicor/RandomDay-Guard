<a id="faq"></a>
# FAQ

> **Fuente canónica en inglés:** [FAQ.md](../../FAQ.md). Esta documentación localizada conserva comandos, rutas, claves, valores de estado, hashes y nombres de archivos exactos. Si la redacción técnica difiere, utilice la fuente en inglés.


<a id="is-randomdayguard-the-randomday-mod"></a>
## Es RandomDayGuard el RandomDayMod?

No. RandomDayMod cambia la experiencia del servidor. RandomDayGuard observa la capa de evidencia del servidor.

<a id="does-live-defense-work-before-the-scan-completes"></a>
## ¿Funciona la defensa en vivo antes de que se complete el escaneo?

Sí. La defensa en vivo utiliza registros y eventos de sesión. El análisis de referencia mejora el contexto más adelante.

<a id="why-can-the-first-scan-take-a-long-time"></a>
## ¿Por qué el primer análisis puede tardar mucho tiempo?

El primer análisis crea world/object contexto, manifiestos de archivos y datos de referencia reutilizables.

<a id="what-do-i-check-first-after-startup"></a>
## ¿Qué debo comprobar primero después del inicio?

```text
runtime/current/poll_status.json
```

Busque:

```text
scheduler_status=running
poll_id increasing
poll_in_flight=false
```

<a id="where-are-player-summaries"></a>
## ¿Dónde están los reproductores? ¿resúmenes?

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
```

<a id="where-is-the-daily-quick-review-package"></a>
## ¿Dónde está el paquete de revisión rápida diaria?

```text
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

<a id="which-file-should-i-upload-for-fastest-review"></a>
## ¿Qué archivo debo cargar para una revisión más rápida?

```text
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="can-it-write-bans-automatically"></a>
## ¿Puede escribir prohibiciones automáticamente?

Solo si está explícitamente habilitado.

Predeterminado:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

<a id="what-does-adminini-receive"></a>
## ¿Qué hace? Admin.ini ¿recibir?

Solo:

```ini
BannedPlayer=<ID>
```

Sin nombres, comentarios, motivos ni sufijos.

<a id="is-a-display-name-enough-to-ban"></a>
## ¿Es suficiente un nombre para mostrar para prohibir?

No. Utilice un registro del servidor `Login request` con `ConnectID` o evidencia de servidor equivalente.

<a id="can-one-crash-ban-someone"></a>
## ¿Se puede prohibir a alguien por accidente?

No de forma predeterminada.

<a id="can-object-count-alone-ban-someone"></a>
## ¿Puede el recuento de objetos por sí solo prohibir a alguien?

No de forma predeterminada.

<a id="should-savedroottxt-point-to-the-world-folder"></a>
## ¿Debería SavedRoot.txt señalar al mundo? carpeta?

No. Apunta a `AbioticFactor/Saved`.

<a id="what-if-the-world-folder-changes"></a>
## ¿Qué pasa si la carpeta mundial cambia?

Trátelo como un cambio de identidad básico. Conserve la línea de base anterior y cree una nueva.

<a id="related-docs"></a>
## Documentos relacionados

* [`START_HERE.md`](COMIENCE_AQU%C3%8D.md)
* [`FORENSIC_DAILY_ROLLUPS.md`](RES%C3%9AMENES_DIARIOS_FORENSES.md)
* [`TROUBLESHOOTING.md`](SOLUCI%C3%93N_DE_PROBLEMAS.md)
