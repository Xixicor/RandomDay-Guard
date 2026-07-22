<a id="start-here-read-the-first-guard-report"></a>
# Comece aqui: leia o primeiro Guard relatório

> **Fonte canônica em inglês:** [START_HERE.md](../../START_HERE.md). Essa documentação localizada preserva comandos, caminhos, chaves, valores de status, hashes e nomes de arquivos exatos. Se o texto técnico for diferente, use a fonte em inglês.


Este guia começa após RandomDayGuard ser instalado e ativado. Ele prova um resultado útil sem pedir a um novo operador para inspecionar o código-fonte, os componentes internos do pacote ou os arquivos de status somente da máquina.

<a id="what-happens-after-the-server-starts"></a>
## O que acontece depois que o servidor é iniciado

Guard aguarda o servidor do jogo e UE4SS carregar, encontra os registros disponíveis do servidor e inicia uma varredura em segundo plano limitada. Ele pode relatar a integridade atual do servidor enquanto o histórico antigo ainda está sendo indexado.

O primeiro relatório deve ser **Status do servidor**. Ele responde se o Guard está concluindo os ciclos de monitoramento agora, quando a execução atual do servidor começou, se esse carimbo de data e hora estiver disponível, quanto active/rotated cobertura de log e varredura existe, quantos jogadores estão conectados, quais grupos de origem estão faltando e se uma ação do operador é necessária.

Uma varredura em segundo plano que ainda está em andamento é uma limitação na cobertura histórica, e não automaticamente uma falha de inicialização. O Guard registra o cursor da varredura, os arquivos concluídos, os arquivos descobertos e o horário do último progresso. Se esses valores pararem de mudar em ciclos repetidos de monitoramento, trate o caminho histórico como paralisado e siga a ramificação de varredura em Solução de problemas. Não descarte os resultados atuais do log e da sessão apenas porque o histórico antigo está incompleto.

<a id="read-the-first-server-status-report"></a>
## Leia o primeiro relatório de status do servidor

1. Inicie o servidor dedicado normalmente.
2. Aguarde o servidor do jogo e UE4SS termine de iniciar.
3. Aberto RandomDayGuard's pasta de relatórios finais e escolha o relatório de status do servidor legível mais recente.
4. Confirme se o relatório contém:
   - **Resumo**
   - **O que o Guard observou**
   - **O que significa**
   - **O que permanece desconhecido**
   - **Próxima etapa recomendada**
   - **Registro técnico**
5. Em **O que o Guard observou**, confirma os últimos avanços do ciclo de monitoramento e os nomes dos relatórios disponíveis, log, varredura, player e cobertura de fonte.
6. Se a próxima etapa disser que nenhuma intervenção é necessária, mantenha o relatório como o primeiro resultado bem-sucedido. Se ele nomear uma origem ausente ou um processo interrompido, siga exatamente o sintoma em [Solução de problemas](SOLU%C3%87%C3%83O_DE_PROBLEMAS.md).

O relatório pode conter links para evidências técnicas para uma análise mais profunda. Um operador normal pode ler o relatório primeiro e abrir essas referências somente quando o resultado simples precisar ser verificado.

<a id="understand-quiet-reports"></a>
## Entenda os relatórios silenciosos

A atividade do jogador, a análise do caso e o Critical Guard são orientados por eventos. Um servidor silencioso não deve produzir um jogador fictício, um caso ou uma falha meramente para preencher um canal. O resultado legível pode indicar que a fonte foi verificada e nada pertencia a esse relatório.

O rollup diário é diferente: ele fornece uma revisão por data de relatório usando sessões do mesmo dia, assuntos de revisão atuais, retidos identity/case contexto, progresso da verificação e lacunas de origem que o Guard pode realmente ler. Os fatos ausentes dos registros disponíveis do servidor permanecem desconhecidos em vez de serem estimados.

<a id="test-one-ordinary-player-session"></a>
## Teste uma sessão de jogador comum

Depois que o primeiro relatório de status do servidor estiver atualizado:

1. Permitir que um jogador conhecido entre e saia normalmente.
2. Aguarde o próximo ciclo de relatório.
3. Atividade do player aberto.
4. Confirme se ele identifica a conta ou o nome de exibição disponível para o Guard, os horários de entrada e saída, o resultado da sessão limpa ou incompleta, o histórico anterior quando disponível e uma próxima ação.

O relatório da sessão deve conter os dados observados. Não deve ser substituído por uma lista de nomes de arquivos ou por uma declaração genérica de que existem registros.

<a id="continue"></a>
## Continuar

- [Cinco exemplos de relatórios](EXEMPLOS_DE_RELAT%C3%93RIOS.md)
- [Manual de operações](MANUAL_DE_OPERA%C3%87%C3%95ES.md)
- [Fluxo de trabalho de revisão do jogador](FLUXO_DE_TRABALHO_DE_REVIS%C3%83O_DO_JOGADOR.md)
- [Solução de problemas](SOLU%C3%87%C3%83O_DE_PROBLEMAS.md)
- [Índice completo da documentação](DOCUMENTA%C3%87%C3%83O.md)
