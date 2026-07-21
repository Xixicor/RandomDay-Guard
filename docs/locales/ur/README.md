# RandomDayGuard اردو رہنما

**v0.4.12-alpha**

RandomDayGuard ایک Abiotic Factor dedicated server سے محدود ثبوت جمع کر کے انہیں
واضح operator reports میں ترتیب دیتا ہے۔ Server status، daily summary، player
activity، case review اور critical failures الگ routes میں رہتے ہیں۔

## تنصیب

[Installation guide](../../../INSTALL.md) پر عمل کریں۔ Mod کا درست مقام
`ue4ss/Mods/RandomDayGuard` ہے اور `mods.txt` میں `RandomDayGuard : 1` ہونا
چاہیے۔ Nested install اور duplicate `Scripts` folder نہ رکھیں۔

## پہلی report کی تصدیق

پہلے `runtime/current/startup_status.json`، پھر
`runtime/final_logs/latest_dossier.json` اور
`runtime/final_logs/route_proof.json` دیکھیں۔ ہر route کی حالت `full`،
`limited_expected_empty` یا `missing` ہوگی۔ Summary اور cited source ایک ہی
processing cycle سے ہونے چاہییں۔

## Configuration اور operation

Public defaults ہیں: `review_only_mode = true`، `auto_ban = false` اور
`write_admin_ini = false`۔ [Start](../../START_HERE.md)،
[Operations](../../OPERATIONS_PLAYBOOK.md)، [Configuration](../../CONFIG_PROFILES.md)
اور [Troubleshooting](../../TROUBLESHOOTING.md) دیکھیں۔ Structured evidence
technical record ہے؛ translation اسے پڑھنے میں آسان بناتی ہے۔

Commands، paths، keys اور states اصل files سے مطابقت کے لیے English میں رہتے ہیں۔

## الفا ریلیز اور ثبوت کے دو راستے

یہ الفا ریلیز ہے۔ دستاویزی جمع، رپورٹ اور بحالی کے راستے آزمائے گئے ہیں؛ مطابقت، تاریخی کوریج اور رپورٹ کا معیار مزید بہتر ہو رہا ہے۔

موجودہ راستہ فعال لاگ، موجودہ آغاز اور شیڈیولر کی حالت اور موجودہ سیشن استعمال کرتا ہے، اس لیے فوری موجودہ رپورٹ لکھ سکتا ہے۔ تاریخی راستہ محفوظ لاگ، PlayerData نام، پرانے ثبوت اور کیس محدود مراحل میں دیکھتا ہے۔

`runtime/current/report_worker_status.json`

کئی ادوار میں `runtime/current/report_worker_status.json` کے `scan_cursor` اور `last_progress_ts` کا موازنہ کریں۔ آگے بڑھیں تو اسکین چل رہا ہے۔ موجودہ رپورٹس بڑھیں مگر یہ نہ بدلیں تو تاریخی اسکین رکا ہوا ہے؛ موجودہ حقائق مفید رہتے ہیں مگر پرانی تاریخ پر منحصر نتائج محدود رہتے ہیں۔

[Troubleshooting](../../TROUBLESHOOTING.md)
