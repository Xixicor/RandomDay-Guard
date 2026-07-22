# Türkçe RandomDayGuard rehberi

**v0.4.12-alpha**

RandomDayGuard, Abiotic Factor adanmış sunucusundan toplanan sınırlı kanıtları
okunabilir yönetici raporlarına dönüştürür. Sunucu durumu, günlük özet, oyuncu
etkinliği, vaka incelemesi ve kritik hatalar ayrı tutulur.

## Kurulum

[Kurulum kılavuzunu](Y%C3%9CKLEME.md) izleyin. Mod
`ue4ss/Mods/RandomDayGuard` altında olmalı ve `mods.txt` içinde
`RandomDayGuard : 1` bulunmalıdır. İç içe kurulumdan ve çift `Scripts`
klasöründen kaçının.

## İlk raporu doğrulama

Önce `runtime/current/startup_status.json`, ardından
`runtime/final_logs/latest_dossier.json` ve
`runtime/final_logs/route_proof.json` dosyalarını inceleyin. Her rota `full`,
`limited_expected_empty` veya `missing` durumunu bildirir. Özet ile kaynak aynı
çalışma döngüsüne ait olmalıdır.

## Yapılandırma ve kullanım

Genel varsayılanlar `review_only_mode = true`, `auto_ban = false` ve
`write_admin_ini = false` değerleridir. [Başlangıç](BURADAN_BA%C5%9ELAYIN.md),
[İşletim](%C4%B0%C5%9ELEMLERIN_BA%C5%9EUCU_KITABI.md), [Yapılandırma](YAPILANDIRMA_PROFILLERI.md)
ve [Sorun giderme](SORUN_GIDERME.md) belgelerini kullanın. Yapılandırılmış
kanıt teknik kayıttır; çeviri bu kaydı okunabilir kılar.

Komutlar, yollar, anahtarlar ve durumlar gerçek dosyalarla eşleşmesi için
İngilizce bırakılmıştır.

## Alfa sürüm ve iki kanıt yolu

Bu bir alfa sürümüdür. Belgelenen toplama, raporlama ve kurtarma yolları test edildi; uyumluluk, geçmiş kapsamı ve rapor kalitesi geliştirilmeye devam ediyor.

Güncel yol etkin günlük, mevcut başlangıç ve zamanlayıcı durumu ile mevcut oturumları kullanır ve güncel raporları hemen yazabilir. Geçmiş yolu saklanan günlükleri, PlayerData adlarını, kanıtları ve eski vakaları sınırlı adımlarla inceler.

`runtime/current/report_worker_status.json`

Birkaç döngü boyunca `runtime/current/report_worker_status.json` içindeki `scan_cursor` ve `last_progress_ts` değerlerini karşılaştırın. İlerliyorsa tarama çalışıyordur. Güncel raporlar ilerlerken bunlar değişmiyorsa geçmiş taraması takılmıştır; güncel bilgiler kullanılabilir, eski geçmişe bağlı sonuçlar sınırlı kalır.

[Troubleshooting](SORUN_GIDERME.md)

## Tam dokümantasyon kitaplığı

Her genel Markdown belgesi yerelleştirilmiş dosya adlarıyla bu dilde mevcuttur.

- [Yerelleştirilmiş dokümantasyon dizinini aç](BELGELER.md)
