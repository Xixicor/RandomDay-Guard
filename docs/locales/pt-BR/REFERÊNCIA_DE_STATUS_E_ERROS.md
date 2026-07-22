<a id="status-and-error-reference"></a>
# Status e referência de erro

> **Fonte canônica em inglês:** [STATUS_AND_ERROR_REFERENCE.md](../../STATUS_AND_ERROR_REFERENCE.md). Essa documentação localizada preserva comandos, caminhos, chaves, valores de status, hashes e nomes de arquivos exatos. Se o texto técnico for diferente, use a fonte em inglês.


Use esta referência após um sintoma ter sido classificado em [Solução de problemas](SOLU%C3%87%C3%83O_DE_PROBLEMAS.md). Leia o arquivo de status estruturado nomeado pelo erro. Códigos distintos representam estados distintos de segurança e de ciclo de vida; não os reduza em um resultado genérico de "Falha no Guard".

<a id="route-and-source-states"></a>
## Rota e estados de origem

| Valor | Significado | Resposta do operador |
|---|---|---|
| `full` | O contrato de rota concluído com prova de origem do ciclo atual. | Leia o limite de evidências da rota; nenhum reparo está implícito. |
| `limited_expected_empty` | A rota concluída e a atividade ausente são legítimas para este ciclo. | Nenhum evento player/case sintético deve ser criado. |
| `missing` | Uma saída obrigatória, campo de linhagem ou prova de origem está ausente. | Inspecione o motivo da rota e o status da fonte nomeada. |
| `available` | A fonte nomeada estava legível e utilizável. | Não ação. |
| `expected_empty` | A fonte foi verificada e legitimamente não tinha linhas. | Nenhuma ação, a menos que a atividade fosse esperada de forma independente. |
| `partial` / `complete_with_gaps` | Existem evidências utilizáveis, mas as classes de origem nomeadas estão incompletas. | Limite as conclusões às evidências coletadas. |
| `deferred` | O trabalho vinculado é agendado para um trabalhador posterior. oportunidade. | Confirme os avanços do progresso antes de alterar a configuração. |
| `unavailable` | O ambiente não forneceu a fonte. | Registre o limite; corrija apenas um caminho comprovado ou problema de permissão. |
| `malformed` | A fonte era legível, mas falhou na validação estrutural. | Preserva-a e corrige a fonte; não adivinhe. |
| `permission_denied` | A fonte existe, mas não pôde ser lida. | Conceda apenas a permissão de leitura restrita necessária. |
| `error` | A coleta falhou pelo motivo registrado. | Preserve o erro e diagnostique esse estágio. |

<a id="playerdata-and-inventory-codes"></a>
## PlayerData e códigos de inventário

| Código | Significado | Resposta segura |
|---|---|---|
| `saved_root_unavailable` | Nenhuma raiz salva verificada estava disponível para o pipeline público. | Corrija `SavedRoot.txt` e verifique novamente a investigação do caminho. |
| `unsafe_playerdata_root` | PlayerData descoberta resolvida fora do raiz salva limitada. | Corrija o caminho; nunca enfraqueça o limite. |
| `playerdata_discovery_not_run` | O trabalho de descoberta limitado ainda não foi executado. | Verifique o agendador e o progresso do trabalho. |
| `playerdata_discovery_read_failed:*` | A saída da descoberta não pôde ser lida. | Preservar os detalhes do sufixo e verificar o comando de inventário limitado. |
| `inventory_command_open_failed` | O processo de inventário não pôde ser iniciado. | Verifique se o tempo de execução fornece a ponte de comando configurada. |
| `inventory_command_read_failed` | A saída do inventário falhou durante a leitura. | Preserva a saída parcial e execute novamente somente depois que o erro subjacente for corrigido. |
| `inventory_command_close_failed` | Inventário concluído sem um resultado de fechamento confiável. | Trate a origem como incompleto. |
| `identity_ledger_row_limit_exceeded` | A entrada de identidade durável excedeu seu limite de segurança pública. | Arquivar e revisar o livro-razão; não o trunque silenciosamente em uma prova completa. |

<a id="adminini-enforcement-codes"></a>
## Admin.ini códigos de aplicação

Todos os códigos nesta seção são fechados com falha. Eles não autorizam um banimento manual por si próprios.

| Código | Significado | Resposta segura |
|---|---|---|
| `admin_ini_write_disabled` / `admin_ini_disabled` | As portas de gravação de segurança pública estão desativadas. | Esperado em operação somente de revisão. |
| `admin_ini_backup_disabled` / `backup_safety_gate_disabled` | A política de backup necessária não está ativa. | Manter as gravações desativadas. |
| `enforcement_disabled` / `ban_on_threshold_disabled` / `auto_ban_disabled` | Uma porta de aplicação explícita é desativado. | Esperado em padrões somente para revisão pública; não o reinterprete como uma falha de gravação. |
| `review_only_mode_enabled` | O modo somente revisão bloqueia intencionalmente a mutação. | Revisar apenas evidências. |
| `duplicate_prevention_disabled` | A proteção duplicada foi desativada. | Mantenha as gravações desativadas até que a porta de segurança seja restaurada. |
| `readback_safety_gate_disabled` / `rollback_safety_gate_disabled` | A verificação pós-gravação ou a proteção contra reversão foram desativadas. | Manter gravações desativadas; nunca ignore esses portões. |
| `clean_id_safety_gate_disabled` / `account_specific_evidence_gate_disabled` | A limpeza de identidade ou a aplicação de evidências específicas da conta foram desativadas. | Restaure o portão antes de qualquer teste de aplicação. |
| `moderator_preservation_disabled` / `existing_ban_preservation_disabled` | A preservação da conta protegida ou do banimento existente foi desativada. | Manter as gravações desativadas. |
| `clean_numeric_identity_required` | O ID proposto não é o formulário de conexão aceito completo ou o ID numérico limpo. | Obter um mapeamento verificado; nunca trunque um prefixo arbitrário. |
| `identity_strength_below_minimum` | A evidência de identidade é mais fraca que o limite configurado. | Revisar apenas evidências. |
| `playerdata_verification_required` | A configuração requer PlayerData confirmação e a conta não a possui. | Manter o candidato apenas para revisão; não infira a propriedade a partir de um nome de arquivo. |
| `trusted_or_moderator_identity` | A conta é protegida pelo estado confiável ou moderador. | Nenhuma gravação é permitida. |
| `admin_ini_path_invalid` / `admin_ini_path_outside_saved_root` | O caminho de destino é inválido ou escapa da raiz salva. | Configuração correta; nunca ignore o guarda do caminho. |
| `admin_ini_unavailable` | Não legível configurado Admin.ini foi encontrado dentro da raiz salva. | Corrija o caminho limitado ou mantenha a aplicação desativada. |
| `admin_ini_read_failed` | Não foi possível ler os bytes autorizados. | Parar antes da mutação. |
| `admin_ini_parse_failed` | Admin.ini a validação falhou sem um código estrutural mais específico. | Preservar o arquivo e inspecionar sua seção e estrutura de linha. |
| `admin_ini_contains_nul` | O arquivo contém NUL bytes e não é aceito como texto. | Preservar o arquivo e repará-lo fora do Guard. |
| `admin_ini_duplicate_banned_players_section` | Existe mais de uma `[BannedPlayers]` seção. | Mesclar seções manualmente enquanto parado. |
| `admin_ini_banned_player_outside_section` | Uma linha de banimento aparece fora de `[BannedPlayers]`. | Corrija o layout manualmente. |
| `admin_ini_invalid_banned_player_line` | Uma linha de banimento não é exatamente uma linha de ID compatível e limpa. | Corrija a linha malformada. |
| `admin_ini_backup_failed` | O backup exclusivo não gravou e leu bytes de forma idêntica. | Nenhuma mutação é permitida. |
| `admin_ini_external_change_detected` | Outro gravador alterou o arquivo após o instantâneo do Guard. | Preservar os bytes externos e tentar novamente somente após coordenar os gravadores. |
| `atomic_rename_unavailable` | A substituição atômica foi solicitada, mas Lua não forneceu `os.rename`. | Nenhuma gravação é confiável; use um tempo de execução compatível ou mantenha a aplicação desativada. |
| `admin_ini_write_failed` | A substituição controlada não foi concluída. | Inspecione o erro de substituição registrado e faça backup. |
| `post_write_verification_failed` | Os bytes de produção não foram iguais ao candidato. | Verifique `rollback_success` e `rollback_refused_external_change` antes de qualquer ação. |

<a id="startup-scheduler-and-backlog-states"></a>
## Estados de inicialização, agendador e backlog

Esses valores são evidências do ciclo de vida, não prova de rota. Leia-os com os arquivos atuais de pesquisa, report-worker e prova de rota.

| Valor | Significado | Resposta segura |
|---|---|---|
| `not_started` | O estágio de inicialização ou agendador nomeado ainda não começou. | Durante a inicialização, aguarde o intervalo documentado; depois inspecione a primeira fase inalterada. |
| `main_lua_loaded` / `starting` | O carregador canônico foi executado e o Guard entrou na inicialização. | Continue para as fases posteriores; isso por si só não é prontidão. |
| `saved_root_found` / `log_tail_initialized` / `epoch_started` | Origem do núcleo e inicialização de continuidade avançadas. | Nenhuma ação a menos que a próxima fase pare de avançar. |
| `admin_state_written` / `playerdata_index_written` | Os índices limitados iniciais foram exportados. | Nenhuma ação; a transferência do agendador ainda deve ocorrer. |
| `watchdog_started` | O watchdog do relatório e da pesquisa foi registrado. | Em seguida, confirme o progresso do agendador e da pesquisa. |
| `ready_degraded` / `scan_running` | O Guard está em execução enquanto a verificação do histórico limitado permanece pendente. | Cuidado, não falha; verifique o avanço dos contadores de progresso. |
| `ready` | A inicialização e a varredura limitada atual atingiram o estado pronto. | Verifique a prova de rota separadamente. |
| `scan_failed` / `error` | Inicialização ou varredura finalizada com um erro registrado. | Preservar o erro nomeado ou arquivo de status e diagnosticar esse estágio. |
| `running` | O agendador possui futuras oportunidades de pesquisa. | Confirme `poll_id` e `poll_completed_count` advance. |
| `manual_only` | O agendamento do loop não estava disponível; somente trabalho explícito pode ser executado. | Trate a operação autônoma como indisponível. |
| `stopped` | A operação do agendador foi encerrada. | Inspecione a parada anterior e as evidências de erro antes de reiniciar. |
| `active_log_caught_up` | Nenhum backlog de log ativo não lido permanece. | A verificação histórica pode ser executada. prossiga. |
| `active_log_unavailable_nonblocking` | O log ativo estava ausente, mas a inicialização permaneceu sem bloqueio. | Registre o limite de origem e verifique outras fontes. |
| `active_log_read_failed` | O log ativo existia, mas não pôde ser lido. | Preserve o erro e corrija apenas o caminho comprovado ou o problema de permissão. |
| `budget_exhausted` / `active_log_has_unread_bytes` | A passagem final limitada foi interrompida com o backlog restante. | Confirme que as pesquisas posteriores reduzem o não lido contagem. |
| `offset_commit_failed_after_events_applied` | Os eventos foram processados, mas a persistência do deslocamento de log durável falhou. | A aplicação foi adiada; repare o armazenamento de deslocamento antes de confiar em outro ciclo. |

<a id="scheduler-report-and-notification-codes"></a>
## Programador, relatório e códigos de notificação

| Código ou status | Significado | Resposta segura |
|---|---|---|
| `poll already in flight` | Um segundo retorno de chamada chegou enquanto a pesquisa atual possuía o ciclo de vida. | Confirme os avanços da pesquisa existentes; não adicione outro proprietário de loop. |
| `no_log_files_found` | Nenhum log ativo ou de backup configurado foi descoberto. | Verifique a configuração raiz e de origem salva. |
| `current_poll_error` | O ciclo atual registrou uma falha na origem da pesquisa. | Ler `runtime/current/poll_error.json`. |
| `cadence_deferred` | O despachante de conclusão ainda não venceu. | Esperado até a próxima oportunidade limitada. |
| `reports_disabled` | A geração de relatórios públicos está desativada. | Ativar apenas se os relatórios forem pretendidos. |
| `local_outbox_write_failed` | Não foi possível gravar um envelope local traduzido. | Reparar o diretório de saída do tempo de execução; este não é um erro de transporte de notificação. |
| `source_accounting_disabled` | A prova de rota não pode reivindicar cobertura completa da fonte. | Ative a contabilidade de origem ou aceite explicitamente a prova ausente. |
| `route_disabled` | A rota foi desativada intencionalmente. | Nenhuma entrega é esperada para essa rota. |
| `poll_owner_between_polls` | O trabalhador de relatório está na fila para o intervalo de propriedade do agendador entre as pesquisas. | Esperado apenas enquanto os carimbos de data e hora e os cursores continuam avançando. |
| `unsafe_shell_path` | Um inventário limitado ou caminho de shell falhou na validação segura da plataforma. | Corrija o caminho; nunca enfraqueça a cotação ou a validação de caminho. |

<a id="related-procedures"></a>
## Procedimentos relacionados

- [Solução de problemas](SOLU%C3%87%C3%83O_DE_PROBLEMAS.md) para classificação e reparo de sintomas.
- [Validação e revisão de lançamento](VALIDA%C3%87%C3%83O_E_LIBERA%C3%87%C3%83O.md) para falhas de equipamentos e pacotes.
- [Referência do esquema de saída](REFER%C3%8ANCIA_DO_ESQUEMA_DE_SA%C3%8DDA.md) para contratos de campo completos.
