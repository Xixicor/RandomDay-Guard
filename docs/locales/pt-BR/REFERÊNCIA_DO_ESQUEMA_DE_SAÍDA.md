<a id="output-and-state-schema-reference"></a>
# Referência de esquema de saída e estado

> **Fonte canônica em inglês:** [OUTPUT_SCHEMA_REFERENCE.md](../../OUTPUT_SCHEMA_REFERENCE.md). Essa documentação localizada preserva comandos, caminhos, chaves, valores de status, hashes e nomes de arquivos exatos. Se o texto técnico for diferente, use a fonte em inglês.


Este é o contrato canônico para arquivos gerados voltados para o operador. Somente ele possui caminhos de saída exatos, nomes de campos, valores permitidos, requisitos de linhagem e esquemas de rota. Os guias de procedimento estão vinculados aqui em vez de redefinir esses fatos.

A evidência do tempo de execução é oficial; um nome de arquivo, pulsação do agendador, relatório traduzido ou objeto de caixa de saída local não prova mais do que seus próprios campos e linhagem.

<a id="public-report-routes"></a>
## Rotas de relatório públicas

O trabalhador de relatório possui cinco rotas sob `runtime/final_logs/`:

| Rota | Contrato | `full` requisito | Significado de vazio esperado |
|---|---|---|---|
| `server_status` | Programador atual, log ativo, varredura pendente e estado de cobertura de origem. | Eventos boot/epoch/poll linhagem, novo log ativo, accounting/history gravações e JSON/TXT par. | Não usado para um ciclo atual íntegro; linhagem ausente é `missing`. |
| `daily_rollup` | Eventos day/window continuidade entre servidor, jogadores, casos, varredura e cobertura. | Terminal de contabilidade histórica suficiente para a rota e a prova do ciclo atual serem concluídas. | Nenhum jogador retido e nenhum caso de revisão. |
| `player_activity` | Separar observações atuais e históricas player/account. | Prova do ciclo atual mais uma ou mais current/historical linhas. | Nenhuma linha de jogador elegível em entradas limitadas; nenhum assunto sintético. |
| `case_review` | Casos retidos nomeados e review/BAN-ELIGIBLE candidatos atuais. | Prova do ciclo atual mais um ou mais casos nomeados com referências de origem. | Nenhum caso nomeado atendeu aos critérios de revisão; nenhum caso sintético. |
| `critical_guard` | Agendador de inicialização atual, inicialização, pesquisa ou falha de integridade de evidência. | Prova do ciclo atual mais uma falha crítica atual. | Nenhuma falha crítica atual; erros de texto antigos não possuem esta rota. |

Cada rota habilitada grava `<route>_latest.json` e `<route>_latest.txt`. O par não é concluído até que `runtime/final_logs/route_proof.json` registre a mesma versão, inicialização, época, pesquisa e atualização de origem.

<a id="report-json-schema"></a>
## Relatar JSON esquema

Todos os caminhos JSON usa `schema="randomdayguard.report/v1"`.

| Campo | Tipo | Significado e invariante |
|---|---|---|
| `schema` | string | Exatamente `randomdayguard.report/v1`. |
| `generated_ts`, `report_date` | string | Carimbo de data/hora de geração e data de relatório. |
| `version` | string | Runtime/package identidade para este ciclo. |
| `boot_id`, `epoch_id` | string | Época atual de inicialização do processo e continuidade do servidor. Ambos são necessários para a conclusão. |
| `poll_id` | inteiro | Identificador de pesquisa atual positivo. Zero/missing não é possível completar uma rota. |
| `source_freshness` | objeto | `status`, `checked_ts`, status do log ativo, carimbo de data/hora da última pesquisa e carimbo de data/hora da última pesquisa concluída. |
| `current_cycle_proof_complete` | booleano | Verdadeiro somente quando a linhagem e active-log/current-poll evidências recentes concordam. |
| `route` | enum | Uma das cinco rotas acima. |
| `route_proof_status` | enum | `full`, `limited_expected_empty`, ou `missing`. |
| `coverage_status` | enum | Exatamente `complete`, `complete_with_gaps`, `partial`, ou `unavailable`. |
| `completed`, `expected_empty` | booleano | `completed` é falso apenas para `missing`; `expected_empty` é verdadeiro apenas para `limited_expected_empty`. |
| `observed` | matriz de strings | concreto retido facts/counts/statuses. |
| `interpretation` | matriz de strings | significado cauteloso calibrado para a evidência. |
| `unknown` | matriz de strings | falta de identidade, histórico, origem ou contexto. |
| `does_not_prove` | matriz de strings | Conclusões que as evidências não podem suportar. |
| `next_action` | string | Ação limitada mais segura do operador. |
| `source_references` | matriz de strings | Referências runtime/Saved exclusivas classificadas. |
| `enforcement_authority` | booleano | Sempre falsas. Um relatório nunca autoriza uma gravação. |
| `output_paths` | duas strings | JSON e TXT de rota adicionados antes das gravações emparelhadas. |

`coverage_status` é apenas contabilidade de nível superior. Registros de origem próprios separadamente `available`, `expected_empty`, `partial`, `deferred`, `unavailable`, `malformed`, `permission_denied` e `error`. A prova de rota possui separadamente `full`, `limited_expected_empty` e `missing`; os valores nunca ultrapassam esses limites.

Extensões de rota:

- `server_status`: `scheduler_status`, `active_log_status` e `server_metrics`. As métricas registram o início da época atual, o carimbo de data e hora da última pesquisa concluída e o ID, a contagem de jogadores ativos, active/backup-log contagens, valores de varredura pending/progress e configured/usable/unavailable contabilidade do grupo de origem. Eles não inventam tempo de atividade, contagens de reinicialização, registros de data e hora de backup ou duração de interrupção quando nenhuma fonte expõe esses fatos.
- `player_activity`: `player_activity_present`, `movement`, `same_day_sessions`, `current_player_count`, `current_evidence_player_count`, `historical_player_count`, `historical_session_count`, `current_players`, `historical_players` e matriz de compatibilidade `players`. Cada sessão do mesmo dia mantém seu ID de sessão, ID de conta, nome de exibição quando conhecido, join/leave carimbos de data/hora, sinalizadores de saída limpa e ciclo de vida e referências de origem. A identidade e a PlayerData presença retidas permanecem no contexto, e não como prova de atividade atual.
- `case_review`: `cases`, `review_subjects`, `current_case_count` e `retained_case_count`. Um assunto de revisão atual registra seu case/account ID, nome de exibição quando conhecido, status, pontuação, confiança de identidade, first/last observação, contagens de avisos, motivos, sinalização atual e referências de origem. Os casos retidos não criam um assunto atual por si só.
- `critical_guard`: `critical_failure_present` e `current_boot_error_only=true`.
- `daily_rollup`: `daily_maturity`, `once_per_day_continuity`, `dedupe_window` e `daily_metrics`. As métricas registram a data do relatório, jogadores ativos, contas com atividade no mesmo dia, ingressões, saídas, saídas limpas e não limpas, retornos do ciclo de vida, assuntos de revisão nomeados atualmente, casos retidos, current/retained contagens de identidade e cobertura do grupo de origem.

<a id="translated-txt-schema"></a>
## Traduzido TXT esquema

O arquivo de texto emparelhado leva ao resultado legível pelo operador e move os detalhes da linhagem para o fim. Ele preserva esta ordem exata de seção:

```text
RandomDayGuard <route title>
Generated: <timestamp>

Summary
<one plain-language route summary>

What Guard observed
- ...

What it means
- ...

What remains unknown
- ...

Recommended next step
...

Evidence boundary
- ...

Rating explanation
- ...

Technical record
- Route: <route>
- Version: <version>
- Cycle: boot=<boot> epoch=<epoch> poll=<poll>
- Source freshness: <status>
- Route result: <full|limited_expected_empty|missing>
- Coverage: <status>

Translation notes
- ...

Source references
- ...
```

A tradução usa apenas os campos estruturados do relatório e os mapeamentos de dicionário aprovados. Ele não pode adicionar participantes, casos, entrega, causalidade, propriedade, intenção ou elegibilidade de execução ausentes do relatório estruturado. Os detalhes técnicos permanecem disponíveis sem substituir o resultado legível.

<a id="source-accounting-schema"></a>
## Esquema de contabilidade de origem

`runtime/final_logs/source_accounting_latest.json` usa `randomdayguard.source-accounting/v1` com geração reason/status, enablement/disabled razão, current/historical distinção, manifesto de arquivo alterado, registros de origem, usable/unavailable listas de classes e um limite de reivindicação.

Cada registro de origem contém:

| Campo | Tipo | Significado |
|---|---|---|
| `source_class` | string | Uma das oito classes abaixo. |
| `scope` | `current` ou `historical` | Propriedade do tempo; os escopos nunca são mesclados silenciosamente. |
| `required` | booleano | Somente `active_log` é necessário para a atualização da rota do ciclo atual. |
| `status` | enum | Resultado da fonte listado abaixo. |
| `terminal` | booleano | Falso apenas para `partial` e `deferred`. |
| `available`, `readable` | booleano | Verdadeiro apenas para `available` e `expected_empty`. |
| `file_count` | inteiro | Limite contabilizado file/reference contagem. |
| `source_references` | array | Fonte única classificada paths/references. |
| `detail` | string | Resultado limitado ou detalhes do erro. |
| `does_not_prove` | string | Disponibilidade não é prova de intenção, propriedade, dano, duplicação ou aplicação. |

Classes de origem:

| Classe de origem | Escopo | O que contribui | O que não pode provar |
|---|---|---|---|
| `active_log` | atual, obrigatório | Registro legível do servidor ativo e linhagem de pesquisa recente. | Histórico completo ou culpabilidade do jogador. |
| `admin_ini` | atual, opcional | estado atual moderator/ban estruturalmente válido ou ausência esperada. | Comportamento do jogador ou metadados de motivo válido. |
| `recent_backup_logs` | histórico | referências de registro rotated/backup legíveis. | Presença atual ou estado de inicialização atual. |
| `playerdata_filenames` | contexto atual | Referências de nome de arquivo legíveis e delimitadas na raiz salva selecionada. | Propriedade de arquivo, presença ao vivo, conteúdo de identidade ou má conduta. |
| `existing_cases` | histórico | Registros de casos nomeados retidos files/index capturados antes das saídas atuais. | Atividade atual ou correção de conclusões antigas. |
| `existing_reports` | histórico | Relatório final/forensic/warning retido referências. | Substituição de fonte autorizada. |
| `existing_evidence` | histórico | Referências de evidências retidas. | Completude de eventos que o servidor nunca expôs. |
| `world_save_scan` | histórico | Estado completo, parcial, adiado ou indisponível scan/checkpoint. | Ação ou propriedade de um jogador específico. |

Valores de status de origem:

| Status | Terminal | Significado e ação do operador |
|---|---:|---|
| `available` | sim | Fonte útil legível existe; revise suas referências. |
| `expected_empty` | sim | A fonte opcional foi verificada e legitimamente absent/empty. Não invente dados. |
| `partial` | não | O trabalho limitado ou o limite de estoque estão incompletos; permitir retomada. |
| `deferred` | não | O trabalho está intencionalmente pendente; espere pelo trabalhador proprietário. |
| `unavailable` | sim | Source/path/tool está ausente ou inutilizável; repare apenas se necessário pela rota. |
| `malformed` | sim | O conteúdo falhou na validação estrutural; preserve-o e repare o formato. |
| `permission_denied` | sim | O acesso foi explicitamente negado; restaurar o acesso de leitura com privilégio mínimo. |
| `error` | sim | Limite de nível de origem probe/read falhou inesperadamente; inspecionar `detail` sem expor segredos. |

O nível superior `coverage_status` é exatamente `complete`, `complete_with_gaps`, `partial`, ou `unavailable`. Um `error`, `malformed`, ou `permission_denied` de nível de origem obrigatório é acumulado para `unavailable` de nível superior; nível de origem `deferred` de nível de origem obrigatório é acumulado para `partial`. Desativar a contabilidade de origem ainda grava um status indisponível e força todas as rotas para o `missing`.

<a id="historical-status-schema"></a>
## esquema de status histórico

`runtime/final_logs/historical_backfill_latest.json` usa `randomdayguard.history/v1`: `generated_ts`, a contabilidade `status`, `resumable=true`, `changed_file_refresh=true`, `current_evidence_is_not_history=true`, a matriz de contabilidade de origem, as classes indisponíveis e um `next_action`.

`runtime/history/public_accounts.tsv` histórico público durável limitado com este cabeçalho:

```text
account_id	ban_id	display_name	identity_confidence	status	score	first_seen	last_seen	source_references
```

As linhas são classificadas por ID da conta, os campos são single-line/tab-safe e as referências são sorted/unique. Este arquivo preserva o contexto histórico durante reinicializações silenciosas; ele nunca converte o histórico em presença atual.

<a id="route-proof-schema"></a>
## Esquema de prova de rota

`runtime/final_logs/route_proof.json` usa `randomdayguard.route-proof/v1` e registra carimbo de data/hora de geração de nível superior, versão, inicialização, época, pesquisa, atualização de origem, conclusão do ciclo atual, status permitidos e uma matriz `routes`.

Cada entrada de rota contém route/status, version/boot/epoch/poll, objeto de atualização de origem, ciclo atual integridade, caminhos de saída e referências de origem. Uma rota desabilitada registra `status="missing"` e `reason="route_disabled"`. Se a gravação à prova de rota falhar, cada rota será reescrita como incomplete/missing antes que qualquer candidato a notificação seja aceito.

<a id="notification-schemas"></a>
## Esquemas de notificação

O modo público opcional é apenas caixa de saída de arquivo local.

`runtime/notifications/pending/<route>_latest.json` usa `randomdayguard.notification/v1` com carimbo de data/hora gerado, version/boot/epoch/ poll/source atualização, rota, `completed_output`, status de prova de rota, caminhos de relatório estruturados e traduzidos, referências de origem, `delivery_backend="none"` e `delivery_attempted=false`. A saída qualificada usa `status="ready_for_local_consumer"`, `delivery_eligible=true` e `delivery_allowed=true`. Uma rota configurada, mas missing/ineligible ainda grava um envelope de auditoria com `status="suppressed_current_cycle"`, ambos os sinalizadores de entrega falsos, e `suppression_reason="route_or_completion_policy_blocked"`. Portanto, a presença de um arquivo em `pending/` não significa por si só enfileirado ou elegível.

`runtime/notifications/notification_status.json` usa `randomdayguard.notification-status/v1` com a mesma linhagem, `generic_local_outbox_only=true`, `delivery_attempted=false` e linhas `queued`/`outcome` por rota. `full` é elegível; esperado-vazio é elegível somente quando `include_expected_empty=true`; `missing` nunca é elegível. Em uma falha de gravação à prova de rota, o resultado do status é `route_proof_write_failed`; um envelope de auditoria suprimido ainda pode ser escrito, mas não é um resultado aceito.

<a id="runtime-output-inventory"></a>
## Inventário de saída de tempo de execução

O índice de rastreabilidade possui uma linha de máquina para cada caminho ou classe de arquivo dinâmico. Este inventário legível agrupa arquivos por finalidade do operador.

| Caminho ou padrão | Producer/trigger | Política e estados úteis | Failure/recovery |
|---|---|---|---|
| `runtime/loader_probe.txt`, `runtime/loader_probe.json` | Entrada do carregador. | Inicialização substituída identity/probe. | Ausência não prova carga; inspecionar UE4SS registros e ativação. |
| `runtime/config_load_error.txt` | Falha no carregamento de configuração. | Somente erro, preserva o motivo limitado. | Restaure a configuração pública válida e reinicie. |
| `runtime/saved_path_probe.json` | Resolução de raiz salva. | Candidate/readability limitada. | Definir `SavedRoot.txt` ou repare um candidato genérico. |
| `runtime/startup_status.json`, `runtime/startup_error.txt`, `runtime/current/startup_error.json` | Ciclo de vida de inicialização. | Erro de inicialização mais recente e de inicialização atual. | Apenas a inicialização correspondente possui status crítico atual. |
| `runtime/runtime_version.json`, `runtime/runtime_capabilities.json`, `runtime/public_pipeline_status.json` | Startup/report integração. | Mais recente version/capability/handoff. | Desvio de versão ou capacidade bloqueia reivindicações de conclusão. |
| `runtime/poll_status.json`, `runtime/current/poll_status.json`, `runtime/poll_error.txt`, `runtime/current/poll_error.json` | Poll finalizer/error. | Mais recente poll/scheduler/in-flight estado e erro de inicialização atual. | Repare o retorno de chamada limitado e exija uma pesquisa concluída mais recente. |
| `runtime/logs/current.jsonl`, `runtime/raw_events.jsonl` | Registrador de eventos. | Limited append/rotation. | Preservar bytes anteriores; reparar disk/retention antes de confiar em lacunas. |
| `runtime/log_offsets.tsv`, `runtime/log_registry.json` | Registre tail/registry. | Deslocamentos mais recentes e identidades de log canônicas. | Reconstrua com cuidado; os logs de backup permanecem históricos. |
| `runtime/log_continuity_events.jsonl`, `runtime/evidence/log_continuity_events.jsonl`, `runtime/server_lifecycle_events.jsonl`, `runtime/evidence/lifecycle_events.jsonl` | Continuity/lifecycle normalizador. | Contexto apenas de acréscimo. | O contexto ausente não pode provar graceful/crash. |
| `runtime/current_server_epoch.json`, `runtime/server_epochs.jsonl`, `runtime/epochs/**` | Proprietário da época. | Épocas de servidor atuais mais retidas. | Iniciar uma nova época após o reparo; não reescreva o histórico antigo. |
| `runtime/session_events.tsv`, `runtime/evidence/session_events.jsonl`, `runtime/sessions/**` | Proprietário da sessão. | Current/historical eventos e instantâneos da sessão. | As linhas não mapeadas permanecem desconhecidas; sem invenção de identidade. |
| `runtime/account_evidence.tsv`, `runtime/account_evidence.json`, `runtime/history/public_accounts.tsv` | Account/session módulo de agregação e relatórios. | Snapshot atual mais histórico durável. | Mantenha os escopos separados e restaure a partir de evidências, não de suposições. |
| `runtime/current/session_state.json`, `runtime/current/active_accounts.json`, `runtime/current/spatial_context.json`, `runtime/current/actor_touch_rollup.json` | Poll/current-state gravadores. | Snapshots atuais sobrescritos. | Stale/missing é desconhecido, não esperado vazio. |
| `runtime/days/**`, `runtime/weeks/**` | Daily/weekly agregação. | Índices reconstruíveis. | Reconstruir a partir de eventos autoritativos. |
| `runtime/scan_started.json`, `runtime/scan_progress.json`, `runtime/scan_checkpoint.json`, `runtime/scan_complete.json`, `runtime/scan_error.txt` | Trabalhador de verificação. | Iniciado, partial/deferred, ponto de verificação, conclusão ou erro. | Retomar ponto de verificação; reconstruir apenas com motivo registrado. |
| `runtime/baselines/last_scan.json`, `runtime/baselines/last_completed_baseline.json`, `runtime/baselines/file_manifest.tsv` | Trabalhador de linha de base. | Mais recente scan/baseline e vinculação de arquivo alterado. | Stale/incompatible manifestos requerem uma reconstrução explícita. |
| `runtime/object_registry_partial.json`, `runtime/object_registry_counts_partial.tsv`, `runtime/object_registry.json`, `runtime/object_registry_counts.tsv` | Verificação de objetos. | Partial/final contexto de classe. | As contagens não são à prova de ação do jogador; retomar ou reconstruir a verificação. |
| `runtime/new_classes_detected.jsonl`, `runtime/class_deltas.jsonl` | Comparação de objetos. | Apenas new/delta parcial e depois final. | Revisão mapping/baseline antes da inferência. |
| `runtime/playerdata_index.json`, `runtime/admin_state.json` | Índices de raiz salva. | Filename/admin contexto da estrutura. | Os nomes dos arquivos são fracos; estado administrativo malformado fecha gravações. |
| `runtime/world_state/boot/**`, `runtime/world_state/current/world_state_latest.json`, `runtime/world_state/sessions/**` | Escritor de estado mundial. | Boot/current/session snapshots e diferenças. | Somente contexto; regenerar após scan/source reparo. |
| `runtime/warning_events.jsonl`, `runtime/warnings/**`, `runtime/evidence/critical_events.jsonl`, `runtime/evidence/high_events.jsonl`, `runtime/evidence/medium_events.jsonl` | Warning/evidence gravadores. | Anexação delimitada e per-player/session arquivos de revisão. | Relatório ausente não é prova de evento ausente; inspecionar evidências de origem. |
| `runtime/raid_cases/**`, `runtime/raid_cases/index.jsonl`, `runtime/ban_queue.json` | Case/review agregação. | Material de revisão nomeado e candidatos na fila. | Caso membership/threshold nunca ignora portões específicos da conta. |
| `runtime/backups/Admin_*.ini`, `runtime/enforced.txt`, `runtime/enforced_bans.jsonl`, `runtime/evidence/enforced_bans.jsonl`, `runtime/evidence/enforcement_failed_*` | Transação Admin.ini opcional. | Backup, registro de sucesso ou failure/rollback evidências citadas. | qualquer falha backup/write/readback/rollback explícita fecha a aplicação; restaurar backup. |
| `runtime/request_restart.flag`, `runtime/restart_reason.json` | Escritor de marcador opcional. | Somente solicitação local. | Não comprova consumo ou reinicialização. |
| `runtime/current/forensic_today.json`, `.md`, `.txt`, `runtime/forensic_days/YYYY-MM-DD/**`, `runtime/final_logs/YYYY-MM-DD/**` | Acúmulo forense. | Índices de revisão reconstruíveis atuais e datados. | Reconstruir a partir da fonte evidências; nunca trate o resumo como autoridade. |
| `runtime/final_logs/source_accounting_latest.json`, `historical_backfill_latest.json`, `<route>_latest.json`, `<route>_latest.txt`, `route_proof.json` | Trabalhador de relatório público. | Esquemas e regras de conclusão acima. | Repare primeiro a incompatibilidade lineage/source/write; faltando permanece faltando. |
| `runtime/notifications/pending/<route>_latest.json`, `runtime/notifications/notification_status.json` | Caixa de saída local opcional. | Envelope local mais qualificado ou explicitamente suprimido mais status. | Missing/ineligible rotas podem ter arquivos suprimidos, mas nunca são enfileiradas; inspecionar sinalizadores de entrega e inferir que não há entrega externa. |

Overwrite/append/retention o comportamento é controlado pela seção de produção em [`CONFIG_FIELD_CATALOG.md`](CAT%C3%81LOGO_DE_CAMPOS_DE_CONFIGURA%C3%87%C3%83O.md). Os ZIPs de pacotes contêm apenas `.gitkeep` vazios em `runtime/`; qualquer evidence/output byte em um pacote de lançamento falha na validação.

<a id="failure-and-recovery-matrix"></a>
## Matriz de falha e recuperação

| Falha | Estado necessário | Recuperação segura | Inferência inválida |
|---|---|---|---|
| Linhagem atual absent/stale | Todas as rotas `missing`. | Restaurar active-log/current-poll comprovar e regenerar. | Arquivos de rota antigos não estão concluídos no momento. |
| Fonte opcional esperada vazia | Fonte `expected_empty`; a rota elegível pode ser `limited_expected_empty`. | Sem reparo, a menos que a fonte exista. | Vazia não está indisponível e não prova ausência histórica. |
| Verificação incompleta | Fonte `partial` ou `deferred`. | Permitir retomada limitada; manter explícita a política de rota atual. | Parcial não é corrupção. |
| Fonte necessária indisponível | `coverage_status=unavailable`; rotas dependentes `missing`. | Reparar acesso Saved/log selecionado. | Outras fontes íntegras não substituem a fonte necessária. |
| Erros de investigação de origem necessários | Status da fonte `error` com `detail`; `coverage_status=unavailable`; rotas dependentes `missing`. | Repare o source/probe nomeado e gere um ciclo mais recente. | Um erro de origem não é um quinto valor de cobertura de nível superior. |
| Falha na gravação do relatório emparelhado | `coverage_status=unavailable`; a rota converge para `missing`. | Reparar o sistema de arquivos e reescrever ambos os membros do par mais a prova. | Um arquivo irmão não está completo e a falha de gravação não é de nível superior `error`. |
| A gravação à prova de rota falha | Todas as rotas reescritas estão faltando; nenhuma caixa de saída qualificada; rotas configuradas podem receber envelopes de auditoria suprimidos. | Reparar gravação à prova de rota e regenerar saídas do mesmo ciclo. | Relatório de aparência válida JSON ou um envelope suprimido não é à prova de rota. |
| Falha na gravação de notificação | Resultado `local_outbox_write_failed`. | Reparar saída local raiz; regenerar a partir do relatório concluído. | Nenhuma entrega externa ocorreu. |
| Admin.ini transação falha | Aplicação bloqueada com backup/write/readback/rollback evidências citadas. | Restauração de backup verificado; permanecem apenas para revisão. | Um limite ou relatório não pode justificar ignorar a recuperação. |

Consulte [`EVIDENCE_BOUNDARY.md`](LIMITE_DE_EVID%C3%8ANCIAS.md), [`ARCHITECTURE.md`](ARQUITETURA.md) e [`SOURCE_MODULE_REFERENCE.md`](REFER%C3%8ANCIA_DO_M%C3%93DULO_DE_ORIGEM.md).
