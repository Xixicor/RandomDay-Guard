<a id="start-here-read-the-first-guard-report"></a>
# Buradan başlayın: ilk Guard raporunu okuyun

> **Kanonik İngilizce kaynağı:** [START_HERE.md](../../START_HERE.md). Bu yerelleştirilmiş belgeler tam komutları, yolları, anahtarları, durum değerlerini, karmaları ve dosya adlarını korur. Teknik ifadeler farklıysa İngilizce kaynağı kullanın.


Bu kılavuz, RandomDayGuard yüklendikten sonra başlar ve etkinleştirildi. Yeni bir operatörden kaynak kodunu, paket içindekileri veya yalnızca makine durum dosyalarını incelemesini istemeden yararlı bir sonuç ortaya koyar.

<a id="what-happens-after-the-server-starts"></a>
## Sunucu başladıktan sonra ne olur?

Guard, oyun sunucusunun ve UE4SS'nin yüklenmesini bekler, sunucunun kullanılabilir kayıtlarını bulur ve sınırlı bir arka plan taraması başlatır. Eski geçmiş hâlâ dizine eklenirken mevcut sunucu durumunu bildirebilir.

 tarafından oluşturulur. İlk rapor **Sunucu durumu** olmalıdır. Guard'ın izleme döngülerini şimdi tamamlayıp tamamlamadığını, mevcut sunucu çalıştırması başladığında, söz konusu zaman damgası mevcutsa, ne kadar active/rotated günlük ve tarama kapsamının mevcut olduğunu, kaç oynatıcının bağlı olduğunu, hangi kaynak gruplarının eksik olduğunu ve bir operatör eyleminin gerekli olup olmadığını yanıtlar.

Hala devam eden bir arka plan taraması, otomatik olarak bir başlatma hatası değil, geçmiş kapsama ilişkin bir sınırlamadır. Guard, tarama imlecini, tamamlanan dosyaları, keşfedilen dosyaları ve son ilerleme süresini kaydeder. Bu değerlerin tekrarlanan izleme döngüleri boyunca değişmesi durursa, geçmiş yolu durmuş olarak değerlendirin ve Sorun Giderme'deki tarama dalını izleyin. Yalnızca eski geçmiş eksik olduğu için mevcut günlük ve oturum sonuçlarını atmayın.

<a id="read-the-first-server-status-report"></a>
## İlk sunucu durumu raporunu okuyun

1. Ayrılmış sunucuyu normal şekilde başlatın.
2. Oyun sunucusunun ve UE4SS'nin başlatmayı bitirmesini bekleyin.
3. Aç RandomDayGuard's son raporlar klasörünü seçin ve okunabilir en yeni sunucu durumu raporunu seçin.
4. Raporun şunları içerdiğini doğrulayın:
   - **Özet**
   - **Guard'ın gözlemlediği**
   - **Ne anlama gelir**
   - **Bilinmeyenler**
   - **Önerilen sonraki adım**
   - **Teknik kayıt**
5. **Guard'ın gözlemlediği** yanıtını verir, en son izleme döngüsü ilerlemelerini ve mevcut günlük, tarama, oynatıcı ve kaynak kapsamı rapor adlarını onaylar.
6. Sonraki adım herhangi bir müdahaleye gerek olmadığını söylüyorsa, raporu ilk başarılı sonuç olarak saklayın. Eksik bir kaynak veya durdurulmuş bir işlemin adını veriyorsa, [Sorun Giderme](SORUN_GIDERME.md).

Rapor, daha derin bir inceleme için teknik kanıtlara bağlantı verebilir. Normal bir operatör önce raporu okuyabilir ve bu referansları yalnızca düz sonucun kontrol edilmesi gerektiğinde açabilir.

<a id="understand-quiet-reports"></a>
## Sessiz raporları anlayın

Oyuncu etkinliği, vaka incelemesi ve Kritik Koruma olaya dayalıdır. Sessiz bir sunucu, sadece bir kanalı doldurmak için kurgusal bir oyuncu, vaka veya başarısızlık üretmemelidir. Okunabilir sonuç, kaynağın kontrol edildiğini ve bu rapora ait hiçbir şeyin olmadığını söyleyebilir.

Günlük toplama farklıdır: aynı gündeki oturumları, mevcut inceleme konularını, tutulan identity/case bağlamı, tarama ilerlemesini ve Guard'ın gerçekten okuyabildiği kaynak boşluklarını kullanarak rapor tarihi başına bir inceleme sağlar. Mevcut sunucu kayıtlarında bulunmayan gerçekler tahmin edilmek yerine bilinmiyor.

<a id="test-one-ordinary-player-session"></a>
## Sıradan bir oyuncu oturumunu test edin

İlk sunucu durumu raporu güncellendikten sonra:

1. Bilinen bir oyuncunun normal şekilde katılmasına ve ayrılmasına izin verin.
2. Sonraki rapor döngüsünü bekleyin.
3. Oynatıcıyı Aç etkinlik.
4. Guard'ın kullanabileceği hesabı veya görünen adı, katılma ve ayrılma zamanlarını, temiz veya eksik oturum sonucunu, varsa önceki geçmişi ve bir sonraki eylemi tanımladığını doğrulayın.

Oturum raporu gözlemlenen verileri içermelidir. Dosya adlarının bir listesi veya kayıtların mevcut olduğunu belirten genel bir ifadeyle değiştirilmemelidir.

<a id="continue"></a>
## Devam

- [Beş rapor örneğinde](RAPOR_%C3%96RNEKLERI.md)
- [Operasyonların başucu kitabı](%C4%B0%C5%9ELEMLERIN_BA%C5%9EUCU_KITABI.md)
- [Oyuncu inceleme iş akışı](OYUNCU_%C4%B0NCELEME_%C4%B0%C5%9E_AKI%C5%9EI.md)
- [Sorun Giderme](SORUN_GIDERME.md)
- [Tam belge dizini](BELGELER.md)
