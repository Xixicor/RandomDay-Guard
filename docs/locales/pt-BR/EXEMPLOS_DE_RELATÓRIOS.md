<a id="examples-of-the-five-guard-reports"></a>
# Exemplos dos cinco relatórios do Guard

> **Fonte canônica em inglês:** [REPORT_EXAMPLES.md](../../REPORT_EXAMPLES.md). Essa documentação localizada preserva comandos, caminhos, chaves, valores de status, hashes e nomes de arquivos exatos. Se o texto técnico for diferente, use a fonte em inglês.


Esses exemplos foram produzidos a partir dos dados de amostra incluídos no lançamento; os nomes e números de contas são inventados. Eles mostram os campos de relatório testados, cálculos e limites de rota. Um relatório real os substitui por informações coletadas daquele servidor e informa quando um fato não estava disponível.

Cada relatório possui um trabalho. A integridade do servidor não repete o histórico do jogador, a revisão diária não é enviada a cada poucos minutos e jogadores silenciosos ou rotas de caso não recebem mensagens de preenchimento. Um relatório atual pode estar pronto enquanto a varredura histórica limitada ainda está em andamento; nesse caso, o relatório nomeia a lacuna em vez de apresentar o histórico antigo como completo.

<a id="server-status"></a>
## Status do servidor

> **Status do servidor: Online após reinicialização**  **Estado atual:** Online **Disponível desde:** 14:07  **Reiniciar concluído:** 14:06  **Tempo de inatividade:** 3 minutos e 12 segundos **Motivo de reinicialização:** Atualização agendada do jogo **Monitoramento:** Ativo. Última verificação bem-sucedida: 14h09 **Registro do jogo:** Disponível e atualizado **Verificação histórica:** 312 de 355 arquivos revisados ​​**Backups:** Última verificação: 13h. Próxima previsão: 15h. Falhas hoje: 0 **Ação:** Nenhuma. O servidor se recuperou normalmente.

O status do servidor é para a operação atual do servidor: inicialização, recuperação de reinicialização, tempo de inatividade, backups, agendador e integridade do Guard. Ele não contém sessões de jogadores ou detalhes de casos.

<a id="daily-rollup"></a>
## Acúmulo diário

> **Revisão diária: 19 de julho de 2026**  **Disponibilidade do servidor:** Online por 23 horas e 47 minutos. Off-line por 13 minutos.  **Reinicializações:** 2 no total: 1 programada e 1 inesperada.  **Backups:** 23 bem-sucedido. 1 ausente ou com falha. Último backup bem-sucedido: 23:00.  **Atividade do jogador:** 3 jogadores únicos. 7 sessões: 6 concluídas normalmente e 1 interrompida.  **Atividade do caso:** 1 caso novo, 2 casos atualizados, 1 caso que precisa de atenção e 0 casos críticos.  **Cobertura de evidências:** 6 dos 7 grupos de fontes esperados estavam disponíveis. O log de backup das 04:00 não estava disponível.  **Resumo do dia:** O servidor permaneceu disponível durante a maior parte do dia. Uma interrupção inesperada encerrou uma sessão de jogador mais cedo. O monitoramento foi retomado após a recuperação e um caso está pronto para análise.  **Ação:** Analisar caso `RDG-20260719-004`. Nenhuma outra ação imediata é necessária.

O rollup diário é gravado uma vez para a data do calendário. Ele combina o dia em períodos de silêncio e reinicia sem se tornar outro ping de status do servidor.

<a id="player-activity"></a>
## Atividade do jogador

> **Atividade do jogador: Alex**  **Conta:** `76561198000000400`  **Primeira observação:** 12 de julho de 2026 **Última sessão:** Entrou às 10h02, saiu às 11h18, durou 1 hora e 16 minutos e terminou normalmente.  **Hoje:** 3 conexões, 2 sessões concluídas, 1 sessão interrompida e 2 reconexões rápidas em 10 minutos.  **7 dias anteriores:** 9 sessões, 6 horas e 18 minutos de reprodução gravada e 0 casos anteriores.  **Observado:** Alex retornou duas vezes logo após uma sessão interrompida. A atividade registrada é completa o suficiente para ser preservada como história, mas não explica por si só por que ocorreram as reconexões.  **Ação:** Continue monitorando. Nenhuma ação imediata é necessária.

A atividade do jogador é enviada somente quando as informações do jogador compatível ou da sessão mudam. Um período de silêncio não cria uma mensagem ao jogador.

<a id="case-review"></a>
## Revisão do caso

> **Revisão do caso: RDG-20260719-004**  **Assunto:** Alex **Conta:** `76561198000000400`  **Status:** Revisão do administrador solicitada **Classificação da revisão:** 90 - Alta prioridade **Por que o caso foi aberto:** A conta fez repetidas tentativas de conexão após uma sessão interrompida e o servidor registrou as solicitações de login diretamente.  **Observações confirmadas:** - Uma solicitação de login foi registrada às 18h42. - Quatro tentativas foram registradas em 6 minutos. - Duas sessões terminaram sem registo normal de saídas. - O mesmo relato foi observado nos dias 12 e 17 de julho.  **Histórico relevante:**Nenhum caso anterior foi registrado para esta conta.  **Desconhecido:** Os registros disponíveis não estabelecem o motivo das reconexões, a intenção do jogador ou se o estado mundial mudou.  **Ação recomendada:** Compare os tempos de sessão com o log do servidor e a atividade mundial registrada antes de decidir se alguma ação é necessária.

A revisão do caso contém material de revisão nomeado, suas observações confirmadas, seus limites e uma etapa de revisão específica. A presença histórica por si só não cria um novo caso.

<a id="critical-guard"></a>
## Critical Guard

> **Critical Guard: Report Writing Stopped**  **Iniciado:** 21:14  **Função afetada:** Gravador de relatórios do jogador **Impacto:** Os resumos de novos jogadores não podem ser concluídos.  **Servidor:** Permanece online.  **Monitoramento:** A coleta de evidências continua, mas os relatórios legíveis estão atrasados.  **Último relatório bem-sucedido:** 21:09  **Falha:** A saída do relatório não pôde ser salva.  **Motivo provável:** O destino não estava disponível ou rejeitou a gravação.  **Ação:** Verifique o local de saída do tempo de execução do Guard. Não reinicie o servidor do jogo, a menos que o monitoramento também pare.

Quando o problema for resolvido, a mesma rota registra a recuperação:

> **Critical Guard Resolvido: Gravação de relatório restaurada**  **Retomada:** 21:22  **Interrupção:** 8 minutos **Resultado:** Evidência coletados durante a interrupção foram preservados e os relatórios atrasados foram concluídos.

Critical Guard é somente para falhas. O status da rotina, o histórico diário, a atividade do jogador e os resultados normais esperados vazios permanecem em seus próprios relatórios.

<a id="when-a-route-is-quiet"></a>
## Quando uma rota está silenciosa

Uma rota silenciosa registra um resultado direto sem enviar preenchimento para o Discord:

> **Verificado; nada para este relatório.** Os registros necessários estavam disponíveis e nenhuma atividade de jogador, caso ou falha de guarda correspondente ocorreu durante esta janela de relatório.

Esse é um resultado completamente vazio. É diferente de um relatório ausente, onde uma fonte necessária não pode ser verificada ou a saída legível não pode ser criada.

Cada relatório legível segue o mesmo caminho:

```text
collected evidence -> normalized values -> dictionary mapping -> route calculations -> readable report -> Discord notification
```

Use o [manual de operações](MANUAL_DE_OPERA%C3%87%C3%95ES.md) para revisar os relatórios atuais e o [esquema de saída](REFER%C3%8ANCIA_DO_ESQUEMA_DE_SA%C3%8DDA.md) para referência de campo técnico.
