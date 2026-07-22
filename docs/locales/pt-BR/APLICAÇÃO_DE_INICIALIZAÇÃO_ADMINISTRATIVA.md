<a id="adminini-enforcement"></a>
# Admin.ini aplicação

> **Fonte canônica em inglês:** [ADMIN_INI_ENFORCEMENT.md](../../ADMIN_INI_ENFORCEMENT.md). Essa documentação localizada preserva comandos, caminhos, chaves, valores de status, hashes e nomes de arquivos exatos. Se o texto técnico for diferente, use a fonte em inglês.


RandomDayGuard não altera a lista de banimentos do servidor em sua configuração padrão. Ele apenas cria relatórios para um administrador revisar. Esta página explica a atualização automática opcional da lista de banimentos para administradores que a habilitam deliberadamente.

<a id="what-guard-checks-before-changing-the-ban-list"></a>
## O que o Guard verifica antes de alterar a lista de banimentos

Guard adiciona um banimento somente quando cada resposta abaixo for **sim**:

1. As evidências atuais identificaram uma conta específica com confiança suficiente?
2. A conta não é um moderador nem uma conta que o administrador marcou como confiável?
3. A conta ainda não está na lista de banimentos?
4. A conta atingiu a pontuação de ação automática configurada?
5. O Guard consegue ler a atual `Admin.ini` e salvar um backup idêntico?
6. `Admin.ini` permaneceu inalterado enquanto o Guard preparava a atualização?
7. Depois de salvar, o arquivo completo corresponde exatamente ao resultado pretendido?

Se alguma resposta for **não**, ou não puder ser verificada, Guard sai do `Admin.ini` inalterada e registra o motivo em seus relatórios. Se o salvamento começar, mas a verificação final falhar, o Guard restaura o backup verificado.

<a id="file-format"></a>
## Formato do arquivo

`Admin.ini` deve receber apenas linhas de proibição limpas:

```ini
BannedPlayer=<ID>
```

- Sem nomes.
- Sem comentários.
- Sem motivos.
- Não sufixos.

<a id="safe-defaults"></a>
## Padrões seguros

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
require_clean_ban_id = true
preserve_existing_bans = true
preserve_moderators = true
```

<a id="ban-id-source"></a>
## Fonte do ID de banimento

Melhor fonte:

```text
Login request
Name=<player>
ConnectID=<raw_id>
UniqueId=<platform_id>
```

O tempo de execução aceita um ID totalmente numérico ou o formulário de conexão `<digits>_+_|<non-space token>` documentado completo e deriva o ID de banimento numérico dele. Prefixos numéricos arbitrários com sufixo desconhecido são rejeitados; elas não são truncadas em um ID de banimento.

Correto:

```ini
BannedPlayer=2535422284688820
```

Errado:

```ini
BannedPlayer=ExamplePlayer
```

Também errado:

```text
BannedPlayer=<ID>
```

<a id="exact-settings-guard-checks"></a>
## Configurações exatas Verificações de proteção

Essas configurações implementam as verificações descritas acima. Cada condição listada deve ser verdadeira:

```text
review_only_mode == false
auto_ban == true
write_admin_ini == true
ban_id is clean numeric
identity is mapped
not trusted
not moderator
threshold is met
account-specific evidence exists
```

Se alguma condição for falsa ou não puder ser verificada, o Guard deixa a lista de banimentos inalterada e registra o que a interrompeu.

<a id="transaction-safety"></a>
## Segurança nas transações

O único `Admin.ini` caminho de mutação executa estas etapas em ordem:

1. Leia e valide estruturalmente os bytes autoritativos.
2. Deduza o estado de moderador, confiável e de banimento existente desse mesmo snapshot.
3. Escreva um backup exclusivo em `runtime/backups/` e verifique-o byte por byte.
4. Releia `Admin.ini` imediatamente antes da substituição e rejeite qualquer alteração externa.
5. Escreva o candidato através do caminho de substituição controlado configurado.
6. Exija que os bytes de leitura completos sejam iguais aos bytes candidatos completos.
7. Ativado falha de leitura, restaure o backup verificado apenas enquanto o arquivo atual ainda for o candidato exato escrito pelo Guard. Se outro gravador o alterou, o Guard recusa a reversão em vez de substituir bytes externos desconhecidos.

IDs duplicados são idempotentes: nenhuma segunda linha e nenhum segundo backup são gravados. Os nomes de backup incluem carimbo de data e hora, impressão digital de byte de origem e ID limpo, portanto, tentativas separadas não podem compartilhar o nome de arquivo antigo de um segundo.

<a id="local-regression-proof"></a>
## Prova de regressão local

`tests/lua/enforcement_runtime_test.lua` inicializa o carregador enviado uma vez e, em seguida, executa seu fechamento local real `append_ban()` em arquivos sintéticos isolados abaixo do diretório do repositório `.tmp/`. Abrange inserção, idempotência duplicada, moderator/trusted rejeição, rejeição de identidade fraca e malformada, verificação de backup exato de bytes, rejeição de modificação simultânea, reversão bem-sucedida após leitura com falha e recusa de substituir uma alteração externa pós-gravação. Seus wrappers de sistema de arquivos rejeitam qualquer mutação fora da raiz do fixture; nenhum caminho de servidor real ou `Admin.ini` real é usado.

Execute-o em `python tools/test_public_pipeline.py`. Um passe de fixture prova apenas o comportamento da transação local. Ele não permite a aplicação, não autoriza uma gravação de produção nem prova permissões específicas do host.

<a id="files-to-check"></a>
## Arquivos a serem verificados

```text
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
runtime/enforced_bans.jsonl
runtime/enforced.txt
runtime/ban_queue.json
```

<a id="rollback"></a>
## Reversão

1. Pare o servidor.
2. Restaure o Admin.ini backup mais recente de `runtime/backups/`.
3. Remova a linha `BannedPlayer=<ID>` incorreta, se necessário.
4. Inicie o servidor.
5. Reabra Admin.ini e confirme se a linha persistiu ou foi removida.
6. Preservar `enforced_bans.jsonl` para auditoria.

<a id="related-docs"></a>
## Documentos relacionados

* [`BAN_ID_MAPPING.md`](MAPEAMENTO_DE_ID_DE_BANIMENTO.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](FLUXO_DE_TRABALHO_DE_REVIS%C3%83O_DO_JOGADOR.md)
