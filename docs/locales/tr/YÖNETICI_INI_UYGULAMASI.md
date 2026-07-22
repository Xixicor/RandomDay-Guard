<a id="adminini-enforcement"></a>
# Admin.ini uygulama

> **Kanonik İngilizce kaynağı:** [ADMIN_INI_ENFORCEMENT.md](../../ADMIN_INI_ENFORCEMENT.md). Bu yerelleştirilmiş belgeler tam komutları, yolları, anahtarları, durum değerlerini, karmaları ve dosya adlarını korur. Teknik ifadeler farklıysa İngilizce kaynağı kullanın.


RandomDayGuard varsayılan kurulumunda sunucu yasaklama listesini değiştirmez. Yalnızca bir yöneticinin incelemesi için raporlar oluşturur. Bu sayfada, bunu bilinçli olarak etkinleştiren yöneticiler için isteğe bağlı otomatik yasaklama listesi güncellemesini açıklanmaktadır.

<a id="what-guard-checks-before-changing-the-ban-list"></a>
## Guard, yasak listesini değiştirmeden önce hangileri kontrol eder

Guard yalnızca aşağıdaki her yanıt **evet**:

1. Mevcut kanıtlar belirli bir hesabı yeterli güvenle tanımladı mı?
2. Hesap moderatör de değil mi? veya yöneticinin güvenilir olarak işaretlediği bir hesap mı yok?
3. Hesap zaten yasak listesinde değil mi?
4. Hesap yapılandırılmış otomatik eylem puanına ulaştı mı?
5. Can Guard mevcut bilgileri okuyabilir `Admin.ini` ve aynı yedeği kaydedin?
6. Guard güncellemeyi hazırlarken `Admin.ini` değişmeden kaldı mı?
7. Kaydettikten sonra, dosyanın tamamı amaçlanan sonuçla tam olarak eşleşiyor mu?

 olduğunda yasak ekler. Herhangi bir yanıt **hayır** ise veya kontrol edilemiyorsa, Guard `Admin.ini` değişmez ve nedenini raporlarına kaydeder. Kaydetme başlar ancak son kontrol başarısız olursa, Guard doğrulanmış yedeklemeyi geri yükler.

<a id="file-format"></a>
## Dosya biçimi

`Admin.ini` yalnızca temiz yasak satırları almalıdır:

```ini
BannedPlayer=<ID>
```

- Ad yok.
- Yorum yok.
- Neden yok.
- Hayır sonekler.

<a id="safe-defaults"></a>
## Güvenli varsayılanlar

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
require_clean_ban_id = true
preserve_existing_bans = true
preserve_moderators = true
```

<a id="ban-id-source"></a>
## Yasaklama kimliği kaynağı

En iyi kaynak:

```text
Login request
Name=<player>
ConnectID=<raw_id>
UniqueId=<platform_id>
```

Çalışma zamanı, ya tamamen sayısal bir kimliği ya da tam belgelenmiş `<digits>_+_|<non-space token>` bağlantı formunu kabul eder ve sayısal yasaklama kimliğini bundan türetir. Bilinmeyen bir sonek içeren rastgele sayısal önekler reddedilir; bunlar bir yasaklama kimliğine dönüştürülmez.

Doğru:

```ini
BannedPlayer=2535422284688820
```

Yanlış:

```ini
BannedPlayer=ExamplePlayer
```

Ayrıca yanlış:

```text
BannedPlayer=<ID>
```

<a id="exact-settings-guard-checks"></a>
## Tam ayarlar Koruma kontrolleri

Bu ayarlar yukarıda açıklanan kontrolleri uygular. Listelenen her koşul doğru olmalıdır:

```text
review_only_mode == false
auto_ban == true
write_admin_ini == true
ban_id is clean numeric
identity is mapped
not trusted
not moderator
threshold is met
account-specific evidence exists
```

Herhangi bir koşul yanlışsa veya kontrol edilemiyorsa Guard, yasak listesini değiştirmeden bırakır ve onu neyin durdurduğunu kaydeder.

<a id="transaction-safety"></a>
## İşlem güvenliği

Tek `Admin.ini` mutasyon yolu şu adımları sırayla gerçekleştirir:

1. Yetkili baytları okuyun ve yapısal olarak doğrulayın.
2. Aynı anlık görüntüden moderatör, güvenilen ve mevcut yasaklama durumunu türetin.
3. Altına benzersiz bir yedek yazın `runtime/backups/` ve bayt bayt doğrulayın.
4. Değiştirmeden hemen önce `Admin.ini` dosyasını yeniden okuyun ve herhangi bir harici değişikliği reddedin.
5. Adayı yapılandırılmış kontrollü değiştirme yolu üzerinden yazın.
6. Tam geri okuma baytlarının tam aday baytlara eşit olmasını zorunlu kılın.
7. Açık geri okuma hatası varsa, doğrulanmış yedeği yalnızca geçerli dosya hala Guard tarafından yazılan adayın aynısıyken geri yükleyin. Başka bir yazar değiştirmişse Guard, bilinmeyen harici baytların üzerine yazmak yerine geri almayı reddeder.

Yinelenen kimlikler önemsizdir: ikinci satır veya ikinci yedek yazılmaz. Yedekleme adları bir zaman damgası, kaynak bayt parmak izi ve temiz kimlik içerir; böylece ayrı denemeler eski bir saniyelik dosya adını paylaşamaz.

<a id="local-regression-proof"></a>
## Yerel regresyon kanıtı

`tests/lua/enforcement_runtime_test.lua` gönderilen yükleyiciyi bir kez başlatır ve ardından depo `append_ban()` kapatma işlemini yürütür. Ekleme, yinelenen idempotency, `.tmp/` dizininin altındaki yalıtılmış sentetik dosyalara karşı gerçek yerel moderator/trusted reddi, zayıf ve hatalı biçimlendirilmiş kimlik reddi, tam bayt yedekleme doğrulaması, eşzamanlı değişiklik reddi, başarısız okuma sonrasında başarılı geri alma ve yazma sonrası harici değişikliğin üzerine yazmayı reddetmeyi kapsar. Dosya sistemi sarmalayıcıları, fikstür kökü dışındaki her türlü mutasyonu reddeder; gerçek sunucu yolu yok veya gerçek `Admin.ini` kullanılmıyor.

Bunu çalıştırın `python tools/test_public_pipeline.py`. Demirbaş geçişi yalnızca yerel işlem davranışını kanıtlar. Uygulamayı etkinleştirmez, üretim yazma yetkisi vermez veya ana makineye özel izinleri kanıtlamaz.

<a id="files-to-check"></a>
## Kontrol edilecek dosyalar

```text
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
runtime/enforced_bans.jsonl
runtime/enforced.txt
runtime/ban_queue.json
```

<a id="rollback"></a>
## Geri alma

1. Sunucuyu durdurun.
2. En son Admin.ini yedeklemesini `runtime/backups/`.
3. Gerekiyorsa yanlış `BannedPlayer=<ID>` satırını kaldırın.
4. Sunucuyu başlatın.
5. Yeniden açın Admin.ini ve satırın devam ettiğini veya kaldırıldığını doğrulayın.
6. Koruyun `enforced_bans.jsonl` denetim.

<a id="related-docs"></a>
## İlgili belgeler

* [`BAN_ID_MAPPING.md`](YASAKLI_KIMLIK_E%C5%9ELEME.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](OYUNCU_%C4%B0NCELEME_%C4%B0%C5%9E_AKI%C5%9EI.md)
