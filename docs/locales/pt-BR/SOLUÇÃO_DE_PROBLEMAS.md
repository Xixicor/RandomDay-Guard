<a id="troubleshooting"></a>
# Solução de problemas

> **Fonte canônica em inglês:** [TROUBLESHOOTING.md](../../TROUBLESHOOTING.md). Essa documentação localizada preserva comandos, caminhos, chaves, valores de status, hashes e nomes de arquivos exatos. Se o texto técnico for diferente, use a fonte em inglês.


Use esta página quando o Guard não carrega, uma fonte não pode ser coletada, um relatório não aparece ou a prova de rota contradiz o que você esperava. Comece com a árvore de decisão e siga um ramo. Use o dedicado [status e referência de erro](REFER%C3%8ANCIA_DE_STATUS_E_ERROS.md) somente depois que a camada com falha for conhecida.

Preservar os arquivos de tempo de execução atuais antes de alterar a configuração ou reinstalar. Um artefato obsoleto ou ausente identifica um estágio com falha; reinicializações repetidas podem apagar essa evidência.

<a id="choose-the-failure-path"></a>
## Escolha o caminho da falha

<a id="1-decide-whether-guard-loaded"></a>
### 1. Decida se o Guard carregou

- **Não existem `runtime/` arquivos:** siga [Restaure arquivos de tempo de execução ausentes](#restore-missing-runtime-files). Verifique o caminho de instalação, carregador canônico, `enabled.txt` e `mods.txt` antes de investigar os relatórios.
- **Existem arquivos de status atuais:** Guard carregado o suficiente para gravar o estado. Continue para a etapa 2; reinstalar não é a primeira resposta.

<a id="2-decide-whether-the-scheduler-is-advancing"></a>
### 2. Decida se o agendador está avançando

Abrir:

```text
runtime/current/startup_status.json
runtime/current/poll_status.json
```

- **Contadores e carimbos de data/hora avançam:** continue na etapa 3.
- **`poll_id` é estático, `poll_in_flight` permanece verdadeiro ou o status do agendador não está em execução:** siga [Recupere um loop de pesquisa travado](#recover-a-stuck-poll-loop).
- **A verificação da linha de base está pendente enquanto o progresso do agendador continua:** este é um aviso, não é automaticamente uma inicialização com falha. Investigue apenas se o backlog ou o progresso da verificação for interrompido.

<a id="3-classify-route-proof"></a>
### 3. Classificar prova de rota

Aberto `runtime/final_logs/route_proof.json` e inspecione cada rota separadamente.

- **`full`:** compare o texto inesperado com o atual `source_references` e linhagem. Não altere a entrega porque o texto por si só parece errado.
- **`limited_expected_empty`:** confirme se a contabilidade de origem suporta um resultado vazio legítimo. Não crie um player ou caso sintético.
- **`missing`:** siga [Diagnostique uma rota ausente](#diagnose-a-missing-route).

<a id="4-classify-source-coverage"></a>
### 4. Classifique a cobertura da fonte

- **`partial`, `deferred`, `unavailable`, `malformed`, `permission_denied`, ou `error`:** siga [Interprete a cobertura incompleta da fonte](#interpret-incomplete-source-coverage) e procure o código exato em [Status e referência de erro](REFER%C3%8ANCIA_DE_STATUS_E_ERROS.md).
- **A fonte estruturada é atual, mas a saída traduzida ou pendente é mais antiga:** diagnostique a transferência de conclusão, não o endpoint de entrega. Preserve os carimbos de data e hora e inspecione o status do relatório e do despacho antes de alterar a configuração de entrega.

<a id="5-follow-the-matching-branch"></a>
### 5. Siga o ramo correspondente

- Identidade incompleta: [Mapeie um jogador não mapeado](#map-an-unmapped-player).
- Continuidade diária ausente: [Restaurar um rollup diário ausente](#restore-a-missing-daily-rollup).
- O teste de aplicação explicitamente aprovado não gravou: [Diagnostique uma gravação Admin.ini bloqueada](#diagnose-a-blocked-adminini-write).
- ZIP extração falhou: [Resolver um Windows colisão de caso de extração](#resolve-a-windows-extraction-folder-collision).
- Falha na verificação de dispositivo, pacote ou repositório: [Validação e revisão de lançamento](VALIDA%C3%87%C3%83O_E_LIBERA%C3%87%C3%83O.md#avoid-validation-environment-pitfalls).

<a id="6-stop-with-one-proved-outcome"></a>
### 6. Pare com um resultado comprovado

Uma etapa de solução de problemas termina quando:

- a rota é atual e `full`;
- a rota é atual e `limited_expected_empty` por um motivo específico;
- um bloqueador exato, caminho de evidência e próxima ação são registrados; ou
- a reversão restaurou o estado conhecido anterior e preservou as evidências de falha.

“O servidor está em execução”, uma pulsação crescente ou HTTP o sucesso por si só não prova que uma rota de relatório foi concluída.

<a id="diagnose-a-missing-route"></a>
## Diagnostique uma rota ausente

Aberto `runtime/final_logs/route_proof.json` e compare `server_status`, `daily_rollup`, `player_activity`, `case_review` e `critical_guard`.

1. Leia o motivo, a linhagem, o tempo de geração e o motivo da rota e referências de origem.
2. Confirme se a fonte estruturada nomeada existe e pertence ao mesmo ciclo.
3. Compare seu mtime com a saída traduzida e o envelope pendente.
4. Se os logs finais forem mais recentes que a saída traduzida ou pendente, registre o despacho de conclusão obsoleto e repare essa transferência primeiro.
5. Se toda a saída local estiver atual, mas a entrega estiver ausente, então inspecione a configuração da rota. e status do remetente.

Não promova a integridade do agendador ou uma notificação bem-sucedida para prova de cinco rotas.

<a id="interpret-incomplete-source-coverage"></a>
## Interprete a cobertura incompleta da fonte

| Estado | O que fazer |
|---|---|
| `partial` | Use apenas evidências coletadas e evite reivindicações de cobertura completa. |
| `deferred` | Confirme os avanços de trabalho vinculados posteriores antes alterando a configuração. |
| `unavailable` | Registre o limite do ambiente; corrija apenas um caminho comprovado ou problema de permissão. |
| `malformed` | Preservar a fonte e analisar o erro; não adivinhe valores ausentes. |
| `permission_denied` | Conceda apenas a permissão de leitura restrita necessária. |
| `error` | Preserve detalhes e diagnostique o estágio nomeado antes de confiar na rota. |

<a id="restore-missing-runtime-files"></a>
## Restaure arquivos de tempo de execução ausentes

Confirme:

```text
mods.txt contains RandomDayGuard : 1
RandomDayGuard/enabled.txt exists
RandomDayGuard/Scripts/main.lua exists
```

A raiz de instalação correta é:

```text
AbioticFactor/Binaries/Win64/ue4ss/Mods/RandomDayGuard/
```

Rejeite este layout aninhado:

```text
Mods/RandomDayGuard/RandomDayGuard/Scripts/main.lua
```

Se os arquivos estiverem corretos, mas UE4SS não iniciou o Guard, preserve `UE4SS.log` e compare seu carimbo de data e hora de inicialização com o início real do processo do jogo.

<a id="resolve-a-windows-extraction-folder-collision"></a>
## Resolver uma colisão de pasta de extração do Windows

Uma versão mais antiga usava diretórios de programas cujos nomes diferiam apenas pela capitalização. Alguns extratores do Windows mesclam esses nomes quando um ZIP é colocado sobre uma pasta existente.

1. Exclua apenas a extração temporária malsucedida, não o mod instalado ou suas evidências.
2. Crie um novo diretório temporário vazio.
3. Extraia a versão atual lá.
4. Confirme que ele produz uma pasta RandomDayGuard e um diretório de programa.
5. Se o Windows ainda relatar uma colisão, baixe o lançamento novamente e informe a versão do lançamento e o extrator usado.

Nunca extraia uma nova versão na pasta instalada. Siga o procedimento de atualização de pasta limpa em [`../INSTALL.md`](INSTALA%C3%87%C3%83O.md).

<a id="load-the-expected-version"></a>
## Carregar a versão esperada

Verifique o marcador de origem e o marcador de compilação:

```sh
grep -n "local VERSION" RandomDayGuard/Scripts/main.lua
cat RandomDayGuard/BUILD_MARKER.txt
```

Se eles discordarem:

1. Pare o servidor.
2. Faça backup da pasta instalada, da configuração revisada e da evidência de tempo de execução.
3. Prepare e inspecione o pacote pretendido.
4. Substitua apenas programas gerenciados por pacote e arquivos de dados.
5. Confirme se o carregador canônico existe e se nenhuma duplicata minúscula foi adicionada.
6. Inicie uma vez e leia os marcadores atuais antes de julgar a saída do tempo de execução.

<a id="correct-a-missing-saved-root"></a>
## Corrija uma raiz salva ausente

Aberto `runtime/saved_path_probe.json`. Coloque o caminho absoluto verificado para o Fator Abiótico completo `Saved/` em `SavedRoot.txt`; não aponte apenas para um diretório mundial. Um caminho fora da raiz limitada deve permanecer rejeitado.

<a id="recover-a-stalled-historical-scan"></a>
## Recuperar uma verificação de histórico paralisada

O monitoramento atual e a descoberta de histórico são separados. Um arquivo grande pode precisar de muitos ciclos limitados, portanto, uma observação inalterada não é suficiente para considerá-lo paralisado.

1. Aberto `runtime/current/report_worker_status.json`.
2. Registre `scan_cursor`, arquivos descobertos, arquivos concluídos e `last_progress_ts`.
3. Aguarde pelo menos duas oportunidades normais de trabalho de relatório e compare os mesmos campos novamente.
4. Se o cursor, a contagem concluída ou o tempo de progresso avançarem, a varredura ainda estará funcionando. Deixe-o limitado.
5. Se todos os campos de progresso permanecerem inalterados enquanto os IDs de pesquisa e os relatórios atuais continuam avançando, preserve o arquivo de status e verifique a classe de origem nomeada pela fase de trabalho. Repare esse caminho de origem ou leia a falha antes de tentar novamente.

Uma verificação de histórico paralisada limita as conclusões que precisam de registros mais antigos. Isso não invalida um relatório atual cujo log ativo e prova do ciclo atual sejam recentes.

<a id="recover-a-stuck-poll-loop"></a>
## Recupere um loop de pesquisa travado

Abrir:

```text
runtime/current/poll_status.json
runtime/poll_error.txt
```

Registre `poll_id`, `poll_completed_count`, `poll_in_flight`, `poll_stage`, `scheduler_status` e carimbos de data e hora duas vezes em um intervalo limitado.

- Se os contadores avançarem, o loop não ficará travado; diagnosticar o estágio de trabalho posterior.
- Se `poll_in_flight=true` permanece inalterado, preserve o último estágio de progresso e o erro antes de reiniciar.
- Se o agendador parou, inspecione o erro anterior e a transferência de inicialização.

Não adicione um segundo proprietário de loop para compensar um ciclo de vida paralisado.

<a id="start-the-scan-after-log-backlog"></a>
## Iniciar a verificação após o backlog de log

Em `runtime/current/poll_status.json`, compare:

```text
active_log_caught_up
active_log_unread_bytes
log_backlog_pending
```

A verificação histórica deve aguardar enquanto o log ativo tem bytes não lidos. Confirme que as pesquisas posteriores reduzem o atraso. Uma contagem fixa de não lidos com o avanço das pesquisas é um problema de origem e cauda; uma pesquisa fixa é um problema do agendador.

<a id="preserve-scan-progress-after-a-crash"></a>
## Preservar o progresso da verificação após uma falha

Preservar e comparar:

```text
runtime/scan_checkpoint.json
runtime/scan_progress.json
runtime/baselines/file_manifest.tsv
```

Verifique se o ponto de verificação ou manifesto está faltando, se a raiz salva ou o mundo foi alterado ou se o ponto de verificação foi marcado como obsoleto. Não exclua uma linha de base válida para fazer o progresso parecer mais recente.

<a id="map-an-unmapped-player"></a>
## Mapeie um jogador não mapeado

Compare a evidência da sessão com o registro oficial:

```text
runtime/evidence/session_events.jsonl
Saved/Logs/AbioticFactor.log
```

Procure um relacionamento `Login request` completo entre o nome de exibição, `ConnectID` e `UniqueId`. Se não existir nenhuma identidade de conexão aceita, mantenha a linha somente para revisão. Um nome de exibição ou PlayerData nome de arquivo por si só não é uma identidade executável.

<a id="diagnose-a-blocked-adminini-write"></a>
## Diagnostique uma gravação Admin.ini bloqueada

Execute um teste de aplicação apenas com aprovação explícita e um arquivo de teste descartável, nunca com um arquivo de servidor ativo. Primeiro confirme se a configuração de teste pede ao Guard para escrever:

```lua
review_only_mode = false
auto_ban = true
write_admin_ini = true
```

Em seguida, leia o motivo da falha registrada. O Guard deve identificar uma conta, proteger moderadores e contas confiáveis, encontrar evidências suficientes específicas da conta, criar e verificar um novo backup, confirmar se nenhum outro programa alterou o arquivo, salvar a atualização pretendida e comparar o arquivo salvo completo com o resultado pretendido. Se alguma etapa falhar ou não puder ser verificada, deixe a lista de banimentos inalterada. Consulte [Admin.ini aplicação](APLICA%C3%87%C3%83O_DE_INICIALIZA%C3%87%C3%83O_ADMINISTRATIVA.md).

<a id="restore-a-missing-daily-rollup"></a>
## Restaurar um rollup diário ausente

Confirme `forensic_rollup.enabled = true` e inspecione:

```text
runtime/current/forensic_today.json
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

Se eles estiverem faltando, verifique o status de inicialização, pesquisa, report-worker e contabilidade de origem nessa ordem. O rollup diário é um registro de continuidade por dia, não uma notificação repetida de status do servidor.

<a id="look-up-an-exact-status-or-error"></a>
## Procure um status ou erro exato

Use [Status e referência de erro](REFER%C3%8ANCIA_DE_STATUS_E_ERROS.md) para rota completa, origem, PlayerData, execução, inicialização, agendador, relatório e tabelas de códigos de notificação. Manter as tabelas de pesquisa separadas evita que esta página de reparo se torne um segundo manual de esquema.

<a id="related-docs"></a>
## Documentos relacionados

- [Comece aqui](COMECE_AQUI.md)
- [Manual de operações](MANUAL_DE_OPERA%C3%87%C3%95ES.md)
- [Status e referência de erro](REFER%C3%8ANCIA_DE_STATUS_E_ERROS.md)
- [Validação e revisão de lançamento](VALIDA%C3%87%C3%83O_E_LIBERA%C3%87%C3%83O.md)
