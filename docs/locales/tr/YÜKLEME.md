<a id="install-randomdayguard"></a>
# Yükle RandomDayGuard

> **Kanonik İngilizce kaynağı:** [INSTALL.md](../../../INSTALL.md). Bu yerelleştirilmiş belgeler tam komutları, yolları, anahtarları, durum değerlerini, karmaları ve dosya adlarını korur. Teknik ifadeler farklıysa İngilizce kaynağı kullanın.


Bu kılavuz yükler `v0.4.12-alpha` halihazırda UE4SS. Mod, tek bir barındırma şirketine veya kontrol paneline bağlı değildir.

<a id="before-you-begin"></a>
## Başlamadan önce

Gerekli olanlar:

- özel sunucuyu durdurmak ve başlatmak için erişim;
- sunucunun UE4SS `Mods` klasörü;
- geçerli olanın bir kopyası RandomDayGuard eğer güncelleme yapıyorsanız klasör;
- normalde bir modu değiştirmeden önce koruduğunuz sunucu verilerinin yedeği.

**Modlar klasörü** `ue4ss/Mods/` adanmış sunucu kurulumunun içindeki dizin. RandomDayGuard doğrudan bu klasörün içine aittir.

<a id="new-installation"></a>
## Yeni kurulum

1. Ayrılmış sunucuyu durdurun.
2. Çıkarın RandomDayGuard ZIP yeni bir boş klasöre taşıyın.
3. Ayıklanan `RandomDayGuard` klasörünü sunucunun UE4SS `Mods` klasörü. Sonuç, içine yerleştirilmiş ikinci bir RandomDayGuard klasörü değil, tek bir `Mods/RandomDayGuard/` klasör, bir saniye bile değil RandomDayGuard klasör onun içine yerleştirilmiştir.
4. Aç UE4SS `mods.txt` ve etkinleştirin:

   ```text
   RandomDayGuard : 1
   ```

5. Sunucuyu normal şekilde başlatın.
6. Bekle UE4SS ve oyun sunucusunun başlatılmasını bitirin, ardından [İlk raporu okuyun](BURADAN_BA%C5%9ELAYIN.md).

Yeni bir sürümü çalışan bir kurulumun üzerine kopyalamayın. Güncellenen kurulum geçerli bir sunucu durumu raporu oluşturana kadar yedeği saklayın.

<a id="update-an-existing-installation"></a>
## Mevcut bir kurulumu güncelleyin

1. Sunucuyu durdurun.
2. Yüklenenin tamamını kopyalayın RandomDayGuard klasörünü güvenli bir yedekleme konumuna taşıyın.
3. Eski program klasörünü dizinin dışına taşıyın UE4SS `Mods`.
4. Yeniyi kopyalayın RandomDayGuard klasörünü `Mods`.
5. Yalnızca incelenen dosyalarınızı geri yükleyin yerel konfigürasyon ve kaydedilen kanıtlar. Yapılandırma kılavuzunda yeni alanlar listeleniyorsa, tüm ayarları körü körüne değiştirmek yerine bunları incelenen kopyayla birleştirin.
6. `RandomDayGuard : 1` seçeneğinin etkin kaldığını onaylayın.
7. Sunucuyu başlatın ve mevcut sunucu durumu raporunu okuyun.

Bu temiz klasör güncellemesi ayrıca operatörden programı incelemesini istemeden eski sürümlerdeki eski dosyaları da kaldırır. dosya adları.

<a id="help-guard-find-the-server-records"></a>
## Guard'ın sunucu kayıtlarını bulmasına yardımcı olun

Guard normalde Abiyotik Faktör `Saved` dizinini otomatik olarak bulur. Eğer yapamıyorsa, RandomDayGuard klasörünün içindeki `Saved` dizininin tam yolunu koyun. Altındaki tek bir dünyayı değil, `SavedRoot.txt` RandomDayGuard klasörü. `Saved` öğesinin üzerine gelin.

İlk sunucu durumu raporu, kayıt konumunun bulunup bulunmadığını ve hangi kaynak gruplarının mevcut olduğunu belirtir. [Sorun Giderme](SORUN_GIDERME.md) konumu okuyamadığı zaman.

<a id="first-run-behavior"></a>
## İlk çalıştırma davranışı

Varsayılan kurulum, mevcut kayıtları izler ve raporlar yazar. `Admin.ini` değerini değiştirmez veya yasaklama eklemez. Bu, isteğe bağlı herhangi bir eylemi etkinleştirip etkinleştirmemeye karar vermeden önce toplama, çeviri ve rapor kalitesini onaylamanıza olanak tanır.

[İlk raporu okuyun](BURADAN_BA%C5%9ELAYIN.md)

<a id="disable-or-remove-randomdayguard"></a>
## Devre dışı bırakın veya kaldırın RandomDayGuard

1. Sunucuyu durdurun.
2. Tamamını kopyalayın RandomDayGuard klasörünü güvenli bir arşive taşıyın.
3. Modu devre dışı bırakmak için `RandomDayGuard : 0` UE4SS `mods.txt`.
4. Kaldırmak için tamamını taşıyın RandomDayGuard klasörü `Mods` dışına taşıyın.
5. Sunucuyu başlatın ve Guard'ın artık başlamadığını onaylayın.

Guard'ın devre dışı bırakılması veya kaldırılması gelecekteki toplama işlemini durdurur. Oyun verilerini silmez, arşivlenmiş raporları silmez veya ayrı bir operatör eylemini tersine çevirmez.

<a id="roll-back-an-update"></a>
## Güncellemeyi geri alma

Yeni kurulum yüklenmezse veya geçerli bir rapor oluşturamazsa:

1. Sunucuyu durdurun.
2. Başarısız kurulumu, kayıtlarını silmeden bir kenara taşıyın.
3. Ön güncellemenin tamamını geri yükleyin RandomDayGuard klasörü.
4. İncelenen yapılandırmayı ve kaydedilen kanıtları aynı yedeklemeden geri yükleyin.
5. Modun etkinleştirildiğini onaylayın ve sunucuyu başlatın.
6. Başka bir değişiklik yapmadan önce geri yüklenen sunucu durumu raporunu okuyun.

<a id="more-help"></a>
## Daha fazla yardım

- [İlk raporu okuyun](BURADAN_BA%C5%9ELAYIN.md)
- [Operasyonların başucu kitabı](%C4%B0%C5%9ELEMLERIN_BA%C5%9EUCU_KITABI.md)
- [Sorun Giderme](SORUN_GIDERME.md)
- [Yapılandırma profilleri](YAPILANDIRMA_PROFILLERI.md)
- [Admin.ini uygulama](Y%C3%96NETICI_INI_UYGULAMASI.md)

Sürüm bakımcıları kaynak, paket ve gizlilik kontrollerini [Doğrulama ve yayınlama](DO%C4%9ERULAMA_VE_S%C3%9CR%C3%9CM.md). Sıradan bir kurulum için bunlara gerek yoktur.
