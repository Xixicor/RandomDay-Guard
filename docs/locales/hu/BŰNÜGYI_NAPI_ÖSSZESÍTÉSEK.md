<a id="forensic-daily-rollups"></a>
# Bűnügyi szakértői napi összesítések

> **Kanonikus angol forrás:** [FORENSIC_DAILY_ROLLUPS.md](../../FORENSIC_DAILY_ROLLUPS.md). Ez a lokalizált dokumentáció megőrzi a pontos parancsokat, elérési utakat, kulcsokat, állapotértékeket, kivonatokat és fájlneveket. Ha a technikai megfogalmazás eltér, használja az angol forrást.


A napi összesítés egy újraépíthető index. A forrás bizonyítéka továbbra is mérvadó; a napi mappa és a végső napló futásidejű bizonyítékokból előállított gyors áttekintési csomagok.

Használja ezt az oldalt, ha egy mappát szeretne feltölteni a gyors elemzéshez.

<a id="what-it-is"></a>
## Mi ez
A napi összesítés egy napra vonatkozó nyers bizonyítékok újraépíthető összefoglalása.

Nem helyettesíti a nyers bizonyítékokat.

```text
Source evidence = truth
Daily rollup = fast index
Final log = plain-language summary
```

<a id="where-it-writes"></a>
## Ahová ír
Aktuális nap:

```text
runtime/current/forensic_today.json
runtime/current/forensic_today.md
runtime/current/forensic_today.txt
```

Napi csomag:

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

A TXT egyszerű nyelven íródott a gyors kezelői áttekintés érdekében.

<a id="what-the-final-txt-should-answer"></a>
## Mi a végső TXT válaszolnia kell
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
## Használt forrásfájlok
Az összesítő ezeket tudja olvasni, ha jelen vannak:

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

A hiányzó fájlokat hiányzóként kell megjelölni, nem pedig végzetesként kezelni.

<a id="update-behavior"></a>
## Frissítési viselkedés
Ugyanazon a napon az őr ugyanazokat a fájlokat frissíti.

Helyes:

```text
runtime/forensic_days/2026-05-13/forensic_day_summary.json
```

Rossz:

```text
forensic_day_summary_1.json
forensic_day_summary_2.json
forensic_day_summary_3.json
```

<a id="crash-safety"></a>
## Összeomlás-biztonság
Az őrnek először ideiglenes fájlokat kell írnia, majd át kell neveznie:

```text
final_forensic_log.txt.tmp -> final_forensic_log.txt
players.tsv.tmp -> players.tsv
forensic_day_summary.json.tmp -> forensic_day_summary.json
```

Ez megvédi az utolsó jó összefoglalót, ha a szerver összeomlik az írás közben.

<a id="playerstsv-columns"></a>
## `players.tsv` oszlopok
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
## `ban_recommendations.tsv` oszlopok
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
## Felülvizsgálati szabály
A napi összesítés gyorsíthatja az áttekintést, de nem ez az egyetlen bizonyíték.

Ha egy ajánlás számít, ellenőrizze a következővel:

```text
account_evidence.json
session_events.jsonl
server_lifecycle_events.jsonl
warning_events.jsonl
world_state files
enforced_bans.jsonl
```

<a id="related-docs"></a>
## Kapcsolódó dokumentumok
* [`MEMORY_ECONOMY_AND_OUTPUTS.md`](MEM%C3%93RIATAKAR%C3%89KOSS%C3%81G_%C3%89S_KIMENETEK.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](J%C3%81T%C3%89KOS_ELLEN%C5%90RZ%C3%89SI_MUNKAFOLYAMAT.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](KIMENETI_S%C3%89MA_HIVATKOZ%C3%81S.md)
