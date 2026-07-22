<a id="configuration-concepts"></a>
# Conceitos de configuração

> **Fonte canônica em inglês:** [CONFIG_REFERENCE.md](../../CONFIG_REFERENCE.md). Essa documentação localizada preserva comandos, caminhos, chaves, valores de status, hashes e nomes de arquivos exatos. Se o texto técnico for diferente, use a fonte em inglês.


Esta explicação descreve o que cada área de configuração principal controla, quando é executada e como interage com evidências e portas de segurança. Ele não possui o catálogo de campos exato ou procedimentos de perfil.

Para predefinições orientadas a tarefas e etapas de alteração seguras, use [`CONFIG_PROFILES.md`](PERFIS_DE_CONFIGURA%C3%87%C3%83O.md). Para cada campo de origem exato, padrão, tipo, invariante, efeito de saída e regra de recuperação, use o [`CONFIG_FIELD_CATALOG.md`](CAT%C3%81LOGO_DE_CAMPOS_DE_CONFIGURA%C3%87%C3%83O.md) gerado; o validador requer uma linha para cada `config.lua` enviado.

<a id="reading-this-page"></a>
## Ler esta página

Cada área de configuração responde:

```text
What it controls
When it runs
What to check
What can go wrong
```

<a id="top-level-safety"></a>
## Segurança de nível superior

| Opção | Padrão | Significado |
|---|---:|---|
| `enabled` | `true` | Switch mestre para o guard |
| `enforcement.review_only_mode` | `true` | Record/recommend somente |
| `enforcement.auto_ban` | `false` | Não banir automaticamente por padrão |
| `enforcement.write_admin_ini` | `false` | Não escrever Admin.ini por padrão |

Mantenha-os seguros até que o proprietário do servidor revise a saída.

<a id="saved"></a>
## `saved`

Controla como o guard encontra a pasta `Saved/` do servidor e qual arquivo famílias que ele pode verificar.

Usar quando:

```text
Saved root auto-detection fails.
World folder changed.
Provider or container path is unusual.
```

Verificar:

```text
runtime/saved_path_probe.json
RandomDayGuard/SavedRoot.txt
```

Regra:

```text
SavedRoot.txt -> AbioticFactor/Saved
not -> Worlds/<WorldName>
```

<a id="log_tail"></a>
## `log_tail`

Controla a leitura de registros em tempo real.

Opções úteis:

| Opção | Valor seguro | Por que |
|---|---|---|
| `enabled` | `true` | Necessário para defesa em tempo real |
| `start_at_end_on_first_run` | `true` | Evita logs antigos como eventos ao vivo |
| `tail_backup_logs` | `false` | Os logs de backup são históricos, não ativos |
| `max_lines_per_poll` | limitados | Mantém o loop de pesquisa responsivo |

Verificar:

```text
runtime/log_offsets.tsv
runtime/evidence/session_events.jsonl
runtime/current/poll_status.json
```

<a id="runtime"></a>
## `runtime`

Controla pesquisas e orçamentos.

Regra de integridade principal:

```text
poll_id increases
poll_in_flight returns false
poll_scheduled is true
```

Verificar:

```text
runtime/current/poll_status.json
```

Se `poll_id` parar, algo está bloqueando o loop.

<a id="source_accounting"></a>
## `source_accounting`

Controla a cobertura e o escopo explícitos da fonte de evidências.

| Chave | Padrão | Significado |
|---|---:|---|
| `enabled` | `true` | Escreve a contabilidade de origem para relatórios de rotas públicas. |
| `require_terminal_status` | `true` | Requer que cada fonte exponha um terminal explícito ou incompleto estado. |
| `distinguish_current_from_historical` | `true` | Mantém as evidências atuais e históricas separadas. |
| `slow_world_scan_blocks_current_reports` | `false` | Permite que os relatórios atuais indiquem que a verificação mundial limitada é adiada ou parcial. |
| `changed_file_manifest` | caminho do manifesto de linha de base | Referência usada para contabilidade historical/world limitada. |

Os estados de origem são `available`, `expected_empty`, `partial`, `deferred`, `unavailable`, `malformed`, `permission_denied`, ou `error`.

A configuração `source_accounting.enabled = false` não remove silenciosamente a saída de status. O pipeline ainda grava `runtime/final_logs/source_accounting_latest.json` com `enabled=false`, `status="unavailable"` e `disabled_reason="source_accounting_disabled"`. Também grava o registro de status histórico com contabilidade indisponível. Como a contabilidade de origem faz parte do contrato de relatório, toda rota falha no fechamento para `missing`; nenhuma rota é tratada como concluída enquanto a contabilidade está desativada.

<a id="reports"></a>
## `reports`

Controla o pipeline de relatórios locais genéricos.

Os padrões ativam todas as cinco rotas e escrevem em `runtime/final_logs`:

```text
server_status
daily_rollup
player_activity
case_review
critical_guard
```

Cada rota deve escrever a saída estruturada e traduzida, além da prova em `route_proof.json`. Desabilitar uma rota produz `missing` prova em vez de fingir que ela foi concluída.

<a id="notification"></a>
## `notification`

Caixa de saída de arquivo local genérico opcional. Ela está desabilitada por padrão e não envia nada para um provedor externo.

Padrões:

```lua
notification = {
    enabled = false,
    mode = "local_file_outbox",
    include_expected_empty = false,
},
```

Toda rota de notificação está desabilitada por padrão. Quando habilitada deliberadamente, a caixa de saída pode consumir apenas um relatório traduzido concluído após a gravação de `route_proof.json`. Evidências e relatórios locais permanecem confiáveis. Entrega específica do provedor, pontos de extremidade de entrega, credenciais e pontes não fazem parte do contrato público de vigilância independente.

<a id="scanning"></a>
## `scanning`

Controla verificação de linha de base, pontos de verificação e atualização de arquivos alterados.

Usar quando:

```text
building first world baseline
resuming after crash
refreshing changed files later
```

Verificar:

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/scan_complete.json
runtime/baselines/file_manifest.tsv
```

Configurações importantes:

```lua
scanning = {
    resume_incomplete_scan = true,
    reuse_completed_baseline = true,
    incremental_refresh_after_baseline = true,
    changed_file_detection = true,
},
```

<a id="forensic_rollup"></a>
## `forensic_rollup`

Controla o pacote de upload diário rápido e os registros finais em linguagem simples.

Saídas:

```text
runtime/current/forensic_today.json
runtime/current/forensic_today.md
runtime/current/forensic_today.txt
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

Usar quando:

```text
You want one daily folder that summarizes what happened.
You want a plain-language TXT to upload for quick analysis.
```

Verificar:

```text
runtime/forensic_days/YYYY-MM-DD/forensic_day_summary.json
runtime/forensic_days/YYYY-MM-DD/players.tsv
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

Regra:

```text
Daily summaries are rebuildable indexes.
Source evidence remains authoritative.
```

<a id="logging"></a>
## `logging`

Controla o volume de eventos e a agregação de baixa importância.

Usar quando:

```text
actor-touch events are noisy
raw event files grow too quickly
```

Padrão seguro:

```lua
logging = {
    low_importance_mode = "aggregate",
    write_low_importance_raw_events = false,
},
```

<a id="retention"></a>
## `retention`

Controla por quanto tempo os arquivos são mantidos e quando JSONL os registros são alternados.

Usar quando:

```text
disk usage grows too fast
you need more audit history
you need shorter live-history windows
```

Opções importantes:

```text
detailed_retention_days
rotate_jsonl_when_bytes_exceed
max_raw_events_lines
keep_enforced_forever
keep_evidence_forever
```

<a id="warning_bursts"></a>
## `warning_bursts`

Controles detecção de janela de aviso.

Exemplos:

```text
ActorChannelFailure
DeployableSaveWarning
UpdateActorToWorldSave
ServerMove warnings
```

Regra:

```text
Warnings are context until correlated with mapped sessions and thresholds.
```

<a id="crash_correlation"></a>
## `crash_correlation`

Controles repetidos crash/reconnect revisão.

Padrões seguros:

```lua
crash_correlation = {
    single_crash_never_bans = true,
    require_same_account = true,
},
```

Contadores úteis:

```text
server_crash_overlap_count
post_crash_reconnect_count
unclean_disconnect_count
```

<a id="join_leave"></a>
## `join_leave`

Controla rotatividade e rastreamento de onda de adesão.

Seguro padrão:

```lua
join_leave = {
    churn_alone_never_bans = true,
},
```

Use para:

```text
rapid reconnect loops
join waves
short-session patterns
```

<a id="raid_detection"></a>
## `raid_detection`

Agrupa contas ativas em janelas relacionadas.

Regra:

```text
A raid case groups accounts for review.
It does not make every account guilty.
```

Cada conta aplicada ainda precisa de evidências específicas da conta.

<a id="object_registry"></a>
## `object_registry`

Controla object/class extração de token de evidências legíveis salvas.

Saídas:

```text
runtime/object_registry_partial.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
```

Regra:

```text
Object/class context is not a ban reason by itself.
```

<a id="world_state"></a>
## `world_state`

Controla boot/current/session snapshots do estado mundial.

Saídas:

```text
runtime/world_state/current/world_state_latest.json
runtime/world_state/sessions/<date>/<session_id>_<account_id>/
```

Use para revisão de sessão e contexto mundial.

<a id="enforcement"></a>
## `enforcement`

Controla recomendações e Admin.ini gravações reais.

Antes que Guard possa adicionar um banimento, cada afirmação abaixo deve ser verdadeira:

```text
review_only_mode == false
auto_ban == true
write_admin_ini == true
ban_id is clean numeric
account identity is mapped
not trusted
not moderator
threshold is met
```

Se uma afirmação for falsa ou não puder ser verificada, Guard sai `Admin.ini` inalterado e registra o motivo.

<a id="admin_ini"></a>
## `admin_ini`

Controla gravações seguras de arquivos.

Regras:

```text
Back up before writing.
Preserve existing bans.
Preserve moderators.
Write clean BannedPlayer=<ID> only.
```

<a id="restart_request"></a>
## `restart_request`

Controla arquivos de marcadores locais opcionais que outro processo de propriedade do operador pode inspecionar. Ele não reinicia nem encerra o servidor.

Padrões:

```lua
restart_request = {
    enabled = false,
    restart_marker_file = "runtime/request_restart.flag",
    restart_reason_file = "runtime/restart_reason.json",
},
```

Saídas:

```text
runtime/request_restart.flag
runtime/restart_reason.json
```

Nenhum painel de hospedagem, ponte de provedor ou automação de reinicialização é incluído. Ativar a criação de marcadores não prova que um processo externo consumiu a solicitação ou reiniciou o servidor.

<a id="related-docs"></a>
## Documentos relacionados

* [`CONFIG_PROFILES.md`](PERFIS_DE_CONFIGURA%C3%87%C3%83O.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](REFER%C3%8ANCIA_DO_ESQUEMA_DE_SA%C3%8DDA.md)
* [`ADMIN_INI_ENFORCEMENT.md`](APLICA%C3%87%C3%83O_DE_INICIALIZA%C3%87%C3%83O_ADMINISTRATIVA.md)
