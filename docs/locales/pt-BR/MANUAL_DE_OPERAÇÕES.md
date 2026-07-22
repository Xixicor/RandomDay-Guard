<a id="operations-playbook"></a>
# Manual de operações

> **Fonte canônica em inglês:** [OPERATIONS_PLAYBOOK.md](../../OPERATIONS_PLAYBOOK.md). Essa documentação localizada preserva comandos, caminhos, chaves, valores de status, hashes e nomes de arquivos exatos. Se o texto técnico for diferente, use a fonte em inglês.


Esta é a ordem de leitura normal para RandomDayGuard. Você não precisa saber JSON, Git, somas de verificação ou ferramentas de linha de comando para revisar um servidor íntegro.

<a id="daily-operator-flow"></a>
## Fluxo diário do operador

1. Aberto `runtime/final_logs/server_status_latest.txt`. Ele informa se o Guard está monitorando a execução atual do servidor, quando seu último ciclo foi concluído, quantos jogadores estão conectados e se uma fonte ou varredura está incompleta.
2. Aberto `runtime/final_logs/daily_rollup_latest.txt` uma vez por dia. Ele resume sessões do mesmo dia, saídas, trabalho de caso nomeado, inventário de identidade e cobertura de origem sem repetir cada registro individual.
3. Aberto `runtime/final_logs/player_activity_latest.txt` somente quando o servidor teve uma sessão de entrada, saída ou ativa durante o dia.
4. Aberto `runtime/final_logs/case_review_latest.txt` somente quando ele nomeia um assunto atual. O relatório fornece a conta, o estado de revisão, a pontuação, a origem da identidade e os registros a serem abertos em seguida.
5. Aberto `runtime/final_logs/critical_guard_latest.txt` somente quando o Guard relata uma falha em sua própria inicialização, ciclo de monitoramento ou gravação de relatório.

Se uma rota não tem nada a relatar, o Guard registra um resultado esperado vazio. Essa é uma verificação concluída, não um relatório ausente.

<a id="what-to-read-inside-a-report"></a>
## O que ler em um relatório

Leia estas seções em ordem:

1. **Resumo** - o que este relatório cobre.
2. **O que o Guard observou** - carimbos de data/hora reais, contagens, contas, sessões ou valores de status coletados para esta rota.
3. **O que significa** - a interpretação em linguagem simples desses registros.
4. **O que permanece desconhecido** - uma fonte ou limite de varredura que afeta o resultado.
5. **Próxima etapa recomendada** - seja para monitorar, revisar um assunto nomeado ou reparar o Guard.
6. **Limite de evidências** - o limite do relatório escopo.

O registro técnico e as referências de origem aparecem no final para leitores que precisam inspecionar a evidência estruturada exata.

<a id="when-a-report-is-missing"></a>
## Quando um relatório está faltando

Aberto `runtime/final_logs/route_proof.json` somente quando um relatório legível está ausente ou diz que sua prova atual está faltando. Cada rota tem um destes resultados:

| Resultado | Significado |
|---|---|
| `full` | O guarda completou a rota com evidências atuais de propriedade da rota. |
| `limited_expected_empty` | O guarda completou a rota e não encontrou nenhum evento qualificado ou registrou um limite de maturidade nomeado. |
| `missing` | Uma fonte necessária, verificação de linhagem ou gravação de relatório emparelhado não foi concluída. |

Para uma rota ausente, siga a origem nomeada ou escreva o erro no relatório. Não altere rotas não relacionadas ou configurações de notificação primeiro.

<a id="after-a-crash-or-restart"></a>
## Após uma falha ou reinicialização

1. Leia o status do servidor para o novo carimbo de data/hora de execução do servidor e o último ciclo de monitoramento concluído.
2. Leia o Critical Guard para uma inicialização atual ou falha de pesquisa.
3. Leia a atividade do jogador somente se uma sessão do mesmo dia entrou, saiu ou retornou após o ciclo de vida alterar.
4. Preservar o registro de origem citado antes de alterar a configuração.

<a id="before-enabling-optional-adminini-writes"></a>
## Antes de ativar Admin.ini gravações opcionais

O pacote padrão observa e relata sem alteração `Admin.ini`. Operadores avançados podem ativar o caminho de imposição opcional após testá-lo em uma cópia do arquivo. O Guard então requer um ID de conta numérico limpo, protege contas confiáveis, cria e verifica um backup, rejeita alterações simultâneas, lê o arquivo salvo e restaura o backup se a verificação falhar. Consulte [`ADMIN_INI_ENFORCEMENT.md`](APLICA%C3%87%C3%83O_DE_INICIALIZA%C3%87%C3%83O_ADMINISTRATIVA.md) para obter o procedimento completo de configuração e teste.

<a id="related-guides"></a>
## Guias relacionados

- [`START_HERE.md`](COMECE_AQUI.md)
- [`REPORT_EXAMPLES.md`](EXEMPLOS_DE_RELAT%C3%93RIOS.md)
- [`PLAYER_REVIEW_WORKFLOW.md`](FLUXO_DE_TRABALHO_DE_REVIS%C3%83O_DO_JOGADOR.md)
- [`TROUBLESHOOTING.md`](SOLU%C3%87%C3%83O_DE_PROBLEMAS.md)
- [`OUTPUT_SCHEMA_REFERENCE.md`](REFER%C3%8ANCIA_DO_ESQUEMA_DE_SA%C3%8DDA.md)
