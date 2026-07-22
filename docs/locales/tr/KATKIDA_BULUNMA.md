<a id="contributing"></a>
# Katkıda bulunma

> **Kanonik İngilizce kaynağı:** [CONTRIBUTING.md](../../../CONTRIBUTING.md). Bu yerelleştirilmiş belgeler tam komutları, yolları, anahtarları, durum değerlerini, karmaları ve dosya adlarını korur. Teknik ifadeler farklıysa İngilizce kaynağı kullanın.


RandomDayGuard ayrıştırıcılarda, dokümantasyonda, testlerde ve kamu güvenliği doğrulamasında odaklanmış, tekrarlanabilir iyileştirmeleri kabul eder. Her değişikliği genel proje sözleşmesiyle sınırlı tutun ve önce inceleme davranışını koruyun: Koruma ayrılmalı `Admin.ini`'yi değiştirmeden bırakmalıdır.

<a id="prepare-a-safe-workspace"></a>
## Güvenli bir çalışma alanı hazırlayın

1. Depoyu çatallayın veya klonlayın ve odaklanmış bir dal oluşturun.
2. Desteklenen bir Python 3 yorumlayıcısı yükleyin. Lua'yı değiştirdiğinizde `luac -p`'nin sözdizimini kontrol edebilmesi için bir Lua derleyicisi yükleyin.
3. Okuyun [dokümantasyon ana sayfası](BELGELER.md), [mimari](MIMARI.md) ve [kanıt sınırı](KANIT_SINIRI.md) değiştireceğiniz alan için.
4. Düzenlemeden önce `git status`'yi inceleyin ve ilgisiz işleri koruyun.
5. Yalnızca sentetik veya sterilize edilmiş armatürler kullanın.

Özel sunucu günlüklerini, Kayıtlı klasörleri, oynatıcı tanımlayıcılarını, `Admin.ini`, özel bildirim uç noktalarını, kimlik bilgilerini, özel yolları, çalışma zamanı çıktılarını veya kopyalanmış canlı kanıtları asla göndermeyin.

<a id="make-a-focused-change"></a>
## Odaklanmış bir değişiklik yapın

- Mevcut adlandırma, biçimlendirme, güvenlik kontrolleri ve modül sahipliğini takip edin.
- Her prosedür veya kesin bilgi için bir standart belge sahibi tutun.
- Davranış veya genel çıktı değiştiğinde kullanıcı belgelerini ve örnekleri güncelleyin.
- Uygulamalı olduğunda bir hata düzeltmesi için bir regresyon testi ekleyin.
- Hesap onayını, güvenilir hesap korumasını, yedekleme doğrulamasını, dış değişiklik algılamayı, kayıtlı dosya karşılaştırmasını, kurtarmayı veya yalnızca incelemeyi zayıflatmayın varsayılan olarak bir test geçişi gerçekleştirir.

<a id="run-the-relevant-checks"></a>
## İlgili kontrolleri çalıştırın

Yalnızca dokümantasyona yönelik değişiklikler için şunu çalıştırın:

```powershell
python -B tools\generate_documentation_audit.py --check
python -B -m unittest discover tests -p "test_documentation*.py"
git diff --check
```

Kaynak, yapılandırma, paketleme veya test değişiklikleri için ayrıca ilgili kontrolleri şuradan çalıştırın: [Doğrulama ve sürüm incelemesi](DO%C4%9ERULAMA_VE_S%C3%9CR%C3%9CM.md), Lua sözdizimi kontrolleri, veri havuzu doğrulaması, genel işlem hattı testleri ve tam birim test paketi dahil. Atlanan veya kullanılamayan her kontrolü rapor edin; geçti olarak tanımlamayın.

<a id="submit-the-change-for-review"></a>
## Değişikliği inceleme için gönderin

Yalnızca farkın tamamını inceledikten sonra odaklanmış bir çekme isteği açın. Şunları ekleyin:

- sorun ve amaçlanan davranış;
- tam dosyalar ve genel sözleşmeler değişti;
- komutların çalıştırılması ve sonuçları;
- gizlilik, uyumluluk ve uygulamanın etkisi; ve
- kalan sınırlamalar veya takip çalışmaları.

Değişiklik açıkça gerektirmediği ve bunları doğrulamadığı sürece oluşturulan çalışma zamanı kanıtlarını veya yayın arşivlerini dahil etmeyin. Katkı, bir sürüm, dağıtım, canlı sunucu testi, yaptırım eylemi veya üçüncü taraf bir sitede yayın yapılmasına izin vermez.

Güvenlik açıklarını [özel güvenlik yolu](G%C3%9CVENLIK.md), genel bir sorun veya sıradan bir çekme isteği değildir.
