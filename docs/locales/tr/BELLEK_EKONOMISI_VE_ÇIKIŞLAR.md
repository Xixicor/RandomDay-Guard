<a id="memory-economy-and-output-files"></a>
# Bellek ekonomisi ve çıktı dosyaları

> **Kanonik İngilizce kaynağı:** [MEMORY_ECONOMY_AND_OUTPUTS.md](../../MEMORY_ECONOMY_AND_OUTPUTS.md). Bu yerelleştirilmiş belgeler tam komutları, yolları, anahtarları, durum değerlerini, karmaları ve dosya adlarını korur. Teknik ifadeler farklıysa İngilizce kaynağı kullanın.


Bu sayfada hangi dosyaların büyüyeceği, hangi dosyaların üzerine yazılacağı ve hızlı inceleme için nelerin yükleneceği açıklanmaktadır.

<a id="fast-answer"></a>
## Hızlı yanıt

| Soru | Açık |
|---|---|
| Gardiyan hayatta mı? | `runtime/current/poll_status.json` |
| Kim görüldü? | `runtime/account_evidence.json` |
| Oturumlara ne oldu? | `runtime/evidence/session_events.jsonl` |
| Bugün ne oldu? | `runtime/forensic_days/YYYY-MM-DD/` |
| Sade dil nedir? özet? | `runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt` |
| Tarama ilerlemesi nedir? | `runtime/scan_progress.json` |
| Dünya bağlamı nedir? | `runtime/world_state/current/world_state_latest.json` |
| Hangi yasaklar yazılmıştır? | `runtime/enforced_bans.jsonl` |

<a id="output-model"></a>
## Çıktı modeli

| Tür | Davranış | Örnekler |
|---|---|---|
| Geçerli anlık görüntüler | Üzerine yazılan | `runtime/current/*.json` |
| Olay günlükleri | Yalnızca ekleme | `runtime/evidence/*.jsonl` |
| Tablolar | Güncellendi veya eklendi | `*.tsv` |
| Temel çizgiler | Tamamlandıktan sonra yeniden kullanıldı | `runtime/baselines/*` |
| Günlük özetler | Yerinde güncellendi | `runtime/forensic_days/YYYY-MM-DD/*` |
| Son günlükler | Sade dilli günlük özet | `runtime/final_logs/YYYY-MM-DD/*` |

<a id="current-snapshots"></a>
## Geçerli anlık görüntüler

Bunlar küçük kalır ve "şimdi doğru olan"a yanıt verir.

```text
runtime/current/poll_status.json
runtime/current/session_state.json
runtime/current/active_accounts.json
runtime/current/forensic_today.json
runtime/current/forensic_today.md
runtime/current/forensic_today.txt
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/world_state/current/world_state_latest.json
```

<a id="player-summaries"></a>
## Oyuncu özetleri

Bunlar, hesap incelemesi için kontrol edilecek ilk dosyalardır.

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
```

Özetler:

```text
account_id
ban_id
name
identity_confidence
first_seen
last_seen
join_count
leave_count
status
score
```

<a id="event-logs"></a>
## Olay günlükleri

Bunlar, zaman çizelgesi.

```text
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/warning_events.jsonl
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/evidence/live_defense_events.jsonl
```

<a id="daily-forensic-rollups"></a>
## Günlük adli özetler

Bunlar hızlı yükleme paketleridir.

```text
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

Hızlı bir dönem analizi istediğinizde bu klasörlerden birini yükleyin.

<a id="scan-and-baseline-files"></a>
## Dosyaları tarayın ve temel çizgi

Dünya bağlamının kısmi mi yoksa kısmi mi olduğunu anlamak için bunları kullanın. tamamlandı.

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/scan_complete.json
runtime/object_registry_partial.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
```

<a id="enforcement-files"></a>
## Zorunluluk dosyaları

Bunları yalnızca zorlama etkinleştirildiğinde kullanın.

```text
runtime/enforced.txt
runtime/enforced_bans.jsonl
runtime/ban_queue.json
runtime/evidence/enforced_bans.jsonl
```

`Admin.ini` yalnızca şunu almalıdır:

```ini
BannedPlayer=<ID>
```

<a id="what-updates-when-a-player-joins"></a>
## Bir oyuncu katıldığında hangi güncellemeleri

Beklenen güncellemeler:

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/current/session_state.json
runtime/forensic_days/YYYY-MM-DD/players.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="what-updates-when-the-server-crashes-or-restarts"></a>
## Sunucu çöktüğünde hangi güncellemeleri veya yeniden başlar

Beklenen güncellemeler:

```text
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/crash_reconnects.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="what-updates-when-the-scan-progresses"></a>
## Tarama ilerlediğinde hangi güncellemeler yapılır?

Beklenen güncellemeler:

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/object_registry_partial.json
runtime/world_state/current/world_state_latest.json
runtime/forensic_days/YYYY-MM-DD/forensic_day_summary.json
```

<a id="what-to-upload-for-quick-analysis"></a>
## Hızlı analiz için neler yüklenmeli

En iyi paket:

```text
runtime/final_logs/YYYY-MM-DD/
```

Daha kapsamlı paket:

```text
runtime/forensic_days/YYYY-MM-DD/
```

Tam kanıt paketi:

```text
runtime/account_evidence.json
runtime/evidence/session_events.jsonl
runtime/server_lifecycle_events.jsonl
runtime/warning_events.jsonl
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

<a id="related-docs"></a>
## İlgili belgeler

* [`FORENSIC_DAILY_ROLLUPS.md`](ADLI_G%C3%9CNL%C3%9CK_TOPLAMALAR.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](%C3%87IKTI_%C5%9EEMASI_REFERANSI.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](OYUNCU_%C4%B0NCELEME_%C4%B0%C5%9E_AKI%C5%9EI.md)
