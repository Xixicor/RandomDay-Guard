<a id="ban-id-mapping"></a>
# Ban-ID-Zuordnung

> **Kanonisch-englische Quelle:** [BAN_ID_MAPPING.md](../../BAN_ID_MAPPING.md). Diese lokalisierte Dokumentation bewahrt genaue Befehle, Pfade, Schlüssel, Statuswerte, Hashes und Dateinamen. Wenn der technische Wortlaut abweicht, verwenden Sie die englische Quelle.


Verwenden Sie diese Seite, wenn Sie einen Spielernamen in eine sichere `Admin.ini` Bannlinie umwandeln.

<a id="core-rule"></a>
## Kernregel

Ein Anzeigename ist keine Bann-ID.

`Admin.ini` verwendet:

```ini
BannedPlayer=<raw numeric player ID>
```

<a id="evidence-hierarchy"></a>
## Beweishierarchie

| Rang | Quelle | Verwendung |
|---:|---|---|
| 1 | Serverprotokoll `Login request` | Beste Name-zu-ID-Zuordnung |
| 2 | `Player_<ID>.sav` | Bestätigt, dass die ID vorhanden ist |
| 3 | Vorhandene `Admin.ini` | Vorhandene bans/moderators |
| 4 | Externe Benachrichtigung oder Hosting-Panel-Aktivität | Time/name nur Kontext; nicht ausweissicher |
| 5 | UE4SS focus/player nur Zeilen | Presence/context |
| 6 | Systemlebenszyklus- oder Containerprotokolle | Nur Hostlebenszykluskontext; Kein ID-Beweis |

<a id="extract-the-clean-id"></a>
## Extrahieren Sie die saubere ID

Rohbeispiel:

```text
ConnectID=2535422284688820_+_|0002d07b...
```

Sauber `Admin.ini`Wert:

```ini
BannedPlayer=2535422284688820
```

Nicht einfügen `_+_|...`.

<a id="verify-with-playerdata"></a>
## Überprüfen mit PlayerData

Überprüfen auf:

```text
Saved/SaveGames/Server/Worlds/<WorldName>/PlayerData/Player_<ID>.sav
```

Bedeutung:

```text
The ID exists in the world save.
```

Einschränkung:

```text
PlayerData may not prove the display name unless another source maps it.
```

<a id="when-not-to-ban"></a>
## Wann nicht gesperrt werden soll

Weisen Sie keine Sperr-ID zu, wenn:

```text
the name only appears in an external notification
the name only appears in hosting-panel activity
UE4SS shows a name but no ConnectID
only system lifecycle or container logs exist
the ID is trusted or moderator
```

<a id="evidence-table-template"></a>
## Beweistabellenvorlage

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
## Verwandte Dokumente

* [`ADMIN_INI_ENFORCEMENT.md`](ADMIN_INI_ENFORCEMENT.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](WORKFLOW_ZUR_PLAYER-%C3%9CBERPR%C3%9CFUNG.md)
