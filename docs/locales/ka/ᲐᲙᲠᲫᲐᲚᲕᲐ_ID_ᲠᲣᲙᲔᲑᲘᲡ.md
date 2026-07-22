<a id="ban-id-mapping"></a>
# იდენტიფიკაციის შედგენის აკრძალვა

> **კანონიკური ინგლისური წყარო:** [BAN_ID_MAPPING.md](../../BAN_ID_MAPPING.md). ეს ლოკალიზებული დოკუმენტაცია ინახავს ზუსტ ბრძანებებს, ბილიკებს, გასაღებებს, სტატუსის მნიშვნელობებს, ჰეშებსა და ფაილების სახელებს. თუ ტექნიკური ფორმულირება განსხვავდება, გამოიყენეთ ინგლისური წყარო.


გამოიყენეთ ეს გვერდი მოთამაშის სახელის სეიფად გადაქცევისას `Admin.ini` აკრძალვის ხაზი.

<a id="core-rule"></a>
## ძირითადი წესი

საჩვენებელი სახელი არ არის აკრძალვის ID.

`Admin.ini` იყენებს:

```ini
BannedPlayer=<raw numeric player ID>
```

<a id="evidence-hierarchy"></a>
## მტკიცებულებების იერარქია

| რანგი | წყარო | გამოიყენეთ |
|---:|---|---|
| 1 | სერვერის ჟურნალი `Login request` | საუკეთესო სახელი-იდენტიფიკაციის რუქა |
| 2 | `Player_<ID>.sav` | ადასტურებს ID-ს არსებობას |
| 3 | არსებული `Admin.ini` | არსებული bans/moderators |
| 4 | გარე შეტყობინება ან ჰოსტინგის პანელის აქტივობა | Time/name კონტექსტი; არა პირადობის დამადასტურებელი საბუთი |
| 5 | UE4SS focus/player ხაზები | Presence/context |
| 6 | სისტემის სასიცოცხლო ციკლის ან კონტეინერის ჟურნალები | მხოლოდ ჰოსტის სასიცოცხლო ციკლის კონტექსტი; არა პირადობის დამადასტურებელი საბუთი |

<a id="extract-the-clean-id"></a>
## ამოიღეთ სუფთა ID

დაუმუშავებელი მაგალითი:

```text
ConnectID=2535422284688820_+_|0002d07b...
```

გასუფთავება `Admin.ini` მნიშვნელობა:

```ini
BannedPlayer=2535422284688820
```

არ ჩასვათ `_+_|...`.

<a id="verify-with-playerdata"></a>
## დაადასტურეთ PlayerData

შეამოწმეთ:

```text
Saved/SaveGames/Server/Worlds/<WorldName>/PlayerData/Player_<ID>.sav
```

მნიშვნელობა:

```text
The ID exists in the world save.
```

შეზღუდვა:

```text
PlayerData may not prove the display name unless another source maps it.
```

<a id="when-not-to-ban"></a>
## როდის არ უნდა აიკრძალოს

არ მიანიჭოთ აკრძალვის ID, როდესაც:

```text
the name only appears in an external notification
the name only appears in hosting-panel activity
UE4SS shows a name but no ConnectID
only system lifecycle or container logs exist
the ID is trusted or moderator
```

<a id="evidence-table-template"></a>
## მტკიცებულებების ცხრილის შაბლონი

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
## დაკავშირებული დოკუმენტები

* [`ADMIN_INI_ENFORCEMENT.md`](ADMIN_INI_ENFORCEMENT.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](%E1%B2%9B%E1%B2%9D%E1%B2%97%E1%B2%90%E1%B2%9B%E1%B2%90%E1%B2%A8%E1%B2%98%E1%B2%A1_%E1%B2%9B%E1%B2%98%E1%B2%9B%E1%B2%9D%E1%B2%AE%E1%B2%98%E1%B2%9A%E1%B2%95%E1%B2%98%E1%B2%A1_%E1%B2%A1%E1%B2%90%E1%B2%9B%E1%B2%A3%E1%B2%A8%E1%B2%90%E1%B2%9D_%E1%B2%9E%E1%B2%A0%E1%B2%9D%E1%B2%AA%E1%B2%94%E1%B2%A1%E1%B2%98.md)
