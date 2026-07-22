<a id="output-and-state-schema-reference"></a>
# Çıktı ve durum şeması referansı

> **Kanonik İngilizce kaynağı:** [OUTPUT_SCHEMA_REFERENCE.md](../../OUTPUT_SCHEMA_REFERENCE.md). Bu yerelleştirilmiş belgeler tam komutları, yolları, anahtarları, durum değerlerini, karmaları ve dosya adlarını korur. Teknik ifadeler farklıysa İngilizce kaynağı kullanın.


Bu, operatöre yönelik oluşturulan dosyalar için standart sözleşmedir. Tam çıktı yollarına, alan adlarına, izin verilen değerlere, köken gereksinimlerine ve rota şemalarına tek başına sahiptir. Prosedür kılavuzları bu gerçekleri yeniden tanımlamak yerine buraya bağlantı verir.

Çalışma zamanı kanıtları güvenilirdir; bir dosya adı, zamanlayıcı sinyali, çevrilmiş rapor veya yerel giden kutusu nesnesi, kendi alanlarından ve kökeninden fazlasını kanıtlamaz.

<a id="public-report-routes"></a>
## Genel rapor rotaları

Rapor çalışanının altında beş rota var `runtime/final_logs/`:

| Rota | Sözleşme | `full` gereksinimi | Beklenen-boş anlamı |
|---|---|---|---|
| `server_status` | Geçerli zamanlayıcı, aktif günlük, tarama beklemede ve kaynak kapsamı durumu. | Etkin günlükte görünen güncel boot/epoch/poll köken, yeni etkin günlük, accounting/history yazar ve JSON/TXT çifti. | Başka türlü sağlıklı bir akım döngüsü için kullanılmaz; eksik köken `missing`. |
| `daily_rollup` | Etkin günlükte görünen güncel day/window sunucu, oynatıcılar, vakalar, tarama ve kapsam genelinde sürekliliktir. | Rota için yeterli geçmiş muhasebe terminali ve mevcut döngünün kanıtı tamamlandı. | Tutulan oynatıcı ve inceleme vakası yok. |
| `player_activity` | Mevcut ve geçmiş player/account gözlemleri ayırın. | Geçerli döngü kanıtı artı bir veya daha fazla current/historical satır. | Sınırlı girişlerde uygun oynatıcı satırı yok; sentetik konu yok. |
| `case_review` | Adlandırılmış tutulan vakalar ve mevcut review/BAN-ELIGIBLE adaylar. | Geçerli döngü kanıtı artı kaynak referanslarıyla birlikte bir veya daha fazla adlandırılmış vaka. | Adlandırılmış vaka yok inceleme kriterlerini karşıladı; sentetik durum yok. |
| `critical_guard` | Geçerli önyükleme zamanlayıcısı, başlatma, yoklama veya kanıt bütünlüğü hatası. | Geçerli döngü kanıtı ve güncel kritik hata. | Mevcut kritik hata yok; eski metin hataları bu rotanın sahibi değil. |

Etkinleştirilen her rota `<route>_latest.json` ve `<route>_latest.txt` yazar. `runtime/final_logs/route_proof.json` aynı sürümü, önyüklemeyi, dönemi, anketi ve kaynak yeniliğini kaydedene kadar çift tamamlanmaz.

<a id="report-json-schema"></a>
## Rapor JSON şeması

Eşleştirilmiş yazmalardan önce eklenen tüm rota JSON kullanır `schema="randomdayguard.report/v1"`.

| Alan | Tür | Anlam ve değişmez |
|---|---|---|
| `schema` | dizeyi | Tam olarak `randomdayguard.report/v1`. |
| `generated_ts`, `report_date` | dizeyi | Oluşturma zaman damgası ve raporlama tarihi. |
| `version` | dizeyi | Runtime/package bu döngünün kimliği. |
| `boot_id`, `epoch_id` | dizeyi | Geçerli işlem önyüklemesi ve sunucu sürekliliği dönemi. Tamamlanmak için her ikisi de gereklidir. |
| `poll_id` | integer | Pozitif geçerli anket tanımlayıcısı. Zero/missing bir rotayı tamamlayamıyor. |
| `source_freshness` | nesne | `status`, `checked_ts`, aktif günlük durumu, son anket zaman damgası ve son tamamlanan anket zaman damgası. |
| `current_cycle_proof_complete` | boolean | Yalnızca köken ve yeni olduğunda doğrudur active-log/current-poll kanıtlar aynı fikirde. |
| `route` | enum | Yukarıdaki beş rotadan biri. |
| `route_proof_status` | enum | `full`, `limited_expected_empty` veya `missing`. |
| `coverage_status` | enum | Tam olarak `complete`, `complete_with_gaps`, `partial` veya `unavailable`. |
| `completed`, `expected_empty` | boolean | `completed` yalnızca `missing`; `expected_empty` yalnızca `limited_expected_empty`. |
| `observed` | dize dizisi | Beton tutuldu facts/counts/statuses. |
| `interpretation` | dize dizisi | Kanıtlara göre ayarlanmış ihtiyatlı anlam. |
| `unknown` | dize dizisi | Kimlik, geçmiş, kaynak veya bağlam eksik. |
| `does_not_prove` | dize dizisi | Kanıtların destekleyemediği sonuçlar. |
| `next_action` | dizeyi | En güvenli sınırlı operatör eylemi. |
| `source_references` | dize dizisi | Sıralı benzersiz runtime/Saved referanslar. |
| `enforcement_authority` | boolean | Her zaman yanlış. Bir rapor hiçbir zaman yazmaya izin vermez. |
| `output_paths` | iki dize | JSON ve TXT yolları. |

`coverage_status` yalnızca üst düzey muhasebedir. Kaynak kayıtları ayrı olarak kendilerine aittir `available`, `expected_empty`, `partial`, `deferred`, `unavailable`, `malformed`, `permission_denied` ve `error`. Rota kanıtı ayrı olarak sahibi `full`, `limited_expected_empty` ve `missing`; değerler asla bu sınırları aşmaz.

Rota uzantıları:

- `server_status`: `scheduler_status`, `active_log_status` ve `server_metrics`. Ölçümler mevcut dönemin başlangıcını, en son tamamlanan anket zaman damgasını ve kimliğini, aktif oyuncu sayısını, active/backup-log sayar, tara pending/progress değerleri ve configured/usable/unavailable kaynak grubu muhasebesi. Hiçbir kaynak bu gerçekleri ifşa etmediğinde çalışma süresini, yeniden başlatma sayımlarını, yedekleme zaman damgalarını veya kesinti süresini icat etmezler.
- `player_activity`: `player_activity_present`, `movement`, `same_day_sessions`, `current_player_count`, `current_evidence_player_count`, `historical_player_count`, `historical_session_count`, `current_players`, `historical_players` ve uyumluluk dizisi `players`. Aynı gün içindeki her oturum, oturum kimliğini, hesap kimliğini ve biliniyorsa görünen adını saklar join/leave zaman damgaları, temiz çıkış ve yaşam döngüsü işaretleri ve kaynak referansları. Saklanan kimlik ve PlayerData mevcudiyeti bağlam olarak kalır, bugünkü etkinliğin kanıtı değildir.
- `case_review`: `cases`, `review_subjects`, `current_case_count` ve `retained_case_count`. Geçerli bir inceleme konusu kendi case/account Kimlik, bilindiğinde görünen ad, durum, puan, kimlik güvenirliği, first/last gözlem, uyarı sayıları, nedenler, mevcut canlı işaret ve kaynak referansları. Saklanan vakalar tek başına güncel bir konu oluşturmaz.
- `critical_guard`: `critical_failure_present` ve `current_boot_error_only=true`.
- `daily_rollup`: `daily_maturity`, `once_per_day_continuity`, `dedupe_window` ve `daily_metrics`. Ölçümler rapor tarihini, aktif oyuncuları, aynı gün etkinliği olan hesapları, katılımları, ayrılmaları, temiz ve kirli çıkışları, yaşam döngüsü geri dönüşlerini, mevcut adlandırılmış inceleme konularını, tutulan vakaları, current/retained kimlik sayıları ve kaynak grubu kapsamı.

<a id="translated-txt-schema"></a>
## Çevrildi TXT şeması

Eşleştirilmiş metin dosyası, operatörün okuyabileceği sonuçla başlar ve köken ayrıntılarını sona taşır. Tam olarak bu bölüm sırasını korur:

```text
RandomDayGuard <route title>
Generated: <timestamp>

Summary
<one plain-language route summary>

What Guard observed
- ...

What it means
- ...

What remains unknown
- ...

Recommended next step
...

Evidence boundary
- ...

Rating explanation
- ...

Technical record
- Route: <route>
- Version: <version>
- Cycle: boot=<boot> epoch=<epoch> poll=<poll>
- Source freshness: <status>
- Route result: <full|limited_expected_empty|missing>
- Coverage: <status>

Translation notes
- ...

Source references
- ...
```

Çeviri yalnızca yapılandırılmış rapor alanlarını ve onaylanmış sözlük eşlemelerini kullanır. Yapılandırılmış raporda bulunmayan oyuncular, vakalar, teslimat, nedensellik, sahiplik, niyet veya yaptırım uygunluğu eklenemez. Okunabilir sonuç değişmeden teknik ayrıntılar kullanılabilir durumda kalır.

<a id="source-accounting-schema"></a>
## Kaynak muhasebe şeması

`runtime/final_logs/source_accounting_latest.json` kullanır `randomdayguard.source-accounting/v1` oluşturma ile reason/status, enablement/disabled sebep, current/historical ayrımı, değiştirilen dosya bildirimi, kaynak kayıtları, usable/unavailable sınıf listeleri ve bir talep sınırı.

Her kaynak kaydı şunları içerir:

| Alan | Tür | Anlam |
|---|---|---|
| `source_class` | dizeyi | Aşağıdaki sekiz sınıftan biri. |
| `scope` | `current` veya `historical` | Zaman sahipliği; kapsamlar hiçbir zaman sessizce birleştirilmez. |
| `required` | boolean | Geçerli döngü rotasının güncelliği için yalnızca `active_log` gereklidir. |
| `status` | enum | Kaynak sonucu aşağıda listelenmiştir. |
| `terminal` | boolean | Yalnızca `partial` ve `deferred`. |
| `available`, `readable` | boolean |  için doğru Yalnızca `available` ve `expected_empty`. |
| `file_count` | integer | Sınırlı için doğru hesaplanan file/reference sayısı. |
| `source_references` | array | Sıralı benzersiz kaynak paths/references. |
| `detail` | dizeyi | Sınırlı sonuç veya hata ayrıntısı. |
| `does_not_prove` | dizeyi | Kullanılabilirlik amaç, sahiplik, hasar, çoğaltma veya uygulama kanıtı değildir. |

Kaynak sınıfları:

| Kaynak sınıfı | Kapsam | Katkıları | Neleri kanıtlayamaz |
|---|---|---|---|
| `active_log` | geçerli, gerekli | Okunabilir aktif sunucu günlüğü ve yeni anket kökeni. | Tam geçmiş veya oyuncunun kusuru. |
| `admin_ini` | geçerli, isteğe bağlı | Yapısal olarak geçerli mevcut moderator/ban durumu veya beklenen yokluk. | Oyuncu davranışı veya geçerli neden meta verileri. |
| `recent_backup_logs` | geçmişsel | Okunabilir rotated/backup günlük referansları. | Geçerli iletişim durumu veya geçerli önyükleme durumu. |
| `playerdata_filenames` | geçerli bağlam | Seçili Kaydedilmiş kök altında sınırlanmış okunabilir dosya adı referansları. | Dosya sahipliği, canlı varlık, kimlik içeriği veya suiistimal. |
| `existing_cases` | geçmişsel | Alıkonulan adlandırılmış vaka files/index mevcut çıktılardan önce yakalanan kayıtlar. | Mevcut etkinlik veya eski sonuçların doğruluğu. |
| `existing_reports` | geçmişsel | Tutulan final/forensic/warning raporu referanslar. | Yetkili kaynak değişimi. |
| `existing_evidence` | geçmişsel | Saklanan kanıt referansları. | Sunucunun asla açığa çıkarmadığı olayların eksiksizliği. |
| `world_save_scan` | geçmişsel | Tam, kısmi, ertelenmiş veya kullanılamayan sınırlı scan/checkpoint durumu. | Belirli bir oyuncunun işlemi veya sahipliği. |

Kaynak durumu değerleri:

| Durum | Terminal | Operatörün anlamı ve işlemi |
|---|---:|---|
| `available` | evet | Okunabilir yararlı kaynak mevcut; referanslarını inceleyin. |
| `expected_empty` | evet | İsteğe bağlı kaynak kontrol edildi ve yasal olarak absent/empty. Veri icat etmeyin. |
| `partial` | hayır | Sınırlı çalışma veya envanter sınırı eksik; devam ettirmeye izin ver. |
| `deferred` | hayır | Çalışma kasıtlı olarak beklemede; sahip çalışanı bekleyin. |
| `unavailable` | evet | Source/path/tool yok veya kullanılamaz durumda; yalnızca rotanın gerektirdiği durumlarda onarın. |
| `malformed` | evet | İçerik yapısal doğrulamada başarısız oldu; onu koruyun ve formatı onarın. |
| `permission_denied` | evet | Erişim açıkça reddedildi; en az ayrıcalıklı okuma erişimini geri yükleyin. |
| `error` | evet | Kaynak düzeyi sınırlandı probe/read beklenmedik bir şekilde başarısız oldu; sırları açığa çıkarmadan `detail` inceleyin. |

Üst düzey `coverage_status` tam olarak `complete`, `complete_with_gaps`, `partial` veya `unavailable`'dir. Gerekli bir kaynak düzeyi `error`, `malformed` veya `permission_denied` üst düzeye `unavailable` toplanır; kaynak düzeyi `deferred` üst düzeye `partial`. Kaynak muhasebesinin devre dışı bırakılması yine de kullanılamayan bir durum yazmaya devam eder ve her rotayı `missing`.

<a id="historical-status-schema"></a>
## Geçmişsel durum şemasına

`runtime/final_logs/historical_backfill_latest.json` kullanır `randomdayguard.history/v1`: `generated_ts`, muhasebeye `status`, `resumable=true`, `changed_file_refresh=true`, `current_evidence_is_not_history=true`, kaynak-muhasebe dizisine, kullanılamayan sınıflara ve sınırlı bir `next_action`.

`runtime/history/public_accounts.tsv`'ye bu başlıkla kalıcı genel geçmişe zorlar:

```text
account_id	ban_id	display_name	identity_confidence	status	score	first_seen	last_seen	source_references
```

Satırlar hesap kimliğine göre sıralanır, alanlar single-line/tab-safe ve referanslar sorted/unique şeklindedir. Bu dosya sessiz yeniden başlatmalarda geçmiş bağlamı korur; geçmişi hiçbir zaman şimdiki varlığa dönüştürmez.

<a id="route-proof-schema"></a>
## Rota kanıt şeması

`runtime/final_logs/route_proof.json` kullanır `randomdayguard.route-proof/v1` ve üst düzey oluşturma zaman damgasını, sürümü, önyüklemeyi, dönemi, yoklamayı, kaynak güncelliğini, geçerli döngünün bütünlüğünü, izin verilen durumları ve bir `routes` dizisini kaydeder.

Her rota girişi route/status, version/boot/epoch/poll, kaynak tazelik nesnesini içerir, geçerli döngünün bütünlüğü, çıktı yolları ve kaynak referansları. Devre dışı bırakılmış bir rota, `status="missing"` ve `reason="route_disabled"` kayıtlarını yapar. Rota korumalı yazma başarısız olursa, herhangi bir bildirim adayı kabul edilmeden önce her rota incomplete/missing olarak yeniden yazılır.

<a id="notification-schemas"></a>
## Bildirim şemaları

İsteğe bağlı genel mod yalnızca yerel dosya giden kutusudur.

`runtime/notifications/pending/<route>_latest.json` kullanır `randomdayguard.notification/v1` oluşturulan zaman damgasıyla, version/boot/epoch/ poll/source tazelik, rota, `completed_output`, yönlendirme durumu, yapılandırılmış ve çevrilmiş rapor yolları, kaynak referansları, `delivery_backend="none"` ve `delivery_attempted=false`. Uygun çıktı kullanımları `status="ready_for_local_consumer"`, `delivery_eligible=true` ve `delivery_allowed=true`. Yapılandırılmış ancak missing/ineligible rotası yine de `status="suppressed_current_cycle"`, her iki teslim bayrağı da yanlış ve `suppression_reason="route_or_completion_policy_blocked"` içeren bir denetim zarfı yazar. Bu nedenle, `pending/` altında bir dosyanın bulunması, tek başına sıraya alınmış veya uygun olduğu anlamına gelmez.

`runtime/notifications/notification_status.json` kullanır `randomdayguard.notification-status/v1` aynı kökene, `generic_local_outbox_only=true`, `delivery_attempted=false` ve rota başına `queued`/`outcome` satırlara sahip. `full` uygundur; beklenen-empty yalnızca `include_expected_empty=true`; `missing` hiçbir zaman uygun olmadığında uygundur. Rota korumalı bir yazma hatası durumunda durum sonucu `route_proof_write_failed`; bastırılmış bir denetim zarfı yine de yazılabilir ancak çıktı olarak kabul edilmez.

<a id="runtime-output-inventory"></a>
## Çalışma zamanı çıktı envanteri

İzlenebilirlik dizininde her yol veya dinamik dosya sınıfı için bir makine satırı bulunur. Bu okunabilir envanter, dosyaları operatörün amacına göre gruplandırır.

| Yol veya kalıp | Producer/trigger | Politika ve kullanışlı durumlar | Failure/recovery |
|---|---|---|---|
| `runtime/loader_probe.txt`, `runtime/loader_probe.json` | Yükleyici girişi. | Üzerine yazılan başlangıç ​​identity/probe. | Eksiklik yükün kanıtı değildir; UE4SS günlüklerini ve etkinleştirmeyi inceleyin. |
| `runtime/config_load_error.txt` | Yapılandırma yükleme hatası. | Yalnızca hata, sınırlı nedeni korur. | Geçerli genel yapılandırmayı geri yükleyin ve yeniden başlatın. |
| `runtime/saved_path_probe.json` | Kayıtlı kök çözümü. | Candidate/readability hesaplama için kullanılan referans. | `SavedRoot.txt` veya genel bir adayı onarın. |
| `runtime/startup_status.json`, `runtime/startup_error.txt`, `runtime/current/startup_error.json` | Başlangıç yaşam döngüsü. | En son başlatma ve geçerli önyükleme hatası. | Yalnızca eşleşen önyükleme geçerli kritik duruma sahiptir. |
| `runtime/runtime_version.json`, `runtime/runtime_capabilities.json`, `runtime/public_pipeline_status.json` | Startup/report entegrasyonu. | En son version/capability/handoff durumu. | Sürüm veya yetenek kayması tamamlama taleplerini engeller. |
| `runtime/poll_status.json`, `runtime/current/poll_status.json`, `runtime/poll_error.txt`, `runtime/current/poll_error.json` | Anket finalizer/error. | En son poll/scheduler/in-flight durum ve geçerli önyükleme hatası. | Sınırlı geri aramayı onarın ve daha yeni tamamlanmış bir anket gerektir. |
| `runtime/logs/current.jsonl`, `runtime/raw_events.jsonl` | Olay günlüğü. | Sınırlı append/rotation. | Önceki baytları koruyun; onar disk/retention boşluklara güvenmeden önce. |
| `runtime/log_offsets.tsv`, `runtime/log_registry.json` | Günlük tail/registry. | En son farklar ve kurallı günlük kimlikleri. | Dikkatli bir şekilde yeniden oluşturun; yedekleme günlükleri tarihsel olarak kalır. |
| `runtime/log_continuity_events.jsonl`, `runtime/evidence/log_continuity_events.jsonl`, `runtime/server_lifecycle_events.jsonl`, `runtime/evidence/lifecycle_events.jsonl` | Continuity/lifecycle normalleştirici. | Yalnızca ekleme bağlamı. | Eksik bağlam kanıtlanamaz graceful/crash durumu. |
| `runtime/current_server_epoch.json`, `runtime/server_epochs.jsonl`, `runtime/epochs/**` | Dönem sahibi. | Geçerli artı tutulan sunucu dönemleri. | Yeni bir çağ başlatın onarımdan sonra; eski geçmişi yeniden yazmayın. |
| `runtime/session_events.tsv`, `runtime/evidence/session_events.jsonl`, `runtime/sessions/**` | Oturum sahibi. | Current/historical oturum etkinlikleri ve anlık görüntüler. | Eşlenmemiş satırlar bilinmiyor; kimlik buluşu yok. |
| `runtime/account_evidence.tsv`, `runtime/account_evidence.json`, `runtime/history/public_accounts.tsv` | Account/session toplama ve raporlama modülü. | Mevcut anlık görüntü artı dayanıklı geçmiş. | Kapsamları ayrı tutun ve tahminlerden değil kanıtlardan geri yükleyin. |
| `runtime/current/session_state.json`, `runtime/current/active_accounts.json`, `runtime/current/spatial_context.json`, `runtime/current/actor_touch_rollup.json` | Poll/current-state yazarlar. | Geçerli anlık görüntülerin üzerine yazılır. | Stale/missing bilinmiyor, boş olması beklenmiyor. |
| `runtime/days/**`, `runtime/weeks/**` | Daily/weekly toplama. | Yeniden oluşturulabilir dizinler. | Yetkili olaylardan yeniden oluştur. |
| `runtime/scan_started.json`, `runtime/scan_progress.json`, `runtime/scan_checkpoint.json`, `runtime/scan_complete.json`, `runtime/scan_error.txt` | Tarama çalışanı. | Başladı, partial/deferred, denetim noktası, tamamlandı veya hata. | Denetim noktasını devam ettir; yalnızca kayıtlı nedenle yeniden oluşturun. |
| `runtime/baselines/last_scan.json`, `runtime/baselines/last_completed_baseline.json`, `runtime/baselines/file_manifest.tsv` | Temel çalışan. | En son scan/baseline ve değiştirilmiş dosya bağlama. | Stale/incompatible bildirimler açık bir yeniden oluşturma gerektirir. |
| `runtime/object_registry_partial.json`, `runtime/object_registry_counts_partial.tsv`, `runtime/object_registry.json`, `runtime/object_registry_counts.tsv` | Nesne taraması. | Partial/final sınıf bağlamı. | Sayılar, oyuncunun eyleminin kanıtı değildir; taramayı sürdürün veya yeniden oluşturun. |
| `runtime/new_classes_detected.jsonl`, `runtime/class_deltas.jsonl` | Nesne karşılaştırması. | Yalnızca ekleme new/delta bağlamını üretir. | Çıkarımdan önce mapping/baseline inceleme. |
| `runtime/playerdata_index.json`, `runtime/admin_state.json` | Kaydedilmiş kök dizinler. | Filename/admin yapı bağlamı. | Dosya adları zayıf; hatalı biçimlendirilmiş yönetici durumu, yazma işlemlerini kapatır. |
| `runtime/world_state/boot/**`, `runtime/world_state/current/world_state_latest.json`, `runtime/world_state/sessions/**` | Dünya durumu yazarı. | Boot/current/session anlık görüntüler ve farklar. | Yalnızca içerik; scan/source onarımından sonra yeniden oluşturun. |
| `runtime/warning_events.jsonl`, `runtime/warnings/**`, `runtime/evidence/critical_events.jsonl`, `runtime/evidence/high_events.jsonl`, `runtime/evidence/medium_events.jsonl` | Warning/evidence yazarlar. | Sınırlı ekleme ve per-player/session inceleme dosyaları. | Eksik raporda olay kanıtı eksik değildir; kaynak kanıtlarını inceleyin. |
| `runtime/raid_cases/**`, `runtime/raid_cases/index.jsonl`, `runtime/ban_queue.json` | Case/review toplama. | Adlandırılmış inceleme materyali ve adayları sıraya koymak. | Örnek olay membership/threshold hiçbir zaman hesaba özgü kapıları atlamaz. |
| `runtime/backups/Admin_*.ini`, `runtime/enforced.txt`, `runtime/enforced_bans.jsonl`, `runtime/evidence/enforced_bans.jsonl`, `runtime/evidence/enforcement_failed_*` | İsteğe bağlı Admin.ini işlem. | Yedekleme, başarı defteri veya açık failure/rollback kanıtları inceleyin. | Herhangi bir backup/write/readback/rollback hatası yaptırımı kapatır; yedeği geri yükleyin. |
| `runtime/request_restart.flag`, `runtime/restart_reason.json` | İsteğe bağlı işaretleyici yazıcı. | Yalnızca yerel istek. | Tüketim veya yeniden başlatmayı kanıtlamaz. |
| `runtime/current/forensic_today.json`, `.md`, `.txt`, `runtime/forensic_days/YYYY-MM-DD/**`, `runtime/final_logs/YYYY-MM-DD/**` | Adli toplama. | Geçerli ve tarihli, yeniden oluşturulabilir inceleme dizinleri. | Şuradan yeniden oluştur: kaynak kanıtı; Özeti hiçbir zaman otorite olarak görmeyin. |
| `runtime/final_logs/source_accounting_latest.json`, `historical_backfill_latest.json`, `<route>_latest.json`, `<route>_latest.txt`, `route_proof.json` | Genel rapor çalışanı. | Yukarıdaki şemalar ve tamamlama kuralları. | Önce uyumsuzluğu onar lineage/source/write; eksik, eksik kalır. |
| `runtime/notifications/pending/<route>_latest.json`, `runtime/notifications/notification_status.json` | İsteğe bağlı yerel giden kutusu. | Uygun veya açıkça bastırılmış yerel zarf artı durumu. | Missing/ineligible rotalar bastırılmış dosyalara sahip olabilir ancak hiçbir zaman sıraya alınmaz; teslimat işaretlerini inceleyin ve harici teslimatın olmadığı sonucunu çıkarın. |

Overwrite/append/retention davranışı, [`CONFIG_FIELD_CATALOG.md`](YAPILANDIRMA_ALANI_KATALO%C4%9EU.md) içindeki üretim bölümü tarafından kontrol edilir. Paket ZIP'leri yalnızca boş `.gitkeep` yer tutucuları içerir; yayın paketindeki herhangi bir `runtime/` altında yalnızca boş evidence/output bayt doğrulamada başarısız olur.

<a id="failure-and-recovery-matrix"></a>
## Arıza ve kurtarma matrisi

| Arıza | Gerekli durum | Güvenli kurtarma | Geçersiz çıkarım |
|---|---|---|---|
| Geçerli köken absent/stale | Tüm rotalar `missing`. | active-log/current-poll kanıtlayın ve yeniden oluşturun. | Eski rota dosyaları şu anda tamamlanmadı. |
| İsteğe bağlı kaynağın boş olması bekleniyor | Kaynak `expected_empty`; uygun rota `limited_expected_empty`. | Kaynağın mevcut olması gerekmediği sürece onarım yapılmaz. | Boş, kullanılamaz değildir ve geçmişte yokluğu kanıtlamaz. |
| Tarama eksik | Kaynak `partial` veya `deferred`. | Sınırlı özgeçmişe izin ver; mevcut rota politikasını açık tutun. | Kısmi yolsuzluk değildir. |
| Gerekli kaynak mevcut değil | `coverage_status=unavailable`; bağımlı rotalar `missing`. | Seçilen Saved/log erişimi onar. | Diğer sağlıklı kaynaklar gerekli kaynağın yerini almaz. |
| Gerekli kaynak araştırma hataları | Kaynak durumu `error` sınırlanmış `detail`; `coverage_status=unavailable`; bağımlı rotalar `missing`. | Adlandırılmış source/probe'yi onarın ve daha yeni bir döngü oluşturun. | Kaynak hatası, beşinci üst düzey kapsam değeri değildir. |
| Eşleştirilmiş rapor yazma işlemi başarısız olur | `coverage_status=unavailable`; rota şu şekilde birleşir: `missing`. | Dosya sistemini onarın ve her iki çift üyesini artı kanıtı yeniden yazın. | Bir kardeş dosya tamamlanmadı ve yazma hatası üst düzey değil `error`. |
| Rota korumalı yazma başarısız | Yeniden yazılan her rota eksik; uygun giden kutusu yok; yapılandırılmış rotalar bastırılmış denetim zarfları alabilir. | Rota korumalı yazmayı onarın ve aynı döngüdeki çıktıları yeniden oluşturun. | Geçerli görünen rapor JSON veya bastırılmış bir zarf rotaya dayanıklı değildir. |
| Bildirim yazma başarısız | Sonuç `local_outbox_write_failed`. | Yerel çıktı kökünü onarın; tamamlanan rapordan yeniden oluştur. | Harici dağıtım gerçekleşmedi. |
| Admin.ini işlem başarısız oldu | Uygulama backup/write/readback/rollback kanıtları inceleyin. | Doğrulanmış yedeklemeyi geri yükle ile engellendi; yalnızca inceleme amaçlı olarak kalır. | Bir eşik veya rapor, kurtarmanın atlanmasını haklı gösteremez. |

Bkz. [`EVIDENCE_BOUNDARY.md`](KANIT_SINIRI.md), [`ARCHITECTURE.md`](MIMARI.md) ve [`SOURCE_MODULE_REFERENCE.md`](KAYNAK_MOD%C3%9CL_REFERANSI.md).
