<a id="troubleshooting"></a>
# Sorun Giderme

> **Kanonik İngilizce kaynağı:** [TROUBLESHOOTING.md](../../TROUBLESHOOTING.md). Bu yerelleştirilmiş belgeler tam komutları, yolları, anahtarları, durum değerlerini, karmaları ve dosya adlarını korur. Teknik ifadeler farklıysa İngilizce kaynağı kullanın.


Guard yüklenmediğinde, kaynak toplanamadığında, rapor görünmediğinde veya rota kanıtı beklediğinizle çeliştiğinde bu sayfayı kullanın. Karar ağacıyla başlayın ve bir dalı takip edin. Özel [durum ve hata referansı](DURUM_VE_HATA_REFERANSI.md) yalnızca başarısız katman bilindikten sonra.

Yapılandırmayı değiştirmeden veya yeniden yüklemeden önce mevcut çalışma zamanı dosyalarını koruyun. Eski veya eksik bir eser, başarısız bir aşamayı belirtir; tekrarlanan yeniden başlatmalar bu kanıtı silebilir.

<a id="choose-the-failure-path"></a>
## Hata yolunu seçin

<a id="1-decide-whether-guard-loaded"></a>
### 1. Guard'ın yüklenip yüklenmediğine karar verin

- **Hiçbir `runtime/` dosyası mevcut değil:** takip edin [Eksik çalışma zamanı dosyalarını geri yükleyin](#restore-missing-runtime-files). Yükleme yolunu, kurallı yükleyiciyi, `enabled.txt` ve `mods.txt` yükleme yolunu doğrulayın.
- **Mevcut durum dosyalarının mevcut olduğunu doğrulayın:** Koruma durumu yazacak kadar yüklendi. 2. adıma geçin; yeniden yükleme ilk yanıt değildir.

<a id="2-decide-whether-the-scheduler-is-advancing"></a>
### 2. Planlayıcının ilerleyip ilerlemediğine karar verin

Aç:

```text
runtime/current/startup_status.json
runtime/current/poll_status.json
```

- **Sayaçlar ve zaman damgaları ilerler:** 3. adıma devam edin.
- **`poll_id` statiktir, `poll_in_flight` doğru kalır veya zamanlayıcı durumu çalışmıyor:** takip edin [Takılmış bir yoklama döngüsünü kurtarın](#recover-a-stuck-poll-loop).
- **Zamanlayıcı ilerlemesi devam ederken temel tarama beklemede:** bu bir uyarıdır, otomatik olarak başarısız bir başlangıç değil. Yalnızca biriktirme listesi veya tarama ilerlemesi durursa araştırın.

<a id="3-classify-route-proof"></a>
### 3. Rota kanıtını sınıflandırın

Aç `runtime/final_logs/route_proof.json` ve her rotayı ayrı ayrı inceleyin.

- **`full`:** beklenmeyen ifadeleri mevcut ifadelerle karşılaştırın `source_references` ve köken. Yalnızca ifadeler yanlış göründüğü için yayını değiştirmeyin.
- **`limited_expected_empty`:** kaynak muhasebesinin yasal bir boş sonucu desteklediğini onaylayın. Sentetik bir oynatıcı veya servis talebi oluşturmayın.
- **`missing`:** takip edin [Eksik bir rotayı teşhis edin](#diagnose-a-missing-route).

<a id="4-classify-source-coverage"></a>
### 4. Kaynak kapsamını sınıflandırın

- **`partial`, `deferred`, `unavailable`, `malformed`, `permission_denied` veya `error`:** takip edin [Eksik kaynak kapsamını yorumlama](#interpret-incomplete-source-coverage), ardından [Durum ve hata referansı](DURUM_VE_HATA_REFERANSI.md).
- **Yapılandırılmış kaynak güncel ancak çevrilmiş veya beklemedeki çıktı daha eski:** teslim uç noktasını değil, tamamlama aktarımını tanılayın. Teslimat yapılandırmasını değiştirmeden önce hem zaman damgalarını koruyun hem de rapor ve gönderim durumunu inceleyin.

<a id="5-follow-the-matching-branch"></a>
### 5. Eşleşen şubeyi takip edin

- Eksik kimlik: [Eşlenmemiş bir oynatıcıyı eşleyin](#map-an-unmapped-player).
- Günlük süreklilik eksik: [Eksik bir günlük toplamayı geri yükleme](#restore-a-missing-daily-rollup).
- Açıkça onaylanan uygulama testi yazmadı: [Engellenen bir Admin.ini yazmayı teşhis edin](#diagnose-a-blocked-adminini-write).
- ZIP çıkarma başarısız oldu: [Bir Windows'u çözümleyin çıkarma durumu çarpışması](#resolve-a-windows-extraction-folder-collision).
- Fikstür, paket veya depo kontrolü başarısız oldu: [Doğrulama ve sürüm incelemesi](DO%C4%9ERULAMA_VE_S%C3%9CR%C3%9CM.md#avoid-validation-environment-pitfalls).

<a id="6-stop-with-one-proved-outcome"></a>
### 6. Kanıtlanmış bir sonuçla yetinmeyin

Sorun giderme geçişi şu durumlarda sona erer:

- rota geçerli ve `full`;
- rota geçerli ve `limited_expected_empty` adlandırılmış bir nedenden dolayı;
- tam bir engelleyici, kanıt yolu ve sonraki eylem kaydedilir; veya
- geri alma, bilinen önceki durumu geri yükledi ve başarısız kanıtları korudu.

“Sunucu çalışıyor”, artan kalp atışı veya HTTP başarısı tek başına rapor yolunun tamamlandığını kanıtlamaz.

<a id="diagnose-a-missing-route"></a>
## Eksik bir rotayı teşhis edin

Aç `runtime/final_logs/route_proof.json` ve karşılaştırın `server_status`, `daily_rollup`, `player_activity`, `case_review` ve `critical_guard`.

1. Rotanın nedenini, kökenini, oluşturulma süresini ve kaynak referansları.
2. Adlandırılmış yapılandırılmış kaynağın mevcut olduğunu ve aynı döngüye ait olduğunu doğrulayın.
3. Mtime'ı çevrilmiş çıktı ve bekleyen zarfla karşılaştırın.
4. Nihai günlükler çevrilmiş veya bekleyen çıktıdan daha yeniyse, eski tamamlama gönderimini kaydedin ve önce bu aktarımı onarın.
5. Tüm yerel çıktı geçerliyse ancak teslimat yapılıyorsa yoksa rota yapılandırmasını ve gönderen durumunu inceleyin.

Zamanlayıcı durumunu veya başarılı bir bildirimi beş rotalı kanıta yükseltmeyin.

<a id="interpret-incomplete-source-coverage"></a>
## Eksik kaynak kapsamını yorumlama

| Durum | Ne yapmalı |
|---|---|
| `partial` | Yalnızca toplanan kanıtları kullanın ve tam kapsamlı iddialardan kaçının. |
| `deferred` | Yapılandırmayı değiştirmeden önce daha sonra sınırlanan iş ilerlemelerini onaylayın. |
| `unavailable` | Ortam sınırını kaydedin; yalnızca kanıtlanmış bir yolu veya izin sorununu düzeltin. |
| `malformed` | Kaynağı ve ayrıştırma hatasını koruyun; eksik değerleri tahmin etmeyin. |
| `permission_denied` | Yalnızca gereken dar kapsamlı okuma iznini verin. |
| `error` | Rotaya güvenmeden önce ayrıntıları koruyun ve adlandırılmış aşamayı teşhis edin. |

<a id="restore-missing-runtime-files"></a>
## Eksik çalışma zamanı dosyalarını geri yükleyin

Onayla:

```text
mods.txt contains RandomDayGuard : 1
RandomDayGuard/enabled.txt exists
RandomDayGuard/Scripts/main.lua exists
```

Doğru yükleme kökü:

```text
AbioticFactor/Binaries/Win64/ue4ss/Mods/RandomDayGuard/
```

Bu iç içe düzeni reddet:

```text
Mods/RandomDayGuard/RandomDayGuard/Scripts/main.lua
```

Dosyalar doğruysa ancak UE4SS Guard'ı başlatmadıysa, `UE4SS.log` dosyasını koruyun ve başlangıç zaman damgasını gerçek oyun süreci başlangıcıyla karşılaştırın.

<a id="resolve-a-windows-extraction-folder-collision"></a>
## Windows çıkarma klasörü çakışmasını çözme

Daha eski bir sürümde, adları yalnızca büyük harf kullanımı açısından farklılık gösteren program dizinleri kullanılıyordu. Bazı Windows çıkarıcıları, ZIP mevcut bir klasörün üzerine yerleştirildiğinde bu adları birleştirir.

1. Yüklü modu veya kanıtlarını değil, yalnızca başarısız olan geçici çıkartmayı silin.
2. Yeni bir boş geçici dizin oluşturun.
3. Geçerli sürümü buraya çıkarın.
4. Bir RandomDayGuard klasörü ve bir program dizini oluşturduğunu doğrulayın.
5. Windows hâlâ bir çarpışma bildiriyorsa sürümü tekrar indirin ve kullanılan sürüm sürümünü ve çıkarıcıyı bildirin.

Yeni bir sürümü asla kurulu klasöre çıkarmayın. [`../INSTALL.md`](Y%C3%9CKLEME.md).

<a id="load-the-expected-version"></a>
## Beklenen sürümü yükleyin

Kaynak işaretçisini ve yapı işaretçisini kontrol edin:

```sh
grep -n "local VERSION" RandomDayGuard/Scripts/main.lua
cat RandomDayGuard/BUILD_MARKER.txt
```

Eğer aynı fikirde değillerse:

1. Sunucuyu durdurun.
2. Yüklü klasörü, incelenen yapılandırmayı ve çalışma zamanı kanıtlarını yedekleyin.
3. Amaçlanan paketi hazırlayın ve inceleyin.
4. Yalnızca paket tarafından yönetilen program ve veri dosyalarını değiştirin.
5. Kurallı yükleyicinin mevcut olduğunu ve küçük harfli kopyanın eklenmediğini doğrulayın.
6. Bir kez başlayın ve çalışma zamanı çıktısını değerlendirmeden önce mevcut işaretçileri tekrar okuyun.

<a id="correct-a-missing-saved-root"></a>
## Eksik bir Kayıtlı kökü düzeltme

Aç `runtime/saved_path_probe.json`. Doğrulanmış mutlak yolu tam Abiyotik Faktöre yerleştirin `Saved/` dizininin tam yolunu koyun. Altındaki tek bir dünyayı değil, `SavedRoot.txt`; yalnızca bir dünya dizinine işaret etmeyin. Sınırlandırılmış kökün dışındaki bir yol reddedilmiş olarak kalmalıdır.

<a id="recover-a-stalled-historical-scan"></a>
## Durmuş bir geçmiş taramayı kurtarma

Mevcut izleme ve geçmiş keşif ayrıdır. Büyük bir arşiv çok sayıda sınırlı döngüye ihtiyaç duyabilir, dolayısıyla değişmeyen tek bir gözlem arşivin durduğunu söylemek için yeterli değildir.

1. Aç `runtime/current/report_worker_status.json`.
2. Kayıt `scan_cursor`, keşfedilen dosyalar, tamamlanan dosyalar ve `last_progress_ts`.
3. En az iki normal rapor çalışanı fırsatını bekleyin ve aynı alanları tekrar karşılaştırın.
4. İmleç, tamamlanan sayım veya ilerleme süresi ilerlerse tarama hala çalışıyor demektir. Sınırlı bırakın.
5. Anket kimlikleri ve mevcut raporlar ilerlemeye devam ederken tüm ilerleme alanları değişmeden kalırsa, durum dosyasını koruyun ve çalışan aşaması tarafından adlandırılan kaynak sınıfını kontrol edin. Yeniden denemeden önce kaynak yolunu onarın veya okuma hatasını giderin.

Durmuş bir geçmiş tarama, daha eski kayıtlara ihtiyaç duyan sonuçları sınırlar. Aktif günlük ve güncel döngü kanıtı yeni olan güncel bir raporu geçersiz kılmaz.

<a id="recover-a-stuck-poll-loop"></a>
## Takılmış bir yoklama döngüsünü kurtarın

Aç:

```text
runtime/current/poll_status.json
runtime/poll_error.txt
```

Kayıt `poll_id`, `poll_completed_count`, `poll_in_flight`, `poll_stage`, `scheduler_status` ve sınırlı aralıklarla iki kez zaman damgalarını kurtarın.

- Sayaçlar ilerlerse döngü sıkışmaz; sonraki çalışan aşamasını teşhis edin.
- Eğer `poll_in_flight=true` değişmeden kalır, yeniden başlatmadan önce son ilerleme aşamasını ve hatayı koruyun.
- Zamanlayıcı durmuşsa, önceki hatayı ve başlatma aktarımını inceleyin.

Durmuş bir yaşam döngüsünü telafi etmek için ikinci bir döngü sahibi eklemeyin.

<a id="start-the-scan-after-log-backlog"></a>
## Günlük biriktirme işleminden sonra taramayı başlatın

`runtime/current/poll_status.json`'de şunu karşılaştırın:

```text
active_log_caught_up
active_log_unread_bytes
log_backlog_pending
```

Etkin günlükte okunmamış baytlar varken geçmiş taramanın beklemesi gerekir. Confirm later polls reduce the backlog. İlerleyen anketlerle birlikte sabit okunmamış sayı, kaynak kuyruğu sorunudur; sabit anket bir zamanlayıcı sorunudur.

<a id="preserve-scan-progress-after-a-crash"></a>
## Bir kilitlenme sonrasında tarama ilerlemesini koruyun

Koruyun ve karşılaştırın:

```text
runtime/scan_checkpoint.json
runtime/scan_progress.json
runtime/baselines/file_manifest.tsv
```

Denetim noktasının veya bildirimin eksik olup olmadığını, Kaydedilen kökün veya dünyanın değişip değişmediğini veya denetim noktasının eski olarak işaretlenip işaretlenmediğini kontrol edin. İlerlemenin daha yeni görünmesini sağlamak için geçerli bir temeli silmeyin.

<a id="map-an-unmapped-player"></a>
## Eşlenmemiş bir oynatıcıyı eşleyin

Oturum kanıtlarını yetkili günlükle karşılaştırın:

```text
runtime/evidence/session_events.jsonl
Saved/Logs/AbioticFactor.log
```

Görünen ad arasında tam bir `Login request` ilişki arayın, `ConnectID` ve `UniqueId`. Kabul edilen bir bağlantı kimliği yoksa satırı yalnızca inceleme amaçlı tutun. Bir görünen ad veya PlayerData dosya adı tek başına uygulanabilir bir kimlik değildir.

<a id="diagnose-a-blocked-adminini-write"></a>
## Engellenen bir Admin.ini yazmayı teşhis edin

Yapma testini yalnızca açık onay ve tek kullanımlık bir test dosyasıyla çalıştırın; asla canlı bir sunucu dosyasıyla değil. Öncelikle test yapılandırmasının Guard'dan şunu yazmasını istediğini doğrulayın:

```lua
review_only_mode = false
auto_ban = true
write_admin_ini = true
```

 bölümündeki temiz klasör güncelleme prosedürünü izleyin ve ardından kaydedilen hata nedenini okuyun. Guard bir hesabı tanımlamalı, moderatörleri ve güvenilir hesapları korumalı, hesaba özgü yeterli kanıt bulmalı, yeni bir yedekleme oluşturup doğrulamalı, dosyayı başka hiçbir programın değiştirmediğini doğrulamalı, amaçlanan güncellemeyi kaydetmeli ve kaydedilen dosyanın tamamını amaçlanan sonuçla karşılaştırmalıdır. Herhangi bir adım başarısız olursa veya kontrol edilemiyorsa, yasaklı listeyi değiştirmeden bırakın. Rotanın tamamı ve kaynak için [Admin.ini uygulama](Y%C3%96NETICI_INI_UYGULAMASI.md).

<a id="restore-a-missing-daily-rollup"></a>
## Eksik bir günlük toplamayı geri yükleme

`forensic_rollup.enabled = true` konusuna bakın ve ardından şunları inceleyin:

```text
runtime/current/forensic_today.json
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

Bunlar eksikse, başlangıç, anket, rapor çalışanı ve kaynak muhasebesi durumunu bu sırayla kontrol edin. Günlük toplama, tekrarlanan bir sunucu durumu bildirimi değil, günde bir süreklilik kaydıdır.

<a id="look-up-an-exact-status-or-error"></a>
## Tam bir durum veya hata arayın

Kullan [Durum ve hata referansı](DURUM_VE_HATA_REFERANSI.md) adresine bakın, PlayerData, uygulama, başlangıç, zamanlayıcı, rapor ve bildirim kodu tabloları için. Arama tablolarını ayrı tutmak, bu onarım sayfasının ikinci bir şema kılavuzu olmasını engeller.

<a id="related-docs"></a>
## İlgili belgeler

- [Buradan başlayın](BURADAN_BA%C5%9ELAYIN.md)
- [Operasyonların başucu kitabı](%C4%B0%C5%9ELEMLERIN_BA%C5%9EUCU_KITABI.md)
- [Durum ve hata referansı](DURUM_VE_HATA_REFERANSI.md)
- [Doğrulama ve sürüm incelemesi](DO%C4%9ERULAMA_VE_S%C3%9CR%C3%9CM.md)
