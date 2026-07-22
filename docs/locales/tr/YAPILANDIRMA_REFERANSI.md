<a id="configuration-concepts"></a>
# Yapılandırma kavramlarıyla

> **Kanonik İngilizce kaynağı:** [CONFIG_REFERENCE.md](../../CONFIG_REFERENCE.md). Bu yerelleştirilmiş belgeler tam komutları, yolları, anahtarları, durum değerlerini, karmaları ve dosya adlarını korur. Teknik ifadeler farklıysa İngilizce kaynağı kullanın.


Bu açıklama, her bir ana yapılandırma alanının neyi kontrol ettiğini, ne zaman çalıştığını ve kanıtlarla ve güvenlik kapılarıyla nasıl etkileşime girdiğini açıklar. Tam alan kataloğuna veya profil prosedürlerine sahip değildir.

Göreve yönelik ön ayarlar ve güvenli değişiklik adımları için [`CONFIG_PROFILES.md`](YAPILANDIRMA_PROFILLERI.md) kullanın. Her kesin kaynak alanı, varsayılan, tür, değişmez, çıktı efekti ve kurtarma kuralı için oluşturulan [`CONFIG_FIELD_CATALOG.md`](YAPILANDIRMA_ALANI_KATALO%C4%9EU.md); doğrulayıcı gönderilen her dosya için orada bir satırın bulunmasını gerektirir `config.lua` yaprak alanı için orada bir satırın olmasını gerektirir.

<a id="reading-this-page"></a>
## Bu sayfayı okumak

Her yapılandırma alanı aşağıdaki yanıtları verir:

```text
What it controls
When it runs
What to check
What can go wrong
```

<a id="top-level-safety"></a>
## Üst düzey güvenlik

| Seçenek | Varsayılan | Anlam |
|---|---:|---|
| `enabled` | `true` | Ana anahtar guard |
| `enforcement.review_only_mode` | `true` | Record/recommend yalnızca |
| `enforcement.auto_ban` | `false` | Varsayılan olarak otomatik olarak yasaklama |
| `enforcement.write_admin_ini` | `false` | Varsayılan olarak Admin.ini yazmayın |

Sunucu sahibi çıktıyı gözden geçirene kadar bunları güvende tutun.

<a id="saved"></a>
## `saved`

Koruyucunun sunucu `Saved/` klasörünü nasıl bulduğunu ve hangi dosya ailesini oluşturduğunu kontrol eder tarayabilir.

Ne zaman kullanılır:

```text
Saved root auto-detection fails.
World folder changed.
Provider or container path is unusual.
```

Kontrol et:

```text
runtime/saved_path_probe.json
RandomDayGuard/SavedRoot.txt
```

Kural:

```text
SavedRoot.txt -> AbioticFactor/Saved
not -> Worlds/<WorldName>
```

<a id="log_tail"></a>
## `log_tail`

Canlı günlük okumayı kontrol eder.

Yararlı seçenekler:

| Seçenek | Güvenli değer | Neden |
|---|---|---|
| `enabled` | `true` | Canlı savunma için gerekli |
| `start_at_end_on_first_run` | `true` | Eski günlükleri canlı etkinlik olarak önler |
| `tail_backup_logs` | `false` | Yedekleme günlükleri geçmiştir, canlı değildir |
| `max_lines_per_poll` | sınırlıdır | Anket döngüsünün duyarlı kalmasını sağlar |

Kontrol et:

```text
runtime/log_offsets.tsv
runtime/evidence/session_events.jsonl
runtime/current/poll_status.json
```

<a id="runtime"></a>
## `runtime`

Yoklama ve bütçeleri kontrol eder.

Ana sağlık kuralı:

```text
poll_id increases
poll_in_flight returns false
poll_scheduled is true
```

Kontrol et:

```text
runtime/current/poll_status.json
```

Eğer `poll_id` durursa, bir şey döngüyü engelliyor demektir.

<a id="source_accounting"></a>
## `source_accounting`

Açık kanıt-kaynak kapsamını ve kapsamını kontrol eder.

| Anahtar | Varsayılan | Anlam |
|---|---:|---|
| `enabled` | `true` | Genel rota raporları için kaynak hesaplaması yazar. |
| `require_terminal_status` | `true` | Her kaynağın açık veya eksik bir terminali açığa çıkarmasını gerektirir. durumu. |
| `distinguish_current_from_historical` | `true` | Mevcut ve geçmiş kanıtları ayrı tutar. |
| `slow_world_scan_blocks_current_reports` | `false` | Mevcut raporların, sınırlı dünya taramasının ertelenmiş veya kısmi olduğunu belirtmesine olanak tanır. |
| `changed_file_manifest` | temel bildirim yolu | Sınırlı historical/world hesaplama için kullanılan referans. |

Kaynak durumları `available`, `expected_empty`, `partial`, `deferred`, `unavailable`, `malformed`, `permission_denied` veya `error`.

Ayar `source_accounting.enabled = false` durum çıktısını sessizce kaldırmaz. İşlem hattı hala `runtime/final_logs/source_accounting_latest.json` ile `enabled=false`, `status="unavailable"` ve `disabled_reason="source_accounting_disabled"` yazıyor. Ayrıca, mevcut olmayan muhasebeyle geçmiş durum kaydını da yazar. Kaynak muhasebesi rapor sözleşmesinin bir parçası olduğundan, her yol `missing`'e kapatılırken başarısız olur; Hesaplama devre dışı bırakıldığında hiçbir rota tamamlanmış olarak değerlendirilmez.

<a id="reports"></a>
## `reports`

Genel yerel raporlama hattını kontrol eder.

Varsayılanlar beş rotanın tümünü etkinleştirir ve `runtime/final_logs`:

```text
server_status
daily_rollup
player_activity
case_review
critical_guard
```

 altına yazma işlemini gerçekleştirir. Her rota yapılandırılmış ve çevrilmiş çıktı artı kanıtı `route_proof.json` olarak yazmalıdır. Bir rotanın devre dışı bırakılması, tamamlanmış gibi davranmak yerine `missing` kanıt sağlar.

<a id="notification"></a>
## `notification`

İsteğe bağlı genel yerel dosya giden kutusu. Varsayılan olarak devre dışıdır ve harici bir sağlayıcıya hiçbir şey göndermez.

Varsayılanlar:

```lua
notification = {
    enabled = false,
    mode = "local_file_outbox",
    include_expected_empty = false,
},
```

Her bildirim yolu varsayılan olarak devre dışıdır. Kasıtlı olarak etkinleştirildiğinde, giden kutusu yalnızca `route_proof.json` yazıldıktan sonra tamamlanmış çevrilmiş bir raporu kullanabilir. Yerel kanıtlar ve raporlar geçerliliğini koruyor. Sağlayıcıya özel teslimat, teslimat uç noktaları, kimlik bilgileri ve köprüler, genel bağımsız gözlemci sözleşmesinin parçası değildir.

<a id="scanning"></a>
## `scanning`

Temel taramayı, kontrol noktası oluşturmayı ve değiştirilmiş dosya yenilemeyi kontrol eder.

Ne zaman kullanılır:

```text
building first world baseline
resuming after crash
refreshing changed files later
```

Kontrol et:

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/scan_complete.json
runtime/baselines/file_manifest.tsv
```

Önemli ayarlar:

```lua
scanning = {
    resume_incomplete_scan = true,
    reuse_completed_baseline = true,
    incremental_refresh_after_baseline = true,
    changed_file_detection = true,
},
```

<a id="forensic_rollup"></a>
## `forensic_rollup`

Hızlı günlük yükleme paketini ve son düz dil günlüklerini kontrol eder.

Çıktılar:

```text
runtime/current/forensic_today.json
runtime/current/forensic_today.md
runtime/current/forensic_today.txt
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

Ne zaman kullanılır:

```text
You want one daily folder that summarizes what happened.
You want a plain-language TXT to upload for quick analysis.
```

Kontrol et:

```text
runtime/forensic_days/YYYY-MM-DD/forensic_day_summary.json
runtime/forensic_days/YYYY-MM-DD/players.tsv
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

Kural:

```text
Daily summaries are rebuildable indexes.
Source evidence remains authoritative.
```

<a id="logging"></a>
## `logging`

Olay hacmini ve düşük öneme sahip toplamayı kontrol eder.

Ne zaman kullanılır:

```text
actor-touch events are noisy
raw event files grow too quickly
```

Güvenli model:

```lua
logging = {
    low_importance_mode = "aggregate",
    write_low_importance_raw_events = false,
},
```

<a id="retention"></a>
## `retention`

Dosyaların ne kadar süre saklanacağını ve JSONL günlüklerin ne zaman döndürüleceğini kontrol eder.

Ne zaman kullanılır:

```text
disk usage grows too fast
you need more audit history
you need shorter live-history windows
```

Önemli seçenekler:

```text
detailed_retention_days
rotate_jsonl_when_bytes_exceed
max_raw_events_lines
keep_enforced_forever
keep_evidence_forever
```

<a id="warning_bursts"></a>
## `warning_bursts`

Uyarı penceresi algılamayı kontrol eder.

Örnekler:

```text
ActorChannelFailure
DeployableSaveWarning
UpdateActorToWorldSave
ServerMove warnings
```

Kural:

```text
Warnings are context until correlated with mapped sessions and thresholds.
```

<a id="crash_correlation"></a>
## `crash_correlation`

Tekrarlanan kontroller crash/reconnect inceleme.

Güvenli varsayılanlar:

```lua
crash_correlation = {
    single_crash_never_bans = true,
    require_same_account = true,
},
```

Yararlı sayaçlar:

```text
server_crash_overlap_count
post_crash_reconnect_count
unclean_disconnect_count
```

<a id="join_leave"></a>
## `join_leave`

Kaybolma ve birleştirme dalgası izlemeyi kontrol eder.

Güvenli varsayılan:

```lua
join_leave = {
    churn_alone_never_bans = true,
},
```

Kullanım amacı:

```text
rapid reconnect loops
join waves
short-session patterns
```

<a id="raid_detection"></a>
## `raid_detection`

İlgili pencerelerde etkin olan hesapları gruplandırır.

Kural:

```text
A raid case groups accounts for review.
It does not make every account guilty.
```

Zorunlanan her hesap için yine de hesaba özel kanıtlar gerekir.

<a id="object_registry"></a>
## `object_registry`

Kontroller object/class okunabilir Kaydedilmiş kanıtlardan jeton çıkarma.

Çıktılar:

```text
runtime/object_registry_partial.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
```

Kural:

```text
Object/class context is not a ban reason by itself.
```

<a id="world_state"></a>
## `world_state`

Kontroller boot/current/session dünya durumu anlık görüntüleri.

Çıktılar:

```text
runtime/world_state/current/world_state_latest.json
runtime/world_state/sessions/<date>/<session_id>_<account_id>/
```

Oturum incelemesi ve dünya bağlamı için kullanın.

<a id="enforcement"></a>
## `enforcement`

Önerileri ve gerçek Admin.ini yazmaları kontrol eder.

Guard'ın yasak ekleyebilmesi için aşağıdaki her ifadenin doğru olması gerekir:

```text
review_only_mode == false
auto_ban == true
write_admin_ini == true
ban_id is clean numeric
account identity is mapped
not trusted
not moderator
threshold is met
```

Bir ifade yanlışsa veya kontrol edilemiyorsa, Guard ayrılır `Admin.ini` değişmez ve nedenini kaydeder.

<a id="admin_ini"></a>
## `admin_ini`

Güvenli dosya yazma işlemlerini kontrol eder.

Kurallar:

```text
Back up before writing.
Preserve existing bans.
Preserve moderators.
Write clean BannedPlayer=<ID> only.
```

<a id="restart_request"></a>
## `restart_request`

Operatörün sahip olduğu başka bir işlemin inceleyebileceği isteğe bağlı yerel işaretleyici dosyalarını kontrol eder. Sunucuyu yeniden başlatmaz veya sonlandırmaz.

Varsayılanlar:

```lua
restart_request = {
    enabled = false,
    restart_marker_file = "runtime/request_restart.flag",
    restart_reason_file = "runtime/restart_reason.json",
},
```

Çıktılar:

```text
runtime/request_restart.flag
runtime/restart_reason.json
```

Hiçbir barındırma paneli, sağlayıcı köprüsü veya yeniden başlatma otomasyonu pakete dahil edilmemiştir. İşaretçi oluşturmayı etkinleştirmek, harici bir işlemin isteği tükettiğini veya sunucuyu yeniden başlattığını kanıtlamaz.

<a id="related-docs"></a>
## İlgili belgeler

* [`CONFIG_PROFILES.md`](YAPILANDIRMA_PROFILLERI.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](%C3%87IKTI_%C5%9EEMASI_REFERANSI.md)
* [`ADMIN_INI_ENFORCEMENT.md`](Y%C3%96NETICI_INI_UYGULAMASI.md)
