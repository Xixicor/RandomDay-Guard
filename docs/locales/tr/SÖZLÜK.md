<a id="glossary"></a>
# Sözlük

> **Kanonik İngilizce kaynağı:** [GLOSSARY.md](../../GLOSSARY.md). Bu yerelleştirilmiş belgeler tam komutları, yolları, anahtarları, durum değerlerini, karmaları ve dosya adlarını korur. Teknik ifadeler farklıysa İngilizce kaynağı kullanın.


| Terim | Açık anlam | Tam teknik anlam |
|---|---|---|
| Aktif günlük | Yeni kanıtlar için kullanılan mevcut sunucu günlüğü. | Gerekli `active_log` kaynak; rotanın tamamlanması için okunabilirlik ve geçerli köken gereklidir. |
| Önyükleme Kimliği | Bir izleme işlemi başlangıcı. | Önceki önyüklemeyi reddetmek için kullanılan geçerli çalışma zamanı tanımlayıcısı errors/reports. |
| Epoch Kimliği | Bir sunucu süreklilik aralığı. | Süreklilik mantığı başka bir çağ başlatana kadar normal çalışma süresini kapsayan tanımlayıcı. |
| Anket Kimliği | Sınırlı bir yoklama fırsatı. | Pozitif monotonik döngü alanı; zero/missing bir rotayı tamamlayamıyor. |
| Kaynak güncelliği | Mevcut kaynak ve anket kökeninin uyumlu olup olmadığı. | `fresh_current_poll` veya `stale_or_unproven` zaman damgaları ve aktif günlük durumuyla birlikte. |
| Kaynak muhasebesi | Kanıt kullanılabilirliği ve sınırları envanteri. | `randomdayguard.source-accounting/v1` sekiz kaynak sınıfıyla ve current/historical kapsamı. |
| `available` | Bir kaynak bulundu ve okundu. | Terminal kaynağı durumu `available=true`, `readable=true`. |
| `expected_empty` | İsteğe bağlı bir kaynak kontrol edildi ve yasal olarak absent/empty. | Terminal okunabilir kaynak durumu; asla bir konu üretmez. |
| `partial` | Sınırlı çalışmanın yararlı ancak eksik sonuçları vardır. | Terminal Olmayan source/accounting durum; sahip olan çalışanı devam ettirin. |
| `deferred` | Çalışma kasıtlı olarak beklemede. | Terminal olmayan kaynak durumu; bir hata veya tamamlama değil. |
| `unavailable` | Kaynak şu anda kullanılamıyor. | Terminal boşluğu; gerekli kaynak açığı, muhasebenin kullanılamamasına neden olur. |
| `malformed` | Bir kaynak mevcut ancak yapısal olarak geçersiz. | Doğrulama ayrıntılarını koruyan ve bağımlı yazma işlemlerini kapatan terminal boşluğu. |
| `permission_denied` | İşletim sistemi erişimi açıkça reddetti. | Terminal boşluğu farklı missing/unavailable. |
| `error` | Sınırlı bir işlem beklenmedik bir şekilde başarısız oldu. | Adlandırılmış kurtarmayı gerektiren terminal hatası; kamuya açık raporlarda hiçbir gizli ayrıntı yer almaz. |
| `complete` | Hesaplanan tüm kaynaklar, boşluk içermeyen terminallerdir. | Üst düzey kaynak muhasebe durumu. |
| `complete_with_gaps` | Gerekli güncel kanıt çalışmaları; isteğe bağlı terminal boşlukları kalır. | Üst düzey muhasebe durumu; rotalar hâlâ kendi gerekliliklerini uyguluyor. |
| `full` | Zorunlu boş olmayan sözleşmesiyle tamamlanan bir rota. | Tamamlanmış akım döngüsü çıktılarıyla rota korumalı numaralandırma. |
| `limited_expected_empty` | Bir rota tamamlandı ve uygun bir rota bulunamadı subject/failure. | Rota kanıtı numaralandırması `completed=true`, `expected_empty=true`. |
| `missing` | Rota tamamlama kanıtı yok veya başarısız. | Rota kanıtı numaralandırması `completed=false`; hiçbir zaman giden kutusu için uygun değildir. |
| Yapılandırılmış rapor | Makine tarafından okunabilir rota çıkışı. | `<route>_latest.json` kullanarak `randomdayguard.report/v1`. |
| Çevrilmiş rapor | Aynı rotanın insanlar tarafından okunabilir şekilde oluşturulması. | `<route>_latest.txt` Gözlemlenen Kaynağa referans sırası düzeltildi. |
| Rota kanıtı | Rotalar arası tamamlama defteri. | `route_proof.json` bağlama version/boot/epoch/poll/freshness/output yollar. |
| Mevcut kanıtlar | Etkin döngüye ait gözlem. | Kapsam `current`; eskiden yeniden inşa edilmedi filenames/reports. |
| Geçmişsel kanıt | Daha önceki döngülerden veya yavaş taramadan korunan bağlam. | Kapsam `historical`; incelemeyi bildirebilir ancak mevcut durumu talep edemez. |
| Yalnızca inceleme | İnceleme kanıtlarını Admin.ini yazmaları kontrol eder. | Varsayılan `review_only_mode=true`, `auto_ban=false`, `write_admin_ini=false`. |
| Yasaklı liste güvenlik kontrolü | Değişmeden önce Guard'ın yanıtlaması gereken bir soru `Admin.ini`. | Hesabı ve puanı onaylamalı, güvenilir hesapları ve kopyaları hariç tutmalı, bir yedeği doğrulamalı, dış değişiklikleri algılamalı, amaçlanan güncellemeyi kaydetmeli ve dosyanın tamamını doğrulamalı veya güvenli bir şekilde geri yüklemelidir. |
| Yerel giden kutusu | İsteğe bağlı sağlayıcıdan bağımsız bildirim aktarımı. | JSON dosyaları `delivery_backend="none"` ve `delivery_attempted=false`. |
| Temel | Sınırlı Kaydedilmiş dosya bağlamı anlık görüntüsü tamamlandı. | Manifest/object/world durumu yalnızca uyumlu ve yeterince yeni olduğunda yeniden kullanılır. |
| Kontrol noktası | Tamamlanmamış tarama işi için konumu sürdürün. | `scan_checkpoint.json`; silme işlemi varsayılan kurtarma işlemi değildir. |
| Yeniden oluşturulabilir dizin | Yeniden oluşturulabilecek özet. | Daily/weekly/forensic/final inceleme çıktısı; kaynak kanıtları geçerli olmaya devam ediyor. |
| Kanıt sınırı | Bir kaynağın destekleyebileceklerinin sınırı. | Açık `does_not_prove`, bilinmeyenler, kimlik gücü ve kapsam kuralları. |

Şemaların kanonik tanımları [`OUTPUT_SCHEMA_REFERENCE.md`](%C3%87IKTI_%C5%9EEMASI_REFERANSI.md) içindedir; yapılandırma terimleri [`CONFIG_FIELD_CATALOG.md`](YAPILANDIRMA_ALANI_KATALO%C4%9EU.md).
