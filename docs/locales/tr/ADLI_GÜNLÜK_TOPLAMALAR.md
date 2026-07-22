<a id="forensic-daily-rollups"></a>
# Adli günlük özetler

> **Kanonik İngilizce kaynağı:** [FORENSIC_DAILY_ROLLUPS.md](../../FORENSIC_DAILY_ROLLUPS.md). Bu yerelleştirilmiş belgeler tam komutları, yolları, anahtarları, durum değerlerini, karmaları ve dosya adlarını korur. Teknik ifadeler farklıysa İngilizce kaynağı kullanın.


Günlük özet, yeniden oluşturulabilir bir dizindir. Kaynak kanıtları güvenilir olmaya devam ediyor; günlük klasör ve son günlük, çalışma zamanı kanıtlarından oluşturulan hızlı inceleme paketleridir.

Hızlı analiz için bir klasörün yüklenmesini istediğinizde bu sayfayı kullanın.

<a id="what-it-is"></a>
## Nedir
Günlük toplama, bir günlük ham kanıtın yeniden oluşturulabilir bir özetidir.

Ham kanıtın yerini almaz.

```text
Source evidence = truth
Daily rollup = fast index
Final log = plain-language summary
```

<a id="where-it-writes"></a>
## Nerede yazıyor
Geçerli gün:

```text
runtime/current/forensic_today.json
runtime/current/forensic_today.md
runtime/current/forensic_today.txt
```

Günlük paket:

```text
runtime/forensic_days/YYYY-MM-DD/
- forensic_day_summary.json
- forensic_day_summary.md
- forensic_day_summary.txt
- players.tsv
- sessions.tsv
- crash_reconnects.tsv
- warning_bursts.tsv
- raid_cases.tsv
- world_context.tsv
- ban_recommendations.tsv
- enforcement_audit.tsv
- evidence_index.json

## Final log contents
```text
runtime/final_logs/YYYY-MM-DD/
- final_forensic_log.txt
- final_forensic_log.md
- final_forensic_log.json

TXT hızlı operatör incelemesi için sade bir dille yazılmıştır.

<a id="what-the-final-txt-should-answer"></a>
## Son TXT yanıtı ne olmalıdır
```text
Did the guard run?
Was the scan partial or complete?
Who joined?
Who left cleanly?
Who did not leave cleanly?
Who rapidly reconnected?
Who overlapped crashes?
Who returned after crashes?
Who had warning overlap?
Who appears in a cluster?
Who is REVIEW?
Who is BAN-ELIGIBLE?
Which BannedPlayer=<ID> lines are candidates?
Which gates blocked enforcement?
What evidence files support each recommendation?
```

<a id="source-files-used"></a>
## Kullanılan kaynak dosyaları
Toplama, mevcut olduğunda bunları okuyabilir:

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/evidence/live_defense_events.jsonl
runtime/warning_events.jsonl
runtime/raid_cases/
runtime/world_state/current/world_state_latest.json
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/scan_complete.json
runtime/object_registry.json
runtime/enforced_bans.jsonl
runtime/enforced.txt
runtime/ban_queue.json
```

Eksik dosyalar, ölümcül olarak değerlendirilmemeli, eksik olarak işaretlenmelidir.

<a id="update-behavior"></a>
## Güncelleme davranışı
Koruyucu aynı gün için aynı dosyaları günceller.

Doğru:

```text
runtime/forensic_days/2026-05-13/forensic_day_summary.json
```

Yanlış:

```text
forensic_day_summary_1.json
forensic_day_summary_2.json
forensic_day_summary_3.json
```

<a id="crash-safety"></a>
## Çökme güvenliği
Koruyucu önce geçici dosyaları yazmalı, sonra yeniden adlandırmalıdır:

```text
final_forensic_log.txt.tmp -> final_forensic_log.txt
players.tsv.tmp -> players.tsv
forensic_day_summary.json.tmp -> forensic_day_summary.json
```

Bu, sunucu yazma işleminin ortasında çökerse son iyi özeti korur.

<a id="playerstsv-columns"></a>
## `players.tsv` sütunlar
```text
date
account_id
ban_id
name
identity_confidence
playerdata_verified
first_seen
last_seen
join_count
leave_count
clean_leave_count
unclean_disconnect_count
rapid_rejoin_count
crash_overlap_count
post_crash_reconnect_count
warning_overlap_count
raid_case_count
world_context_count
score
status
recommended_action
ban_eligible
already_enforced
admin_ini_line
```

<a id="ban_recommendationstsv-columns"></a>
## `ban_recommendations.tsv` sütunlar
```text
date
account_id
ban_id
name
status
recommended_action
reason
admin_ini_line
gates_passed
blocked_by
evidence_files
```

<a id="review-rule"></a>
## İnceleme kuralı
Günlük toplama, incelemeyi hızlandırabilir ancak tek kanıt bu olmamalıdır.

Bir öneri önemli olduğunda şunu kullanarak doğrulayın:

```text
account_evidence.json
session_events.jsonl
server_lifecycle_events.jsonl
warning_events.jsonl
world_state files
enforced_bans.jsonl
```

<a id="related-docs"></a>
## İlgili belgeler
* [`MEMORY_ECONOMY_AND_OUTPUTS.md`](BELLEK_EKONOMISI_VE_%C3%87IKI%C5%9ELAR.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](OYUNCU_%C4%B0NCELEME_%C4%B0%C5%9E_AKI%C5%9EI.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](%C3%87IKTI_%C5%9EEMASI_REFERANSI.md)
