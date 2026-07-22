<a id="faq"></a>
# FAQ

> **Fonte canônica em inglês:** [FAQ.md](../../FAQ.md). Essa documentação localizada preserva comandos, caminhos, chaves, valores de status, hashes e nomes de arquivos exatos. Se o texto técnico for diferente, use a fonte em inglês.


<a id="is-randomdayguard-the-randomday-mod"></a>
## É RandomDayGuard o RandomDay Mod?

Não. RandomDay Mod altera a experiência do servidor. RandomDayGuard observa a camada de evidências do servidor.

<a id="does-live-defense-work-before-the-scan-completes"></a>
## A defesa ao vivo funciona antes da conclusão da verificação?

Sim. A defesa ao vivo usa logs e eventos de sessão. A verificação da linha de base melhora o contexto posteriormente.

<a id="why-can-the-first-scan-take-a-long-time"></a>
## Por que a primeira verificação pode demorar muito?

A primeira verificação cria world/object contexto, manifestos de arquivo e dados de linha de base reutilizáveis.

<a id="what-do-i-check-first-after-startup"></a>
## O que verifico primeiro após a inicialização?

```text
runtime/current/poll_status.json
```

Procure:

```text
scheduler_status=running
poll_id increasing
poll_in_flight=false
```

<a id="where-are-player-summaries"></a>
## Onde estão os jogadores resumos?

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
```

<a id="where-is-the-daily-quick-review-package"></a>
## Onde está o pacote de revisão rápida diária?

```text
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

<a id="which-file-should-i-upload-for-fastest-review"></a>
## Qual arquivo devo enviar para uma revisão mais rápida?

```text
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="can-it-write-bans-automatically"></a>
## Ele pode gravar proibições automaticamente?

Somente se explicitamente ativado.

Padrão:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

<a id="what-does-adminini-receive"></a>
## O que faz Admin.ini receber?

Apenas:

```ini
BannedPlayer=<ID>
```

Sem nomes, comentários, motivos ou sufixos.

<a id="is-a-display-name-enough-to-ban"></a>
## Um nome de exibição é suficiente para banir?

Não. Use um registro do servidor `Login request` com `ConnectID` ou evidência de servidor equivalente.

<a id="can-one-crash-ban-someone"></a>
## É possível banir alguém por acidente?

Não por padrão.

<a id="can-object-count-alone-ban-someone"></a>
## A contagem de objetos sozinha pode banir alguém?

Não por padrão.

<a id="should-savedroottxt-point-to-the-world-folder"></a>
## Deve SavedRoot.txt apontar para o mundo pasta?

Não. Aponte para `AbioticFactor/Saved`.

<a id="what-if-the-world-folder-changes"></a>
## E se a pasta mundial mudar?

Trate isso como uma mudança de identidade básica. Preserve a linha de base antiga e crie uma nova.

<a id="related-docs"></a>
## Documentos relacionados

* [`START_HERE.md`](COMECE_AQUI.md)
* [`FORENSIC_DAILY_ROLLUPS.md`](ROLLUPS_DI%C3%81RIOS_FORENSES.md)
* [`TROUBLESHOOTING.md`](SOLU%C3%87%C3%83O_DE_PROBLEMAS.md)
