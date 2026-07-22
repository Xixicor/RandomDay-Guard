<a id="configuration-profiles"></a>
# Perfis de configuração

> **Fonte canônica em inglês:** [CONFIG_PROFILES.md](../../CONFIG_PROFILES.md). Essa documentação localizada preserva comandos, caminhos, chaves, valores de status, hashes e nomes de arquivos exatos. Se o texto técnico for diferente, use a fonte em inglês.


Use este guia prático para escolher e aplicar um perfil de configuração prático. Para obter uma explicação de como os grupos de configurações interagem, leia [`CONFIG_REFERENCE.md`](REFER%C3%8ANCIA_DE_CONFIGURA%C3%87%C3%83O.md). Para campos exatos, padrões, tipos e invariantes, use o [`CONFIG_FIELD_CATALOG.md`](CAT%C3%81LOGO_DE_CAMPOS_DE_CONFIGURA%C3%87%C3%83O.md).

Cada bloco Lua abaixo é um conjunto de entradas de nível superior que podem substituir as entradas correspondentes dentro do `return { ... }` tabela enviada.

<a id="profile-chooser"></a>
## Seletor de perfil

| Situação | Usar este perfil |
|---|---|
| Primeira instalação | Primeira instalação segura |
| O servidor é instável e trava com frequência | Evidência atual sem verificação lenta |
| Você deseja object/world contexto | Linha de base completa |
| Você deseja revisar registros antigos | Forense backfill |
| Você quer recomendações, mas não gravações | Testes de aplicação |
| Você está pronto para deixar o guarda proibir gravações | Aplicação habilitada |
| O disco é limitado | Baixo crescimento do disco |
| Você concluiu uma linha de base limpa | Configuração de backup fixa |

<a id="safe-first-install"></a>
## Primeira instalação segura

Use isso primeiro em um servidor ativo.

```lua
enforcement = {
    review_only_mode = true,
    auto_ban = false,
    write_admin_ini = false,
},

log_tail = {
    enabled = true,
    start_at_end_on_first_run = true,
    tail_backup_logs = false,
},

scanning = {
    full_scan_on_start = true,
    resume_incomplete_scan = true,
    reuse_completed_baseline = true,
    incremental_refresh_after_baseline = true,
},

reports = {
    enabled = true,
},

notification = {
    enabled = false,
},
```

O que isso faz:

```text
Tracks live sessions.
Starts the baseline scan.
Does not edit Admin.ini.
Avoids treating old backup logs as fresh live events.
```

<a id="current-evidence-without-slow-scan"></a>
## Evidência atual sem verificação lenta

Use isso se o servidor estiver instável e você precisar de crash/reconnect evidências antes de um ataque pesado fazer a varredura.

```lua
log_tail = {
    enabled = true,
},

scanning = {
    full_scan_on_start = false,
},

enforcement = {
    review_only_mode = true,
    auto_ban = false,
    write_admin_ini = false,
},

reports = {
    enabled = true,
},

notification = {
    enabled = false,
},
```

O que isso faz:

```text
Tracks logins, joins, leaves, reconnects, crashes, and unclean sessions.
Delays heavy world scanning.
```

<a id="full-baseline"></a>
## Linha de base completa

Use isso depois que o servidor puder ficar ativo por tempo suficiente para fazer a varredura.

```lua
scanning = {
    full_scan_on_start = true,
    resume_incomplete_scan = true,
    reuse_completed_baseline = true,
    incremental_refresh_after_baseline = true,
},
```

O que isso faz:

```text
Builds object registry.
Writes world-state context.
Creates file manifest.
Enables changed-file refresh later.
```

<a id="forensic-backfill"></a>
## Forense backfill

Use isso apenas ao revisar intencionalmente os registros históricos.

```lua
log_tail = {
    start_at_end_on_first_run = false,
    tail_backup_logs = true,
    backfill_backup_logs_on_start = true,
},
```

Antes de usá-lo:

```text
Back up runtime/log_offsets.tsv.
Expect old events to be reprocessed.
Return to live settings when finished.
```

<a id="enforcement-testing"></a>
## Testes de aplicação

Use isso antes da Admin.ini gravação real.

```lua
enforcement = {
    review_only_mode = true,
    auto_ban = false,
    write_admin_ini = false,
},
```

O que inspecionar:

```text
runtime/account_evidence.json
runtime/warnings/
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="enforcement-enabled"></a>
## Aplicação habilitada

Use somente depois que o resultado da revisão estiver correto.

```lua
enforcement = {
    review_only_mode = false,
    auto_ban = true,
    write_admin_ini = true,
    require_clean_ban_id = true,
    preserve_existing_bans = true,
    preserve_moderators = true,
},
```

Antes de ativar:

```text
Trusted IDs are configured.
Moderator IDs are preserved.
Admin.ini backups work.
Ban recommendations are understandable.
Thresholds are accepted by the server owner.
```

<a id="low-disk-growth"></a>
## Baixo crescimento do disco

Use quando os arquivos de tempo de execução estiverem crescendo muito rapidamente.

```lua
logging = {
    low_importance_mode = "aggregate",
    write_low_importance_raw_events = false,
},

retention = {
    detailed_retention_days = 7,
    rotate_jsonl_when_bytes_exceed = 5242880,
    max_raw_events_lines = 20000,
    compact_json_outputs = true,
},
```

<a id="sticky-backup-setup"></a>
## Configuração de backup fixa

Use após a primeira linha de base concluída.

Verifique se eles existem:

```text
runtime/scan_complete.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
runtime/world_state/current/world_state_latest.json
```

Em seguida, faça backup deles com `config.lua`, `SavedRoot.txt` e `Admin.ini`.

<a id="related-docs"></a>
## Documentos relacionados

* [`CONFIG_REFERENCE.md`](REFER%C3%8ANCIA_DE_CONFIGURA%C3%87%C3%83O.md)
* [`FORENSIC_DAILY_ROLLUPS.md`](ROLLUPS_DI%C3%81RIOS_FORENSES.md)
* [`ADMIN_INI_ENFORCEMENT.md`](APLICA%C3%87%C3%83O_DE_INICIALIZA%C3%87%C3%83O_ADMINISTRATIVA.md)
