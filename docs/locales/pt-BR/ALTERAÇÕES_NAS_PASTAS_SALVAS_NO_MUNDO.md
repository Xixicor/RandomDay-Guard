<a id="world-save-folder-changes"></a>
# Alterações na pasta salvamento mundial

> **Fonte canônica em inglês:** [WORLD_SAVE_FOLDER_CHANGES.md](../../WORLD_SAVE_FOLDER_CHANGES.md). Essa documentação localizada preserva comandos, caminhos, chaves, valores de status, hashes e nomes de arquivos exatos. Se o texto técnico for diferente, use a fonte em inglês.


Use esta página quando a pasta mundial ativa for alterada.

<a id="normal-layout"></a>
## Layout normal

```text
Saved/SaveGames/Server/Worlds/<WorldName>/
```

`SavedRoot.txt` ainda deve apontar para:

```text
AbioticFactor/Saved
```

não o mundo pasta.

<a id="case-1-same-world-renamed"></a>
## Caso 1: mesmo mundo renomeado

Exemplo:

```text
Worlds/OldName/
Worlds/NewName/
```

Comportamento esperado:

```text
Reuse cached evidence where fingerprints match.
Rescan files whose path/cache no longer matches.
Preserve old evidence.
```

<a id="case-2-different-world-or-restored-backup"></a>
## Caso 2: mundo diferente ou backup restaurado

Comportamento esperado:

```text
Preserve old completed baseline.
Start a new baseline generation.
Do not overwrite old baseline until the new one completes.
```

<a id="case-3-partial-scan-existed-before-the-change"></a>
## Caso 3: verificação parcial existia antes da alteração

Comportamento esperado:

```text
Mark the old checkpoint stale.
Preserve partial evidence.
Start a new baseline for the current world.
```

<a id="case-4-completed-baseline-existed-before-the-change"></a>
## Caso 4: linha de base concluída existia antes da alteração

Comportamento esperado:

```text
Load the old baseline for visibility.
Mark it as previous-world context.
Build a new baseline safely.
```

<a id="what-to-check"></a>
## O que verificar

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

* [`MEMORY_ECONOMY_AND_OUTPUTS.md`](ECONOMIA_DE_MEM%C3%93RIA_E_SA%C3%8DDAS.md)
* [`BAD_ACTOR_PATTERNS_AND_RESILIENCE.md`](PADR%C3%95ES_E_RESILI%C3%8ANCIA_DE_ATORES_MAL-INTENCIONADOS.md)
