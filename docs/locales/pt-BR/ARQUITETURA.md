<a id="architecture-and-lifecycle"></a>
# Arquitetura e ciclo de vida

> **Fonte canônica em inglês:** [ARCHITECTURE.md](../../ARCHITECTURE.md). Essa documentação localizada preserva comandos, caminhos, chaves, valores de status, hashes e nomes de arquivos exatos. Se o texto técnico for diferente, use a fonte em inglês.


RandomDayGuard é um UE4SS watchdog mais um módulo de relatório isolado. provedor, painel de controle, serviço de notificação, RandomDay ou dependência de rede.

<a id="end-to-end-data-flow"></a>
## Fluxo de dados ponta a ponta

1. UE4SS carrega o ponto de entrada canônico único `RandomDayGuard/Scripts/main.lua`. Os pacotes atuais não enviam uma duplicata de variante minúscula.
2. O carregador lê `config.lua`, os três dicionários de dados e `SavedRoot.txt` opcional. A identidade da versão deve estar de acordo com `VERSION`, `MANIFEST.json` e `BUILD_MARKER.txt`.
3. A descoberta de raiz salva verifica candidatos conhecidos limitados e arquivos conhecidos diretos. Ele registra o que estava legível em `runtime/saved_path_probe.json`; encontrar um diretório por si só não é cobertura de evidências.
4. A camada imediata segue o log do servidor ativo a partir de um deslocamento seguro. Ele normaliza o ciclo de vida, a sessão, a conta, o aviso, a reconexão e outros eventos observados em evidências somente anexadas, além de instantâneos atuais.
5. Os inventários da camada lenta Arquivos salvos em partes limitadas. Ele grava o progresso e os pontos de verificação, retoma o trabalho incompleto, compara um manifesto de arquivo alterado e produz um contexto object/world parcial e depois final.
6. A lógica de revisão correlaciona apenas as evidências disponíveis para ela. Nomes de arquivos fracos, tempo, contagens de classe, coordenadas relativas, rotatividade, uma única falha ou ping permanecem no contexto e não podem autorizar a aplicação por si só.
7. Um trabalhador de relatório separado chama `Scripts/public_pipeline.lua`. Ele inventaria classes de origem, registra o escopo atual versus histórico, vincula o ciclo à version/boot/epoch/poll/source atualização, grava cinco pares JSON/TXT específicos da rota e, em seguida, grava `route_proof.json`.
8. Quando explicitamente ativado, a caixa de saída local copia referências de um relatório concluído após a prova de rota existir. Ele registra `delivery_backend="none"` e `delivery_attempted=false`; o transporte está fora deste produto.

<a id="ownership-and-asynchronous-boundaries"></a>
## Propriedade e limites assíncronos

| Proprietário | Trabalho limitado | Não deve bloquear ou implicar |
|---|---|---|
| Inicialização | Configuração, raiz salva, log ativo, época, índices, status inicial. | Um marcador de carregador bem-sucedido não prova evidências ou rotas. |
| Retorno de chamada de pesquisa | Novos bytes de log, atualizações de estado, event/session/account saídas, agendamento. | Descoberta ou relatório recursivo lento drenagem. |
| Trabalhador de verificação | Descoberta de manifesto, análise de arquivo, ponto de verificação, partial/final linha de base. | Progresso do registro atual; parcial não é falha. |
| Trabalhador de relatório | Contabilidade de origem, tradução, pares de relatórios, prova de rota, caixa de saída local. | Aplicação ou entrega externa. |
| Aplicação opcional | Confirme a conta e a pontuação, proteja contas confiáveis e duplicatas, verifique um backup, rejeite alterações externas no arquivo e verifique o resultado salvo. | Uma pontuação de relatório, status de rota ou associação de caso ignorando qualquer verificação de segurança necessária. |

O loop de pesquisa permanece íntegro apenas enquanto `poll_id` avança, `poll_in_flight` retorna falso e o agendamento permanece ativo. Isso prova o componente da enquete, não o pipeline do relatório. Varreduras lentas podem ser `partial` ou `deferred`; o padrão `slow_world_scan_blocks_current_reports=false` permite que novas rotas atuais continuem enquanto nomeia a limitação histórica.

<a id="state-and-lifecycle"></a>
## Estado e ciclo de vida

| Estado | Entrada | Terminal ou próximo estado | Erro e recuperação |
|---|---|---|---|
| Inicialização | UE4SS invoca o carregador. | Executar poll/scan/report trabalhadores com um ID de inicialização e época. | `startup_error` é uma evidência crítica de inicialização atual; reparar config/path/source e reiniciar. |
| Pesquisa atual | O retorno de chamada limitado programado começa. | Pesquisa concluída registra carimbo de data e hora e reprogramações. | `poll_error` é uma evidência crítica de inicialização atual; restaure o trabalho vinculado e confirme uma pesquisa mais recente. |
| Verificação pendente | Linha de base necessária ou ponto de verificação incompleto encontrado. | `partial`/`deferred`, então `scan_complete`. | Retomar o ponto de verificação; reconstruir somente quando stale/incompatible evidências forem registradas. |
| Contabilidade de origem | Relatar inventários de trabalhadores oito classes de origem. | `complete`, `complete_with_gaps`, `partial`, ou `unavailable`. | Disabled/failed contabilidade força todas as rotas para `missing`. |
| Geração de rota | A linhagem do ciclo atual e a contabilidade de origem estão disponíveis. | `full`, `limited_expected_empty`, ou `missing`. | Falha de gravação JSON/TXT pareada ou à prova de rota converge a rota para `missing`. |
| Caixa de saída local | Uma rota é ativada, concluída e elegível. | Local pendente resultado do envelope e do status da notificação. | Nenhuma escrita ou prova incompleta significa que não há envelope; nenhuma entrega é inferida. |
| Revisão de aplicação | Evidências específicas da conta atingem a pontuação configurada para ação automática. | Recomendação somente de revisão ou uma atualização `Admin.ini` ativada explicitamente. | Uma verificação de segurança com falha ou indisponível interrompe a atualização; uma comparação final com falha restaura o backup verificado quando a recuperação está habilitada. |

<a id="current-and-historical-evidence"></a>
## Evidência atual e histórica

A evidência atual pertence ao boot/poll ativo e nunca é reconstruída apenas a partir de nomes de arquivos retidos. A evidência histórica inclui toras rotacionadas, duráveis ​​account/session histórico, retido cases/reports/evidence e verificação limitada de salvamento mundial. Os relatórios expõem matrizes e contagens atuais e históricas separadas. Uma reinicialização silenciosa não deve apagar o contexto durável e um registro histórico não deve ser apresentado como presença atual.

<a id="completion-and-recovery-boundary"></a>
## Limite de conclusão e recuperação

A conclusão de uma rota requer a correspondência da versão do ciclo atual, ID de inicialização, ID de época, ID de pesquisa positiva, status de log ativo recente, ambas as saídas de rota e sua entrada em `route_proof.json`. As solicitações de notificação exigem adicionalmente o envelope local do mesmo ciclo; a entrega externa nunca faz parte da prova pública.

Se os relatórios finais estiverem faltando ou forem mais antigos que o poll/source estado, continue a partir da primeira linhagem incompatível ou falha na gravação. Não altere rotas, palavras ou configurações de aplicação não relacionadas. Consulte [`OUTPUT_SCHEMA_REFERENCE.md`](REFER%C3%8ANCIA_DO_ESQUEMA_DE_SA%C3%8DDA.md), [`TROUBLESHOOTING.md`](SOLU%C3%87%C3%83O_DE_PROBLEMAS.md) e [`SOURCE_MODULE_REFERENCE.md`](REFER%C3%8ANCIA_DO_M%C3%93DULO_DE_ORIGEM.md).
