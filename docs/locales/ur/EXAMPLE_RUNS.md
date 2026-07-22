<a id="worked-operation-examples"></a>
# کام شدہ آپریشن کی مثالیں

> **کیننیکل انگریزی ماخذ:** [EXAMPLE_RUNS.md](../../EXAMPLE_RUNS.md). یہ مقامی دستاویزات درست کمانڈز، پاتھز، کیز، اسٹیٹس ویلیوز، ہیشز اور فائل کے ناموں کو محفوظ رکھتی ہیں۔ اگر تکنیکی الفاظ میں فرق ہے تو انگریزی ماخذ استعمال کریں۔


یہ مثالیں متوقع حالت کی منتقلی کی وضاحت کے لیے ایجاد کردہ اقدار کا استعمال کرتی ہیں۔ وہ براہ راست مطابقت یا کھلاڑی کے ثبوت نہیں ہیں۔

<a id="successful-current-cycle"></a>
## کامیاب موجودہ سائیکل

ان پٹ: پڑھنے کے قابل فعال لاگ، version/boot/epoch, `poll_id=41`، مکمل موجودہ پول، قابل تحریر accounting/history/report روٹس، کوئی مسدود نہ کرنے کی سست اسکین پالیسی۔

متوقع:

```text
server_status = full
player_activity = full or limited_expected_empty
case_review = full or limited_expected_empty
daily_rollup = full or limited_expected_empty
critical_guard = full or limited_expected_empty
```

ہر فعال راستے میں ہوتا ہے JSON/TXT آؤٹ پٹ اور `route_proof.json`۔ راستے کی حیثیت اس کے اپنے مضامین پر منحصر ہے، کامیابی کے عمومی پیغام پر نہیں۔

<a id="expected-empty-player-and-case-routes"></a>
## متوقع خالی پلیئر اور کیس روٹس

ان پٹ: کرنٹ سائیکل پروف مکمل ہے؛ کوئی موجودہ یا برقرار رکھنے والے کھلاڑی کی قطار نہیں؛ کوئی برقرار رکھا ہوا کیس اور کوئی موجودہ نہیں REVIEW/BAN-ELIGIBLE اکاؤنٹ۔

متوقع:

```text
player_activity.route_proof_status = limited_expected_empty
player_activity.expected_empty = true
player_activity.players = []

case_review.route_proof_status = limited_expected_empty
case_review.expected_empty = true
case_review.cases = []
```

ترجمہ شدہ رپورٹس کہتی ہیں کہ کوئی اہل پابند مضمون نہیں دیکھا گیا۔ ان کا یہ بھی کہنا ہے کہ اس سے یہ ثابت نہیں ہوتا کہ کوئی بھی کبھی جڑا نہیں ہے یا کوئی سیاق و سباق غائب نہیں ہے۔ کوئی پلیس ہولڈر نہیں player/case بنایا گیا ہے۔

<a id="partial-bounded-scan"></a>
## جزوی باؤنڈڈ اسکین

ان پٹ: تازہ کرنٹ log/poll; `scan_checkpoint.json` یا `scan_progress.json` موجود ہے؛ اسکین نامکمل ہے؛ پہلے سے طے شدہ `slow_world_scan_blocks_current_reports=false`.

متوقع:

```text
world_save_scan.status = partial
source accounting = partial
server_status may still be full for fresh current state
historical routes name the scan limitation
```

سیٹ کریں `slow_world_scan_blocks_current_reports=true` صرف اس صورت میں جب آپریٹر موجودہ رپورٹس کو بلاک کرنے کے لیے اختیاری سست ذریعہ چاہتا ہے۔ بازیابی اسکین کارکن کو دوبارہ شروع کرنے کی اجازت دینا ہے، نہ کہ چیک پوائنٹ کو حذف کرنے کے لیے۔

<a id="missing-current-cycle-proof"></a>
## کرنٹ سائیکل ثبوت غائب ہے

ان پٹ: فعال لاگ دستیاب نہیں، `poll_id=0`، یا boot/epoch/last-poll نسب غائب۔

متوقع:

```text
current_cycle_proof_complete = false
all route proof statuses = missing
each configured route envelope status = suppressed_current_cycle
delivery_eligible = false
delivery_attempted = false
```

دبا ہوا لفافہ ایک آڈٹ ریکارڈ ہے، قطار بند ترسیل نہیں۔ پرانے فائنل لاگز صرف تاریخی رہتے ہیں۔ پہلے گمشدہ lineage/source فیلڈ اور ایک نیا سائیکل بنائیں۔

<a id="malformed-optional-adminini-source"></a>
## غلط شکل اختیاری Admin.ini ذریعہ

ان پٹ: `Admin.ini` موجود ہے لیکن صاف ساختی توثیق میں ناکام ہے۔

متوقع:

```text
admin_ini.status = malformed
source reference preserved
write/enforcement path closed
```

فائل کو محفوظ کریں اور نظرثانی شدہ کلین فارمیٹ کو بحال کریں۔ رن ٹائم ثبوت میں وضاحتی متن رکھیں؛ ہر ایک `Admin.ini` صرف اندراج پر پابندی باقی ہے `BannedPlayer=<ID>`.

<a id="required-active-log-probe-error"></a>
## ضروری ایکٹیو لاگ پروب کی خرابی

ان پٹ: باؤنڈڈ مطلوبہ ایکٹیو لاگ پروب صاف پڑھنے کی غلطی کے ساتھ ناکام ہوجاتا ہے۔

متوقع:

```text
source_accounting.sources[active_log].status = error
source_accounting.sources[active_log].detail = "bounded active-log probe failed: <sanitized reason>"
coverage_status = unavailable
all route proof statuses = missing
```

`error` ماخذ کی قطار پر اپنی باؤنڈڈ تفصیل کے ساتھ رہتا ہے۔ اعلی درجے کی رپورٹ `unavailable`، اور روٹ پروف باقی ہے `missing` جب تک کہ ایک نیا موجودہ دور مطلوبہ ذریعہ ثابت نہ کر دے۔

<a id="incompatible-or-stale-baseline"></a>
## غیر موافق یا باسی بیس لائن

ان پٹ: تبدیل کر دیا گیا package/source شناخت یا stale/incompatible بیس لائن مینی فیسٹ۔

متوقع: توثیق یا رن ٹائم اسٹیٹس عدم مطابقت کو ریکارڈ کرتا ہے۔ اسکین ریاست مکمل دوبارہ استعمال کا دعوی نہیں کرتی ہے۔ پیشگی ثبوت کو محفوظ رکھیں، ایک واضح بیس لائن دوبارہ تعمیر شروع کریں، اور نئے ٹرمینل ثبوت کا انتظار کریں۔ بغیر کسی ریکارڈ شدہ وجہ کے زبردستی دوبارہ تعمیر کرنا ڈیفالٹ ریکوری نہیں ہے۔

<a id="paired-report-write-failure"></a>
## جوڑا رپورٹ لکھنے میں ناکامی

ان پٹ: JSON لکھنا کامیاب ہوتا ہے لیکن TXT لکھنا ناکام ہو جاتا ہے، یا الٹا۔

متوقع:

```text
route_proof_status = missing
completed = false
coverage_status = unavailable
output_write_detail = "paired JSON/TXT write failed: <sanitized reason>"
next_action = repair both route output writes
```

مصنف نے ناکامی پر دونوں بہن بھائیوں کو دوبارہ لکھنے کی بہترین کوشش کی۔ ایک کامیاب بہن بھائی کامیابی کے دعوے کے طور پر نہیں رہ سکتا۔ پابند تحریر کی تفصیل پانچویں اعلی سطحی کوریج ویلیو نہیں بناتی۔

<a id="route-proof-write-failure"></a>
## روٹ پروف تحریری ناکامی

ان پٹ: راستے کے جوڑے لکھے گئے تھے لیکن `route_proof.json` کو تبدیل نہیں کیا جا سکتا۔

متوقع: تمام رپورٹس دوبارہ لکھی گئی ہیں `missing`، تمام اطلاعاتی نتائج ہیں `route_proof_write_failed`، اور کوئی لفافہ قبول نہیں کیا جاتا ہے۔ ایک ترتیب شدہ راستے میں `suppressed_current_cycle` ڈیلیوری جھنڈوں کے ساتھ آڈٹ لفافہ غلط ہے۔ آؤٹ پٹ روٹ کی مرمت کریں اور اسی موجودہ سائیکل کو دوبارہ تخلیق کریں۔

<a id="review-only-enforcement-example"></a>
## صرف جائزہ کے نفاذ کی مثال

تشکیل:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

متوقع: اسکور، کیسز، اور سفارشات لکھی جا سکتی ہیں؛ `Admin.ini` کوئی تبدیلی نہیں ہے۔ یہ عوامی ڈیفالٹ ہے۔

<a id="approved-write-success-example"></a>
## تصویر کی کامیابی کی مثال

صرف الگ سے منظور شدہ ٹیسٹ تینوں رائٹ سوئچ سیٹ کر سکتا ہے۔ اسے صاف عددی شناخت بھی ثابت کرنی چاہیے، trust/moderator اخراج، حد کی اہلیت، درست Admin.ini path/parse، بیک اپ کامیابی، تحریری کامیابی، ریڈ بیک مساوات، اور اکاؤنٹ کے ساتھ مخصوص ثبوت۔

متوقع:

```text
runtime/backups/Admin_<timestamp>_<source-fingerprint>_<clean-ID>.ini
Admin.ini contains one clean BannedPlayer=<ID>
runtime/enforced_bans.jsonl and evidence mirror record success
```

کامیاب مثال دوسرے اکاؤنٹس کے لیے خودکار نفاذ کو فعال نہیں کرتی ہے۔

<a id="writereadback-failure-with-rollback"></a>
## Write/readback رول بیک کے ساتھ ناکامی

ان پٹ: ہر پری رائٹ گیٹ پاس ہوا؛ متبادل لکھنا یا ریڈ بیک ناکام ہوجاتا ہے۔ `rollback_on_readback_failure=true` اور تصدیق شدہ بیک اپ دستیاب ہے۔

متوقع: ناکامی کا ثبوت اسٹیج کو ریکارڈ کرتا ہے اور `rollback_success`؛ اصل Admin.ini بائٹس کو بحال کر دیا گیا ہے اور اکاؤنٹ کو کامیابی کے ساتھ نافذ ہونے کی اطلاع نہیں دی گئی ہے۔ اگر رول بیک بھی ناکام ہو جائے تو لکھنا بند کر دیں، دونوں کو محفوظ رکھیں files/evidence، اور بیک اپ سے دستی طور پر بازیافت کریں۔

<a id="local-outbox-example"></a>
## مقامی آؤٹ باکس کی مثال

ان پٹ: نوٹیفکیشن فعال ہے`local_file_outbox` موڈ، روٹ فعال، مکمل روٹ پروف، اور یا تو `full` یا واضح طور پر اجازت دی گئی متوقع خالی۔

متوقع لفافہ:

```text
schema = randomdayguard.notification/v1
completed_output = true
status = ready_for_local_consumer
delivery_eligible = true
delivery_backend = none
delivery_attempted = false
```

کے لیے missing/ineligible آؤٹ پٹ، اسی راستے میں اس کی بجائے `status=suppressed_current_cycle`, `completed_output=false`، اور `delivery_eligible=false`۔ یا تو فائل صرف مقامی تحریر کو ثابت کرتی ہے۔ کوئی فراہم کنندہ، نقل و حمل، ترسیل، یا پڑھنے کی رسید بنڈل یا اندازہ نہیں ہے۔

دیکھیں [`OUTPUT_SCHEMA_REFERENCE.md`](%D8%A2%D8%A4%D9%B9_%D9%BE%D9%B9_%D8%A7%D8%B3%DA%A9%DB%8C%D9%85%D8%A7_%D8%AD%D9%88%D8%A7%D9%84%DB%81.md), [`CONFIG_FIELD_CATALOG.md`](%DA%A9%D9%86%D9%81%DB%8C%DA%AF_%D9%81%DB%8C%D9%84%DA%88_%DA%A9%DB%8C%D9%B9%D9%84%D8%A7%DA%AF.md)، اور [`TROUBLESHOOTING.md`](%D9%B9%D8%B1%D8%A8%D9%84_%D8%B4%D9%88%D9%B9%D9%86%DA%AF.md).
