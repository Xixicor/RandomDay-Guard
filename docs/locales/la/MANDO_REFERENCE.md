<a id="configuration-concepts"></a>
# Configurationis notiones

> **Canonicum Anglicum fontem:** [CONFIG_REFERENCE.md](../../CONFIG_REFERENCE.md).  Haec documenta localia mandata exacta, semitas, claves, valores, hashes, nomina fasciculi conservat. Si forma technica differt, fonte Anglico utere.


 Haec explicatio describitur quid quaeque regio majoris configurationis moderetur, quando currat, et quomodo testimoniis ac tuto portis occurrat. Non proprium agri catalogum vel profile rationes.

Pro ordinatis presetibus et tuta mutatione gradus, utere [`CONFIG_PROFILES.md`](MANDO_PROFILES.md). Pro omni fonte exacto ager, defectus, typus, immutatus, outputus effectus, regulae receptae, generato [`CONFIG_FIELD_CATALOG.md`](CONFIG_FIELD_CATALOGUE.md) utuntur; validator unum ordinem requirit pro singulis uit `config.lua` folium campum.

<a id="reading-this-page"></a>
## Lege hanc paginam

Singula responsa area config:

```text
What it controls
When it runs
What to check
What can go wrong
```

<a id="top-level-safety"></a>
## Top-level salus

| Option | Default | Means |
|---|---:|---|
| `enabled` | `true` | Magister switch ad custodiam |
| `enforcement.review_only_mode` | `true` | Record/recommend tantum |
| `enforcement.auto_ban` | `false` | Noli sponte prohibeas defaltam |
| `enforcement.write_admin_ini` | `false` | Noli scribere Admin.ini defalta |

Hos salvos serva donec dominus servo output recensuit.

<a id="saved"></a>
## `saved`

Imperium quomodo custodiens invenit in servo `Saved/` folder et quae lima familias lustrare potest.

Utere cum:

```text
Saved root auto-detection fails.
World folder changed.
Provider or container path is unusual.
```

Reprehendo:

```text
runtime/saved_path_probe.json
RandomDayGuard/SavedRoot.txt
```

Rule:

```text
SavedRoot.txt -> AbioticFactor/Saved
not -> Worlds/<WorldName>
```

<a id="log_tail"></a>
## `log_tail`

Imperium lege log vivas.

Optiones utiles:

| Option | Valorem Tutum | Quare |
|---|---|---|
| `enabled` | `true` | Responsionis necessariae ad vivam defensionem |
| `start_at_end_on_first_run` | `true` | Tigna vetera vitat dum eventa vivant |
| `tail_backup_logs` | `false` | Tabulae historicae sunt, non vivae |
| `max_lines_per_poll` | bound | Poll loop responsivum custodit |

Reprehendo:

```text
runtime/log_offsets.tsv
runtime/evidence/session_events.jsonl
runtime/current/poll_status.json
```

<a id="runtime"></a>
## `runtime`

Imperium datorum ac rationes.

salutem regulae principale:

```text
poll_id increases
poll_in_flight returns false
poll_scheduled is true
```

Reprehendo:

```text
runtime/current/poll_status.json
```

Si `poll_id` sistit aliquid ansam impedit.

<a id="source_accounting"></a>
## `source_accounting`

Imperia evidentia-fonte coverage et scop.

| Key | Default | Means |
|---|---:|---|
| `enabled` | `true` | Scribit fontem rationem itineris publici tradit. |
| `require_terminal_status` | `true` | Uterque fontem requirit ut statum explicite vel imperfecte patefaciat. |
| `distinguish_current_from_historical` | `true` | Hentica et historica testimonia separatim custodit. |
| `slow_world_scan_blocks_current_reports` | `false` | Permittit hodiernas relationes ad statum mundi terminatum intuens differri vel partialem. |
| `changed_file_manifest` | baseline manifestam viam | Referentia ad usum terminatum historical/world ratione. |

Source civitates sunt `available`, `expected_empty`, `partial`, `deferred`, `unavailable`, `malformed`, `permission_denied`, vel `error`.

Ponere`source_accounting.enabled = false` tacite statum output non tollit. Pipeline adhuc scribit `runtime/final_logs/source_accounting_latest.json`cum `enabled=false`, `status="unavailable"`, et `disabled_reason="source_accounting_disabled"`. Etiam historico-statum recordum cum ratione perpendente scribit. Quia fons rationis est pars relationis contractus, omnis via ad `missing`; nulla via tractatur ut peracta computatione debilis.

<a id="reports"></a>
## `reports`

Imperium generalem localem renuntiationem pipeline.

Defaultis da omnes quinque vias et scribe sub `runtime/final_logs`:

```text
server_status
daily_rollup
player_activity
case_review
critical_guard
```

Via quaeque scribere debet structa et translata output plus probationis in `route_proof.json`. Iter inactivare producit `missing` probationem potius quam simulans peractam.

<a id="notification"></a>
## `notification`

Libitum genericum loci fasciculi outbox. Is defalta debilitatur et nihil ad provisorem externum mittit.

Defaultis:

```lua
notification = {
    enabled = false,
    mode = "local_file_outbox",
    include_expected_empty = false,
},
```

Omnis iter notificatio defalta debilitatur. Cum consulto datum est, cursorium emissarium tantum relationem translatam post `route_proof.json` scriptum est. Loci testimonia et relationes auctoritates manent. Provisor Utilia traditio, terminos partus, documentorum, et pontes non sunt pars contractus publici sui iuris speculator.

<a id="scanning"></a>
## `scanning`

Imperium baseline scan, reprimendi, et mutata fasciculi recrea.

Utere cum:

```text
building first world baseline
resuming after crash
refreshing changed files later
```

Reprehendo:

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/scan_complete.json
runtime/baselines/file_manifest.tsv
```

Maximae occasus:

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

 Imperat velox sarcinas cotidianas fasciculos et ultimam plani linguae tigna.

Outputs:

```text
runtime/current/forensic_today.json
runtime/current/forensic_today.md
runtime/current/forensic_today.txt
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

Utere cum:

```text
You want one daily folder that summarizes what happened.
You want a plain-language TXT to upload for quick analysis.
```

Reprehendo:

```text
runtime/forensic_days/YYYY-MM-DD/forensic_day_summary.json
runtime/forensic_days/YYYY-MM-DD/players.tsv
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

Rule:

```text
Daily summaries are rebuildable indexes.
Source evidence remains authoritative.
```

<a id="logging"></a>
## `logging`

Imperium eventus volubilis et humilis-momenti aggregatio.

Utere cum:

```text
actor-touch events are noisy
raw event files grow too quickly
```

Secretum exemplar:

```lua
logging = {
    low_importance_mode = "aggregate",
    write_low_importance_raw_events = false,
},
```

<a id="retention"></a>
## `retention`

Imperium quo tempore tabulae servantur et quando JSONL acta rotata.

Utere cum:

```text
disk usage grows too fast
you need more audit history
you need shorter live-history windows
```

Optiones Maximus:

```text
detailed_retention_days
rotate_jsonl_when_bytes_exceed
max_raw_events_lines
keep_enforced_forever
keep_evidence_forever
```

<a id="warning_bursts"></a>
## `warning_bursts`

Imperium in fenestra deprehendendi.

Exempla:

```text
ActorChannelFailure
DeployableSaveWarning
UpdateActorToWorldSave
ServerMove warnings
```

Rule:

```text
Warnings are context until correlated with mapped sessions and thresholds.
```

<a id="crash_correlation"></a>
## `crash_correlation`

Imperium repetitum crash/reconnectrecensio.

defaltis tutus:

```lua
crash_correlation = {
    single_crash_never_bans = true,
    require_same_account = true,
},
```

Usus calculis:

```text
server_crash_overlap_count
post_crash_reconnect_count
unclean_disconnect_count
```

<a id="join_leave"></a>
## `join_leave`

Imperium contorquent et sequi undam iungunt.

Secretum defaltam:

```lua
join_leave = {
    churn_alone_never_bans = true,
},
```

Usus pro:

```text
rapid reconnect loops
join waves
short-session patterns
```

<a id="raid_detection"></a>
## `raid_detection`

Sodalitates rationes activae in actis fenestras habent.

Rule:

```text
A raid case groups accounts for review.
It does not make every account guilty.
```

Singula ratio postulata adhuc argumentis certis indiciis eget.

<a id="object_registry"></a>
## `object_registry`

Imperiumobject/classextractionem e documentis readable servatis.

Outputs:

```text
runtime/object_registry_partial.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
```

Rule:

```text
Object/class context is not a ban reason by itself.
```

<a id="world_state"></a>
## `world_state`

Imperiumboot/current/sessionstatu rerum snapshots.

Outputs:

```text
runtime/world_state/current/world_state_latest.json
runtime/world_state/sessions/<date>/<session_id>_<account_id>/
```

Usus ad recognitionem sessionis et contextus mundi.

<a id="enforcement"></a>
## `enforcement`

Imperia commendationes et actuales Admin.iniscribit.

Coram bannum addere potest, quaelibet infra enuntiatio vera esse debet:

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

Si una oratio falsa sit vel cohiberi non possit, custodi folia`Admin.ini` immutata ac notat rationem.

<a id="admin_ini"></a>
## `admin_ini`

Imperium tutum tabella scribit.

Regulae:

```text
Back up before writing.
Preserve existing bans.
Preserve moderators.
Write clean BannedPlayer=<ID> only.
```

<a id="restart_request"></a>
## `restart_request`

Imperium ad libitum loci titulum imagini ut alius operator-possessores inspiciat. Non sileo vel servo occido.

Defaultis:

```lua
restart_request = {
    enabled = false,
    restart_marker_file = "runtime/request_restart.flag",
    restart_reason_file = "runtime/restart_reason.json",
},
```

Outputs:

```text
runtime/request_restart.flag
runtime/restart_reason.json
```

Nulla tabula obnoxia, provisor pontis aut sileo automatio fasciculata est. Creatio titulum praebens non probat externum processum petitionem consumpsit vel restarted in calculonis servi.

<a id="related-docs"></a>
## Related docs

* [`CONFIG_PROFILES.md`](MANDO_PROFILES.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](OUTPUT_SCHEMA_REFERENCE.md)
* [`ADMIN_INI_ENFORCEMENT.md`](ADMIN_INI_EFFECTUS.md)
