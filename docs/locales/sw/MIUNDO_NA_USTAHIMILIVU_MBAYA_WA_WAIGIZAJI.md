<a id="bad-actor-patterns-and-resilience"></a>
# Mifumo na ustahimilivu mbaya wa waigizaji

> **Chanzo cha Kiingereza cha Canonical:** [BAD_ACTOR_PATTERNS_AND_RESILIENCE.md](../../BAD_ACTOR_PATTERNS_AND_RESILIENCE.md). Hati hizi zilizojanibishwa huhifadhi amri kamili, njia, funguo, thamani za hali, heshi na majina ya faili. Ikiwa maneno ya kiufundi yanatofautiana, tumia chanzo cha Kiingereza.


Tumia ukurasa huu kuelewa jinsi mlinzi anavyosaidia kukagua matumizi mabaya ya ajali, tabia ya unyonyaji na upangaji wa uokoaji.

<a id="what-the-guard-can-help-with"></a>
## Kile ambacho mlinzi anaweza kusaidia

| Muundo | Cha kuangalia |
|---|---|
| Rejesha zinazohusiana na kuacha kufanya kazi | Akaunti sawa hutumika kabla ya kuacha kufanya kazi na kurudi baada ya kuwasha upya |
| Uchunguzi wa kuunganisha upya kwa haraka | Imerudiwa join/leave au timeout/reconnect vitanzi |
| Makundi ya akaunti nyingi | Jiunge na mawimbi, madirisha ya onyo yaliyoshirikiwa, madirisha ya kutofaulu yaliyoshirikiwa |
| Mkazo mkali wa onyo | Imerudiwa ActorChannelFailure au madirisha ya maonyo ya hifadhi |
| Muktadha wa nje ya mipaka | PlayerData/map/world muktadha unaposomeka |
| Hifadhi-mguso mwingiliano | Muktadha wa hifadhi ya dunia unaopishana vipindi vya ramani |
| Mkanganyiko wa utambulisho | Majina yanayohitaji ramani ya ConnectID |

<a id="why-it-avoids-memory-access"></a>
## Kwa nini inaepuka ufikiaji wa kumbukumbu

RandomDayGuard hufanya kazi kutoka kwa faili zinazomilikiwa na seva:

```text
Saved/Logs/*.log
Admin.ini
World saves
PlayerData
Backups
runtime evidence
```

Hiyo inaifanya isitegemee sana hali ya kumbukumbu ya upande wa mteja na kuwa dhaifu katika masasisho ya mchezo.

Biashara:

```text
It cannot prove hidden live actions unless the server writes evidence.
```

<a id="crash-correlated-returners"></a>
## Virudishaji vinavyohusiana na kuacha kufanya kazi

Muundo:

```text
Account joins.
Server crashes or restarts.
Same account reconnects quickly.
Pattern repeats.
```

Faili muhimu:

```text
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/account_evidence.json
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="rapid-reconnect-probers"></a>
## Wachunguzi wa kuunganisha upya kwa haraka

Muundo:

```text
join -> leave -> join -> leave -> join
```

Faili muhimu:

```text
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/players.tsv
```

<a id="multi-account-clusters"></a>
## Makundi ya akaunti nyingi

Muundo:

```text
Several accounts join in the same window.
Warnings or crashes follow.
Some accounts rotate or reconnect after restart.
```

Faili muhimu:

```text
runtime/raid_cases/
runtime/forensic_days/YYYY-MM-DD/raid_cases.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

Sheria:

```text
A cluster is not a mass-ban list.
Each account still needs its own evidence.
```

<a id="sticky-backup-recommendation"></a>
## Pendekezo la kuhifadhi nakala nata

Unda nakala nata baada ya:

```text
first full baseline completes
object_registry.json exists
file_manifest.tsv exists
world_state_latest.json has scan_complete=true
Admin.ini is verified
trusted IDs are configured
```

Hifadhi nakala:

```text
RandomDayGuard/config.lua
RandomDayGuard/SavedRoot.txt
RandomDayGuard/runtime/baselines/
RandomDayGuard/runtime/object_registry.json
RandomDayGuard/runtime/world_state/current/world_state_latest.json
Saved/SaveGames/Server/Admin.ini
```

<a id="recovery-model"></a>
## Muundo wa uokoaji

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
## Nyaraka zinazohusiana

* [`FORENSIC_DAILY_ROLLUPS.md`](MAJARIBIO_YA_KILA_SIKU_YA_UCHUNGUZI_WA_UCHUNGUZI.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](MTIRIRIKO_WA_KAZI_WA_MAONI_YA_MCHEZAJI.md)
* [`WORLD_SAVE_FOLDER_CHANGES.md`](MABADILIKO_YA_FOLDA_YA_HIFADHI_DUNIANI.md)
