<a id="bad-actor-patterns-and-resilience"></a>
# Padrões e resiliência de atores mal-intencionados

> **Fonte canônica em inglês:** [BAD_ACTOR_PATTERNS_AND_RESILIENCE.md](../../BAD_ACTOR_PATTERNS_AND_RESILIENCE.md). Essa documentação localizada preserva comandos, caminhos, chaves, valores de status, hashes e nomes de arquivos exatos. Se o texto técnico for diferente, use a fonte em inglês.


Use esta página para entender como o protetor ajuda a analisar o abuso de falhas, o comportamento adjacente à exploração e o planejamento de recuperação.

<a id="what-the-guard-can-help-with"></a>
## Em que o protetor pode ajudar

| Padrão | O que verificar |
|---|---|
| Retornos correlacionados a falhas | Mesma conta ativa antes das falhas e retornando após a reinicialização |
| Investigação de reconexão rápida | Loops join/leave ou timeout/reconnect repetidos |
| Clusters de várias contas | Ondas de junção, janelas de aviso compartilhadas, janelas de falha compartilhadas |
| Estresse de explosão de aviso | Loops ActorChannelFailure ou janelas de aviso de salvamento |
| Contexto fora dos limites | PlayerData/map/world contexto quando legível |
| Sobreposição de toque para salvar | Sessões mapeadas sobrepostas de contexto para salvar o mundo |
| Confusão de identidade | Nomes que precisam de mapeamento ConnectID |

<a id="why-it-avoids-memory-access"></a>
## Por que evita o acesso à memória

RandomDayGuard funciona a partir de arquivos de propriedade do servidor:

```text
Saved/Logs/*.log
Admin.ini
World saves
PlayerData
Backups
runtime evidence
```

Isso o torna menos dependente do estado da memória do lado do cliente e menos frágil nas atualizações do jogo.

Compensação:

```text
It cannot prove hidden live actions unless the server writes evidence.
```

<a id="crash-correlated-returners"></a>
## Retornadores correlacionados a falhas

Padrão:

```text
Account joins.
Server crashes or restarts.
Same account reconnects quickly.
Pattern repeats.
```

Arquivos úteis:

```text
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/account_evidence.json
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="rapid-reconnect-probers"></a>
## Rápido reconectar sondadores

Padrão:

```text
join -> leave -> join -> leave -> join
```

Arquivos úteis:

```text
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/players.tsv
```

<a id="multi-account-clusters"></a>
## Clusters de várias contas

Padrão:

```text
Several accounts join in the same window.
Warnings or crashes follow.
Some accounts rotate or reconnect after restart.
```

Arquivos úteis:

```text
runtime/raid_cases/
runtime/forensic_days/YYYY-MM-DD/raid_cases.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

Regra:

```text
A cluster is not a mass-ban list.
Each account still needs its own evidence.
```

<a id="sticky-backup-recommendation"></a>
## Recomendação de backup fixo

Criar um backup fixo após:

```text
first full baseline completes
object_registry.json exists
file_manifest.tsv exists
world_state_latest.json has scan_complete=true
Admin.ini is verified
trusted IDs are configured
```

Backup:

```text
RandomDayGuard/config.lua
RandomDayGuard/SavedRoot.txt
RandomDayGuard/runtime/baselines/
RandomDayGuard/runtime/object_registry.json
RandomDayGuard/runtime/world_state/current/world_state_latest.json
Saved/SaveGames/Server/Admin.ini
```

<a id="recovery-model"></a>
## Modelo de recuperação

```text
Clean install
-> verify live defense
-> complete first baseline
-> create sticky backup
-> run server normally
-> use daily rollups for review
-> restore sticky backup if needed
```

<a id="related-docs"></a>
## Documentos relacionados

* [`FORENSIC_DAILY_ROLLUPS.md`](ROLLUPS_DI%C3%81RIOS_FORENSES.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](FLUXO_DE_TRABALHO_DE_REVIS%C3%83O_DO_JOGADOR.md)
* [`WORLD_SAVE_FOLDER_CHANGES.md`](ALTERA%C3%87%C3%95ES_NAS_PASTAS_SALVAS_NO_MUNDO.md)
