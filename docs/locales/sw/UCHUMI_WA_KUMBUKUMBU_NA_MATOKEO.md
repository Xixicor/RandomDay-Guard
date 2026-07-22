<a id="memory-economy-and-output-files"></a>
# Uhifadhi wa kumbukumbu na faili za towe

> **Chanzo cha Kiingereza cha Canonical:** [MEMORY_ECONOMY_AND_OUTPUTS.md](../../MEMORY_ECONOMY_AND_OUTPUTS.md). Hati hizi zilizojanibishwa huhifadhi amri kamili, njia, funguo, thamani za hali, heshi na majina ya faili. Ikiwa maneno ya kiufundi yanatofautiana, tumia chanzo cha Kiingereza.


Ukurasa huu unaeleza ni faili zipi zinazokua, faili zipi zimefutwa, na nini cha kupakiwa kwa ukaguzi wa haraka.

<a id="fast-answer"></a>
## Jibu la haraka

| Swali | Fungua |
|---|---|
| Je, mlinzi yuko hai? | `runtime/current/poll_status.json` |
| Nani alionekana? | `runtime/account_evidence.json` |
| Ni nini kilifanyika kwa vipindi? | `runtime/evidence/session_events.jsonl` |
| Ni nini kimetokea leo? | `runtime/forensic_days/YYYY-MM-DD/` |
| Muhtasari wa lugha nyepesi ni upi? | `runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt` |
| Maendeleo ya kuchanganua ni nini? | `runtime/scan_progress.json` |
| Muktadha wa ulimwengu ni upi? | `runtime/world_state/current/world_state_latest.json` |
| Ni marufuku gani yaliandikwa? | `runtime/enforced_bans.jsonl` |

<a id="output-model"></a>
## Muundo wa pato

| Aina | Tabia | Mifano |
|---|---|---|
| Picha za sasa | Imeandikwa Batili | `runtime/current/*.json` |
| Kumbukumbu za matukio | Append-pekee | `runtime/evidence/*.jsonl` |
| Majedwali | Imesasishwa au kuongezwa | `*.tsv` |
| Misingi | Imetumika tena baada ya kukamilika | `runtime/baselines/*` |
| Mchanganuo wa kila siku | Imesasishwa mahali | `runtime/forensic_days/YYYY-MM-DD/*` |
| Kumbukumbu za mwisho | Muhtasari wa kila siku wa lugha rahisi | `runtime/final_logs/YYYY-MM-DD/*` |

<a id="current-snapshots"></a>
## Picha za sasa

Hizi hubaki ndogo na kujibu “ni kweli sasa.”

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
## Muhtasari wa kichezaji

Hizi ndizo faili za kwanza za kuangalia ukaguzi wa akaunti.

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
```

Wanafupisha:

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
## Kumbukumbu za matukio

Hizi huhifadhi rekodi ya matukio.

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
## Majaribio ya kila siku ya mahakama

Hivi ndivyo vifurushi vya upakiaji wa haraka.

```text
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

Pakia mojawapo ya folda hizo unapotaka uchanganuzi wa muda wa haraka.

<a id="scan-and-baseline-files"></a>
## Changanua na faili za msingi

Tumia hizi kuelewa ikiwa muktadha wa ulimwengu ni sehemu au kamili.

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
## Faili za utekelezaji

Tumia hizi tu wakati utekelezaji umewashwa.

```text
runtime/enforced.txt
runtime/enforced_bans.jsonl
runtime/ban_queue.json
runtime/evidence/enforced_bans.jsonl
```

`Admin.ini` inapaswa kupokea pekee:

```ini
BannedPlayer=<ID>
```

<a id="what-updates-when-a-player-joins"></a>
## Ni nini husasishwa mchezaji anapojiunga

Masasisho yanayotarajiwa:

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
## Ni nini husasishwa seva inapoacha kufanya kazi au kuwashwa upya

Masasisho yanayotarajiwa:

```text
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/crash_reconnects.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="what-updates-when-the-scan-progresses"></a>
## Ni nini husasishwa wakati utafutaji unaendelea

Masasisho yanayotarajiwa:

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/object_registry_partial.json
runtime/world_state/current/world_state_latest.json
runtime/forensic_days/YYYY-MM-DD/forensic_day_summary.json
```

<a id="what-to-upload-for-quick-analysis"></a>
## Cha kupakia kwa uchanganuzi wa haraka

Kifurushi bora zaidi:

```text
runtime/final_logs/YYYY-MM-DD/
```

Kifurushi kamili zaidi:

```text
runtime/forensic_days/YYYY-MM-DD/
```

Kifurushi kamili cha ushahidi:

```text
runtime/account_evidence.json
runtime/evidence/session_events.jsonl
runtime/server_lifecycle_events.jsonl
runtime/warning_events.jsonl
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

<a id="related-docs"></a>
## Nyaraka zinazohusiana

* [`FORENSIC_DAILY_ROLLUPS.md`](MAJARIBIO_YA_KILA_SIKU_YA_UCHUNGUZI_WA_UCHUNGUZI.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](REJELEO_LA_UTARATIBU_WA_PATO.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](MTIRIRIKO_WA_KAZI_WA_MAONI_YA_MCHEZAJI.md)
