<a id="forensic-daily-rollups"></a>
# Rollups diários forenses

> **Fonte canônica em inglês:** [FORENSIC_DAILY_ROLLUPS.md](../../FORENSIC_DAILY_ROLLUPS.md). Essa documentação localizada preserva comandos, caminhos, chaves, valores de status, hashes e nomes de arquivos exatos. Se o texto técnico for diferente, use a fonte em inglês.


O rollup diário é um índice reconstruível. A evidência da fonte permanece confiável; a pasta diária e o log final são pacotes de revisão rápida gerados a partir de evidências de tempo de execução.

Use esta página quando desejar fazer upload de uma pasta para análise rápida.

<a id="what-it-is"></a>
## O que é
O rollup diário é um resumo reconstruível da evidência bruta de um dia.

Ele não substitui a evidência bruta.

```text
Source evidence = truth
Daily rollup = fast index
Final log = plain-language summary
```

<a id="where-it-writes"></a>
## Onde escreve
Dia atual:

```text
runtime/current/forensic_today.json
runtime/current/forensic_today.md
runtime/current/forensic_today.txt
```

Pacote diário:

```text
runtime/forensic_days/YYYY-MM-DD/
- forensic_day_summary.json
- forensic_day_summary.md
- forensic_day_summary.txt
- players.tsv
- sessions.tsv
- crash_reconnects.tsv
- warning_bursts.tsv
- raid_cases.tsv
- world_context.tsv
- ban_recommendations.tsv
- enforcement_audit.tsv
- evidence_index.json

## Final log contents
```text
runtime/final_logs/YYYY-MM-DD/
- final_forensic_log.txt
- final_forensic_log.md
- final_forensic_log.json

O TXT é escrito em linguagem simples para revisão rápida do operador.

<a id="what-the-final-txt-should-answer"></a>
## O que o TXT final deve responder
```text
Did the guard run?
Was the scan partial or complete?
Who joined?
Who left cleanly?
Who did not leave cleanly?
Who rapidly reconnected?
Who overlapped crashes?
Who returned after crashes?
Who had warning overlap?
Who appears in a cluster?
Who is REVIEW?
Who is BAN-ELIGIBLE?
Which BannedPlayer=<ID> lines are candidates?
Which gates blocked enforcement?
What evidence files support each recommendation?
```

<a id="source-files-used"></a>
## Arquivos de origem usados
O rollup pode lê-los quando presentes:

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/evidence/live_defense_events.jsonl
runtime/warning_events.jsonl
runtime/raid_cases/
runtime/world_state/current/world_state_latest.json
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/scan_complete.json
runtime/object_registry.json
runtime/enforced_bans.jsonl
runtime/enforced.txt
runtime/ban_queue.json
```

Arquivos ausentes devem ser marcados como ausentes, não tratados como fatais.

<a id="update-behavior"></a>
## Comportamento de atualização
No mesmo dia, o guarda atualiza os mesmos arquivos.

Correto:

```text
runtime/forensic_days/2026-05-13/forensic_day_summary.json
```

Errado:

```text
forensic_day_summary_1.json
forensic_day_summary_2.json
forensic_day_summary_3.json
```

<a id="crash-safety"></a>
## Crash-safety
O guarda deve gravar os arquivos temporários primeiro e depois renomeá-los:

```text
final_forensic_log.txt.tmp -> final_forensic_log.txt
players.tsv.tmp -> players.tsv
forensic_day_summary.json.tmp -> forensic_day_summary.json
```

Isso protege o último resumo válido se o servidor travar no meio da gravação.

<a id="playerstsv-columns"></a>
## `players.tsv` colunas
```text
date
account_id
ban_id
name
identity_confidence
playerdata_verified
first_seen
last_seen
join_count
leave_count
clean_leave_count
unclean_disconnect_count
rapid_rejoin_count
crash_overlap_count
post_crash_reconnect_count
warning_overlap_count
raid_case_count
world_context_count
score
status
recommended_action
ban_eligible
already_enforced
admin_ini_line
```

<a id="ban_recommendationstsv-columns"></a>
## `ban_recommendations.tsv` colunas
```text
date
account_id
ban_id
name
status
recommended_action
reason
admin_ini_line
gates_passed
blocked_by
evidence_files
```

<a id="review-rule"></a>
## Regra de revisão
Um rollup diário pode agilizar a revisão, mas não deve ser a única evidência.

Quando uma recomendação é importante, verifique com:

```text
account_evidence.json
session_events.jsonl
server_lifecycle_events.jsonl
warning_events.jsonl
world_state files
enforced_bans.jsonl
```

<a id="related-docs"></a>
## Documentos relacionados
* [`MEMORY_ECONOMY_AND_OUTPUTS.md`](ECONOMIA_DE_MEM%C3%93RIA_E_SA%C3%8DDAS.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](FLUXO_DE_TRABALHO_DE_REVIS%C3%83O_DO_JOGADOR.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](REFER%C3%8ANCIA_DO_ESQUEMA_DE_SA%C3%8DDA.md)
