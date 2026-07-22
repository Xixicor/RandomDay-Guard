<a id="status-and-error-reference"></a>
# Durum ve hata referansı

> **Kanonik İngilizce kaynağı:** [STATUS_AND_ERROR_REFERENCE.md](../../STATUS_AND_ERROR_REFERENCE.md). Bu yerelleştirilmiş belgeler tam komutları, yolları, anahtarları, durum değerlerini, karmaları ve dosya adlarını korur. Teknik ifadeler farklıysa İngilizce kaynağı kullanın.


Belirti [Sorun Giderme](SORUN_GIDERME.md) içinde sınıflandırıldıktan sonra bu referansı kullanın. Hatanın adlandırdığı yapılandırılmış durum dosyasını okuyun. Farklı kodlar, farklı güvenlik ve yaşam döngüsü durumlarını temsil eder; bunları genel bir "Koruma başarısız" sonucuna daraltmayın.

<a id="route-and-source-states"></a>
## Yol ve kaynak durumları

| Değer | Anlam | Operatör yanıtı |
|---|---|---|
| `full` | Geçerli döngü kaynak kanıtıyla tamamlanan rota sözleşmesi. | Rotanın kanıt sınırını okuyun; herhangi bir onarım ima edilmemektedir. |
| `limited_expected_empty` | Rota tamamlandı ve eksik etkinlik bu döngü için geçerli. | Hiçbir sentetik player/case etkinliği oluşturulmamalıdır. |
| `missing` | Gerekli bir çıktı, köken alanı veya kaynak kanıtı mevcut değil. | Rota nedenini ve adlandırılmış kaynak durumunu inceleyin. |
| `available` | Adlandırılmış kaynak okunabilir ve kullanılabilirdi. | Hayır eylem. |
| `expected_empty` | Kaynak kontrol edildi ve yasal olarak hiçbir satır yoktu. | Etkinlik bağımsız olarak beklenmedikçe eylem yok. |
| `partial` / `complete_with_gaps` | Kullanılabilir kanıtlar mevcut ancak adlandırılmış kaynak sınıfları eksik. | Sonuçları toplanan kanıtlarla sınırlayın. |
| `deferred` | Sınırlı çalışma daha sonraki bir çalışan için planlandı fırsat. | Yapılandırmayı değiştirmeden önce ilerleme ilerlemelerini onaylayın. |
| `unavailable` | Ortam kaynağı sağlamadı. | Sınırı kaydedin; yalnızca kanıtlanmış bir yolu veya izin sorununu düzeltin. |
| `malformed` | Kaynak okunabilirdi ancak yapısal doğrulama başarısız oldu. | Koruyun ve kaynağı düzeltin; tahmin etmeyin. |
| `permission_denied` | Kaynak var ancak okunamadı. | Yalnızca gerekli olan dar okuma iznini verin. |
| `error` | Toplama, kaydedilen nedenden dolayı başarısız oldu. | Hatayı koruyun ve o aşamayı teşhis edin. |

<a id="playerdata-and-inventory-codes"></a>
## PlayerData ve envanter kodları

| Kod | Anlam | Güvenli yanıt |
|---|---|---|
| `saved_root_unavailable` | Doğrulanmış kayıtlı kök, genel ardışık düzende mevcut değildi. | Düzeltin `SavedRoot.txt` ve yol araştırmasını yeniden kontrol edin. |
| `unsafe_playerdata_root` | PlayerData bulma dışında çözüldü sınırlı Kaydedilmiş kök. | Yolu düzeltin; hiçbir zaman sınırı zayıflatmaz. |
| `playerdata_discovery_not_run` | Sınırlı keşif çalışanı henüz çalışmadı. | Zamanlayıcıyı ve çalışan ilerleme durumunu kontrol edin. |
| `playerdata_discovery_read_failed:*` | Keşif çıktısı okunamadı. | Sonek ayrıntısını koruyun ve sınırlı envanter komutunu doğrulayın. |
| `inventory_command_open_failed` | Envanter süreci açılamadı başlatıldı. | Çalışma zamanının yapılandırılmış komut köprüsünü sağladığını doğrulayın. |
| `inventory_command_read_failed` | Envanter çıktısı okuma sırasında başarısız oldu. | Kısmi çıktıyı koruyun ve yalnızca temel hata düzeltildikten sonra yeniden çalıştırın. |
| `inventory_command_close_failed` | Envanter güvenilir bir kapatma sonucu olmadan tamamlandı. | Kaynağı tedavi edin eksik olarak. |
| `identity_ledger_row_limit_exceeded` | Kalıcı kimlik girişi, kamu güvenliği sınırlarını aştı. | Defteri arşivleyin ve inceleyin; bunu sessizce tam kanıta dönüştürmeyin. |

<a id="adminini-enforcement-codes"></a>
## Admin.ini uygulama kodları

Bu bölümdeki tüm kodlar arıza durumunda kapatılmıştır. Kendi başlarına manuel yasaklamaya izin vermezler.

| Kod | Anlam | Güvenli yanıt |
|---|---|---|
| `admin_ini_write_disabled` / `admin_ini_disabled` | Genel olarak güvenli yazma kapıları kapalı. | Yalnızca inceleme işleminde bekleniyor. |
| `admin_ini_backup_disabled` / `backup_safety_gate_disabled` | Gerekli yedekleme politikası etkin değil. | Yazmaları devre dışı bırak. |
| `enforcement_disabled` / `ban_on_threshold_disabled` / `auto_ban_disabled` | Açık bir yaptırım kapısı: kapalı. | Yalnızca herkese açık inceleme varsayılanlarında beklenir; bunu bir yazma hatası olarak yorumlamayın. |
| `review_only_mode_enabled` | Yalnızca inceleme modu, mutasyonu kasıtlı olarak engeller. | Yalnızca kanıtları inceleyin. |
| `duplicate_prevention_disabled` | Yinelenen kopya koruması devre dışı bırakıldı. | Güvenlik kapısı geri yüklenene kadar yazma işlemlerini devre dışı tutun. |
| `readback_safety_gate_disabled` / `rollback_safety_gate_disabled` | Yazma sonrası doğrulama veya geri alma koruması devre dışı bırakıldı. | Tut devre dışı yazıyor; bu kapıları asla atlamayın. |
| `clean_id_safety_gate_disabled` / `account_specific_evidence_gate_disabled` | Temiz kimlik veya hesaba özel kanıt uygulaması devre dışı bırakıldı. | Herhangi bir uygulama testinden önce geçidi geri yükleyin. |
| `moderator_preservation_disabled` / `existing_ban_preservation_disabled` | Korunan hesap veya mevcut yasağın korunması devre dışı bırakıldı. | Yazmaları devre dışı bırak. |
| `clean_numeric_identity_required` | Önerilen kimlik, kabul edilen bağlantı formunun tamamı veya temiz sayısal kimlik değil. | Doğrulanmış bir eşleme edinin; hiçbir zaman rastgele bir öneki kesmeyin. |
| `identity_strength_below_minimum` | Kimlik kanıtı yapılandırılan eşikten daha zayıf. | Yalnızca kanıtları inceleyin. |
| `playerdata_verification_required` | Yapılandırma PlayerData onay gerektiriyor ve hesapta bu onay yok. | Adayın yalnızca incelemeye açık olmasını sağlayın; dosya adından sahiplik sonucunu çıkarmayın. |
| `trusted_or_moderator_identity` | Hesap, güvenilir veya moderatör durumu tarafından korunuyor. | Yazmaya izin verilmez. |
| `admin_ini_path_invalid` / `admin_ini_path_outside_saved_root` | Hedef yol geçersiz veya Kaydedilen kökten kaçıyor. | Doğru yapılandırma; yol korumasını asla atlamayın. |
| `admin_ini_unavailable` | Kayıtlı kök içinde okunabilir bir yapılandırılmış Admin.ini bulunamadı. | Sınırlı yolu düzeltin veya uygulamayı devre dışı bırakın. |
| `admin_ini_read_failed` | Yetkili baytlar okunamadı. | Değişimden önce durdurun. |
| `admin_ini_parse_failed` | Admin.ini doğrulama, daha spesifik bir yapısal kod olmadan başarısız oldu. | Dosyayı koruyun ve bölümünü ve satır yapısını inceleyin. |
| `admin_ini_contains_nul` | Dosya NUL bayt içeriyor ve metin olarak kabul edilmiyor. | Dosyayı koruyun ve Guard dışında onarın. |
| `admin_ini_duplicate_banned_players_section` | Birden fazla `[BannedPlayers]` bölümü mevcut. | Durdurulduğunda bölümleri manuel olarak birleştirin. |
| `admin_ini_banned_player_outside_section` | Dışarıda bir yasaklama satırı görünüyor `[BannedPlayers]`. | Düzeni manuel olarak düzeltin. |
| `admin_ini_invalid_banned_player_line` | Yasaklama satırı tam olarak desteklenen temiz bir kimlik satırı değildir. | Hatalı biçimlendirilmiş satırı düzeltin. |
| `admin_ini_backup_failed` | Benzersiz yedekleme yazmadı ve read back byte-identically. | No mutation is allowed. |
| `admin_ini_external_change_detected` | Another writer changed the file after Guard's snapshot. | Preserve the external bytes and retry only after coordinating writers. |
| `atomic_rename_unavailable` | Atomic replacement was requested but Lua did not provide `os.rename`. | Hiçbir yazmaya güvenilmez; use a supported runtime or keep enforcement disabled. |
| `admin_ini_write_failed` | Controlled replacement did not complete. | Inspect the recorded replacement error and backup. |
| `post_write_verification_failed` | Production bytes did not equal the candidate. | Check `rollback_success` ve `rollback_refused_external_change` before any action. |

<a id="startup-scheduler-and-backlog-states"></a>
## Başlangıç, zamanlayıcı ve biriktirme durumları

Bu değerler rota kanıtı değil, yaşam döngüsü kanıtıdır. Bunları mevcut anket, rapor çalışanı ve rota korumalı dosyalarla birlikte okuyun.

| Değer | Anlam | Güvenli yanıt |
|---|---|---|
| `not_started` | Adlandırılmış başlatma veya zamanlayıcı aşaması henüz başlamadı. | Başlatma sırasında belgelenen aralığı bekleyin; afterward inspect the first unchanged phase. |
| `main_lua_loaded` / `starting` | The canonical loader ran and Guard entered startup. | Continue to later phases; this alone is not readiness. |
| `saved_root_found` / `log_tail_initialized` / `epoch_started` | Core source and continuity initialization advanced. | No action unless the next phase stops advancing. |
| `admin_state_written` / `playerdata_index_written` | Initial bounded indexes were exported. | No action; scheduler handoff must still follow. |
| `watchdog_started` | The report and poll watchdog was registered. | Confirm scheduler and poll progress next. |
| `ready_degraded` / `scan_running` | Guard is running while bounded historical scan remains pending. | Caution, not failure; verify progress counters advance. |
| `ready` | Startup and the current bounded scan reached ready state. | Check route proof separately. |
| `scan_failed` / `error` | Startup or scan terminated with a recorded error. | Preserve the named error or status file and diagnose that stage. |
| `running` | The planlayıcı gelecekteki anket fırsatlarına sahip. | `poll_id` ve `poll_completed_count` ilerleme. |
| `manual_only` | Döngü planlama kullanılamıyordu; only explicit work can run. | Treat unattended operation as unavailable. |
| `stopped` | Scheduler operation ended. | Inspect preceding stop and error evidence before restart. |
| `active_log_caught_up` | No unread active-log backlog remains. | Historical scan may devam edin. |
| `active_log_unavailable_nonblocking` | Etkin günlük yoktu ancak başlangıç engellemesiz kaldı. | Record the source limit and verify other sources. |
| `active_log_read_failed` | The active log existed but could not be read. | Preserve the error and correct only the proven path or permission issue. |
| `budget_exhausted` / `active_log_has_unread_bytes` | The bounded tail pass stopped with backlog remaining. | Confirm later polls reduce the unread sayısı. |
| `offset_commit_failed_after_events_applied` | Olaylar işlendi ancak kalıcı günlük dengeleme kalıcılığı başarısız oldu. | Uygulama ertelendi; repair offset storage before relying on another cycle. |

<a id="scheduler-report-and-notification-codes"></a>
## Scheduler, report, and notification codes

| Code or status | Anlam | Güvenli yanıt |
|---|---|---|
| `poll already in flight` | A second callback arrived while the current poll owned the lifecycle. | Confirm the existing poll advances; do not add another loop owner. |
| `no_log_files_found` | No configured active or backup log was discovered. | Verify Saved root and source configuration. |
| `current_poll_error` | The current cycle recorded a poll-source failure. | Read `runtime/current/poll_error.json`. |
| `cadence_deferred` | The completion dispatcher is not due yet. | Expected until the next bounded opportunity. |
| `reports_disabled` | Public report generation is disabled. | Enable only if reports are intended. |
| `local_outbox_write_failed` | A translated local envelope could not be written. | Repair the runtime output directory; this is not a notification transport error. |
| `source_accounting_disabled` | Route proof cannot claim complete source coverage. | Enable source accounting or accept missing proof explicitly. |
| `route_disabled` | The route is intentionally disabled. | Bu rota için teslimat beklenmiyor. |
| `poll_owner_between_polls` | Rapor çalışanı, yoklamalar arasındaki zamanlayıcıya ait boşluk için sıraya alındı. | Yalnızca zaman damgaları ve imleçler ilerlemeye devam ederken bekleniyor. |
| `unsafe_shell_path` | Sınırlı bir envanter veya kabuk yolu, platform açısından güvenli doğrulamada başarısız oldu. | Yolu düzeltin; Alıntı yapmayı veya yol doğrulamayı asla zayıflatmayın. |

<a id="related-procedures"></a>
## Belirti sınıflandırması ve onarımı için ilgili prosedürler

- [Sorun Giderme](SORUN_GIDERME.md) belirti sınıflandırması ve onarımı için.
- [Doğrulama ve sürüm incelemesi](DO%C4%9ERULAMA_VE_S%C3%9CR%C3%9CM.md) demirbaş ve paket arızaları için.
- [Çıkış şeması referansı](%C3%87IKTI_%C5%9EEMASI_REFERANSI.md) tam saha sözleşmeleri için.
