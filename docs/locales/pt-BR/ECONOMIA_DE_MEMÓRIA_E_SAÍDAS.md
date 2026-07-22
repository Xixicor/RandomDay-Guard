<a id="memory-economy-and-output-files"></a>
# Economia de memória e arquivos de saída

> **Fonte canônica em inglês:** [MEMORY_ECONOMY_AND_OUTPUTS.md](../../MEMORY_ECONOMY_AND_OUTPUTS.md). Essa documentação localizada preserva comandos, caminhos, chaves, valores de status, hashes e nomes de arquivos exatos. Se o texto técnico for diferente, use a fonte em inglês.


Esta página explica quais arquivos crescem, quais arquivos são substituídos e o que carregar para revisão rápida.

<a id="fast-answer"></a>
## Resposta rápida

| Pergunta | Aberta |
|---|---|
| O guarda está vivo? | `runtime/current/poll_status.json` |
| Quem foi visto? | `runtime/account_evidence.json` |
| O que aconteceu com as sessões? | `runtime/evidence/session_events.jsonl` |
| O que aconteceu hoje? | `runtime/forensic_days/YYYY-MM-DD/` |
| O que é a linguagem simples resumo? | `runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt` |
| O que é o progresso da verificação? | `runtime/scan_progress.json` |
| Qual é o contexto mundial? | `runtime/world_state/current/world_state_latest.json` |
| Quais proibições foram escritas? | `runtime/enforced_bans.jsonl` |

<a id="output-model"></a>
## Modelo de saída

| Tipo | Comportamento | Exemplos |
|---|---|---|
| Snapshots atuais | Substituído | `runtime/current/*.json` |
| Registros de eventos | Somente anexos | `runtime/evidence/*.jsonl` |
| Tabelas | Atualizados ou anexados | `*.tsv` |
| Linhas de base | Reutilizadas após a conclusão | `runtime/baselines/*` |
| Rollups diários | Atualizados no local | `runtime/forensic_days/YYYY-MM-DD/*` |
| Registros finais | Resumo diário em linguagem simples | `runtime/final_logs/YYYY-MM-DD/*` |

<a id="current-snapshots"></a>
## Snapshots atuais

Eles permanecem pequenos e respondem “o que é verdade agora”.

```text
runtime/current/poll_status.json
runtime/current/session_state.json
runtime/current/active_accounts.json
runtime/current/forensic_today.json
runtime/current/forensic_today.md
runtime/current/forensic_today.txt
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/world_state/current/world_state_latest.json
```

<a id="player-summaries"></a>
## Resumos dos jogadores

Esses são os primeiros arquivos a serem verificados para análise da conta.

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
```

Eles resumem:

```text
account_id
ban_id
name
identity_confidence
first_seen
last_seen
join_count
leave_count
status
score
```

<a id="event-logs"></a>
## Registros de eventos

Eles preservam o linha do tempo.

```text
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/warning_events.jsonl
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/evidence/live_defense_events.jsonl
```

<a id="daily-forensic-rollups"></a>
## Acumulações forenses diárias

Estes são os pacotes de upload rápido.

```text
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

Carregue uma dessas pastas quando desejar uma análise rápida do período.

<a id="scan-and-baseline-files"></a>
## Arquivos de verificação e linha de base

Use-os para entender se o contexto mundial é parcial ou completo.

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/scan_complete.json
runtime/object_registry_partial.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
```

<a id="enforcement-files"></a>
## Arquivos de aplicação

Use-os somente quando a aplicação estiver ativada.

```text
runtime/enforced.txt
runtime/enforced_bans.jsonl
runtime/ban_queue.json
runtime/evidence/enforced_bans.jsonl
```

`Admin.ini` deve receber apenas:

```ini
BannedPlayer=<ID>
```

<a id="what-updates-when-a-player-joins"></a>
## O que é atualizado quando um jogador entra

Atualizações esperadas:

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/current/session_state.json
runtime/forensic_days/YYYY-MM-DD/players.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="what-updates-when-the-server-crashes-or-restarts"></a>
## O que é atualizado quando o servidor trava ou reinicia

Atualizações esperadas:

```text
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/crash_reconnects.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="what-updates-when-the-scan-progresses"></a>
## O que é atualizado quando a verificação avança

Atualizações esperadas:

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/object_registry_partial.json
runtime/world_state/current/world_state_latest.json
runtime/forensic_days/YYYY-MM-DD/forensic_day_summary.json
```

<a id="what-to-upload-for-quick-analysis"></a>
## O que enviar para análise rápida

Melhor pacote:

```text
runtime/final_logs/YYYY-MM-DD/
```

Pacote mais completo:

```text
runtime/forensic_days/YYYY-MM-DD/
```

Pacote de evidências completo:

```text
runtime/account_evidence.json
runtime/evidence/session_events.jsonl
runtime/server_lifecycle_events.jsonl
runtime/warning_events.jsonl
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

<a id="related-docs"></a>
## Documentos relacionados

* [`FORENSIC_DAILY_ROLLUPS.md`](ROLLUPS_DI%C3%81RIOS_FORENSES.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](REFER%C3%8ANCIA_DO_ESQUEMA_DE_SA%C3%8DDA.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](FLUXO_DE_TRABALHO_DE_REVIS%C3%83O_DO_JOGADOR.md)
