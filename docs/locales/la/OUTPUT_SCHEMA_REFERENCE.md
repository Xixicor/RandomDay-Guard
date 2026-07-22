<a id="output-and-state-schema-reference"></a>
# Output et schema relatum

> **Canonicum Anglicum fontem:** [OUTPUT_SCHEMA_REFERENCE.md](../../OUTPUT_SCHEMA_REFERENCE.md).  Haec documenta localia mandata exacta, semitas, claves, valores, hashes, nomina fasciculi conservat. Si forma technica differt, fonte Anglico utere.


Hic est contractus canonicum pro generatis operatorium adversus fasciculos. Ea sola habet semitas, nomina campus, valores, genus requisita, schemas itineris permissus habet. Duces procedendi hic coniunge pro illis factis redefining.

Runtime testimonium auctoritatis est; filename, pulsatio pulsatio, relatio translata, vel objectum outbox localis non magis probat quam suos agros et genus.

<a id="public-report-routes"></a>
## Publicae famae itinera

Ratio operariorum quinque itinera sub `runtime/final_logs/`:

| Route | Contract | `full` postulationem | Expectata inanis significatio |
|---|---|---|---|
| `server_status` | Schedularum, activum, stipes, scan-pendentia, fons coverage status. | Currentboot/epoch/pollgenus, truncus recens activus, accounting/historyscribit, ac JSON/TXT par. | Non adhibetur pro cyclo sano aliter; absentis prosapia est `missing`. |
| `daily_rollup` | Currentday/window continuatio per servo, lusorum, casuum, scan, et coverage. | Res historicae terminatio satis itineris et probatio-cycli plenae. | Nihil retinuit histriones nec casus recensiti. |
| `player_activity` | Separate vena et historica player/account observationes. | Current-cycli probationem plus vel uno vel pluribus current/historical ordines. | Nullus eligibile ludio ludius ordines in inputibus terminatis; nulla re synthetica. |
| `case_review` | nominatus retinuit causas et venas review/BAN-ELIGIBLE candidati. | Cursus-cyclus probatio plus uno vel pluribus nomine casuum fontium indicio est. | Nulla nominatus casus recensionis criteria occurrit; sine synthetica causa. |
| `critical_guard` | Current-coxarii, satus, capita, seu indicia integritatis defectum. | Cursus-cyclus probatio plus currenti discrimine deficiendi. | Nulla critica incidit; errores veteris textus non habent hanc viam. |

Omnis itineris enabled scribens `<route>_latest.json` et `<route>_latest.txt`. Par non perficitur donec `runtime/final_logs/route_proof.json` eiusdem versionis, caligae, epochae, capitum et fontium viriditatem memorat.

<a id="report-json-schema"></a>
## Report JSON schema

Omnes itinerisJSON utitur `schema="randomdayguard.report/v1"`.

| Field | Type | Significatio et immutabilis |
|---|---|---|
| `schema` | string | Prorsus `randomdayguard.report/v1`. |
| `generated_ts`, `report_date` | string | Generatio indicationis ac relatio temporis. |
| `version` | string | Runtime/packageidentitatis huius cycli. |
| `boot_id`, `epoch_id` | string | Processus currentis tabernus ac servo continuum epocham. Utrumque ad completionem requiritur. |
| `poll_id` | integrus | Potificatus current poll identifier. Zero/missing iter perficere non potest. |
| `source_freshness` | obiec | `status`, `checked_ts`, status activus-logus, index indicis novissimi, et demum capita notationis peractae. |
| `current_cycle_proof_complete` | boolean | Verum solum cum prosapia et recens active-log/current-poll indicio adsentior. |
| `route` | enum | Una ex quinque partibus supra. |
| `route_proof_status` | enum | `full`, `limited_expected_empty`, vel `missing`. |
| `coverage_status` | enum | Prorsus `complete`, `complete_with_gaps`, `partial`, vel `unavailable`. |
| `completed`, `expected_empty` | boolean | `completed` tantum falsum est pro `missing`; `expected_empty` tantum verum est pro `limited_expected_empty`. |
| `observed` |  chordarum ordinata | Concretum retinuit facts/counts/statuses. |
| `interpretation` |  chordarum ordinata | Cutius sensus calibratus est pro testimonio. |
| `unknown` |  chordarum ordinata | Absentis identitatis, historiae, fontis, contextus. |
| `does_not_prove` |  chordarum ordinata | Conclusiones probationes sustinere non possunt. |
| `next_action` | string | tutissima actio operantis terminata. |
| `source_references` |  chordarum ordinata | Sorted unique runtime/Saved p. |
| `enforcement_authority` | boolean | Semper falsus. Renuntiatio numquam permittit scribere. |
| `output_paths` | duo chordarum | JSON et TXT gressus scribit ante binas additas. |

`coverage_status` solum est summa ratio. Source records seorsum habere `available`, `expected_empty`, `partial`, `deferred`, `unavailable`, `malformed`, `permission_denied`, et `error`. Route probationem separatim possidet `full`, `limited_expected_empty`, et `missing`; values ​​​​numquam hos fines transire.

Protensiones itineris:

- `server_status`: `scheduler_status`, `active_log_status`, et `server_metrics`. Metri notant venam epocham initium, novissimam peractam capita indicationem et ID, activum lusorem, active/backup-logcomites, scanpending/progress valores et configured/usable/unavailable source-group rations. Non fingunt uptime, sileo comites, tergum indicationes, vel euasionem durationis cum nulla earum rerum fons patefacit.
- `player_activity`: `player_activity_present`, `movement`, `same_day_sessions`, `current_player_count`, `current_evidence_player_count`, `historical_player_count`, `historical_session_count`, `current_players`, `historical_players` et convenientiae ordinata`players`. Quaelibet eadem dies sessio sessionem suam ID servat, ob ID, nomen ostentationis notum, join/leave indicationes, mundi exitus et vexilla vivendi, et fons indiciorum. Retinuit identitatem et PlayerData praesentia contextus manent, non hodie probatio actionis.
- `case_review`: `cases`, `review_subjects`, `current_case_count`, et `retained_case_count`. Recensio currentis argumenti meminit eius case/accountID, nomen ostentationis notae, status, score, identitatis fiducia, first/last observationes, monita comitum, rationes, vexillum viva, et fons indiciorum. Retentae casus non efficiunt subiectum currentem per se.
- `critical_guard`: `critical_failure_present` et `current_boot_error_only=true`.
- `daily_rollup`: `daily_maturity`, `once_per_day_continuity`, `dedupe_window`, et `daily_metrics`. Metri notant diem relationis, scaenicorum activorum, rationum cum eiusdem diei actuositate, iunctis, foliis, mundis et immundis exitibus, reditibus liferiarum, argumentis recensionis monetae nominatis, casibus retentis, current/retainedidentitatis comites et fons-group coverage.

<a id="translated-txt-schema"></a>
## Translata TXT schema

Tabula bina cum elaboratore-readabili eventu ducit et singularia generis ad finem movet. Hanc sectionem accuratam conservat ordo:

```text
RandomDayGuard <route title>
Generated: <timestamp>

Summary
<one plain-language route summary>

What Guard observed
- ...

What it means
- ...

What remains unknown
- ...

Recommended next step
...

Evidence boundary
- ...

Rating explanation
- ...

Technical record
- Route: <route>
- Version: <version>
- Cycle: boot=<boot> epoch=<epoch> poll=<poll>
- Source freshness: <status>
- Route result: <full|limited_expected_empty|missing>
- Coverage: <status>

Translation notes
- ...

Source references
- ...
```

Translation utitur solum structuris relationibus agrorum et dictionarii mappings approbatarum. Scaenicorum, casuum, traditionis, causationis, possessionis, intentionis, vel eligibilitatem a relatione exstructa absentem, histriones addere non potest. Singulae technicae in promptu manent, quin divellens exitum facilem.

<a id="source-accounting-schema"></a>
## Semma fons computationis

`runtime/final_logs/source_accounting_latest.json` utitur `randomdayguard.source-accounting/v1` cum generatione reason/status, enablement/disabledratione, current/historical distinctionem, limam, mutatam manifestant, monumenta, usable/unavailable indices classium et limites adclamationes.

Tabula singula continet:

| Field | Type | Means |
|---|---|---|
| `source_class` | string | Una ex octo generibus infra. |
| `scope` | `current` vel `historical` | Tempus dominii; scopes numquam immiscet tacite. |
| `required` | boolean | tantum `active_log`requiritur ad iter cycli recentis novitatis. |
| `status` | enum | Source proventum infra recensitum. |
| `terminal` | boolean | Falsum solum ad `partial` et `deferred`. |
| `available`, `readable` | boolean | Verum solum pro `available` et `expected_empty`. |
| `file_count` | integrus | Funditus reputatus file/referencenumerare. |
| `source_references` | ordinate | Sorted unicus fonspaths/references. |
| `detail` | string | Funditur effectus vel error detail. |
| `does_not_prove` | string |  Availability non est intentus, dominii, damni, duplicationis, seu probationis cogendi. |

Source classes:

| Source class | Scopi | Quid confert | Quod probare non possit |
|---|---|---|---|
| `active_log` | current, requiritur | Readable servo activae stipes et recens capitationis generis. | Reperta historia vel lusor culpabilis. |
| `admin_ini` | current, optional | Structure valida vena moderator/banstatu vel absentia expectata. | Play mores vel valida causa metadata. |
| `recent_backup_logs` | historicus | Readable rotated/backup log indiciorum. | Current praesentia seu status tabernus current. |
| `playerdata_filenames` | contextus current | Found readable filename references sub radix electa Servata. | Filiae possessionis, praesentia, identitatis contenta, vel culpa vive. |
| `existing_cases` | historicus | Retentus casus nominatusfiles/index monumentis captis ante current outputs. | Current actio seu rectitudo conclusionum veterum. |
| `existing_reports` | historicus | Retentum final/forensic/warningrenuntiationes p. |  authoritative fons repositum. |
| `existing_evidence` | historicus | Retentio indiciis indiciorum. | Rerum perfectio servo numquam exposita est. |
| `world_save_scan` | historicus | Completa, partialis, dilata, vel terminata pervulgata scan/checkpointstate. | A actio vel proprietas propria lusoris. |

Source status valores:

| Status | Terminal | Operatoris significatio et actio |
|---|---:|---|
| `available` | yes | Fons perlectis utilis exstat; recensere p. |
| `expected_empty` | yes | Libitum libitum repressus ac legitimeabsent/empty. Data noli fingere. |
| `partial` | no | Operi aut inventario circumscriptus est modus incompletus; patitur yero. |
| `deferred` | no | Labor est studiose pendens; exspectamus possessorem operantem. |
| `unavailable` | yes | Source/path/tooldeest aut inutile; reparare solum, si opus fuerit in itinere. |
| `malformed` | yes | Content structurae sanatio defecit; eam conserva et forma repara. |
| `permission_denied` | yes | Accessum diserte negatur; restituat saltem privilegio aditum. |
| `error` | yes | Source-level finiatur probe/read improviso defecit; inspicere `detail` secreta sine exponendo. |

Top-level`coverage_status` prorsus est`complete`, `complete_with_gaps`, `partial`, vel `unavailable`. Requiritur fons-gradu `error`, `malformed`, vel `permission_denied` volvitur ad summum gradu `unavailable`; fons-level `deferred` volvitur ad summum gradu `partial`. Inactivare fontem censea adhuc scribit rem perpendentem statum et omnem viam ad `missing`.

<a id="historical-status-schema"></a>
## Historicum schema

`runtime/final_logs/historical_backfill_latest.json` utitur `randomdayguard.history/v1`: `generated_ts`, rationem `status`, `resumable=true`, `changed_file_refresh=true`, `current_evidence_is_not_history=true`, fons rationis ordinata, pervulgata classes, et limitata `next_action`.

`runtime/history/public_accounts.tsv` durabile est historiam publicam cum hoc titulo:

```text
account_id	ban_id	display_name	identity_confidence	status	score	first_seen	last_seen	source_references
```

Ros ratione ID digestae sunt, agri sunt single-line/tab-safe, et notae sunt sorted/unique. Hic fasciculus historicum contextum per silentium restarts servat; numquam historiam vertit in praesentiam hodiernam.

<a id="route-proof-schema"></a>
## Ratio schematismi

`runtime/final_logs/route_proof.json` utitur `randomdayguard.route-proof/v1``routes`ordinata.

Uterque introitus continet route/status, version/boot/epoch/poll, fons integritatis objecti, vena-cycli perfectionis, semitae outputae, et fons indiciorum. Debilitatum iter records `status="missing"` et `reason="route_disabled"`. Si scripturae probatio itineris deficit, omnis via revocatur ut incomplete/missing ante quamlibet notitiam candidatus accipitur.

<a id="notification-schemas"></a>
## Notificationes schemas

Modus publicus libitum solum est localis-file outbox.

`runtime/notifications/pending/<route>_latest.json` utitur `randomdayguard.notification/v1` cum indicatione genita, version/boot/epoch/ poll/source viriditatem, iter, `completed_output`, status iter-probationis, structi et translati relationum semitarum, fons indiciorum, `delivery_backend="none"`, et `delivery_attempted=false`. Eligibile output utitur `status="ready_for_local_consumer"`, `delivery_eligible=true`, et `delivery_allowed=true`. Aliquam ornare sed missing/ineligible`status="suppressed_current_cycle"``suppression_reason="route_or_completion_policy_blocked"`. Praesentia ergo tabella sub `pending/` non significat ipsum amet neque eligi.

`runtime/notifications/notification_status.json` utitur `randomdayguard.notification-status/v1` eodem genere, `generic_local_outbox_only=true`, `delivery_attempted=false` et per-route`queued`/`outcome` ordines. `full`taxatur; expectata vacua taxatur cum`include_expected_empty=true`; `missing` numquam eligibile est. In itinere-probatione scribe defectum status exitus est `route_proof_write_failed`; involucrum computorum suppressum adhuc scribi potest, sed output non accipitur.

<a id="runtime-output-inventory"></a>
## Runtime output inventarium

Index tracibilis unum habet ordinem machinae ad singulas semitas vel fasciculi dynamicas. Hoc readable inventarium circulorum lima ab operator proposito.

| Path vel exemplar | Producer/trigger | Politica ac utilissima civitatum | Failure/recovery |
|---|---|---|---|
| `runtime/loader_probe.txt`, `runtime/loader_probe.json` | Loader viscus. | Operscripta startup identity/probe. | Missing non probat onus; inspicere UE4SS trabes et enable. |
| `runtime/config_load_error.txt` | Mando defectum onus. | Error solum servat terminatam rationem. | Restitue validum publicum config ac sileo. |
| `runtime/saved_path_probe.json` | salvatus-radialis resolutio. | Candidate/readability ratione. | Set `SavedRoot.txt` vel candidatum generalem reparare. |
| `runtime/startup_status.json`, `runtime/startup_error.txt`, `runtime/current/startup_error.json` | Satus lifecycle. | Tardus satus et error tabernus current. | Tantum matching tabernus possidet current critica status. |
| `runtime/runtime_version.json`, `runtime/runtime_capabilities.json`, `runtime/public_pipeline_status.json` | Startup/report integratio. | Latestversion/capability/handoffstate. | Version vel facultatem summa impedit complementum petit. |
| `runtime/poll_status.json`, `runtime/current/poll_status.json`, `runtime/poll_error.txt`, `runtime/current/poll_error.json` | Pollfinalizer/error. | Latestpoll/scheduler/in-flightstate et errore currenti tabernus. | Restitue callback saeptum et recentiora completo capita require. |
| `runtime/logs/current.jsonl`, `runtime/raw_events.jsonl` | Eventi logger. | Bounded append/rotation. | Conserve priorem bytes; reparare disk/retention ante hiatus freti. |
| `runtime/log_offsets.tsv`, `runtime/log_registry.json` | Logtail/registry. | Litterae exsertiones et identitatum canonicarum. | Diligenter reaedifica; acta historica tergum manent. |
| `runtime/log_continuity_events.jsonl`, `runtime/evidence/log_continuity_events.jsonl`, `runtime/server_lifecycle_events.jsonl`, `runtime/evidence/lifecycle_events.jsonl` | Continuity/lifecycle normalizer. | Appendice tantum contextu. | Contextus Absentis probare non potestgraceful/crashstate. |
| `runtime/current_server_epoch.json`, `runtime/server_epochs.jsonl`, `runtime/epochs/**` | Epoch dominus. | Current plus retenta epochae servo. | Incipit epocha nova post reparationem; non RESCRIBO historiam veterem. |
| `runtime/session_events.tsv`, `runtime/evidence/session_events.jsonl`, `runtime/sessions/**` | Sessionis possessoris. | Current/historicalsessionis rerumque snapshots. | Incomposita porticus ignotus manet; nulla identitatis inventio. |
| `runtime/account_evidence.tsv`, `runtime/account_evidence.json`, `runtime/history/public_accounts.tsv` | Account/session aggregatio et relatio moduli. | Snapsus Current historia plus durabilis. | Spectes separare et ab indiciis, non coniecturis reddere. |
| `runtime/current/session_state.json`, `runtime/current/active_accounts.json`, `runtime/current/spatial_context.json`, `runtime/current/actor_touch_rollup.json` | Poll/current-state scriptores. | Operscripta current snapshots. | Stale/missing ignotus, inanis non expectatus. |
| `runtime/days/**`, `runtime/weeks/**` | Daily/weekly aggregatio. | redificabiles indices. | Redificare ex auctoritate rerum. |
| `runtime/scan_started.json`, `runtime/scan_progress.json`, `runtime/scan_checkpoint.json`, `runtime/scan_complete.json`, `runtime/scan_error.txt` | Scan operarius. | Coepi, partial/deferred, checkpoint, completae vel erroris. | LAPIS Proin; reficere solum exposita ratione. |
| `runtime/baselines/last_scan.json`, `runtime/baselines/last_completed_baseline.json`, `runtime/baselines/file_manifest.tsv` | Baseline operarius. | Latestscan/baseline et lima ligamen mutatum. | Stale/incompatible manifestas reaedificandas requirunt. |
| `runtime/object_registry_partial.json`, `runtime/object_registry_counts_partial.tsv`, `runtime/object_registry.json`, `runtime/object_registry_counts.tsv` | scan objectum. | Partial/final context class. | Comites non sunt ludi-actionis probatio; resumere vel reficere scan. |
| `runtime/new_classes_detected.jsonl`, `runtime/class_deltas.jsonl` | comparationis objecti. | Appendice solum new/delta context. | Reviewmapping/baseline ante illationem. |
| `runtime/playerdata_index.json`, `runtime/admin_state.json` | Res servatae index. | Filename/admin contextum contextum. | Filenames infirma sunt; deformis civitatis admin claudit scribit. |
| `runtime/world_state/boot/**`, `runtime/world_state/current/world_state_latest.json`, `runtime/world_state/sessions/**` | World-status. | Boot/current/session snapshots et diffs. | Context only; Renati post scan/source reparatione. |
| `runtime/warning_events.jsonl`, `runtime/warnings/**`, `runtime/evidence/critical_events.jsonl`, `runtime/evidence/high_events.jsonl`, `runtime/evidence/medium_events.jsonl` | Warning/evidence scriptores. | Appendicis circumscriptus et per-player/session imaginum recognitionis. | Absentis fama non deest rei probatio; fonte inspicere testimonio. |
| `runtime/raid_cases/**`, `runtime/raid_cases/index.jsonl`, `runtime/ban_queue.json` | Case/review aggregatio. | nominatus materia recensionis et candidatorum queue. | Casemembership/threshold numquam praetermittit portas speciales. |
| `runtime/backups/Admin_*.ini`, `runtime/enforced.txt`, `runtime/enforced_bans.jsonl`, `runtime/evidence/enforced_bans.jsonl`, `runtime/evidence/enforcement_failed_*` | Libitum Admin.ini transaction. | Backup, successus ledger, vel explicitus failure/rollback evidentia. | Aliqua backup/write/readback/rollbackdefectum claudit egestas; tergum restituere. |
| `runtime/request_restart.flag`, `runtime/restart_reason.json` | Libitum scriptorem libitum. | Locus solum postulatio. | Non probat consumptionem nec sileo. |
| `runtime/current/forensic_today.json`, `.md`, `.txt`, `runtime/forensic_days/YYYY-MM-DD/**`, `runtime/final_logs/YYYY-MM-DD/**` | rollup forense. | Current ac datas indices recensionum reaedificabiles. | Ex testimoniis fons aedificetur; non summa auctoritate tractare. |
| `runtime/final_logs/source_accounting_latest.json`, `historical_backfill_latest.json`, `<route>_latest.json`, `<route>_latest.txt`, `route_proof.json` | Publicae famae laborantis. | Schemas et regulas peractas supra. | Restitue primum iugumlineage/source/write; absentis manus defuit. |
| `runtime/notifications/pending/<route>_latest.json`, `runtime/notifications/notification_status.json` | Libitum loci outbox. | Eligibile vel expresse involucrum locale plus status suppressi. | Missing/ineligibleitinera lima sed numquam amet suppressa sunt; Vexilla partus inspicere et nullam externam traditionem inferre. |

Overwrite/append/retentionmorum mores refrenat a sectione producenda in [`CONFIG_FIELD_CATALOG.md`](CONFIG_FIELD_CATALOGUE.md). Sarcina ZIPs continet tantum inanis `.gitkeep` placeholders sub `runtime/`; quis evidence/output byte in emissione sarcina deficit sanatio.

<a id="failure-and-recovery-matrix"></a>
## Defectum et receptam vulvam

| Defectum | requisiti status | Recepta tuta | Invalida illatio |
|---|---|---|---|
| Current generisabsent/stale |  Omnia itinera `missing`. | Restitue active-log/current-poll probandi et renatis. | Limae viae veteris non sunt complementum current. |
| Libitum fontem inane expectat | Source`expected_empty`; ingrediuntur iter sit`limited_expected_empty`. | Nulla refectio nisi fons existat. | Inanis non est unavailable et absentia historica non probat. |
| Scan incompletum | Source`partial` vel `deferred`. | Permitte aliquam clausuram; custodi current consilium iter expressum. | Partialis corruptio non est. |
| requiritur fons unavailable | `coverage_status=unavailable`; dependens itineribus `missing`. | Restituo delectum Saved/log access. | Alii fontes sani non recipiunt fontem debitum. |
| requiritur fontem probe errores | Source status`error` clausoque `detail`; `coverage_status=unavailable`; dependens itineribus `missing`. | Restitue nominatum source/probe et novum cyclum generant. | Fons error non est quintus top-level coverage valorem. |
| Paired fama scribe fallit | `coverage_status=unavailable`; iter convergat `missing`. | Reparare filesystem et rescribere utrumque membra plus probationis. |  fasciculus unus fratrem non complet, et defectum scribe in summa gradu non `error`. |
| Route-probatio scribe fallit | Omnis via fessa deest; non eligibile outbox; configuratus itinera recipiat suppressa involucra audit. | Reparare iter-probationis scribe et regenerare eundem cyclum outputs. |  Valida bellus fama JSON vel involucro suppresso probatio itineris non est. |
| Notificatione scribe fallit | Eventum`local_outbox_write_failed`. | Reparatio loci radix output; Renati de peracta fama. | Nulla traditio externa occurrit. |
| Admin.inires fallit | Exactio saepta cum backup/write/readback/rollback evidentia. | Redde verificatum tergum; manet recensio-tantum. |  A limine vel fama non potest iustificare praeteriens convaluisset. |

Vide[`EVIDENCE_BOUNDARY.md`](EVIDENTIA_TERMINUS.md), [`ARCHITECTURE.md`](ARCHITECTURA.md), et [`SOURCE_MODULE_REFERENCE.md`](SOURCE_MODULE_REFERENCE.md).
