<a id="source-module-reference"></a>
# Referência do módulo de origem

> **Fonte canônica em inglês:** [SOURCE_MODULE_REFERENCE.md](../../SOURCE_MODULE_REFERENCE.md). Essa documentação localizada preserva comandos, caminhos, chaves, valores de status, hashes e nomes de arquivos exatos. Se o texto técnico for diferente, use a fonte em inglês.


Esta página mapeia todas as fontes, configurações, dados, carregadores de compatibilidade e classes de espaço de execução admitidas pela lista de permissões de lançamento. O índice da máquina é [`TRACEABILITY_INDEX.json`](../../TRACEABILITY_INDEX.json); esta página é a explicação canônica legível. Cada linha de máquina gerada nomeia um path/class distinto, propósito, bloco de origem proprietário, configurações públicas, efeitos colaterais, estados visíveis ao operador, falhas, recuperação e documento canônico.

<a id="packaged-file-map"></a>
## Mapa de arquivos empacotados

| Caminho | Responsabilidade | Ponto de entrada ou chamador | Entradas | Saídas e efeitos colaterais | Comportamento de falha | Editável pelo usuário |
|---|---|---|---|---|---|---|
| `LICENSE` | Licença do projeto enviada na raiz do arquivo. | Instalador, redistribuidor e operador. | Texto de licença do repositório revisado. | Declara os termos que se aplicam ao pacote; sem mutação de tempo de execução. | A omissão torna o pacote de lançamento legalmente incompleto e bloqueia a lista de permissões. | Não. |
| `NOTICE.md` | Avisos de projeto enviados na raiz do arquivo. | Instalador e operador. | Avisos de projeto revisados. | Preserva a atribuição necessária e o contexto do projeto; sem mutação de tempo de execução. | A omissão torna o pacote de lançamento incompleto e bloqueia a lista de permissões. | Não. |
| `THIRD_PARTY_NOTICES.md` | Avisos de terceiros enviados na raiz do arquivo. | Instalador e redistribuidor. | Texto de atribuição de terceiros revisado. | Preserva a dependência atribuição; sem mutação de tempo de execução. | A omissão torna o pacote de lançamento incompleto e bloqueia a lista de permissões. | Não. |
| `RandomDayGuard/enabled.txt` | UE4SS sinalizador de ativação de mod. | UE4SS carregador de mod. | `1` ou `0` conforme suportado por UE4SS. | Ativa ou desativa o carregamento; não grava nenhuma evidência de tempo de execução. | Um sinalizador desativado ou malformado impede a prova de inicialização normal. | Sim, durante a instalação. |
| `RandomDayGuard/config.lua` | Complete a tabela de configurações públicas. | `Scripts/main.lua` na inicialização. | Campos catalogados em [`CONFIG_FIELD_CATALOG.md`](CAT%C3%81LOGO_DE_CAMPOS_DE_CONFIGURA%C3%87%C3%83O.md). | Controla descoberta, orçamentos, relatórios, portas de revisão e marcadores locais opcionais. | Lua/load/default o desvio bloqueia a validação ou faz com que a inicialização falhe no fechamento. | Sim; mantenha um backup. |
| `RandomDayGuard/SavedRoot.txt` | Substituição de raiz salva explícita opcional. | Resolvedor de raiz salva em `main.lua`. | Um caminho genérico do sistema de arquivos para `AbioticFactor/Saved`. | Seleciona a raiz usada para logs, salvamentos, PlayerData nomes de arquivos e `Admin.ini`. | Ausência é permitida; caminhos inseguros, errados ou ilegíveis permanecem sem comprovação. | Sim; nunca coloque credenciais aqui. |
| `RandomDayGuard/BUILD_MARKER.txt` | Identidade do pacote legível por humanos. | Instalador, validador e operador. | Versão de versão renderizada pelo construtor. | Sem mutação de tempo de execução. | A incompatibilidade de versões bloqueia o empacotamento. | Não. |
| `RandomDayGuard/MANIFEST.json` | Identidade do pacote legível por máquina e metadados de layout. | Validador, construtor e ferramentas de suporte. | Versão de versão renderizada pelo construtor. | Sem mutação de tempo de execução. | JSON ou empacotamento de blocos de incompatibilidade de versão. | Não. |
| `RandomDayGuard/README.txt` | Referência rápida em inglês instalada. | Operador. | Caminhos empacotados e padrões seguros. | Sem mutação de tempo de execução. | Caminhos obsoletos ou palavras de segurança falham na paridade da documentação. | Não. |
| `RandomDayGuard/Scripts/main.lua` | UE4SS entrada, coleta de evidências, propriedade estatal, agendamento limitado, aplicação opcional e gravadores de saída. | UE4SS. | Config, Saved-root fontes, estado atual do tempo de execução, dicionários e módulo de relatórios. | Grava as classes de tempo de execução em [`OUTPUT_SCHEMA_REFERENCE.md`](REFER%C3%8ANCIA_DO_ESQUEMA_DE_SA%C3%8DDA.md); um caminho de aplicação aprovado pode fazer backup e atualização `Admin.ini`. | Startup/poll/write falhas que produzem um estado de erro explícito e nunca comprovam a conclusão da rota. | Não. |
| `RandomDayGuard/Scripts/public_pipeline.lua` | Contabilidade de origem, linhagem do ciclo atual, tradução de relatórios, prova de rota, histórico público durável e caixa de saída local opcional. | `main.lua` trabalhador de relatório. | Retornos de chamada state/context somente leitura e evidências locais retidas. | Grava relatório JSON/TXT pares, source/history contabilidade, prova de rota, histórico de conta durável e notificação status/envelopes. | Linhagem ausente, fonte necessária, gravação emparelhada ou forças de gravação à prova de rota `missing` e enfileiramento de blocos. | Não. |
| `RandomDayGuard/data/detection_events.json` | Vocabulário e explicações de eventos públicos. | `main.lua` evento normalization/reporting. | Válido JSON dicionário. | Evidência de rótulos; não cria observações. | Missing/malformed validação de repositório de blocos de dados. | Não. |
| `RandomDayGuard/data/warning_types.json` | Vocabulário de tipo de aviso e significado de revisão. | Aviso normalization/reporting. | Válido JSON dicionário. | Evidência de aviso de rótulos. | Missing/malformed validação de repositório de blocos de dados. | Não. |
| `RandomDayGuard/data/object_categories.json` | Object/class vocabulário de categoria. | Verificar e relatórios de registro de objeto. | Válido JSON dicionário. | Rótulos extraídos do contexto de classe. | Missing/malformed validação de repositório de blocos de dados. | Não. |
| `RandomDayGuard/runtime/**/.gitkeep` | Apenas espaços reservados de layout de instalação vazios. | Extração de pacote. | Bytes vazios. | Cria estrutura de diretório gravável; nenhuma evidência é agrupada. | Qualquer membro de tempo de execução que não seja um espaço reservado bloqueia a lista de permissões exata. | Não. |

<a id="ue4ss-loader-and-watchdog"></a>
## UE4SS carregador e watchdog

`Scripts/main.lua` possui a inicialização do watchdog independente, descoberta de raiz salva, o final do log atual, épocas e sessões do servidor, pesquisa e varredura limitadas, object/world contexto, pontuação de revisão, `Admin.ini` portas de segurança, resultados operacionais legados e transferência separada do responsável pelo relatório. Deve manter as pesquisas ao vivo limitadas enquanto o lento trabalho histórico é retomado de forma independente. Uma pulsação, um marcador de inicialização ou um aumento `poll_id` comprova apenas esse componente; a conclusão da rota requer a mesma inicialização atual, época, pesquisa, atualização da fonte, par de relatórios e prova de rota.

A fonte e o pacote têm uma autoridade: `RandomDayGuard/Scripts/main.lua`. Uma cópia `scripts/` minúscula não faz parte da árvore de origem ou da versão. Manter uma ortografia canônica evita falhas de colisão de casos quando o pacote é extraído no Windows ou Linux.

<a id="public-reporting-module"></a>
## Módulo de relatório público

`Scripts/public_pipeline.lua` recebe retornos de chamada em vez de credenciais de host ou adaptadores de provedor. Ele inventaria oito classes de origem, registra estados terminais e incompletos, mantém os jogadores atuais separados do histórico retido, traduz cada rota na ordem `Observed`, `Interpretation`, `Unknown`, `Does not prove`, `Next action` e `Source references` e, em seguida, grava a prova de rota. O modo de notificação opcional grava apenas um envelope JSON local; ele nunca reivindica a entrega ou agrupa uma entrega endpoint/bridge.

O dispositivo executável em `tests/lua/public_pipeline_runtime_test.lua` carrega este módulo enviado com Lua, prova rotas completas e vazias esperadas, prova que um ciclo de fonte de corrente ausente falha no fechamento e prova que rotas incompletas não entram na caixa de saída.

<a id="configuration-and-data"></a>
## Configuração e dados

[`CONFIG_FIELD_CATALOG.md`](CAT%C3%81LOGO_DE_CAMPOS_DE_CONFIGURA%C3%87%C3%83O.md) e [`TRACEABILITY_INDEX.json`](../../TRACEABILITY_INDEX.json) são gerados por `tools/generate_documentation_audit.py` a partir de uma análise estrutural não executável de `config.lua`, a lista de permissões do pacote e as classes de saída descobertas na origem. O conteúdo exato gerado e a cobertura individual são validados. Os três JSON dicionários são rótulos e mapeamentos, não fontes de evidências. Um operador pode editar a configuração, a seleção da raiz salva e a ativação; fonte, dicionários, manifestos e leia-mes empacotados são de propriedade da versão.

<a id="package-layout"></a>
## Layout do pacote

O construtor admite apenas os três arquivos legais raiz, o `RandomDayGuard/` caminhos acima e espaços reservados de tempo de execução vazios. Ele ordena os membros por byte, corrige ZIP metadados, empacota o carregador canônico uma vez, verifica cada membro em busca de material privado, registra um SHA-256 para cada membro, vincula nomes e bytes em um resumo de conteúdo e compila duas vezes. Os testes rejeitam todas as colisões entre casos e provam que a extração normal produz exatamente um arquivo físico por entrada de arquivo.

O repositório público mantém apenas a pasta de lançamento atual. O construtor verifica se ZIP, soma de verificação, notas, marcadores de versão e árvore de origem estão de acordo.

<a id="code-comment-contract"></a>
## Contrato de comentários de código

Comentários de tempo de execução são contratos concisos do mantenedor, não um segundo manual. Cada módulo de tempo de execução enviado deve colocar um link canônico em seu bloco de comentários de abertura:

```lua
-- Documentation: docs/SOURCE_MODULE_REFERENCE.md#ue4ss-loader-and-watchdog
```

Estado não óbvio, agendamento, write/readback/rollback, descoberta de origem, tradução, evidência, esquema de saída, cadência de rota e blocos de redação usam comentários focados com estes rótulos quando aplicável:

```lua
-- Public contract: <invariant or consequence>
-- Evidence boundary: <what the input cannot prove>
-- Failure behavior: <how the block fails closed or recovers>
-- Documentation: docs/<canonical-file>.md#<existing-anchor>
```

O carregador principal também tem um comentário de proprietário focado para carregamento de configuração, descoberta salva, substituição atômica, aplicação e agendamento. Esses comentários indicam o fluxo de controle e os limites de falha; eles não alteram o comportamento do tempo de execução.

O validador requer um link de nível de módulo `Documentation:` para cada módulo de tempo de execução, resolve cada caminho de comentário e âncora, requer contratos focados e comentários de falha em ambos os módulos de tempo de execução e compara os mesmos links canônicos com `TRACEABILITY_INDEX.json`. Um comentário é rastreável, não à prova de tempo de execução.

<a id="contributor-change-checklist"></a>
## Lista de verificação de alteração do contribuidor

1. Atualize um módulo proprietário e seu acessório em foco.
2. Atualize a configuração canônica, esquema, saída, evidência ou seção de ciclo de vida.
3. Execute `python -B tools/generate_documentation_audit.py --write` depois uma configuração, caminho do pacote, classe de saída gerada, proprietário ou alterações no contrato de recuperação.
4. Execute `python -B tools/generate_documentation_audit.py --check`, testes de unidade focados, o dispositivo Lua real onde Lua está disponível, o validador completo, duas construções determinísticas independentes e `git diff --check`.
5. Revise a ZIP lista de membros gerada, soma de verificação e verificação de material privado antes de criar a versão.
