<a id="configuration-profiles"></a>
# Yapılandırma profilleri

> **Kanonik İngilizce kaynağı:** [CONFIG_PROFILES.md](../../CONFIG_PROFILES.md). Bu yerelleştirilmiş belgeler tam komutları, yolları, anahtarları, durum değerlerini, karmaları ve dosya adlarını korur. Teknik ifadeler farklıysa İngilizce kaynağı kullanın.


Pratik bir yapılandırma profili seçmek ve uygulamak için bu nasıl yapılır kılavuzunu kullanın. Ayar gruplarının nasıl etkileşimde bulunduğuna ilişkin bir açıklama için [`CONFIG_REFERENCE.md`](YAPILANDIRMA_REFERANSI.md) adresini okuyun. Kesin alanlar, varsayılanlar, türler ve değişmezler için oluşturulan [`CONFIG_FIELD_CATALOG.md`](YAPILANDIRMA_ALANI_KATALO%C4%9EU.md).

Aşağıdaki her Lua bloğu, gönderilen içindeki eşleşen girişlerin yerini alabilecek bir dizi üst düzey giriştir `return { ... }` tablosunun içine doğrudan eklenecek şekilde şekillendirilmiştir.

<a id="profile-chooser"></a>
## Profil seçici

| Durum | Bu profili kullan |
|---|---|
| İlk kurulum | Güvenli ilk kurulum |
| Sunucu kararsız ve sık sık çöküyor | Yavaş tarama olmadan mevcut kanıtlar |
| Bağlam object/world istiyorsunuz | Tam temel |
| Eski günlükleri incelemek istiyorsunuz | Adli tıp dolgu |
| Öneri istiyorsunuz ancak yazma yok | Yaptırım testi |
| Koruyucunun yazma yasaklarına izin vermeye hazırsınız | Zorlama etkin |
| Disk sınırlı | Düşük disk büyümesi |
| Temiz bir temel çizgiyi tamamladınız | Yapışkan yedekleme kurulumunu |

<a id="safe-first-install"></a>
## Güvenli ilk kurulum

Bunu ilk önce canlı bir sunucuda kullanın.

```lua
enforcement = {
    review_only_mode = true,
    auto_ban = false,
    write_admin_ini = false,
},

log_tail = {
    enabled = true,
    start_at_end_on_first_run = true,
    tail_backup_logs = false,
},

scanning = {
    full_scan_on_start = true,
    resume_incomplete_scan = true,
    reuse_completed_baseline = true,
    incremental_refresh_after_baseline = true,
},

reports = {
    enabled = true,
},

notification = {
    enabled = false,
},
```

Bunun faydası:

```text
Tracks live sessions.
Starts the baseline scan.
Does not edit Admin.ini.
Avoids treating old backup logs as fresh live events.
```

<a id="current-evidence-without-slow-scan"></a>
## Yavaş tarama olmadan mevcut kanıtlar

Sunucu kararsızsa ve ağır bir olaydan önce crash/reconnect kanıta ihtiyacınız varsa bunu kullanın. tarayın.

```lua
log_tail = {
    enabled = true,
},

scanning = {
    full_scan_on_start = false,
},

enforcement = {
    review_only_mode = true,
    auto_ban = false,
    write_admin_ini = false,
},

reports = {
    enabled = true,
},

notification = {
    enabled = false,
},
```

Bunun faydası:

```text
Tracks logins, joins, leaves, reconnects, crashes, and unclean sessions.
Delays heavy world scanning.
```

<a id="full-baseline"></a>
## Tam temel

Sunucu tarama yapacak kadar uzun süre açık kaldıktan sonra bunu kullanın.

```lua
scanning = {
    full_scan_on_start = true,
    resume_incomplete_scan = true,
    reuse_completed_baseline = true,
    incremental_refresh_after_baseline = true,
},
```

Bunun faydası:

```text
Builds object registry.
Writes world-state context.
Creates file manifest.
Enables changed-file refresh later.
```

<a id="forensic-backfill"></a>
## Adli tıp dolgu

Bunu yalnızca geçmiş günlükleri kasıtlı olarak incelerken kullanın.

```lua
log_tail = {
    start_at_end_on_first_run = false,
    tail_backup_logs = true,
    backfill_backup_logs_on_start = true,
},
```

Kullanmadan önce:

```text
Back up runtime/log_offsets.tsv.
Expect old events to be reprocessed.
Return to live settings when finished.
```

<a id="enforcement-testing"></a>
## Yaptırım testi

Bunu gerçek Admin.ini yazmadan önce kullanın.

```lua
enforcement = {
    review_only_mode = true,
    auto_ban = false,
    write_admin_ini = false,
},
```

Neyin denetleneceği:

```text
runtime/account_evidence.json
runtime/warnings/
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="enforcement-enabled"></a>
## Zorlama etkin

Bunu yalnızca inceleme çıktısı doğru olduktan sonra kullanın.

```lua
enforcement = {
    review_only_mode = false,
    auto_ban = true,
    write_admin_ini = true,
    require_clean_ban_id = true,
    preserve_existing_bans = true,
    preserve_moderators = true,
},
```

Etkinleştirmeden önce:

```text
Trusted IDs are configured.
Moderator IDs are preserved.
Admin.ini backups work.
Ban recommendations are understandable.
Thresholds are accepted by the server owner.
```

<a id="low-disk-growth"></a>
## Düşük disk büyümesi

Çalışma zamanı dosyaları çok hızlı büyüdüğünde bunu kullanın.

```lua
logging = {
    low_importance_mode = "aggregate",
    write_low_importance_raw_events = false,
},

retention = {
    detailed_retention_days = 7,
    rotate_jsonl_when_bytes_exceed = 5242880,
    max_raw_events_lines = 20000,
    compact_json_outputs = true,
},
```

<a id="sticky-backup-setup"></a>
## Yapışkan yedekleme kurulumunu

İlk tamamlanan temel çizgiden sonra kullanın.

Bunları kontrol edin. mevcut:

```text
runtime/scan_complete.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
runtime/world_state/current/world_state_latest.json
```

Daha sonra bunları `config.lua`, `SavedRoot.txt` ve `Admin.ini`.

<a id="related-docs"></a>
## İlgili belgeler

* [`CONFIG_REFERENCE.md`](YAPILANDIRMA_REFERANSI.md)
* [`FORENSIC_DAILY_ROLLUPS.md`](ADLI_G%C3%9CNL%C3%9CK_TOPLAMALAR.md)
* [`ADMIN_INI_ENFORCEMENT.md`](Y%C3%96NETICI_INI_UYGULAMASI.md)
