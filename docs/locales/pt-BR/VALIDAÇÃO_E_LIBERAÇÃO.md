<a id="validation-and-release"></a>
# Validação e lançamento

> **Fonte canônica em inglês:** [VALIDATION_AND_RELEASE.md](../../VALIDATION_AND_RELEASE.md). Essa documentação localizada preserva comandos, caminhos, chaves, valores de status, hashes e nomes de arquivos exatos. Se o texto técnico for diferente, use a fonte em inglês.


Esta página é para contribuidores e mantenedores de lançamento. Os operadores de servidor não precisam executar esses comandos para instalar RandomDayGuard.

<a id="user-visible-proof"></a>
## Prova visível ao usuário

Uma versão é compreensível quando um novo operador pode instalá-la, encontrar o primeiro relatório de status do servidor, distinguir as cinco rotas de relatório e seguir uma ação clara de um exemplo trabalhado. As tarefas do leitor não devem exigir conhecimento de Git, PowerShell, Python ou soma de verificação.

<a id="contributor-checks"></a>
## Verificações do contribuidor

```powershell
python -B tools/validate_repo.py
python -B tools/test_public_pipeline.py
python -B -m unittest discover tests
```

Quando `luac` está disponível:

```powershell
luac -p RandomDayGuard/Scripts/main.lua
luac -p RandomDayGuard/Scripts/public_pipeline.lua
```

Os testes de fixture Lua cobrem o carregador, o agendador, as rotas de relatório e Admin.ini transações de gravação opcionais. Os fixtures de imposição usam apenas arquivos temporários e verificam identidade, rejeição de conta confiável, limites, backup, recusa de alteração simultânea, leitura e reversão.

<a id="package-proof"></a>
## Prova de pacote

```powershell
python -B tools/build_release_zip.py --check
git diff --check
```

- Todos os marcadores de versão correspondem. `VERSION`.
- Somente a versão atual existe em `releases/`.
- O ZIP contém os `RandomDayGuard/Scripts/main.lua` e nenhum carregador de variante em minúsculas.
- Saída de tempo de execução, configuração privada, credenciais, caminhos locais, caches e artefatos de teste são excluídos.
- A configuração pública permanece somente para revisão com a aplicação desativada.
- Os cinco exemplos de relatório trabalhados permanecem consistentes com a propriedade da rota e o dispositivo de teste de lançamento.
- ZIP bytes canônicos, são determinísticos e correspondem `CHECKSUMS.sha256`.
- Todos os links de documentação local e 27 páginas de entrada de localidade são validados.

<a id="avoid-validation-environment-pitfalls"></a>
## Evite armadilhas do ambiente de validação

- Execute verificações de gravação de repositório em série para evitar contenção de arquivos temporários.
- No Windows, inspecione nomes de membros arquivados ou ortografia de caminhos enumerados em vez de uma pesquisa de arquivo sem distinção entre maiúsculas e minúsculas ao verificar se há duplicatas carregadores.
- Um comando `luac` ausente ou tempo de execução Lua é um recurso indisponível, não uma sintaxe aprovada ou teste de tempo de execução.
- Um fixture prova apenas suas entradas modeladas. Isso não prova que um servidor ativo produziu um relatório atual.
- Registre os tempos limite do comando e a saída parcial em vez de assumir a conclusão.

<a id="repair-failed-repository-validation"></a>
## Repare a falha na validação do repositório

Comece com o primeiro caminho ou contrato relatado. Corrija esse item, execute novamente o teste restrito e, em seguida, execute novamente a matriz completa. Não esconda um recurso ausente removendo o teste que o exige.

<a id="known-limits-and-release-decision"></a>
## Limites conhecidos e decisão de liberação

Verificações locais comprovam contratos de origem, acessórios, pacotes e documentação. Uma instalação específica de servidor, janela de estabilidade de longa duração ou exibição de cliente requer um resultado de integração separado. Registre esse resultado com sua construção, configuração, duração e saída observada antes de fazer a declaração correspondente.
