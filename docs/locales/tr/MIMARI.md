<a id="architecture-and-lifecycle"></a>
# Mimari ve yaşam döngüsü

> **Kanonik İngilizce kaynağı:** [ARCHITECTURE.md](../../ARCHITECTURE.md). Bu yerelleştirilmiş belgeler tam komutları, yolları, anahtarları, durum değerlerini, karmaları ve dosya adlarını korur. Teknik ifadeler farklıysa İngilizce kaynağı kullanın.


RandomDayGuard birdir UE4SS gözlemci artı bir yalıtılmış raporlama modülü. Sunucuya ait dosyaları okur, sınırlı yerel durumu korur ve yerel kanıtları ve inceleme çıktılarını yazar. Sağlayıcısı, kontrol paneli, bildirim hizmeti yoktur RandomDay veya ağ bağımlılığı.

<a id="end-to-end-data-flow"></a>
## Uçtan uca veri akışı

1. UE4SS tek kurallı giriş noktasını yükler `RandomDayGuard/Scripts/main.lua`. Mevcut paketler küçük harfli bir kopya göndermez.
2. Yükleyici `config.lua`, üç veri sözlüğünü ve isteğe bağlı `SavedRoot.txt` okur. Sürüm kimliği `VERSION`, `MANIFEST.json` ve `BUILD_MARKER.txt`.
3. Kayıtlı-kök keşif kontrolleri, bilinen adayları sınırladı ve bilinen dosyaları yönlendirdi ile uyumlu olmalıdır. `runtime/saved_path_probe.json`'de okunabilenleri kaydeder; Yalnızca bir dizini bulmak kanıt kapsamına girmez.
4. Anında katman, etkin sunucu günlüğünü güvenli bir konumdan takip eder. Yaşam döngüsünü, oturumu, hesabı, uyarıyı, yeniden bağlanmayı ve gözlemlenen diğer olayları yalnızca eklenen kanıtlara ve güncel anlık görüntülere dönüştürerek normalleştirir.
5. Yavaş katman envanterleri Sınırlandırılmış parçalar halinde kaydedilen dosyalar. İlerleme durumunu ve kontrol noktalarını yazar, tamamlanmamış çalışmayı sürdürür, değiştirilen dosya bildirimini karşılaştırır ve önce kısmi, ardından son object/world bağlamını üretir.
6. İnceleme mantığı yalnızca kendisi için mevcut olan kanıtları ilişkilendirir. Zayıf dosya adları, zamanlama, sınıf sayıları, göreli koordinatlar, karışıklık, tek bir kilitlenme veya ping bağlam içinde kalır ve yaptırıma tek başına yetki veremez.
7. Ayrı bir rapor çalışanı çağırır `Scripts/public_pipeline.lua`. Kaynak sınıflarının envanterini çıkarır, güncel ve geçmiş kapsamı kaydeder, döngüyü version/boot/epoch/poll/source tazelik, rotaya özgü beş yazar JSON/TXT çiftleşir ve sonra yazar `route_proof.json`.
8. Açıkça etkinleştirildiğinde, yerel giden kutusu, rota kanıtı mevcut olduktan sonra tamamlanmış bir rapordan referansları kopyalar. `delivery_backend="none"` ve `delivery_attempted=false`; nakliye bu ürünün dışındadır.

<a id="ownership-and-asynchronous-boundaries"></a>
## Sahiplik ve eşzamansız sınırlar

| Sahip | Sınırlı çalışma | Engellememeli veya ima etmemelidir |
|---|---|---|
| Başlangıç | Yapılandırma, Kaydedilen kök, aktif günlük, dönem, dizinler, başlangıç ​​durumu. | Başarılı bir yükleyici işaretçisi, kanıtları veya rotaları kanıtlamaz. |
| Anket geri araması | Yeni günlük baytları, durum güncellemeleri, event/session/account çıktılar, planlama. | Yavaş özyinelemeli keşif veya rapor boşaltma. |
| Tarama çalışanı | Bildirim keşfi, dosya ayrıştırma, denetim noktası, partial/final temel çizgi. | Geçerli günlük ilerlemesi; kısmi başarısızlık değildir. |
| Rapor çalışanı | Kaynak muhasebesi, çeviri, rapor çiftleri, rota kanıtı, yerel giden kutusu. | Yaptırım veya harici dağıtım. |
| İsteğe bağlı yaptırım | Hesabı ve puanı onaylayın, güvenilir hesapları ve kopyaları koruyun, bir yedeği doğrulayın, harici dosya değişikliklerini reddedin ve ardından kaydedilen sonucu doğrulayın. | Gerekli herhangi bir güvenlik kontrolünü atlayan bir rapor puanı, rota durumu veya vaka üyeliği. |

Anket döngüsü yalnızca şu süre boyunca sağlıklı kalır: `poll_id` ilerlemeler, `poll_in_flight` false değerini döndürür ve planlama etkin kalır. Bu, rapor akışını değil, anket bileşenini kanıtlıyor. Yavaş taramalar `partial` veya `deferred`; varsayılan `slow_world_scan_blocks_current_reports=false` geçmiş sınırlamayı adlandırırken yeni mevcut rotaların ilerlemesine izin verir.

<a id="state-and-lifecycle"></a>
## Durum ve yaşam döngüsü

| Durum | Giriş | Terminal veya sonraki durum | Hata ve kurtarma |
|---|---|---|---|
| Başlangıç | UE4SS yükleyiciyi çağırır. | Çalışıyor poll/scan/report önyükleme kimliği ve çağa sahip çalışanlar. | `startup_error` geçerli önyüklemenin kritik kanıtıdır; onar config/path/source ve yeniden başlatın. |
| Mevcut anket | Planlanmış sınırlı geri arama başlıyor. | Tamamlanan anket, zaman damgasını ve yeniden planlamaları kaydeder. | `poll_error` geçerli önyüklemenin kritik kanıtıdır; Sınırlı çalışmayı geri yükleyin ve daha yeni bir anketi onaylayın. |
| Tarama beklemede | Temel gerekli veya eksik kontrol noktası bulundu. | `partial`/`deferred`, ardından `scan_complete`. | Denetim noktasını sürdür; yalnızca stale/incompatible kanıt kaydedildi. |
| Kaynak muhasebesi | Çalışan envanterlerini sekiz kaynak sınıfıyla raporlayın. | `complete`, `complete_with_gaps`, `partial` veya `unavailable`. | Disabled/failed muhasebesi tüm rotaları `missing`. |
| Rota oluşturma | Geçerli döngü kökeni ve kaynak hesaplaması mevcuttur. | `full`, `limited_expected_empty` veya `missing`. | Eşlendi JSON/TXT veya rota korumalı yazma hatası, rotayı `missing`. |
| Yerel giden kutusu | Rota etkinleştirildi, tamamlandı ve uygun. | Yerel zarf ve bildirim durumu sonucu bekleniyor. | Yazı yok veya eksik kanıt, zarf yok demektir; teslimat olmadığı anlaşıldı. |
| Yaptırım incelemesi | Hesaba özgü kanıtlar, otomatik işlem için yapılandırılmış puana ulaşıyor. | Yalnızca inceleme amaçlı öneri veya açıkça etkinleştirilmiş bir öneri `Admin.ini` güncelleme. | Başarısız veya kullanılamayan bir güvenlik kontrolü güncellemeyi durdurur; Başarısız olan son karşılaştırma, kurtarma etkinleştirildiğinde doğrulanan yedeği geri yükler. |

<a id="current-and-historical-evidence"></a>
## Güncel ve geçmiş kanıtlar

Mevcut delil etkin olana aittir boot/poll ve hiçbir zaman yalnızca tutulan dosya adlarından yeniden oluşturulmaz. Tarihsel kanıtlar, döndürülmüş günlükleri içerir, dayanıklı account/session geçmiş, saklanan cases/reports/evidence ve sınırlı, dünya çapında tarama. Raporlar ayrı güncel ve geçmiş dizileri ve sayımları ortaya çıkarır. Sessiz bir yeniden başlatma, kalıcı bağlamı silmemeli ve geçmiş bir kayıt, mevcut durum olarak sunulmamalıdır.

<a id="completion-and-recovery-boundary"></a>
## Tamamlama ve kurtarma sınırı

Bir rotanın tamamlanması, geçerli döngü sürümünün, önyükleme kimliğinin, dönem kimliğinin, pozitif yoklama kimliğinin, yeni aktif günlük durumunun, her iki yol çıkışının ve `route_proof.json`'e girilmesinin eşleşmesini gerektirir. Bildirim talepleri ayrıca aynı döngülü yerel zarfı gerektirir; harici dağıtım hiçbir zaman genel kanıtın bir parçası değildir.

Nihai raporlar eksikse veya mevcut poll/source durumundan ayrılır, ilk uyumsuz kökenden veya başarısız yazmadan devam eder. İlgisiz rotaları, ifadeleri veya yaptırım ayarlarını değiştirmeyin. Yeniden denemeden önce [`OUTPUT_SCHEMA_REFERENCE.md`](%C3%87IKTI_%C5%9EEMASI_REFERANSI.md), [`TROUBLESHOOTING.md`](SORUN_GIDERME.md) ve [`SOURCE_MODULE_REFERENCE.md`](KAYNAK_MOD%C3%9CL_REFERANSI.md).
