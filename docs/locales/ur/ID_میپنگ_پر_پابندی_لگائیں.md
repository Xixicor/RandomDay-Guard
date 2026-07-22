<a id="ban-id-mapping"></a>
# ID میپنگ پر پابندی لگائیں

> **کیننیکل انگریزی ماخذ:** [BAN_ID_MAPPING.md](../../BAN_ID_MAPPING.md). یہ مقامی دستاویزات درست کمانڈز، پاتھز، کیز، اسٹیٹس ویلیوز، ہیشز اور فائل کے ناموں کو محفوظ رکھتی ہیں۔ اگر تکنیکی الفاظ میں فرق ہے تو انگریزی ماخذ استعمال کریں۔


کسی کھلاڑی کے نام کو محفوظ میں تبدیل کرتے وقت اس صفحہ کا استعمال کریں `Admin.ini` پابندی کی لکیر۔

<a id="core-rule"></a>
## بنیادی اصول

ڈسپلے کا نام پابندی والی ID نہیں ہے۔

`Admin.ini` استعمال کرتا ہے:

```ini
BannedPlayer=<raw numeric player ID>
```

<a id="evidence-hierarchy"></a>
## ثبوت کا درجہ بندی

| درجہ | ماخذ | استعمال کریں |
|---:|---|---|
| 1 | سرور لاگ `Login request` | بہترین نام سے ID میپنگ |
| 2 | `Player_<ID>.sav` | تصدیق کرتا ہے کہ ID موجود ہے |
| 3 | موجودہ `Admin.ini` | موجودہ bans/moderators |
| 4 | بیرونی اطلاع یا ہوسٹنگ پینل کی سرگرمی | Time/name صرف سیاق و سباق؛ شناختی ثبوت نہیں |
| 5 | UE4SS focus/player لائنیں | Presence/context صرف |
| 6 | سسٹم لائف سائیکل یا کنٹینر لاگز | صرف میزبان لائف سائیکل سیاق و سباق؛ شناختی ثبوت نہیں |

<a id="extract-the-clean-id"></a>
## کلین آئی ڈی نکالیں

 خام مثال:

```text
ConnectID=2535422284688820_+_|0002d07b...
```

صاف کریں `Admin.ini` قدر:

```ini
BannedPlayer=2535422284688820
```

پیسٹ نہ کریں `_+_|...`.

<a id="verify-with-playerdata"></a>
## کے ساتھ تصدیق کریں PlayerData

چیک کریں:

```text
Saved/SaveGames/Server/Worlds/<WorldName>/PlayerData/Player_<ID>.sav
```

مطلب:

```text
The ID exists in the world save.
```

حد:

```text
PlayerData may not prove the display name unless another source maps it.
```

<a id="when-not-to-ban"></a>
## جب پابندی نہ لگائی جائے

پابندی کی ID تفویض نہ کریں جب:

```text
the name only appears in an external notification
the name only appears in hosting-panel activity
UE4SS shows a name but no ConnectID
only system lifecycle or container logs exist
the ID is trusted or moderator
```

<a id="evidence-table-template"></a>
## ثبوت ٹیبل ٹیمپلیٹ

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
## متعلقہ دستاویزات

* [`ADMIN_INI_ENFORCEMENT.md`](%D8%A7%DB%8C%DA%88%D9%85%D9%86_%D8%A7%D9%86%D9%81%D9%88%D8%B1%D8%B3%D9%85%D9%86%D9%B9.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](%D9%BE%D9%84%DB%8C%D8%A6%D8%B1_%D8%B1%DB%8C%D9%88%DB%8C%D9%88_%D9%88%D8%B1%DA%A9_%D9%81%D9%84%D9%88.md)
