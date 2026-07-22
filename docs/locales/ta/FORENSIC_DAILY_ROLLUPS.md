<a id="forensic-daily-rollups"></a>
# தடயவியல் தினசரி ரோல்அப்கள்

> **நியாய ஆங்கில மூல:** [FORENSIC_DAILY_ROLLUPS.md](../../FORENSIC_DAILY_ROLLUPS.md). இந்த உள்ளூர்மயமாக்கப்பட்ட ஆவணம் சரியான கட்டளைகள், பாதைகள், விசைகள், நிலை மதிப்புகள், ஹாஷ்கள் மற்றும் கோப்பு பெயர்களைப் பாதுகாக்கிறது. தொழில்நுட்ப வார்த்தைகள் வேறுபட்டால், ஆங்கில மூலத்தைப் பயன்படுத்தவும்.


தினசரி ரோல்அப் என்பது மீண்டும் உருவாக்கக்கூடிய குறியீடாகும். ஆதார ஆதாரம் அதிகாரப்பூர்வமாக உள்ளது; தினசரி கோப்புறை மற்றும் இறுதி பதிவு ஆகியவை இயக்க நேர ஆதாரத்திலிருந்து உருவாக்கப்பட்ட விரைவான மதிப்பாய்வு தொகுப்புகள்.

விரைவான பகுப்பாய்விற்கு ஒரு கோப்புறையைப் பதிவேற்ற விரும்பினால் இந்தப் பக்கத்தைப் பயன்படுத்தவும்.

<a id="what-it-is"></a>
## அது என்ன
தினசரி ரோல்அப் என்பது ஒரு நாளுக்கான மூலச் சான்றுகளின் மறுகட்டமைக்கக்கூடிய சுருக்கமாகும்.

இது மூல ஆதாரத்தை மாற்றாது.

```text
Source evidence = truth
Daily rollup = fast index
Final log = plain-language summary
```

<a id="where-it-writes"></a>
## அது எழுதும் இடம்
தற்போதைய நாள்:

```text
runtime/current/forensic_today.json
runtime/current/forensic_today.md
runtime/current/forensic_today.txt
```

தினசரி தொகுப்பு:

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

தி TXT விரைவான ஆபரேட்டர் மதிப்பாய்வுக்காக எளிய மொழியில் எழுதப்பட்டுள்ளது.

<a id="what-the-final-txt-should-answer"></a>
## இறுதியானது என்ன TXT பதிலளிக்க வேண்டும்
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
## பயன்படுத்தப்பட்ட மூலக் கோப்புகள்
ரோல்அப் இருக்கும்போது இவற்றைப் படிக்க முடியும்:

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

காணாமல் போன கோப்புகள் காணாமல் போனதாகக் குறிக்கப்பட வேண்டும், அபாயகரமானதாகக் கருதக்கூடாது.

<a id="update-behavior"></a>
## நடத்தையைப் புதுப்பிக்கவும்
அதே நாளில், காவலர் அதே கோப்புகளைப் புதுப்பிக்கிறார்.

சரியானது:

```text
runtime/forensic_days/2026-05-13/forensic_day_summary.json
```

தவறு:

```text
forensic_day_summary_1.json
forensic_day_summary_2.json
forensic_day_summary_3.json
```

<a id="crash-safety"></a>
## Crash-safety
பாதுகாவலர் முதலில் தற்காலிக கோப்புகளை எழுத வேண்டும், பின்னர் மறுபெயரிட வேண்டும்:

```text
final_forensic_log.txt.tmp -> final_forensic_log.txt
players.tsv.tmp -> players.tsv
forensic_day_summary.json.tmp -> forensic_day_summary.json
```

எழுதும்போது சேவையகம் செயலிழந்தால், இது கடைசி நல்ல சுருக்கத்தைப் பாதுகாக்கும்.

<a id="playerstsv-columns"></a>
## `players.tsv` நெடுவரிசைகள்
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
## `ban_recommendations.tsv` நெடுவரிசைகள்
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
## விதியை மதிப்பாய்வு செய்யவும்
தினசரி ரோல்அப் விரைவாக மதிப்பாய்வு செய்ய முடியும், ஆனால் அது மட்டுமே ஆதாரமாக இருக்கக்கூடாது.

பரிந்துரை முக்கியமானதாக இருக்கும் போது, ​​இதைச் சரிபார்க்கவும்:

```text
account_evidence.json
session_events.jsonl
server_lifecycle_events.jsonl
warning_events.jsonl
world_state files
enforced_bans.jsonl
```

<a id="related-docs"></a>
## தொடர்புடைய ஆவணங்கள்
* [`MEMORY_ECONOMY_AND_OUTPUTS.md`](%E0%AE%A8%E0%AE%BF%E0%AE%A9%E0%AF%88%E0%AE%B5%E0%AE%95%E0%AE%AA%E0%AF%8D_%E0%AE%AA%E0%AF%8A%E0%AE%B0%E0%AF%81%E0%AE%B3%E0%AE%BE%E0%AE%A4%E0%AE%BE%E0%AE%B0%E0%AE%AE%E0%AF%8D_%E0%AE%AE%E0%AE%B1%E0%AF%8D%E0%AE%B1%E0%AF%81%E0%AE%AE%E0%AF%8D_%E0%AE%B5%E0%AF%86%E0%AE%B3%E0%AE%BF%E0%AE%AF%E0%AF%80%E0%AE%9F%E0%AF%81%E0%AE%95%E0%AE%B3%E0%AF%8D.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](%E0%AE%AA%E0%AE%BF%E0%AE%B3%E0%AF%87%E0%AE%AF%E0%AE%B0%E0%AF%8D_%E0%AE%AE%E0%AE%A4%E0%AE%BF%E0%AE%AA%E0%AF%8D%E0%AE%AA%E0%AE%BE%E0%AE%AF%E0%AF%8D%E0%AE%B5%E0%AF%81_%E0%AE%AA%E0%AE%A3%E0%AE%BF%E0%AE%AA%E0%AF%8D%E0%AE%AA%E0%AE%BE%E0%AE%AF%E0%AF%8D%E0%AE%B5%E0%AF%81.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](%E0%AE%B5%E0%AF%86%E0%AE%B3%E0%AE%BF%E0%AE%AF%E0%AF%80%E0%AE%9F%E0%AF%8D%E0%AE%9F%E0%AF%81_%E0%AE%A4%E0%AE%BF%E0%AE%9F%E0%AF%8D%E0%AE%9F_%E0%AE%95%E0%AF%81%E0%AE%B1%E0%AE%BF%E0%AE%AA%E0%AF%8D%E0%AE%AA%E0%AF%81.md)
