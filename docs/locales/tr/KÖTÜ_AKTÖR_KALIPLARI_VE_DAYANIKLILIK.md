<a id="bad-actor-patterns-and-resilience"></a>
# Kötü aktör kalıpları ve dayanıklılık

> **Kanonik İngilizce kaynağı:** [BAD_ACTOR_PATTERNS_AND_RESILIENCE.md](../../BAD_ACTOR_PATTERNS_AND_RESILIENCE.md). Bu yerelleştirilmiş belgeler tam komutları, yolları, anahtarları, durum değerlerini, karmaları ve dosya adlarını korur. Teknik ifadeler farklıysa İngilizce kaynağı kullanın.


Koruyucunun kilitlenmenin kötüye kullanılması, istismara bitişik davranış ve kurtarma planlamasının incelenmesine nasıl yardımcı olduğunu anlamak için bu sayfayı kullanın.

<a id="what-the-guard-can-help-with"></a>
## Koruyucunun yardımcı olabileceği

| Desen | Kontrol edilmesi gerekenler |
|---|---|
| Kilitlenmeyle ilişkili dönüşler | Kilitlenmeden önce aynı hesap etkin ve yeniden başlatmanın ardından geri dönüyor |
| Hızlı yeniden bağlanma incelemesi | Tekrarlanan join/leave veya timeout/reconnect döngüler |
| Çoklu hesap kümeleri | Dalgalara katılma, paylaşılan uyarı pencereleri, paylaşılan hata pencereleri |
| Uyarı patlaması gerilimi | Tekrarlanan ActorChannelFailure veya save-warning pencereleri |
| Sınır dışı bağlamı | PlayerData/map/world okunabilir olduğunda bağlam |
| Dokunma kaydetme örtüşmesi | Dünya çapında çakışan bağlam eşlenmiş oturumlar |
| Kimlik karışıklığı | ConnectID eşlemesi gerektiren adlar |

<a id="why-it-avoids-memory-access"></a>
## Bellek erişimini neden engeller

RandomDayGuard sunucuya ait dosyalardan çalışır:

```text
Saved/Logs/*.log
Admin.ini
World saves
PlayerData
Backups
runtime evidence
```

Bu, istemci tarafı bellek durumuna daha az bağımlı olmasını ve oyun güncellemelerinde daha az kırılgan olmasını sağlar.

Ödül:

```text
It cannot prove hidden live actions unless the server writes evidence.
```

<a id="crash-correlated-returners"></a>
## Çökmeyle ilişkili geri dönüşler

Desen:

```text
Account joins.
Server crashes or restarts.
Same account reconnects quickly.
Pattern repeats.
```

Yararlı dosyalar:

```text
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/account_evidence.json
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="rapid-reconnect-probers"></a>
## Hızlı probları yeniden bağlayın

Desen:

```text
join -> leave -> join -> leave -> join
```

Yararlı dosyalar:

```text
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/players.tsv
```

<a id="multi-account-clusters"></a>
## Çoklu hesap kümeleri

Desen:

```text
Several accounts join in the same window.
Warnings or crashes follow.
Some accounts rotate or reconnect after restart.
```

Yararlı dosyalar:

```text
runtime/raid_cases/
runtime/forensic_days/YYYY-MM-DD/raid_cases.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

Kural:

```text
A cluster is not a mass-ban list.
Each account still needs its own evidence.
```

<a id="sticky-backup-recommendation"></a>
## Yapışkan yedekleme önerisi

Şunlardan sonra yapışkan bir yedekleme oluşturun:

```text
first full baseline completes
object_registry.json exists
file_manifest.tsv exists
world_state_latest.json has scan_complete=true
Admin.ini is verified
trusted IDs are configured
```

Yedekleme:

```text
RandomDayGuard/config.lua
RandomDayGuard/SavedRoot.txt
RandomDayGuard/runtime/baselines/
RandomDayGuard/runtime/object_registry.json
RandomDayGuard/runtime/world_state/current/world_state_latest.json
Saved/SaveGames/Server/Admin.ini
```

<a id="recovery-model"></a>
## Kurtarma modeli

```text
Clean install
-> verify live defense
-> complete first baseline
-> create sticky backup
-> run server normally
-> use daily rollups for review
-> restore sticky backup if needed
```

<a id="related-docs"></a>
## İlgili belgeler

* [`FORENSIC_DAILY_ROLLUPS.md`](ADLI_G%C3%9CNL%C3%9CK_TOPLAMALAR.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](OYUNCU_%C4%B0NCELEME_%C4%B0%C5%9E_AKI%C5%9EI.md)
* [`WORLD_SAVE_FOLDER_CHANGES.md`](D%C3%9CNYA_KAYDETME_KLAS%C3%96R%C3%9C_DE%C4%9EI%C5%9EIKLIKLERI.md)
