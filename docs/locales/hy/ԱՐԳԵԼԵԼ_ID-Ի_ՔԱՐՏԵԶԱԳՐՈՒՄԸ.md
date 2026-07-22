<a id="ban-id-mapping"></a>
# Արգելել ID-ի քարտեզագրումը

> **Կանոնական անգլերեն աղբյուր:** [BAN_ID_MAPPING.md](../../BAN_ID_MAPPING.md). Այս տեղայնացված փաստաթուղթը պահպանում է ճշգրիտ հրամաններ, ուղիներ, բանալիներ, կարգավիճակի արժեքներ, հեշեր և ֆայլերի անուններ: Եթե ​​տեխնիկական ձևակերպումը տարբերվում է, օգտագործեք անգլերեն աղբյուրը:


Օգտագործեք այս էջը խաղացողի անունը պահարանի վերածելիս `Admin.ini` արգելքի տող:

<a id="core-rule"></a>
## Հիմնական կանոն

Ցուցադրվող անունը արգելքի ID չէ:

`Admin.ini` օգտագործում է՝

```ini
BannedPlayer=<raw numeric player ID>
```

<a id="evidence-hierarchy"></a>
## Ապացույցների հիերարխիա

| Վարկանիշ | Աղբյուր | Օգտագործել |
|---:|---|---|
| 1 | Սերվերի մատյան `Login request` | Լավագույն անուն-ID քարտեզագրում |
| 2 | `Player_<ID>.sav` | Հաստատում է ID-ի առկայությունը |
| 3 | Գոյություն ունի `Admin.ini` | Գոյություն ունի bans/moderators |
| 4 | Արտաքին ծանուցում կամ հոսթինգի վահանակի գործունեություն | Time/name միայն համատեքստ; ոչ անձը հաստատող փաստաթուղթ |
| 5 | UE4SS focus/player տողեր | Presence/context միայն |
| 6 | Համակարգի կյանքի ցիկլի կամ կոնտեյների մատյաններ | Միայն հյուրընկալող կյանքի ցիկլի համատեքստ; ոչ անձը հաստատող փաստաթուղթ |

<a id="extract-the-clean-id"></a>
## Հեռացրեք մաքուր ID-ն

Հում օրինակ՝

```text
ConnectID=2535422284688820_+_|0002d07b...
```

Մաքրել `Admin.ini` արժեքը՝

```ini
BannedPlayer=2535422284688820
```

Մի տեղադրեք `_+_|...`.

<a id="verify-with-playerdata"></a>
## Հաստատեք PlayerData

Ստուգեք՝

```text
Saved/SaveGames/Server/Worlds/<WorldName>/PlayerData/Player_<ID>.sav
```

Իմաստը՝

```text
The ID exists in the world save.
```

Սահմանափակում.

```text
PlayerData may not prove the display name unless another source maps it.
```

<a id="when-not-to-ban"></a>
## Երբ արգելել

Մի նշանակեք արգելքի ID, երբ՝

```text
the name only appears in an external notification
the name only appears in hosting-panel activity
UE4SS shows a name but no ConnectID
only system lifecycle or container logs exist
the ID is trusted or moderator
```

<a id="evidence-table-template"></a>
## Ապացույցների աղյուսակի ձևանմուշ

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
## Առնչվող փաստաթղթեր

* [`ADMIN_INI_ENFORCEMENT.md`](ADMIN_INI_ENFORCEMENT.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](%D4%BD%D4%B1%D5%82%D4%B1%D5%91%D5%88%D5%82%D4%BB_%D5%8E%D4%B5%D5%90%D4%B1%D5%86%D4%B1%D5%85%D5%84%D4%B1%D5%86_%D4%B1%D5%87%D4%BD%D4%B1%D5%8F%D4%B1%D5%86%D5%94%D4%B1%D5%85%D4%BB%D5%86_%D5%80%D5%88%D5%8D%D5%94.md)
