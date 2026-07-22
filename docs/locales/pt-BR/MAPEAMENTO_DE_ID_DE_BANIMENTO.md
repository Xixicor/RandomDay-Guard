<a id="ban-id-mapping"></a>
# Mapeamento de ID de banimento

> **Fonte canônica em inglês:** [BAN_ID_MAPPING.md](../../BAN_ID_MAPPING.md). Essa documentação localizada preserva comandos, caminhos, chaves, valores de status, hashes e nomes de arquivos exatos. Se o texto técnico for diferente, use a fonte em inglês.


Use esta página ao converter o nome de um jogador em uma `Admin.ini` linha de banimento segura.

<a id="core-rule"></a>
## Regra básica

Um nome de exibição não é um ID de banimento.

`Admin.ini` usa:

```ini
BannedPlayer=<raw numeric player ID>
```

<a id="evidence-hierarchy"></a>
## Hierarquia de evidências

| Classificação | Origem | Usar |
|---:|---|---|
| 1 | Registro do servidor `Login request` | Melhor mapeamento de nome para ID |
| 2 | `Player_<ID>.sav` | Confirma que o ID existe |
| 3 | Existente `Admin.ini` | Existente bans/moderators |
| 4 | Notificação externa ou atividade do painel de hospedagem | Time/name somente contexto; não é à prova de identificação |
| 5 | UE4SS focus/player linhas | Presence/context somente |
| 6 | Ciclo de vida do sistema ou logs de contêiner | Apenas contexto do ciclo de vida do host; não é prova de ID |

<a id="extract-the-clean-id"></a>
## Extraia o ID limpo

Exemplo bruto:

```text
ConnectID=2535422284688820_+_|0002d07b...
```

Limpo `Admin.ini` valor:

```ini
BannedPlayer=2535422284688820
```

Não cole `_+_|...`.

<a id="verify-with-playerdata"></a>
## Verifique com PlayerData

Verifique:

```text
Saved/SaveGames/Server/Worlds/<WorldName>/PlayerData/Player_<ID>.sav
```

Significado:

```text
The ID exists in the world save.
```

Limitação:

```text
PlayerData may not prove the display name unless another source maps it.
```

<a id="when-not-to-ban"></a>
## Quando não banir

Não atribua um ID de banimento quando:

```text
the name only appears in an external notification
the name only appears in hosting-panel activity
UE4SS shows a name but no ConnectID
only system lifecycle or container logs exist
the ID is trusted or moderator
```

<a id="evidence-table-template"></a>
## Modelo de tabela de evidências

```text
display_name:
server_time:
log_file:
line_number:
log_name:
connect_id_raw:
ban_id:
unique_id:
playerdata_file:
decision:
notes:
```

<a id="related-docs"></a>
## Documentos relacionados

* [`ADMIN_INI_ENFORCEMENT.md`](APLICA%C3%87%C3%83O_DE_INICIALIZA%C3%87%C3%83O_ADMINISTRATIVA.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](FLUXO_DE_TRABALHO_DE_REVIS%C3%83O_DO_JOGADOR.md)
