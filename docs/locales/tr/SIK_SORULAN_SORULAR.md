<a id="faq"></a>
# FAQ

> **Kanonik İngilizce kaynağı:** [FAQ.md](../../FAQ.md). Bu yerelleştirilmiş belgeler tam komutları, yolları, anahtarları, durum değerlerini, karmaları ve dosya adlarını korur. Teknik ifadeler farklıysa İngilizce kaynağı kullanın.


<a id="is-randomdayguard-the-randomday-mod"></a>
## Öyle RandomDayGuard RandomDay Mod?

No. RandomDay Mod, sunucu deneyimini değiştirir. RandomDayGuard sunucu kanıt katmanını izler.

<a id="does-live-defense-work-before-the-scan-completes"></a>
## Tarama tamamlanmadan önce canlı savunma çalışır mı?

Evet. Canlı savunma, günlükleri ve oturum olaylarını kullanır. Temel tarama daha sonra bağlamı iyileştirir.

<a id="why-can-the-first-scan-take-a-long-time"></a>
## İlk tarama neden uzun sürebilir?

İlk tarama world/object bağlamı, dosya bildirimlerini ve yeniden kullanılabilir temel verileri oluşturur.

<a id="what-do-i-check-first-after-startup"></a>
## Başlattıktan sonra ilk olarak neyi kontrol etmeliyim?

```text
runtime/current/poll_status.json
```

Arayın:

```text
scheduler_status=running
poll_id increasing
poll_in_flight=false
```

<a id="where-are-player-summaries"></a>
## Oynatıcı nerede? özetler?

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
```

<a id="where-is-the-daily-quick-review-package"></a>
## Günlük hızlı inceleme paketi nerede?

```text
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

<a id="which-file-should-i-upload-for-fastest-review"></a>
## En hızlı inceleme için hangi dosyayı yüklemeliyim?

```text
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="can-it-write-bans-automatically"></a>
## Yasaklamaları otomatik olarak yazabilir mi?

Yalnızca açıkça etkinleştirilirse.

Varsayılan:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

<a id="what-does-adminini-receive"></a>
## Ne yapar? Admin.ini alıyor musunuz?

Yalnızca:

```ini
BannedPlayer=<ID>
```

Ad, yorum, neden veya sonek yok.

<a id="is-a-display-name-enough-to-ban"></a>
## Görünen ad yasaklamak için yeterli mi?

Hayır. Bir sunucu günlüğü `Login request` ile `ConnectID` veya eşdeğer sunucu kanıtını kullanın.

<a id="can-one-crash-ban-someone"></a>
## Bir kilitlenme bir kişiyi yasaklayabilir mi?

Varsayılan olarak hayır.

<a id="can-object-count-alone-ban-someone"></a>
## Nesne sayımı tek başına bir kişiyi yasaklayabilir mi?

Varsayılan olarak hayır.

<a id="should-savedroottxt-point-to-the-world-folder"></a>
## SavedRoot.txt dünyayı işaret etmelidir klasör?

Hayır. `AbioticFactor/Saved`.

<a id="what-if-the-world-folder-changes"></a>
## Dünya klasörü değişirse ne olur?

Bunu temel bir kimlik değişikliği olarak değerlendirin. Eski temeli koruyun ve yeni bir temel oluşturun.

<a id="related-docs"></a>
## İlgili belgeler

* [`START_HERE.md`](BURADAN_BA%C5%9ELAYIN.md)
* [`FORENSIC_DAILY_ROLLUPS.md`](ADLI_G%C3%9CNL%C3%9CK_TOPLAMALAR.md)
* [`TROUBLESHOOTING.md`](SORUN_GIDERME.md)
