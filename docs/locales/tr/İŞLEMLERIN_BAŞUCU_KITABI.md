<a id="operations-playbook"></a>
# Operasyonların başucu kitabı

> **Kanonik İngilizce kaynağı:** [OPERATIONS_PLAYBOOK.md](../../OPERATIONS_PLAYBOOK.md). Bu yerelleştirilmiş belgeler tam komutları, yolları, anahtarları, durum değerlerini, karmaları ve dosya adlarını korur. Teknik ifadeler farklıysa İngilizce kaynağı kullanın.


Bu, RandomDayGuard için normal okuma sırasıdır. Sağlıklı bir sunucuyu incelemek için JSON, Git, checksums veya komut satırı araçlarını bilmenize gerek yoktur.

<a id="daily-operator-flow"></a>
## Günlük operatör akışı

1. Aç `runtime/final_logs/server_status_latest.txt`. Guard'ın mevcut sunucu çalışmasını izleyip izlemediğini, son döngüsünün ne zaman tamamlandığını, kaç oyuncunun bağlı olduğunu ve bir kaynağın veya taramanın eksik olup olmadığını size bildirir.
2. Aç `runtime/final_logs/daily_rollup_latest.txt` günde bir kez. Her bir kaydı tekrarlamadan aynı gündeki oturumları, çıkışları, adlandırılmış vaka çalışmasını, kimlik envanterini ve kaynak kapsamını özetler.
3. Aç `runtime/final_logs/player_activity_latest.txt` yalnızca sunucunun gün içinde katılma, ayrılma veya etkin oturumu olduğunda.
4. Aç `runtime/final_logs/case_review_latest.txt` yalnızca geçerli bir konuyu adlandırdığında. Rapor, hesabı, inceleme durumunu, puanı, kimlik kaynağını ve bir sonraki açılacak kayıtları verir.
5. Aç `runtime/final_logs/critical_guard_latest.txt` yalnızca Guard kendi başlatma, izleme döngüsünde veya rapor yazmalarında bir hata bildirdiğinde.

Bir rotanın bildirecek hiçbir şeyi yoksa, Guard beklenen boş bir sonucu kaydeder. Bu, eksik bir rapor değil, tamamlanmış bir kontroldür.

<a id="what-to-read-inside-a-report"></a>
## Bir raporda neler okunmalı

Bu bölümleri sırayla okuyun:

1. **Özet** - bu raporun kapsamına dahildir.
2. **Guard'ın gözlemlediği** - bu rota için toplanan gerçek zaman damgaları, sayılar, hesaplar, oturumlar veya durum değerleri.
3. **Ne anlama gelir** - bu kayıtların sade dille yorumlanması.
4. **Bilinmeyenler** - sonucu etkileyen bir kaynak veya tarama sınırı.
5. **Önerilen sonraki adım** - izleme, adlandırılmış bir konuyu inceleme veya Koruma'yı onarma.
6. **Kanıt sınırı** - raporun sınırı kapsam.

Yapılandırılmış kanıtları tam olarak incelemesi gereken okuyucular için teknik kayıt ve kaynak referansları sonunda görünür.

<a id="when-a-report-is-missing"></a>
## Bir rapor eksik olduğunda

Aç `runtime/final_logs/route_proof.json` yalnızca okunabilir bir rapor olmadığında veya mevcut kanıtın eksik olduğunu söylediğinde. Her rota şu sonuçlardan birine sahiptir:

| Sonuç | Anlam |
|---|---|
| `full` | Koruma rotayı rotaya ait geçerli kanıtlarla tamamladı. |
| `limited_expected_empty` | Koruma rotayı tamamladı ve uygun bir etkinlik bulamadı veya adlandırılmış bir olgunluk sınırı kaydetti. |
| `missing` | Gerekli bir kaynak, soy kontrolü veya eşleştirilmiş rapor yazımı tamamlanmadı. |

Eksik bir rota için, adı geçen kaynağı takip edin veya hatayı rapora yazın. Öncelikle ilgisiz rotaları veya bildirim ayarlarını değiştirmeyin.

<a id="after-a-crash-or-restart"></a>
## Bir kilitlenme veya yeniden başlatma sonrasında

1. Sunucu tarafından çalıştırılan yeni zaman damgası ve tamamlanan en son izleme döngüsü için Sunucu Durumunu okuyun.
2. Geçerli bir başlatma veya yoklama hatası için Critical Guard'ı okuyun.
3. Oynatıcı Etkinliğini yalnızca aynı gün içindeki bir oturuma katıldıysa, ayrıldıysa veya yaşam döngüsü değişikliğinden sonra geri döndüyse okuyun.
4. Yapılandırmayı değiştirmeden önce alıntı yapılan kaynak kaydını koruyun.

<a id="before-enabling-optional-adminini-writes"></a>
## İsteğe bağlı etkinleştirmeden önce Admin.ini yazıyor

Varsayılan paket değişmeden izler ve raporlar `Admin.ini`. Gelişmiş operatörler, dosyanın bir kopyasıyla test ettikten sonra isteğe bağlı uygulama yolunu etkinleştirebilir. Guard daha sonra temiz bir sayısal hesap kimliği gerektirir, güvenilir hesapları korur, bir yedekleme oluşturup doğrular, eşzamanlı değişiklikleri reddeder, kaydedilen dosyayı geri okur ve doğrulama başarısız olursa yedeği geri yükler. Kurulum ve test prosedürünün tamamı için [`ADMIN_INI_ENFORCEMENT.md`](Y%C3%96NETICI_INI_UYGULAMASI.md) adresine bakın.

<a id="related-guides"></a>
## İlgili kılavuzlar

- [`START_HERE.md`](BURADAN_BA%C5%9ELAYIN.md)
- [`REPORT_EXAMPLES.md`](RAPOR_%C3%96RNEKLERI.md)
- [`PLAYER_REVIEW_WORKFLOW.md`](OYUNCU_%C4%B0NCELEME_%C4%B0%C5%9E_AKI%C5%9EI.md)
- [`TROUBLESHOOTING.md`](SORUN_GIDERME.md)
- [`OUTPUT_SCHEMA_REFERENCE.md`](%C3%87IKTI_%C5%9EEMASI_REFERANSI.md)
