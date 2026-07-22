<a id="source-module-reference"></a>
# Kaynak modülü referansı

> **Kanonik İngilizce kaynağı:** [SOURCE_MODULE_REFERENCE.md](../../SOURCE_MODULE_REFERENCE.md). Bu yerelleştirilmiş belgeler tam komutları, yolları, anahtarları, durum değerlerini, karmaları ve dosya adlarını korur. Teknik ifadeler farklıysa İngilizce kaynağı kullanın.


Bu sayfada her kaynak, yapılandırma, veri, uyumluluk yükleyici ve yayın izin verilenler listesi tarafından kabul edilen çalışma zamanı yer tutucu sınıfı. Makine dizini [`TRACEABILITY_INDEX.json`](../../TRACEABILITY_INDEX.json); bu sayfa okunabilir kanonik açıklamadır. Oluşturulan her makine satırı, farklı bir path/class, amaç, sahip olunan kaynak bloğu, genel ayarlar, yan etkiler, operatörün görebileceği durumlar, arızalar, kurtarma ve standart belgeyi adlandırır.

<a id="packaged-file-map"></a>
## Paketlenmiş dosya haritası

| Yol | Sorumluluk | Giriş nokta veya arayan | Girişler | Çıktılar ve yan etkiler | Hata davranışı | Kullanıcı tarafından düzenlenebilir |
|---|---|---|---|---|---|---|
| `LICENSE` | Proje lisansı arşiv kökünden gönderilir. | Yükleyici, yeniden dağıtıcı ve operatör. | Depo lisansı metni incelendi. | Paket için geçerli olan şartları belirtir; çalışma zamanı mutasyonu yok. | Eksiklik, yayın paketinin yasal olarak eksik kalmasına neden olur ve izin verilenler listesinin engellenmesine neden olur. | Hayır. |
| `NOTICE.md` | Proje bildirimleri arşiv köküne gönderilir. | Yükleyici ve operatör. | Proje bildirimleri incelendi. | Gerekli ilişkilendirmeyi ve proje içeriğini korur; çalışma zamanı mutasyonu yok. | Eksiklik, sürüm paketinin eksik olmasına neden olur ve izin verilenler listesini engeller. | Hayır. |
| `THIRD_PARTY_NOTICES.md` | Üçüncü taraf bildirimleri arşiv köküne gönderilir. | Yükleyici ve yeniden dağıtıcı. | Üçüncü taraf ilişkilendirme metni incelendi. | Bağımlılık ilişkilendirmesini korur; çalışma zamanı mutasyonu yok. | Eksiklik, sürüm paketinin eksik olmasına neden olur ve izin verilenler listesini engeller. | Hayır. |
| `RandomDayGuard/enabled.txt` | UE4SS mod etkinleştirme işareti. | UE4SS mod yükleyici. | `1` veya `0` UE4SS. | Yüklemeyi etkinleştirir veya devre dışı bırakır; çalışma zamanı kanıtı yazmaz. | Devre dışı bırakılmış veya hatalı biçimlendirilmiş bir işaret, normal başlatma kanıtını engeller. | Evet, yükleme sırasında. |
| `RandomDayGuard/config.lua` | Genel ayarlar tablosunu tamamlayın. | `Scripts/main.lua` başlangıçta. | kataloglanmış alanları adlandırır [`CONFIG_FIELD_CATALOG.md`](YAPILANDIRMA_ALANI_KATALO%C4%9EU.md). | Keşfi, bütçeleri, raporları, inceleme geçişlerini ve isteğe bağlı yerel işaretçileri kontrol eder. | Lua/load/default sürüklenme doğrulamayı engeller veya başlatma işleminin başarısız olmasına neden olur. | Evet; bir yedek bulundurun. |
| `RandomDayGuard/SavedRoot.txt` | İsteğe bağlı açık Kayıtlı kök geçersiz kılma. | Kayıtlı kök çözümleyici `main.lua`. | Bir genel dosya sistemi yolu için `AbioticFactor/Saved`. | Günlükler, kayıtlar için kullanılan kökü seçer PlayerData dosya adları ve `Admin.ini`. | Eksikliğe izin verilir; güvenli olmayan, yanlış veya okunamayan yollar kanıtlanmadan kalır. | Evet; kimlik bilgilerini asla buraya yerleştirmeyin. |
| `RandomDayGuard/BUILD_MARKER.txt` | İnsanlar tarafından okunabilir paket kimliği. | Yükleyici, doğrulayıcı ve operatör. | Oluşturucu tarafından oluşturulan sürümü yayınlayın. | Çalışma zamanı değişimi yok. | Sürüm uyuşmazlığı paketlemeyi engeller. | Hayır. |
| `RandomDayGuard/MANIFEST.json` | Makine tarafından okunabilen paket kimliği ve düzen meta verileri. | Doğrulayıcı, oluşturucu ve destek araçları. | Oluşturucu tarafından oluşturulan sürümü yayınlayın. | Çalışma zamanı değişimi yok. | JSON veya sürüm uyuşmazlığı paketlemeyi engelliyor. | Hayır. |
| `RandomDayGuard/README.txt` | Yüklü İngilizce hızlı başvuru. | Operatör. | Paketlenmiş yollar ve güvenli varsayılanlar. | Çalışma zamanı değişimi yok. | Eski yollar veya güvenlik ifadeleri belge eşlemesinde başarısız oluyor. | Hayır. |
| `RandomDayGuard/Scripts/main.lua` | UE4SS giriş, kanıt toplama, durum sahipliği, sınırlı planlama, isteğe bağlı uygulama ve çıktı yazarları. | UE4SS. | Yapılandırma, Kaydedilmiş kök kaynaklar, geçerli çalışma zamanı durumu, sözlükler ve raporlama modülü. | Çalışma zamanı sınıflarını [`OUTPUT_SCHEMA_REFERENCE.md`](%C3%87IKTI_%C5%9EEMASI_REFERANSI.md) içine yazar; onaylı bir uygulama yolu yedeklenebilir ve güncellenebilir `Admin.ini`. | Startup/poll/write hatalar açık bir hata durumuna neden olur ve hiçbir zaman rotanın tamamlandığını kanıtlamaz. | Hayır. |
| `RandomDayGuard/Scripts/public_pipeline.lua` | Kaynak muhasebesi, mevcut döngü kökeni, rapor çevirisi, rota kanıtı, dayanıklı genel geçmiş ve isteğe bağlı yerel giden kutusu. | `main.lua` rapor çalışanı. | Salt okunur state/context geri aramalar ve saklanan yerel kanıtlar. | Rapor yazar JSON/TXT çiftler, source/history muhasebe, rota kanıtı, dayanıklı hesap geçmişi ve bildirim status/envelopes. | Eksik köken, gerekli kaynak, eşleştirilmiş yazma veya rota korumalı yazma kuvvetleri `missing` ve kuyruğu bloke eder. | Hayır. |
| `RandomDayGuard/data/detection_events.json` | Genel etkinlik sözlüğü ve açıklamaları. | `main.lua` etkinlik normalization/reporting. | Geçerli JSON sözlük. | Etiket kanıtı; gözlem oluşturmaz. | Missing/malformed veriler, veri havuzu doğrulamasını engeller. | Hayır. |
| `RandomDayGuard/data/warning_types.json` | Uyarı türü sözcük dağarcığı ve inceleme anlamı. | Uyarı normalization/reporting. | Geçerli JSON sözlük. | Uyarı kanıtlarını etiketler. | Missing/malformed veriler, veri havuzu doğrulamasını engeller. | Hayır. |
| `RandomDayGuard/data/object_categories.json` | Object/class kategori sözlüğü. | Tara ve nesne kaydı raporlama. | Geçerli JSON sözlük. | Çıkarılan sınıf bağlamı etiketleri. | Missing/malformed veriler, veri havuzu doğrulamasını engeller. | Hayır. |
| `RandomDayGuard/runtime/**/.gitkeep` | Yalnızca boş kurulum düzeni yer tutucuları. | Paket çıkarma. | Boş baytlar. | Yazılabilir dizin yapısı oluşturur; hiçbir kanıt bir araya getirilmedi. | Yer tutucu olmayan herhangi bir çalışma zamanı üyesi, tam izin verilenler listesini engeller. | Hayır. |

<a id="ue4ss-loader-and-watchdog"></a>
## UE4SS yükleyici ve gözlemci

`Scripts/main.lua` bağımsız gözlemcinin başlangıcına, Kaydedilen kök keşfine, mevcut günlük kuyruğuna, sunucu dönemlerine ve oturumlarına, sınırlı yoklama ve taramaya, object/world bağlam, inceleme puanlaması, `Admin.ini` güvenlik kapıları, eski operasyonel çıktılar ve ayrı rapor-çalışan aktarımı. Yavaş tarihsel çalışmalar bağımsız olarak devam ederken, canlı oylamayı sınırlı tutmalı. Bir kalp atışı, başlangıç ​​işareti veya artan `poll_id` yalnızca bu bileşeni kanıtlar; route completion requires the same current boot, epoch, poll, source freshness, report pair, and route proof.

Kaynağın ve paketin tek yetkisi vardır: `RandomDayGuard/Scripts/main.lua`. Küçük harf `scripts/` kopyası kaynak ağacın veya sürümün parçası değil. Tek bir kurallı yazımı korumak, paket Windows veya Linux'ta çıkarıldığında büyük/küçük harf çakışması hatalarını önler.

<a id="public-reporting-module"></a>
## Genel raporlama modülü

`Scripts/public_pipeline.lua`, ana bilgisayar kimlik bilgileri veya sağlayıcı bağdaştırıcıları yerine geri aramaları alır. Sekiz kaynak sınıfının envanterini çıkarır, terminal ve tamamlanmamış durumları kaydeder, mevcut oyuncuları tutulan geçmişten ayrı tutar, her rotayı sırayla çevirir `Observed`, `Interpretation`, `Unknown`, `Does not prove`, `Next action` ve `Source references`, ardından rota kanıtını yazar. İsteğe bağlı bildirim modu yerel bir JSON yalnızca zarf; hiçbir zaman teslimat talebinde bulunmaz veya teslimatı paketlemez endpoint/bridge.

Çalıştırılabilir fikstür `tests/lua/public_pipeline_runtime_test.lua` gönderilen bu modülü Lua ile yükler, dolu ve beklenen boş rotaları kanıtlar, eksik akım kaynağı döngüsünün başarısız bir şekilde kapatıldığını kanıtlar ve eksik rotaların giden kutusuna girmediğini kanıtlar.

<a id="configuration-and-data"></a>
## Yapılandırma ve veriler

[`CONFIG_FIELD_CATALOG.md`](YAPILANDIRMA_ALANI_KATALO%C4%9EU.md) ve [`TRACEABILITY_INDEX.json`](../../TRACEABILITY_INDEX.json) `tools/generate_documentation_audit.py`, `config.lua`, izin verilen paket listesi ve kaynak tarafından keşfedilen çıktı sınıfları. Tam olarak oluşturulan içerik ve bire bir kapsam doğrulanır. Üç JSON sözlükler kanıt kaynakları değil, etiketler ve eşlemelerdir. Bir operatör yapılandırmayı, Kayıtlı kök seçimini ve etkinleştirmeyi düzenleyebilir; kaynak, sözlükler, bildirimler ve paketlenmiş okuma dosyaları yayının mülkiyetindedir.

<a id="package-layout"></a>
## Paket düzeni

Oluşturucu yalnızca üç kök yasal dosyayı kabul eder: `RandomDayGuard/` yolları yukarıda ve boş çalışma zamanı yer tutucuları. Üyeleri bayt bazında sıralar, düzeltmeler yapar ZIP meta verileri, standart yükleyiciyi bir kez paketler, her üyeyi özel materyal açısından tarar, her üye için bir SHA-256 kaydeder, adları ve baytları tek bir içerik özetine bağlar ve iki kez derlenir. Testler, her vaka katlamalı çarpışmayı reddeder ve normal çıkarmanın, arşiv girişi başına tam olarak bir fiziksel dosya ürettiğini kanıtlar.

Genel depo yalnızca geçerli sürüm klasörünü tutar. Oluşturucu, ZIP, sağlama toplamının, notların, sürüm işaretleyicilerinin ve kaynak ağacının uyumlu olup olmadığını kontrol eder.

<a id="code-comment-contract"></a>
## Kod yorumu sözleşmesi

Çalışma zamanı yorumları, ikinci bir kılavuz değil, kısa bakımcı sözleşmeleridir. Gönderilen her çalışma zamanı modülü, açılış yorum bloğuna bir kanonik bağlantı yerleştirmelidir:

```lua
-- Documentation: docs/SOURCE_MODULE_REFERENCE.md#ue4ss-loader-and-watchdog
```

Açık olmayan durum, planlama, write/readback/rollback, kaynak-discovery, çeviri, kanıt, çıktı şeması, rota temposu ve redaksiyon blokları, uygulanabilir olduğunda bu etiketlerle odaklanmış yorumları kullanır:

```lua
-- Public contract: <invariant or consequence>
-- Evidence boundary: <what the input cannot prove>
-- Failure behavior: <how the block fails closed or recovers>
-- Documentation: docs/<canonical-file>.md#<existing-anchor>
```

Ana yükleyicide ayrıca yapılandırma yükleme için odaklanmış bir sahip yorumu bulunur, Keşif, atom değiştirme, uygulama ve planlama kaydedildi. Bu yorumlar kontrol akışını ve arıza sınırlarını belirtir; çalışma zamanı davranışını değiştirmezler.

Doğrulayıcı, her çalışma zamanı modülü için modül düzeyinde bir `Documentation:` bağlantısı gerektirir, her yorum yolunu ve bağlantıyı çözümler, her iki çalışma zamanı modülünde odaklanmış sözleşme ve hata açıklamalarını gerektirir ve aynı kanonik bağlantıları `TRACEABILITY_INDEX.json` ile karşılaştırır. Yorum izlenebilirliktir, çalışma zamanı kanıtı değildir.

<a id="contributor-change-checklist"></a>
## Katkıda bulunan değişiklik kontrol listesi

1. Sahip olan bir modülü ve odaklanılan donanımını güncelleyin.
2. Kanonik yapılandırmayı, şemayı, çıktıyı, kanıtı veya yaşam döngüsü bölümünü güncelleyin.
3. Çalıştır `python -B tools/generate_documentation_audit.py --write` bir yapılandırma, paketlenmiş yol, oluşturulan çıktı sınıfı, sahip veya kurtarma sözleşmesi değişikliklerinden sonra.
4. Çalıştır `python -B tools/generate_documentation_audit.py --check`, odaklanmış birim testleri, Lua'nın mevcut olduğu gerçek Lua fikstürü, tam doğrulayıcı, iki bağımsız deterministik yapı ve `git diff --check`.
5. Sürüm oluşturmadan önce oluşturulan ZIP üye listesini, sağlama toplamını ve özel malzeme taramasını inceleyin.
