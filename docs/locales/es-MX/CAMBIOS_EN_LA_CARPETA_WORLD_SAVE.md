<a id="world-save-folder-changes"></a>
# Cambios en la carpeta de guardado mundial

> **Fuente canónica en inglés:** [WORLD_SAVE_FOLDER_CHANGES.md](../../WORLD_SAVE_FOLDER_CHANGES.md). Esta documentación localizada conserva comandos, rutas, claves, valores de estado, hashes y nombres de archivos exactos. Si la redacción técnica difiere, utilice la fuente en inglés.


Utilice esta página cuando cambie la carpeta mundial activa.

<a id="normal-layout"></a>
## Diseño normal

```text
Saved/SaveGames/Server/Worlds/<WorldName>/
```

`SavedRoot.txt` aún debe apuntar a:

```text
AbioticFactor/Saved
```

no a la carpeta mundial.

<a id="case-1-same-world-renamed"></a>
## Caso 1: mismo mundo renombrado

Ejemplo:

```text
Worlds/OldName/
Worlds/NewName/
```

Comportamiento esperado:

```text
Reuse cached evidence where fingerprints match.
Rescan files whose path/cache no longer matches.
Preserve old evidence.
```

<a id="case-2-different-world-or-restored-backup"></a>
## Caso 2: mundo diferente o copia de seguridad restaurada

Comportamiento esperado:

```text
Preserve old completed baseline.
Start a new baseline generation.
Do not overwrite old baseline until the new one completes.
```

<a id="case-3-partial-scan-existed-before-the-change"></a>
## Caso 3: existía un escaneo parcial antes del cambio

Comportamiento esperado:

```text
Mark the old checkpoint stale.
Preserve partial evidence.
Start a new baseline for the current world.
```

<a id="case-4-completed-baseline-existed-before-the-change"></a>
## Caso 4: la línea base completa existía antes del cambio

Comportamiento esperado:

```text
Load the old baseline for visibility.
Mark it as previous-world context.
Build a new baseline safely.
```

<a id="what-to-check"></a>
## Qué comprobar

```text
runtime/scan_checkpoint.json
runtime/scan_progress.json
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
runtime/world_state/current/world_state_latest.json
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="related-docs"></a>
## Documentos relacionados

* [`MEMORY_ECONOMY_AND_OUTPUTS.md`](ECONOM%C3%8DA_DE_MEMORIA_Y_SALIDAS.md)
* [`BAD_ACTOR_PATTERNS_AND_RESILIENCE.md`](PATRONES_DE_MALOS_ACTORES_Y_RESILIENCIA.md)
