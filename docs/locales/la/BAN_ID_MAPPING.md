<a id="ban-id-mapping"></a>
# Ban ID destinata

> **Canonicum Anglicum fontem:** [BAN_ID_MAPPING.md](../../BAN_ID_MAPPING.md).  Haec documenta localia mandata exacta, semitas, claves, valores, hashes, nomina fasciculi conservat. Si forma technica differt, fonte Anglico utere.


 Hac pagina utere, cum nomen lusoris in tuto convertens `Admin.ini` ban line.

<a id="core-rule"></a>
## Core rule

 Ostentationis nomen bannum ID non est.

`Admin.ini` usus:

```ini
BannedPlayer=<raw numeric player ID>
```

<a id="evidence-hierarchy"></a>
## Evidentia hierarchiae

| Rank | Source | Usus |
|---:|---|---|
| 1 | Servi log `Login request` | Optimus nomen ut-ID destinata |
| 2 | `Player_<ID>.sav` | Confirmat ID existere |
| 3 | Existens `Admin.ini` | Existens bans/moderators |
| 4 | externa notificatio seu actio hosting-panel | Time/namecontext only; Non ID probationem |
| 5 | UE4SS focus/playerlines | Presence/context tantum |
| 6 | Systema vitacycli seu tabulae continens | Militiae vivificum contextum solum; Non ID probationem |

<a id="extract-the-clean-id"></a>
## Extract munda ID

Raw exemplum:

```text
ConnectID=2535422284688820_+_|0002d07b...
```

Clean`Admin.ini` valorem:

```ini
BannedPlayer=2535422284688820
```

Do not crustulum`_+_|...`.

<a id="verify-with-playerdata"></a>
## Verificare cum PlayerData

Reprehendo pro:

```text
Saved/SaveGames/Server/Worlds/<WorldName>/PlayerData/Player_<ID>.sav
```

Significatio:

```text
The ID exists in the world save.
```

Limitation:

```text
PlayerData may not prove the display name unless another source maps it.
```

<a id="when-not-to-ban"></a>
## Cum non prohibeas

 bannum ID cum:

```text
the name only appears in an external notification
the name only appears in hosting-panel activity
UE4SS shows a name but no ConnectID
only system lifecycle or container logs exist
the ID is trusted or moderator
```

<a id="evidence-table-template"></a>
## Evidence table template

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
## Related docs

* [`ADMIN_INI_ENFORCEMENT.md`](ADMIN_INI_EFFECTUS.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](PLAYER_REVIEW_WORKFLOW.md)
