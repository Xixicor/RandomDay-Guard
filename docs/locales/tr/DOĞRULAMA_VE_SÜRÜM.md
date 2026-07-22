<a id="validation-and-release"></a>
# Doğrulama ve yayınlama

> **Kanonik İngilizce kaynağı:** [VALIDATION_AND_RELEASE.md](../../VALIDATION_AND_RELEASE.md). Bu yerelleştirilmiş belgeler tam komutları, yolları, anahtarları, durum değerlerini, karmaları ve dosya adlarını korur. Teknik ifadeler farklıysa İngilizce kaynağı kullanın.


Bu sayfa, katkıda bulunanlar ve sürüm bakımcıları içindir. Sunucu operatörlerinin kurulum için bu komutları çalıştırmalarına gerek yoktur RandomDayGuard.

<a id="user-visible-proof"></a>
## Kullanıcı tarafından görülebilir kanıt

Yeni bir operatör onu kurabildiğinde, ilk sunucu durumu raporunu bulabildiğinde, beş rapor yolunu ayırt edebildiğinde ve çalışılmış bir örnekten net bir eylemi izleyebildiğinde, bir sürüm anlaşılabilir. Okuyucu görevleri Git, PowerShell, Python veya sağlama toplamı bilgisi gerektirmemelidir.

<a id="contributor-checks"></a>
## Katkıda bulunan kontrolleri

```powershell
python -B tools/validate_repo.py
python -B tools/test_public_pipeline.py
python -B -m unittest discover tests
```

Ne zaman `luac` kullanılabilir:

```powershell
luac -p RandomDayGuard/Scripts/main.lua
luac -p RandomDayGuard/Scripts/public_pipeline.lua
```

Lua fikstür testleri, yükleyiciyi, zamanlayıcıyı, rapor yollarını ve isteğe bağlı Admin.ini yazma işlemini kapsar. Yaptırım fikstürleri yalnızca geçici dosyaları kullanır ve kimlik, güvenilir hesap reddi, eşikler, yedekleme, eşzamanlı değişiklik reddi, geri okuma ve geri alma işlemlerini doğrular.

<a id="package-proof"></a>
## Paket kanıtı

```powershell
python -B tools/build_release_zip.py --check
git diff --check
```

- Tüm sürüm işaretleri eşleşir `VERSION`.
- Sadece geçerli sürüm `releases/`.
- ZIP standart `RandomDayGuard/Scripts/main.lua` yolunu içerir ve küçük harf değişken yükleyicisi içermez.
- Çalışma zamanı çıktısı, özel yapılandırma, kimlik bilgileri, yerel yollar, önbellekler ve test yapıları hariç tutulur.
- Genel yapılandırma, uygulama devre dışı bırakıldığında yalnızca inceleme amaçlı kalır.
- Çalışılan beş rapor örneği, rota sahipliği ve sürüm testi donanımıyla tutarlı kalır.
- ZIP baytları içerir ve deterministiktir ve eşleşir `CHECKSUMS.sha256`.
- Tüm yerel dokümantasyon bağlantıları ve 27 yerel ayar girişi sayfası doğrulanır.

<a id="avoid-validation-environment-pitfalls"></a>
## Doğrulama ortamındaki tehlikelerden kaçının

- Geçici dosya çekişmesini önlemek için depo yazma kontrollerini seri olarak çalıştırın.
- Windows'ta, kopya olup olmadığını kontrol ederken büyük/küçük harfe duyarlı olmayan dosya araması yerine arşivlenmiş üye adlarını veya numaralandırılmış yol yazımını inceleyin. yükleyiciler.
- Eksik bir `luac` komutu veya Lua çalışma zamanı, kullanılamayan bir yetenektir; başarılı bir sözdizimi veya çalışma zamanı testi değildir.
- Bir fikstür yalnızca modellenmiş girişlerini kanıtlar. Canlı bir sunucunun güncel bir rapor oluşturduğunu kanıtlamaz.
- Tamamlandığını varsaymak yerine komut zaman aşımlarını ve kısmi çıktıyı kaydedin.

<a id="repair-failed-repository-validation"></a>
## Başarısız depo doğrulamasını onarın

Bildirilen ilk yol veya sözleşmeyle başlayın. Correct that item, rerun the narrow test, then rerun the complete matrix. Eksik bir yeteneği, gerektiren testi kaldırarak gizlemeyin.

<a id="known-limits-and-release-decision"></a>
## Bilinen sınırlar ve sürüm kararı

Yerel kontroller kaynak, donanım, paket ve belge sözleşmelerini kanıtlar. A specific server installation, long-running stability window, or client display requires a separate integration result. Eşleştirme talebinde bulunmadan önce bu sonucu yapısı, yapılandırması, süresi ve gözlemlenen çıktısıyla birlikte kaydedin.
