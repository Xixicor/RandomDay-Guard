<a id="forensic-daily-rollups"></a>
# Majaribio ya kila siku ya kisayansi

> **Chanzo cha Kiingereza cha Canonical:** [FORENSIC_DAILY_ROLLUPS.md](../../FORENSIC_DAILY_ROLLUPS.md). Hati hizi zilizojanibishwa huhifadhi amri kamili, njia, funguo, thamani za hali, heshi na majina ya faili. Ikiwa maneno ya kiufundi yanatofautiana, tumia chanzo cha Kiingereza.


Mchanganuo wa kila siku ni faharasa inayoweza kujengwa upya. Ushahidi wa chanzo unabaki kuwa na mamlaka; folda ya kila siku na kumbukumbu ya mwisho ni vifurushi vya ukaguzi wa haraka vinavyotokana na ushahidi wa wakati wa utekelezaji.

Tumia ukurasa huu unapotaka folda moja kupakiwa kwa uchanganuzi wa haraka.

<a id="what-it-is"></a>
## Ni nini
Mchanganuo wa kila siku ni muhtasari unaoweza kujengwa upya wa ushahidi ghafi kwa siku moja.

Haichukui nafasi ya ushahidi mbichi.

```text
Source evidence = truth
Daily rollup = fast index
Final log = plain-language summary
```

<a id="where-it-writes"></a>
## Inapoandikia
Siku ya sasa:

```text
runtime/current/forensic_today.json
runtime/current/forensic_today.md
runtime/current/forensic_today.txt
```

Kifurushi cha kila siku:

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

The TXT imeandikwa kwa lugha rahisi kwa ukaguzi wa haraka wa waendeshaji.

<a id="what-the-final-txt-should-answer"></a>
## Ni nini cha mwisho TXT inapaswa kujibu
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
## Chanzo faili zilizotumika
Mchanganuo unaweza kusoma haya ukiwapo:

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

Faili zinazokosekana zinapaswa kutiwa alama kuwa hazipo, na zisichukuliwe kuwa mbaya.

<a id="update-behavior"></a>
## Sasisha tabia
Kwa siku hiyo hiyo, mlinzi husasisha faili sawa.

Sahihi:

```text
runtime/forensic_days/2026-05-13/forensic_day_summary.json
```

Si sahihi:

```text
forensic_day_summary_1.json
forensic_day_summary_2.json
forensic_day_summary_3.json
```

<a id="crash-safety"></a>
## Usalama-kuacha kufanya kazi
Mlinzi anapaswa kuandika faili za muda kwanza, kisha azipe jina jipya:

```text
final_forensic_log.txt.tmp -> final_forensic_log.txt
players.tsv.tmp -> players.tsv
forensic_day_summary.json.tmp -> forensic_day_summary.json
```

Hii hulinda muhtasari mzuri wa mwisho ikiwa seva itaacha kufanya kazi katikati ya uandishi.

<a id="playerstsv-columns"></a>
## `players.tsv` safuwima
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
## `ban_recommendations.tsv` safuwima
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
## Kagua sheria
Mchanganuo wa kila siku unaweza kufanya ukaguzi haraka, lakini usiwe ushahidi pekee.

Wakati pendekezo ni muhimu, thibitisha kwa:

```text
account_evidence.json
session_events.jsonl
server_lifecycle_events.jsonl
warning_events.jsonl
world_state files
enforced_bans.jsonl
```

<a id="related-docs"></a>
## Nyaraka zinazohusiana
* [`MEMORY_ECONOMY_AND_OUTPUTS.md`](UCHUMI_WA_KUMBUKUMBU_NA_MATOKEO.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](MTIRIRIKO_WA_KAZI_WA_MAONI_YA_MCHEZAJI.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](REJELEO_LA_UTARATIBU_WA_PATO.md)
