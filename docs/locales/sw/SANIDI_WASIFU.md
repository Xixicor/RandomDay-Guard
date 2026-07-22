<a id="configuration-profiles"></a>
# Wasifu wa usanidi

> **Chanzo cha Kiingereza cha Canonical:** [CONFIG_PROFILES.md](../../CONFIG_PROFILES.md). Hati hizi zilizojanibishwa huhifadhi amri kamili, njia, funguo, thamani za hali, heshi na majina ya faili. Ikiwa maneno ya kiufundi yanatofautiana, tumia chanzo cha Kiingereza.


Tumia mwongozo huu wa jinsi ya kuchagua na kutumia wasifu wa usanidi wa vitendo. Kwa maelezo ya jinsi vikundi vya mipangilio huingiliana, soma [`CONFIG_REFERENCE.md`](SANIDI_REJEA.md). Kwa sehemu kamili, chaguo-msingi, aina na vibadilishi, tumia [`CONFIG_FIELD_CATALOG.md`](CONFIG_SHAMBA_KATALOGI.md).

Kila kizuizi cha Lua hapa chini ni seti ya maingizo ya kiwango cha juu ambayo yanaweza kuchukua nafasi ya maingizo yanayolingana ndani ya iliyosafirishwa `return { ... }`meza.

<a id="profile-chooser"></a>
## Chagua wasifu

| Hali | Tumia wasifu huu |
|---|---|
| Sakinisha kwa mara ya kwanza | Sakinisha salama kwanza |
| Seva si dhabiti na huacha kufanya kazi mara kwa mara | Ushahidi wa sasa bila uchanganuzi polepole |
| Unataka object/world muktadha | Msingi kamili wa msingi |
| Unataka kukagua kumbukumbu za zamani | Mjazo wa uchunguzi wa kitaalamu |
| Unataka mapendekezo lakini hakuna maandishi | Jaribio la utekelezaji |
| Uko tayari kuruhusu mlinzi aandike marufuku | Utekelezaji umewezeshwa |
| Diski ina kikomo | Ukuaji wa chini wa diski |
| Umekamilisha msingi safi | Usanidi wa nakala rudufu |

<a id="safe-first-install"></a>
## Sakinisha salama kwanza

Tumia hii kwanza kwenye seva ya moja kwa moja.

```lua
enforcement = {
    review_only_mode = true,
    auto_ban = false,
    write_admin_ini = false,
},

log_tail = {
    enabled = true,
    start_at_end_on_first_run = true,
    tail_backup_logs = false,
},

scanning = {
    full_scan_on_start = true,
    resume_incomplete_scan = true,
    reuse_completed_baseline = true,
    incremental_refresh_after_baseline = true,
},

reports = {
    enabled = true,
},

notification = {
    enabled = false,
},
```

Hii hufanya nini:

```text
Tracks live sessions.
Starts the baseline scan.
Does not edit Admin.ini.
Avoids treating old backup logs as fresh live events.
```

<a id="current-evidence-without-slow-scan"></a>
## Ushahidi wa sasa bila uchanganuzi polepole

Tumia hii ikiwa seva si dhabiti na unahitaji crash/reconnect ushahidi kabla ya uchanganuzi mzito.

```lua
log_tail = {
    enabled = true,
},

scanning = {
    full_scan_on_start = false,
},

enforcement = {
    review_only_mode = true,
    auto_ban = false,
    write_admin_ini = false,
},

reports = {
    enabled = true,
},

notification = {
    enabled = false,
},
```

Hii hufanya nini:

```text
Tracks logins, joins, leaves, reconnects, crashes, and unclean sessions.
Delays heavy world scanning.
```

<a id="full-baseline"></a>
## Msingi kamili wa msingi

Tumia hii baada ya seva kukaa kwa muda wa kutosha kuchanganua.

```lua
scanning = {
    full_scan_on_start = true,
    resume_incomplete_scan = true,
    reuse_completed_baseline = true,
    incremental_refresh_after_baseline = true,
},
```

Hii hufanya nini:

```text
Builds object registry.
Writes world-state context.
Creates file manifest.
Enables changed-file refresh later.
```

<a id="forensic-backfill"></a>
## Mjazo wa uchunguzi wa kitaalamu

Tumia hii tu unapokagua kumbukumbu za kihistoria kimakusudi.

```lua
log_tail = {
    start_at_end_on_first_run = false,
    tail_backup_logs = true,
    backfill_backup_logs_on_start = true,
},
```

Kabla ya kuitumia:

```text
Back up runtime/log_offsets.tsv.
Expect old events to be reprocessed.
Return to live settings when finished.
```

<a id="enforcement-testing"></a>
## Jaribio la utekelezaji

Tumia hii kabla ya Admin.ini kuandika.

```lua
enforcement = {
    review_only_mode = true,
    auto_ban = false,
    write_admin_ini = false,
},
```

Cha kukagua:

```text
runtime/account_evidence.json
runtime/warnings/
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="enforcement-enabled"></a>
## Utekelezaji umewezeshwa

Tumia hii tu baada ya matokeo ya ukaguzi kuwa sahihi.

```lua
enforcement = {
    review_only_mode = false,
    auto_ban = true,
    write_admin_ini = true,
    require_clean_ban_id = true,
    preserve_existing_bans = true,
    preserve_moderators = true,
},
```

Kabla ya kuwezesha:

```text
Trusted IDs are configured.
Moderator IDs are preserved.
Admin.ini backups work.
Ban recommendations are understandable.
Thresholds are accepted by the server owner.
```

<a id="low-disk-growth"></a>
## Ukuaji wa chini wa diski

Tumia hii wakati faili za wakati wa utekelezaji zinakua haraka sana.

```lua
logging = {
    low_importance_mode = "aggregate",
    write_low_importance_raw_events = false,
},

retention = {
    detailed_retention_days = 7,
    rotate_jsonl_when_bytes_exceed = 5242880,
    max_raw_events_lines = 20000,
    compact_json_outputs = true,
},
```

<a id="sticky-backup-setup"></a>
## Usanidi wa nakala rudufu

Tumia baada ya msingi uliokamilika wa kwanza.

Hakikisha kama hizi zipo:

```text
runtime/scan_complete.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
runtime/world_state/current/world_state_latest.json
```

Kisha zihifadhi nakala kwa `config.lua`, `SavedRoot.txt`, na `Admin.ini`.

<a id="related-docs"></a>
## Nyaraka zinazohusiana

* [`CONFIG_REFERENCE.md`](SANIDI_REJEA.md)
* [`FORENSIC_DAILY_ROLLUPS.md`](MAJARIBIO_YA_KILA_SIKU_YA_UCHUNGUZI_WA_UCHUNGUZI.md)
* [`ADMIN_INI_ENFORCEMENT.md`](UTEKELEZAJI_WA_USIMAMIZI_WA_INI.md)
