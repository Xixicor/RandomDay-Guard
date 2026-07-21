# Ban ID mapping

Use this page when converting a player name into a safe `Admin.ini` ban line.

## Core rule

A display name is not a ban ID.

`Admin.ini` uses:

```ini
BannedPlayer=<raw numeric player ID>
```

## Evidence hierarchy

| Rank | Source | Use |
|---:|---|---|
| 1 | Server log `Login request` | Best name-to-ID mapping |
| 2 | `Player_<ID>.sav` | Confirms ID exists |
| 3 | Existing `Admin.ini` | Existing bans/moderators |
| 4 | External notification or hosting-panel activity | Time/name context only; not ID proof |
| 5 | UE4SS focus/player lines | Presence/context only |
| 6 | System lifecycle or container logs | Host lifecycle context only; not ID proof |

## Extract the clean ID

Raw example:

```text
ConnectID=2535422284688820_+_|0002d07b...
```

Clean `Admin.ini` value:

```ini
BannedPlayer=2535422284688820
```

Do not paste `_+_|...`.

## Verify with PlayerData

Check for:

```text
Saved/SaveGames/Server/Worlds/<WorldName>/PlayerData/Player_<ID>.sav
```

Meaning:

```text
The ID exists in the world save.
```

Limitation:

```text
PlayerData may not prove the display name unless another source maps it.
```

## When not to ban

Do not assign a ban ID when:

```text
the name only appears in an external notification
the name only appears in hosting-panel activity
UE4SS shows a name but no ConnectID
only system lifecycle or container logs exist
the ID is trusted or moderator
```

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

## Related docs

* [`ADMIN_INI_ENFORCEMENT.md`](ADMIN_INI_ENFORCEMENT.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](PLAYER_REVIEW_WORKFLOW.md)
