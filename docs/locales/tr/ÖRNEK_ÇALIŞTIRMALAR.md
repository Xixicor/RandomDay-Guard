<a id="worked-operation-examples"></a>
# Çalışılan işlem örnekleri

> **Kanonik İngilizce kaynağı:** [EXAMPLE_RUNS.md](../../EXAMPLE_RUNS.md). Bu yerelleştirilmiş belgeler tam komutları, yolları, anahtarları, durum değerlerini, karmaları ve dosya adlarını korur. Teknik ifadeler farklıysa İngilizce kaynağı kullanın.


Bu örnekler, beklenen durum geçişlerini açıklamak için icat edilen değerleri kullanır; bunlar canlı uyumluluk veya oynatıcı kanıtı değildir.

<a id="successful-current-cycle"></a>
## Başarılı mevcut döngü

Girdiler: okunabilir aktif günlük, version/boot/epoch, `poll_id=41`, tamamlanmış mevcut anket, yazılabilir accounting/history/report kökler, yavaş tarama politikasını engelleme yok.

Beklenen:

```text
server_status = full
player_activity = full or limited_expected_empty
case_review = full or limited_expected_empty
daily_rollup = full or limited_expected_empty
critical_guard = full or limited_expected_empty
```

Her etkin rotada JSON/TXT çıktısı ve `route_proof.json`'de aynı köken. Rota durumu, genel bir başarı mesajına değil, kendi konularına bağlıdır.

<a id="expected-empty-player-and-case-routes"></a>
## Beklenen boş oynatıcı ve vaka rotaları

Girdiler: mevcut döngü kanıtı tamamlandı; mevcut veya tutulan oyuncu sırası yok; tutulan vaka yok ve mevcut REVIEW/BAN-ELIGIBLE hesap yok.

Beklenen:

```text
player_activity.route_proof_status = limited_expected_empty
player_activity.expected_empty = true
player_activity.players = []

case_review.route_proof_status = limited_expected_empty
case_review.expected_empty = true
case_review.cases = []
```

Çevrilen raporlar, uygun sınırlı bir konunun gözlemlenmediğini söylüyor. Ayrıca bunun hiç kimsenin bağlantı kurmadığını veya hiçbir bağlamın eksik olmadığını kanıtlamadığını da söylüyorlar. Hiçbir yer tutucu player/case oluşturulmadı.

<a id="partial-bounded-scan"></a>
## Kısmi sınırlı tarama

Girişler: yeni akım log/poll; `scan_checkpoint.json` veya `scan_progress.json` mevcut; tarama tamamlanmadı; varsayılan `slow_world_scan_blocks_current_reports=false`.

Beklenen:

```text
world_save_scan.status = partial
source accounting = partial
server_status may still be full for fresh current state
historical routes name the scan limitation
```

`slow_world_scan_blocks_current_reports=true` seçeneğini yalnızca operatör isteğe bağlı yavaş kaynağın mevcut raporları engellemesini istediğinde ayarlayın. Kurtarma, kontrol noktasını silmek için değil, tarama çalışanının devam etmesine izin vermek içindir.

<a id="missing-current-cycle-proof"></a>
## Geçerli döngü kanıtı eksik

Girdiler: etkin günlük kullanılamıyor, `poll_id=0` veya boot/epoch/last-poll köken eksik.

Beklenen:

```text
current_cycle_proof_complete = false
all route proof statuses = missing
each configured route envelope status = suppressed_current_cycle
delivery_eligible = false
delivery_attempted = false
```

Bastırılmış zarf, sıraya alınmış bir teslimat değil, bir denetim kaydıdır. Eski nihai günlükler yalnızca tarihsel olarak kalır. İlk eksik lineage/source alanını onarın ve daha yeni bir döngü oluşturun.

<a id="malformed-optional-adminini-source"></a>
## Kötü biçimlendirilmiş isteğe bağlı Admin.ini kaynak

Girişler: `Admin.ini` mevcut ancak temiz yapısal doğrulamada başarısız oluyor.

Beklenen:

```text
admin_ini.status = malformed
source reference preserved
write/enforcement path closed
```

Dosyayı koruyun ve gözden geçirilmiş temiz bir formatı geri yükleyin. Açıklayıcı metni çalışma zamanı kanıtlarında saklayın; her `Admin.ini` yasak girişi yalnızca kalır `BannedPlayer=<ID>`.

<a id="required-active-log-probe-error"></a>
## Gerekli aktif günlük araştırma hatası

Girişler: sınırlanmış gerekli aktif günlük araştırması, arındırılmış bir okuma hatasıyla başarısız olur.

Beklenen:

```text
source_accounting.sources[active_log].status = error
source_accounting.sources[active_log].detail = "bounded active-log probe failed: <sanitized reason>"
coverage_status = unavailable
all route proof statuses = missing
```

`error`, sınırlanmış ayrıntılarıyla birlikte kaynak satırında kalır. Üst düzey rapor `unavailable` kullanır ve yönlendirme kanıtı, daha yeni bir geçerli döngü gerekli kaynağı kanıtlayana kadar `missing` olarak kalır.

<a id="incompatible-or-stale-baseline"></a>
## Uyumsuz veya eski taban çizgisi

Girdiler: package/source kimliği veya stale/incompatible taban çizgisi değiştirildi manifest.

Beklenen: doğrulama veya çalışma zamanı durumu uyumsuzluğu kaydeder; tarama durumu, yeniden kullanımın tamamlandığını iddia etmez. Önceki kanıtları koruyun, açık bir temel yeniden oluşturma işlemi başlatın ve yeni nihai kanıtları bekleyin. Kaydedilmiş bir neden olmadan zorla yeniden oluşturma, varsayılan kurtarma değildir.

<a id="paired-report-write-failure"></a>
## Eşleştirilmiş rapor yazma hatası

Girişler: JSON yazma başarılı olur ancak TXT yazma başarısız olur veya tam tersi olur.

Beklenen:

```text
route_proof_status = missing
completed = false
coverage_status = unavailable
output_write_detail = "paired JSON/TXT write failed: <sanitized reason>"
next_action = repair both route output writes
```

Yazar, başarısızlık durumunda birleşmek için her iki kardeşi de yeniden yazar. Başarılı bir kardeş başarı iddiası olarak kalamaz. Sınırlandırılmış yazma ayrıntısı, beşinci üst düzey kapsam değerini oluşturmaz.

<a id="route-proof-write-failure"></a>
## Rota korumalı yazma hatası

Girişler: rota çiftleri yazıldı ancak `route_proof.json` değiştirilemez.

Beklenen: tüm raporlar yeniden yazıldı `missing`, tüm bildirim sonuçları `route_proof_write_failed`'dir ve hiçbir zarf kabul edilmez. Yapılandırılmış bir rotada teslim bayrakları yanlış olan bir `suppressed_current_cycle` denetim zarfı bulunabilir. Çıkış kökünü onarın ve aynı geçerli döngüyü yeniden oluşturun.

<a id="review-only-enforcement-example"></a>
## Yalnızca inceleme amaçlı uygulama örneği

Yapılandırma:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

Beklenen: puanlar, vakalar ve öneriler yazılabilir; `Admin.ini` değişmeden kalır. Bu, genel varsayılandır.

<a id="approved-write-success-example"></a>
## Onaylanmış yazma başarısı örneği

Yalnızca ayrı olarak onaylanmış bir test, üç yazma anahtarının tümünü ayarlayabilir. Ayrıca temiz sayısal kimlik, trust/moderator hariç tutma, eşik uygunluğu, geçerli Admin.ini path/parse, yedekleme başarısı, yazma başarısı, geri okuma eşitliği ve hesaba özgü kanıt kanıtlanmalıdır.

Beklenen:

```text
runtime/backups/Admin_<timestamp>_<source-fingerprint>_<clean-ID>.ini
Admin.ini contains one clean BannedPlayer=<ID>
runtime/enforced_bans.jsonl and evidence mirror record success
```

Başarılı örnek, diğer hesaplar için otomatik yaptırımı etkinleştirmez.

<a id="writereadback-failure-with-rollback"></a>
## Write/readback geri alma hatası

Girişler: geçirilen her yazma öncesi geçit; değiştirme yazma veya geri okuma başarısız olur; `rollback_on_readback_failure=true` ve doğrulanmış yedekleme mevcut.

Beklenen: arıza kanıtı aşamayı kaydeder ve `rollback_success`; orijinal Admin.ini baytları geri yüklenir ve hesabın başarıyla uygulandığı bildirilmez. Geri alma da başarısız olursa, yazmayı durdurun, her ikisini de files/evidence koruyun ve manuel olarak yedeklemeden kurtarın.

<a id="local-outbox-example"></a>
## Yerel giden kutusu örneği

Girişler: bildirim `local_file_outbox` modunda etkinleştirildi, rota etkinleştirildi, rota doğrulaması tamamlandı ve `full` veya açıkça izin verildi beklenen-empty.

Beklenen zarf:

```text
schema = randomdayguard.notification/v1
completed_output = true
status = ready_for_local_consumer
delivery_eligible = true
delivery_backend = none
delivery_attempted = false
```

missing/ineligible çıktı, aynı yol bunun yerine `status=suppressed_current_cycle`, `completed_output=false` ve `delivery_eligible=false` içerebilir. Her iki dosya da yalnızca yerel yazma işlemini kanıtlar. Hiçbir sağlayıcı, aktarım, teslimat veya okundu bilgisi paketlenmez veya çıkarılmaz.

Bkz. [`OUTPUT_SCHEMA_REFERENCE.md`](%C3%87IKTI_%C5%9EEMASI_REFERANSI.md), [`CONFIG_FIELD_CATALOG.md`](YAPILANDIRMA_ALANI_KATALO%C4%9EU.md) ve [`TROUBLESHOOTING.md`](SORUN_GIDERME.md).
