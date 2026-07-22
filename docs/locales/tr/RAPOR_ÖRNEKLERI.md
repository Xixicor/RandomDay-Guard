<a id="examples-of-the-five-guard-reports"></a>
# Beş Koruma raporunun örnekleri

> **Kanonik İngilizce kaynağı:** [REPORT_EXAMPLES.md](../../REPORT_EXAMPLES.md). Bu yerelleştirilmiş belgeler tam komutları, yolları, anahtarları, durum değerlerini, karmaları ve dosya adlarını korur. Teknik ifadeler farklıysa İngilizce kaynağı kullanın.


Bu örnekler sürümde yer alan örnek verilerden üretilmiştir; isimler ve hesap numaraları icat ediliyor. Test edilen rapor alanlarını, hesaplamaları ve rota sınırlarını gösterirler. Gerçek bir rapor, bunları o sunucudan toplanan bilgilerle değiştirir ve bir gerçeğin mevcut olmadığı durumlarda bunu bildirir.

Her raporun bir görevi vardır. Sunucu sağlığı, oyuncu geçmişini tekrarlamıyor, günlük inceleme birkaç dakikada bir gönderilmiyor ve sessiz oyuncu veya vaka rotaları dolgu mesajları almıyor. Sınırlı geçmiş taraması devam ederken güncel bir rapor hazır olabilir; bu durumda rapor, eski geçmişi tamamlanmış olarak sunmak yerine boşluğu adlandırır.

<a id="server-status"></a>
## Sunucu durumu

> **Sunucu Durumu: Yeniden Başlatma Sonrası Çevrimiçi**  **Mevcut durum:** Çevrimiçi **Kullanım tarihi:** 14:07  **Yeniden başlat tamamlandı:** 14:06  **Kapalı kalma süresi:** 3 dakika, 12 saniye **Yeniden başlatma nedeni:** Planlanmış oyun güncellemesi **İzleme:** Etkin. Son başarılı kontrol: 14:09 **Oyun günlüğü:** Mevcut ve güncelleniyor **Geçmiş tarama:** 355 dosyadan 312'si incelendi **Yedeklemeler:** Son doğrulama: 13:00. Sonraki beklenen: 15:00. Bugünkü arızalar: 0 **İşlem:** Yok. Sunucu normal şekilde kurtarıldı.

Sunucu durumu, sunucunun mevcut işlemine yöneliktir: başlatma, yeniden başlatma kurtarma, kapalı kalma süresi, yedeklemeler, zamanlayıcı ve Koruma durumu. Oyuncu oturumlarını veya vaka ayrıntılarını içermez.

<a id="daily-rollup"></a>
## Günlük özet

> **Günlük İnceleme: 19 Temmuz 2026**  **Sunucu kullanılabilirliği:** 23 saat 47 dakika boyunca çevrimiçi. 13 dakika boyunca çevrimdışı.  **Yeniden başlatmalar:** Toplam 2: 1 planlanmış ve 1 beklenmeyen.  **Yedeklemeler:** 23 başarılı. 1 eksik veya başarısız. En son başarılı yedekleme: 23:00.  **Oyuncu etkinliği:** 3 benzersiz oyuncu. 7 oturum: 6'sı normal şekilde tamamlandı ve 1'i kesintiye uğradı.  **Vaka etkinliği:** 1 yeni vaka, 2 güncellenmiş vaka, 1 dikkat edilmesi gereken vaka ve 0 kritik vaka.  **Kanıt kapsamı:** Beklenen 7 kaynak grubundan 6'sı mevcuttu. 04:00 yedekleme günlüğü kullanılamıyor.  **Gün özeti:** Sunucu günün büyük bölümünde kullanılabilir durumda kaldı. Beklenmeyen bir kesinti, oyuncu oturumunu erken sonlandırdı. İyileşmenin ardından izleme devam etti ve bir vaka incelemeye hazır.  **İşlem:** Vakayı inceleyin `RDG-20260719-004`. Başka bir acil eyleme gerek yoktur.

Günlük özet, takvim tarihi için bir kez yazılır. Günü sessiz dönemlerde birleştirir ve başka bir sunucu durumu ping'i olmadan yeniden başlar.

<a id="player-activity"></a>
## Oyuncu etkinliği

> **Oyuncu Etkinliği: Alex**  **Hesap:** `76561198000000400`  **İlk gözlemlenme:** 12 Temmuz 2026 **Son oturum:** 10:02'de katıldı, 11:18'de ayrıldı, 1 saat 16 dakika sürdü ve normal şekilde sona erdi.  **Bugün:** 3 bağlantı, 2 tamamlanmış oturum, 1 kesintiye uğramış oturum ve 10 dakika içinde 2 hızlı yeniden bağlanma.  **Önceki 7 gün:** 9 oturum, 6 saat 18 dakika kayıtlı oyun ve önceki 0 vaka.  **Gözlemlendi:** Alex, kesintiye uğrayan bir oturumdan kısa bir süre sonra iki kez geri döndü. Kaydedilen etkinlik, geçmiş olarak saklanacak kadar eksiksizdir ancak yeniden bağlantıların neden oluştuğunu tek başına açıklamaz.  **İşlem:** İzlemeye devam edin. Acil bir işlem yapılmasına gerek yoktur.

Oyuncu etkinliği yalnızca desteklenen oynatıcı veya oturum bilgileri değiştiğinde gönderilir. Sessiz bir dönem oyuncu mesajı oluşturmaz.

<a id="case-review"></a>
## Olgu incelemesi

> **Örnek Olay İncelemesi: RDG-20260719-004**  **Konu:** Alex **Hesap:** `76561198000000400`  **Durum:** Yönetici incelemesi istendi **İnceleme derecelendirmesi:** 90 - Yüksek öncelik **Destek kaydı neden açıldı:** Hesap, kesintiye uğrayan bir oturumun ardından tekrar tekrar bağlantı denemeleri yaptı ve sunucu, oturum açma isteklerini doğrudan kaydetti.  **Onaylanan gözlemler:** - 18:42'de bir giriş isteği kaydedildi. - 6 dakika içinde dört deneme kaydedildi. - İki seans normal bir gidiş kaydı olmadan sona erdi. - Aynı hesap 12 Temmuz ve 17 Temmuz'da da görüldü.  **İlgili geçmiş:** Bu hesap için daha önceki bir vaka kaydedilmemiştir.  **Bilinmiyor:** Mevcut kayıtlar yeniden bağlanmaların nedenini, oyuncunun niyetini veya dünya durumunun değişip değişmediğini belirlemez.  **Önerilen işlem:** Herhangi bir eylemin gerekip gerekmediğine karar vermeden önce oturum sürelerini sunucu günlüğü ve kayıtlı dünya etkinliğiyle karşılaştırın.

Vaka incelemesi, adlandırılmış inceleme materyalini, onaylanmış gözlemlerini, sınırlarını ve belirli bir inceleme adımını içerir. Geçmişteki mevcudiyet tek başına yeni bir durum yaratmaz.

<a id="critical-guard"></a>
## Critical Guard

> **Kritik Koruma: Rapor Yazma Durduruldu**  **Başladı:** 21:14  **Etkilenen işlev:** Oyuncu raporu yazıcısı **Etki:** Yeni oyuncu özetleri tamamlanamıyor.  **Sunucu:** Çevrimiçi kalır.  **İzleme:** Kanıt toplama devam ediyor ancak okunabilir raporlar gecikiyor.  **Son başarılı rapor:** 21:09  **Hata:** Rapor çıktısı kaydedilemedi.  **Olası neden:** Hedef kullanılamıyor veya yazma işlemi reddedildi.  **İşlem:** Guard çalışma zamanı çıkış konumunu kontrol edin. İzleme de durmadıkça oyun sunucusunu yeniden başlatmayın.

Sorun giderildiğinde, kurtarma işlemi aynı rota tarafından kaydedilir:

> **Kritik Koruma Çözüldü: Rapor Yazma Düzeltildi**  **Devam ettirildi:** 21:22  **Kesinti:** 8 dakika **Sonuç:** Kesinti sırasında toplanan kanıtlar korundu ve geciken raporlar tamamlandı.

Kritik Koruma yalnızca arızalara yöneliktir. Rutin durum, günlük geçmiş, oyuncu etkinliği ve sıradan beklenen-boş sonuçlar kendi raporlarında kalır.

<a id="when-a-route-is-quiet"></a>
## Bir rota sessiz olduğunda

Sessiz bir rota, Discord'a dolgu göndermeden doğrudan bir sonuç kaydeder:

> **İşaretlendi; bu rapor için hiçbir şey yok.** Gerekli kayıtlar mevcuttu ve bu rapor penceresi sırasında eşleşen bir oyuncu etkinliği, vaka veya Koruma hatası meydana gelmedi.

Bu tamamen boş bir sonuçtur. Gerekli bir kaynağın kontrol edilemediği veya okunabilir çıktının oluşturulamadığı eksik rapordan farklıdır.

Okunabilir her rapor aynı yolu izler:

```text
collected evidence -> normalized values -> dictionary mapping -> route calculations -> readable report -> Discord notification
```

Geçerli raporları incelemek için [işlemler başucu kitabını](%C4%B0%C5%9ELEMLERIN_BA%C5%9EUCU_KITABI.md) ve teknik alan referansı için [çıkış şemasını](%C3%87IKTI_%C5%9EEMASI_REFERANSI.md) kullanın.
