<a id="bad-actor-patterns-and-resilience"></a>
# Mala-actor exemplaria et mollitiam

> **Canonicum Anglicum fontem:** [BAD_ACTOR_PATTERNS_AND_RESILIENCE.md](../../BAD_ACTOR_PATTERNS_AND_RESILIENCE.md).  Haec documenta localia mandata exacta, semitas, claves, valores, hashes, nomina fasciculi conservat. Si forma technica differt, fonte Anglico utere.


 Hac pagina utere ut intelligas quomodo custodiae subsidia recensionis ruinae, abusus, mores adiacentes, ac recuperatio consiliorum.

<a id="what-the-guard-can-help-with"></a>
## Quae milites adiuvare possunt cum

| Pattern | Quae reprimendam |
|---|---|
| Crash connectuntur redit | Eadem ratio activa ante fragores et reverti post sileo |
| Reconnect celeri perspiciendi | Repetita join/leave vel timeout/reconnect loramenta |
| Multi-rationes ligaturae | coniunge undas, communes fenestras observans, mutuas fenestras delictas |
| Admonitio rupta accentus | Repetita ActorChannelFailure vel fenestras serva-monentes |
| Out-ex terminis context | PlayerData/map/world contextus cum readable |
| Save-tactus aliudque | World-nisi contextus imbricatis sessionibus praetextatis |
| Identity confusio | Nomina quae in ConnectID mapping |

<a id="why-it-avoids-memory-access"></a>
## Cur memoriam aditum vitat

RandomDayGuard opera e files servo possessore:

```text
Saved/Logs/*.log
Admin.ini
World saves
PlayerData
Backups
runtime evidence
```

Hoc facit ut minus pendeat in clientelae memoriae statu ac minus fragilis per updates ludum.

Tradeoff:

```text
It cannot prove hidden live actions unless the server writes evidence.
```

<a id="crash-correlated-returners"></a>
## Crash connectuntur reversi

Pattern:

```text
Account joins.
Server crashes or restarts.
Same account reconnects quickly.
Pattern repeats.
```

Tabulae utiles:

```text
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/account_evidence.json
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="rapid-reconnect-probers"></a>
## Rapido reconnect probrorum

Pattern:

```text
join -> leave -> join -> leave -> join
```

Tabulae utiles:

```text
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/players.tsv
```

<a id="multi-account-clusters"></a>
## Multi-rationes ligaturae

Pattern:

```text
Several accounts join in the same window.
Warnings or crashes follow.
Some accounts rotate or reconnect after restart.
```

Tabulae utiles:

```text
runtime/raid_cases/
runtime/forensic_days/YYYY-MM-DD/raid_cases.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

Rule:

```text
A cluster is not a mass-ban list.
Each account still needs its own evidence.
```

<a id="sticky-backup-recommendation"></a>
## Sticky tergum commendationis

Hunc tergum post:

```text
first full baseline completes
object_registry.json exists
file_manifest.tsv exists
world_state_latest.json has scan_complete=true
Admin.ini is verified
trusted IDs are configured
```

Tergum sursum:

```text
RandomDayGuard/config.lua
RandomDayGuard/SavedRoot.txt
RandomDayGuard/runtime/baselines/
RandomDayGuard/runtime/object_registry.json
RandomDayGuard/runtime/world_state/current/world_state_latest.json
Saved/SaveGames/Server/Admin.ini
```

<a id="recovery-model"></a>
## Recuperatio exemplar

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
## Related docs

* [`FORENSIC_DAILY_ROLLUPS.md`](FORENSIC_DAILY_ROLLUPS.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](PLAYER_REVIEW_WORKFLOW.md)
* [`WORLD_SAVE_FOLDER_CHANGES.md`](MUNDUS_SERVARE_FOLDER_MUTATIONES.md)
