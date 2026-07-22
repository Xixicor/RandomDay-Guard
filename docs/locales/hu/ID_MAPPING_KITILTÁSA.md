<a id="ban-id-mapping"></a>
# Az azonosító leképezés letiltása

> **Kanonikus angol forrás:** [BAN_ID_MAPPING.md](../../BAN_ID_MAPPING.md). Ez a lokalizált dokumentáció megőrzi a pontos parancsokat, elérési utakat, kulcsokat, állapotértékeket, kivonatokat és fájlneveket. Ha a technikai megfogalmazás eltér, használja az angol forrást.


Használja ezt az oldalt, amikor egy játékos nevét széfré alakítja `Admin.ini` kitiltási sor.

<a id="core-rule"></a>
## Alapszabály

A megjelenített név nem tiltási azonosító.

`Admin.ini` használja:

```ini
BannedPlayer=<raw numeric player ID>
```

<a id="evidence-hierarchy"></a>
## Bizonyíték-hierarchia

| Rangsor | Forrás | Használja |
|---:|---|---|
| 1 | Szervernapló `Login request` | A legjobb név-azonosító leképezés |
| 2 | `Player_<ID>.sav` | Megerősíti az azonosító létezését |
| 3 | Meglévő `Admin.ini` | Meglévő bans/moderators |
| 4 | Külső értesítés vagy tárhely-panel tevékenység | Time/name csak kontextusban; nem személyi igazolvány |
| 5 | UE4SS focus/player sorok | Presence/context csak |
| 6 | Rendszer-életciklus vagy tárolónaplók | Csak gazdagép életciklus-kontextusa; nem személyi igazolvány |

<a id="extract-the-clean-id"></a>
## Kivonja ki a tiszta azonosítót

Nyers példa:

```text
ConnectID=2535422284688820_+_|0002d07b...
```

Tisztítás `Admin.ini` érték:

```ini
BannedPlayer=2535422284688820
```

Ne illessze be `_+_|...`.

<a id="verify-with-playerdata"></a>
## Ellenőrzés a PlayerData

Ellenőrizze:

```text
Saved/SaveGames/Server/Worlds/<WorldName>/PlayerData/Player_<ID>.sav
```

Jelentés:

```text
The ID exists in the world save.
```

Korlátozás:

```text
PlayerData may not prove the display name unless another source maps it.
```

<a id="when-not-to-ban"></a>
## Mikor nem szabad kitiltani

Ne rendeljen kitiltási azonosítót, ha:

```text
the name only appears in an external notification
the name only appears in hosting-panel activity
UE4SS shows a name but no ConnectID
only system lifecycle or container logs exist
the ID is trusted or moderator
```

<a id="evidence-table-template"></a>
## Bizonyítéktábla-sablon

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
## Kapcsolódó dokumentumok

* [`ADMIN_INI_ENFORCEMENT.md`](ADMIN_INI_V%C3%89GREHAJT%C3%81S.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](J%C3%81T%C3%89KOS_ELLEN%C5%90RZ%C3%89SI_MUNKAFOLYAMAT.md)
