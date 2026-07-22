<a id="configuration-concepts"></a>
# Dhana za usanidi

> **Chanzo cha Kiingereza cha Canonical:** [CONFIG_REFERENCE.md](../../CONFIG_REFERENCE.md). Hati hizi zilizojanibishwa huhifadhi amri kamili, njia, funguo, thamani za hali, heshi na majina ya faili. Ikiwa maneno ya kiufundi yanatofautiana, tumia chanzo cha Kiingereza.


Ufafanuzi huu unafafanua kile ambacho kila eneo kuu la usanidi hudhibiti, linapotekelezwa, na jinsi linavyoingiliana na ushahidi na milango ya usalama. Haimiliki katalogi halisi ya sehemu au taratibu za wasifu.

iliyoundwa kwa uwekaji mapema unaolenga kazi na hatua za mabadiliko salama, tumia [`CONFIG_PROFILES.md`](SANIDI_WASIFU.md). Kwa kila sehemu halisi ya chanzo, chaguo-msingi, aina, kigeugeu, madoido, na kanuni ya urejeshaji, tumia [`CONFIG_FIELD_CATALOG.md`](CONFIG_SHAMBA_KATALOGI.md)iliyoundwa; kihalalishaji kinahitaji safu mlalo moja hapo kwa kila kusafirishwa `config.lua` uga wa majani.

<a id="reading-this-page"></a>
## Kusoma ukurasa huu

Kila eneo la usanidi hujibu:

```text
What it controls
When it runs
What to check
What can go wrong
```

<a id="top-level-safety"></a>
## Usalama wa kiwango cha juu

| Chaguo | Chaguo-msingi | Maana |
|---|---:|---|
| `enabled` | `true` | Badili kuu ya mlinzi |
| `enforcement.review_only_mode` | `true` | Record/recommend pekee |
| `enforcement.auto_ban` | `false` | Usipige marufuku kiotomatiki kwa chaguo-msingi |
| `enforcement.write_admin_ini` | `false` | Usiandike Admin.ini kwa chaguo-msingi |

Hifadhi hizi salama hadi mmiliki wa seva ahakikishe matokeo.

<a id="saved"></a>
## `saved`

Hudhibiti jinsi mlinzi anavyopata seva `Saved/` folda na ni familia gani za faili inaweza kuchanganua.

Tumia wakati:

```text
Saved root auto-detection fails.
World folder changed.
Provider or container path is unusual.
```

Angalia:

```text
runtime/saved_path_probe.json
RandomDayGuard/SavedRoot.txt
```

Sheria:

```text
SavedRoot.txt -> AbioticFactor/Saved
not -> Worlds/<WorldName>
```

<a id="log_tail"></a>
## `log_tail`

Hudhibiti usomaji wa kumbukumbu wa moja kwa moja.

Chaguo muhimu:

| Chaguo | Thamani salama | Kwa nini |
|---|---|---|
| `enabled` | `true` | Inahitajika kwa ulinzi wa moja kwa moja |
| `start_at_end_on_first_run` | `true` | Huepuka kumbukumbu za zamani kama matukio ya moja kwa moja |
| `tail_backup_logs` | `false` | Kumbukumbu za chelezo ni historia, sio moja kwa moja |
| `max_lines_per_poll` | iliyofungwa | Huweka kitanzi cha kura kuitikia |

Angalia:

```text
runtime/log_offsets.tsv
runtime/evidence/session_events.jsonl
runtime/current/poll_status.json
```

<a id="runtime"></a>
## `runtime`

Hudhibiti upigaji kura na bajeti.

Sheria kuu ya afya:

```text
poll_id increases
poll_in_flight returns false
poll_scheduled is true
```

Angalia:

```text
runtime/current/poll_status.json
```

Kama `poll_id` inasimama, kuna kitu kinazuia kitanzi.

<a id="source_accounting"></a>
## `source_accounting`

Hudhibiti ufikiaji na upeo wa chanzo-chanzo cha ushahidi.

| Ufunguo | Chaguo-msingi | Maana |
|---|---:|---|
| `enabled` | `true` | Huandika uhasibu wa chanzo kwa ripoti za njia za umma. |
| `require_terminal_status` | `true` | Inahitaji kila chanzo kufichua terminal au hali isiyokamilika. |
| `distinguish_current_from_historical` | `true` | Hutenganisha ushahidi wa sasa na wa kihistoria. |
| `slow_world_scan_blocks_current_reports` | `false` | Huruhusu ripoti za sasa kueleza kuwa utambazaji wenye mipaka wa ulimwengu umeahirishwa au haujakamilika. |
| `changed_file_manifest` | njia ya maelezo ya msingi | Rejeleo linalotumika kwa mipaka historical/world uhasibu. |

Hali za vyanzo ni `available`, `expected_empty`, `partial`, `deferred`, `unavailable`, `malformed`, `permission_denied`, au `error`.

Mipangilio `source_accounting.enabled = false` haiondoi pato la hali kimyakimya. Bomba bado linaandika `runtime/final_logs/source_accounting_latest.json` na `enabled=false`, `status="unavailable"`, na `disabled_reason="source_accounting_disabled"`. Pia huandika rekodi ya hali ya kihistoria na uhasibu ambao haupatikani. Kwa sababu uhasibu wa chanzo ni sehemu ya mkataba wa ripoti, kila njia hufungwa kwa `missing`; hakuna njia inayochukuliwa kuwa imekamilika huku uhasibu umezimwa.

<a id="reports"></a>
## `reports`

Hudhibiti bomba la jumla la kuripoti eneo lako.

Chaguo-msingi huwasha njia zote tano na uandike chini ya `runtime/final_logs`:

```text
server_status
daily_rollup
player_activity
case_review
critical_guard
```

Kila njia lazima iandike pato lililoundwa na kutafsiriwa pamoja na uthibitisho katika `route_proof.json`. Kuzima njia hutoa `missing` uthibitisho badala ya kusingizia kuwa imekamilika.

<a id="notification"></a>
## `notification`

Kikasha toezi cha hiari cha faili ya ndani. Imezimwa kwa chaguomsingi na haitumii chochote kwa mtoa huduma wa nje.

Chaguo-msingi:

```lua
notification = {
    enabled = false,
    mode = "local_file_outbox",
    include_expected_empty = false,
},
```

Kila njia ya arifa imezimwa kwa chaguomsingi. Inapowashwa kimakusudi, kisanduku toezi kinaweza kutumia tu ripoti iliyokamilika iliyotafsiriwa baada ya `route_proof.json` imeandikwa. Ushahidi wa ndani na ripoti zinasalia kuwa na mamlaka. Uwasilishaji mahususi kwa mtoa huduma, vidokezo vya uwasilishaji, vitambulisho na madaraja si sehemu ya mkataba wa shirika huru la umma.

<a id="scanning"></a>
## `scanning`

Hudhibiti uchanganuzi wa msingi, uangalizi, na kuonyesha upya faili iliyobadilishwa.

Tumia wakati:

```text
building first world baseline
resuming after crash
refreshing changed files later
```

Angalia:

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/scan_complete.json
runtime/baselines/file_manifest.tsv
```

Mipangilio muhimu:

```lua
scanning = {
    resume_incomplete_scan = true,
    reuse_completed_baseline = true,
    incremental_refresh_after_baseline = true,
    changed_file_detection = true,
},
```

<a id="forensic_rollup"></a>
## `forensic_rollup`

Hudhibiti kifurushi cha haraka cha upakiaji wa kila siku na kumbukumbu za mwisho za lugha rahisi.

Matokeo:

```text
runtime/current/forensic_today.json
runtime/current/forensic_today.md
runtime/current/forensic_today.txt
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

Tumia wakati:

```text
You want one daily folder that summarizes what happened.
You want a plain-language TXT to upload for quick analysis.
```

Angalia:

```text
runtime/forensic_days/YYYY-MM-DD/forensic_day_summary.json
runtime/forensic_days/YYYY-MM-DD/players.tsv
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

Sheria:

```text
Daily summaries are rebuildable indexes.
Source evidence remains authoritative.
```

<a id="logging"></a>
## `logging`

Hudhibiti sauti ya tukio na ujumlisho wa umuhimu wa chini.

Tumia wakati:

```text
actor-touch events are noisy
raw event files grow too quickly
```

Muundo salama:

```lua
logging = {
    low_importance_mode = "aggregate",
    write_low_importance_raw_events = false,
},
```

<a id="retention"></a>
## `retention`

Hudhibiti muda wa faili kuwekwa na wakati JSONL kumbukumbu huzunguka.

Tumia wakati:

```text
disk usage grows too fast
you need more audit history
you need shorter live-history windows
```

Chaguo muhimu:

```text
detailed_retention_days
rotate_jsonl_when_bytes_exceed
max_raw_events_lines
keep_enforced_forever
keep_evidence_forever
```

<a id="warning_bursts"></a>
## `warning_bursts`

Hudhibiti ugunduzi wa dirisha la onyo.

Mifano:

```text
ActorChannelFailure
DeployableSaveWarning
UpdateActorToWorldSave
ServerMove warnings
```

Sheria:

```text
Warnings are context until correlated with mapped sessions and thresholds.
```

<a id="crash_correlation"></a>
## `crash_correlation`

Vidhibiti vimerudiwa crash/reconnect kagua.

Chaguo-msingi salama:

```lua
crash_correlation = {
    single_crash_never_bans = true,
    require_same_account = true,
},
```

Vihesabu muhimu:

```text
server_crash_overlap_count
post_crash_reconnect_count
unclean_disconnect_count
```

<a id="join_leave"></a>
## `join_leave`

Inadhibiti kuzunguka na kufuatilia kwa mawimbi.

Chaguo-msingi salama:

```lua
join_leave = {
    churn_alone_never_bans = true,
},
```

Tumia kwa:

```text
rapid reconnect loops
join waves
short-session patterns
```

<a id="raid_detection"></a>
## `raid_detection`

Akaunti za vikundi zinazotumika katika madirisha yanayohusiana.

Sheria:

```text
A raid case groups accounts for review.
It does not make every account guilty.
```

Kila akaunti inayotekelezwa bado inahitaji ushahidi mahususi wa akaunti.

<a id="object_registry"></a>
## `object_registry`

Vidhibiti object/classutoaji wa tokeni kutoka kwa ushahidi unaosomeka uliohifadhiwa.

Matokeo:

```text
runtime/object_registry_partial.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
```

Sheria:

```text
Object/class context is not a ban reason by itself.
```

<a id="world_state"></a>
## `world_state`

Vidhibiti boot/current/session vijipicha vya hali ya dunia.

Matokeo:

```text
runtime/world_state/current/world_state_latest.json
runtime/world_state/sessions/<date>/<session_id>_<account_id>/
```

Tumia kwa ukaguzi wa kipindi na muktadha wa ulimwengu.

<a id="enforcement"></a>
## `enforcement`

Hudhibiti mapendekezo na halisiAdmin.ini anaandika.

Kabla ya Walinzi hawajaongeza marufuku, kila taarifa iliyo hapa chini lazima iwe kweli:

```text
review_only_mode == false
auto_ban == true
write_admin_ini == true
ban_id is clean numeric
account identity is mapped
not trusted
not moderator
threshold is met
```

Kama taarifa moja ni ya uwongo au haiwezi kukaguliwa, Walinzi huondoka `Admin.ini` haijabadilishwa na hurekodi sababu.

<a id="admin_ini"></a>
## `admin_ini`

Hudhibiti uandishi wa faili salama.

Sheria:

```text
Back up before writing.
Preserve existing bans.
Preserve moderators.
Write clean BannedPlayer=<ID> only.
```

<a id="restart_request"></a>
## `restart_request`

Hudhibiti faili za hiari za alama za ndani ambazo mchakato mwingine unaomilikiwa na opereta unaweza kukagua. Haiwanzishi tena au kuua seva.

Chaguo-msingi:

```lua
restart_request = {
    enabled = false,
    restart_marker_file = "runtime/request_restart.flag",
    restart_reason_file = "runtime/restart_reason.json",
},
```

Matokeo:

```text
runtime/request_restart.flag
runtime/restart_reason.json
```

Hakuna kidirisha cha kupangisha, daraja la mtoa huduma, au uanzishaji upya wa kiotomatiki umeunganishwa. Kuwasha uundaji alama hakuthibitishi kuwa mchakato wa nje ulitumia ombi au kuanzisha upya seva.

<a id="related-docs"></a>
## Nyaraka zinazohusiana

* [`CONFIG_PROFILES.md`](SANIDI_WASIFU.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](REJELEO_LA_UTARATIBU_WA_PATO.md)
* [`ADMIN_INI_ENFORCEMENT.md`](UTEKELEZAJI_WA_USIMAMIZI_WA_INI.md)
