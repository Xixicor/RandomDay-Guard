# Türkçe RandomDayGuard rehberi

> [!IMPORTANT]
> ## Proje durumu — RandomDay testleri tamamlandı
>
> RandomDay test çalışması tamamlandı ve herkese açık test sunucusu yakında kapatılacak.
>
> Bu çalışma sırasında RandomDay ve RandomDayGuard; tekrarlanan profil dönüşümleri, normal ve kesintiye uğramış sunucu yeniden başlatmaları, kurtarma ve geri alma kontrolleri, genişletilmiş mod entegrasyonu, sunucu kanıtlarının toplanması ve operatör raporlarının incelenmesi boyunca birlikte çalıştırıldı.
>
> Böylece hedeflediğimiz bilgiyi edindik: dönüşümlü sandbox profillerinin gerçek ayrılmış sunucu yaşam döngülerindeki davranışı; RandomDay’in desteklenen genişletilmiş modlarla etkileşimi; ve RandomDayGuard’ın boşlukları veya tahminleri gerçekmiş gibi sunmadan sunucunun yazdığı kanıtları ne ölçüde yararlı ve temkinli bir izlemeye dönüştürebildiği.
>
> **Test sunucusunda kullanılan bileşenler:**
>
> - RandomDay özel geliştirme yapısı `v0.41.76`
> - RandomDayGuard özel geliştirme yapısı `v0.46.130`
> - Chaotic Spawn Engine / DynamicSpawns `0.8.5 Hotfix 1`
> - Lethal Lasers `1.0 UE4SS`
> - ANTE Up `0.26`
> - Encounter Director integration — RandomDay’e ait bir DynamicSpawns uzantısıdır, ayrı dağıtılan bir mod değildir
> - UE4SS `v3.0.1 Beta #0` (Git `01e0a584`; Nexus `v3.0.1-940-g01e0a584`)
> - Abiotic Factor ayrılmış sunucusu `1.4.0.27939`
>
> Şu anda yayımlanan paketler RandomDay `v0.3.16-alpha` ve RandomDayGuard `v0.4.12-alpha` olarak kalmaktadır.
>
> Her iki projenin geliştirilmesi şimdilik duraklatıldı. Mevcut sürümler ve belgeler erişilebilir kalacak; çalışmayı yeniden sürdürme isteği duyduğumuzda geri dönebiliriz.
>
> Bu bileşen listesi çalışma sırasında kullanılanları belgeler; asgari sürüm şartı veya oyunun, loader’ın ya da modların sonraki sürümleriyle uyumluluk garantisi değildir. Resmî olarak kaydedilen son döngüde Abiotic Factor `1.4.0.27939` kullanıldı.

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
