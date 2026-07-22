<a id="status-and-error-reference"></a>
# Status et error referuntur

> **Canonicum Anglicum fontem:** [STATUS_AND_ERROR_REFERENCE.md](../../STATUS_AND_ERROR_REFERENCE.md).  Haec documenta localia mandata exacta, semitas, claves, valores, hashes, nomina fasciculi conservat. Si forma technica differt, fonte Anglico utere.


Hoc utere referente post signum in [ Troubleshooting](TROUBLESHOOTING.md). Status lima per errorem nomine legitur exstructa. Codices distincti salutem et vitam cycli distincti repraesentant; non concidat eos in "cadore" generale effectum.

<a id="route-and-source-states"></a>
## Ratio et fons civitates

| Value | Means | Responsio operantis |
|---|---|---|
| `full` | Iter contractus probatio currenti-cycli fonte perficitur. | Recipe limites argumenti itineris; nulla reparatio importatur. |
| `limited_expected_empty` | Iter perfecti et actuositatis absentis huius cycli legitimus est. | Nulla synthetica player/caseres creari debet. |
| `missing` | A requisita output, genus agri vel argumenti fons abest. | Viam rationem inspice et fontem status nominat. |
| `available` | nominatus fons erat lectibilis et utibilis. | Nulla actio. |
| `expected_empty` | Fons repressus est ac legitime nullos ordines habebat. | Nulla actio, nisi actio sine spe esset. |
| `partial` / `complete_with_gaps` | Usable evidentia exstat, sed nominatus fons incompleta sunt. | Conclusiones limitum argumentorum collectarum. |
| `deferred` | Opus circumscriptus pro posteriori laborantis facultate venturus est. | Confirma progressum promovet antequam configurationem mutans. |
| `unavailable` |  Ambitus fontem non praebet. | Record limitem; rectam tantum probatam viam vel exitum permissionis. |
| `malformed` | Fons legebatur, sed fabrica sanatio defuit. | Pura illud et principium fige; noli divinare. |
| `permission_denied` | Fons exstat sed legi non potest. | Concede tantum strictam licentiam requisitam legere. |
| `error` | Collectio incassum memoriae causa. |  Errorem et egritudinem conserva. |

<a id="playerdata-and-inventory-codes"></a>
## PlayerData et codicibus inventarii

| Code | Means | Responsio tuta |
|---|---|---|
| `saved_root_unavailable` | Nulla radix verificata Servata praesto erat fistulae publicae. | Recte`SavedRoot.txt` et viam probe reprime. |
| `unsafe_playerdata_root` | PlayerData inventio extra radicem saeptam servatam resoluta. | Viam corrige; limitem numquam debilitant. |
| `playerdata_discovery_not_run` | Inventus limitatus operarius adhuc non currit. | Reprehendo scheduler et operariorum progressus. |
| `playerdata_discovery_read_failed:*` | Inventa output legi non potuit. | Conserve suffixos singulas et inventarium limitatum comprobare mandatum. |
| `inventory_command_open_failed` |  Inventarium processum iniri non potuit. | Verificare runtime praebet felis mandatum pontis. |
| `inventory_command_read_failed` | Inventarium output in lege defecit. | Conserve partiales output ac rerum tantum post errorem subesse figitur. |
| `inventory_command_close_failed` | Inventarium sine certo eventu confectum. | Tractatus fons ut incompletus. |
| `identity_ledger_row_limit_exceeded` | Dura identitas input eius publicae securitatis vinctum exceditur. | Archive et lectorem recense; noli eam tacite truncatam in plenam probationem. |

<a id="adminini-enforcement-codes"></a>
## Admin.inicodices cogendi

 Omnes codices in hac sectione deficient-clausi sunt. Bannum manuale per se non permittunt.

| Code | Means | Responsio tuta |
|---|---|---|
| `admin_ini_write_disabled` / `admin_ini_disabled` | Public-tuta portae scribe abi. | Expectata recensio solum operandi. |
| `admin_ini_backup_disabled` / `backup_safety_gate_disabled` | requiritur consilium tergum non active est. | Retine scribens debilitatum. |
| `enforcement_disabled` / `ban_on_threshold_disabled` / `auto_ban_disabled` | Ona expressa porta non vigilat. | Expectata in publica recognitione solum defaltis; noli id ​​scribere ut defectum scribes. |
| `review_only_mode_enabled` | Recensio solum modus intentionaliter mutationem impedit. | Recensio tantum argumentorum. |
| `duplicate_prevention_disabled` | Effingo debilitata erat. | Retine scribens debilitatum donec porta salutis restituatur. |
| `readback_safety_gate_disabled` / `rollback_safety_gate_disabled` | Post-scribe verificationem vel reverti praesidium debilitatum erat. | Retine scribens debilitatum; has portas numquam praetermitte. |
| `clean_id_safety_gate_disabled` / `account_specific_evidence_gate_disabled` | Clean identitas seu ratio certa indicia cogendi debilitata erat. | Rede porta ante aliquam egestas elit. |
| `moderator_preservation_disabled` / `existing_ban_preservation_disabled` | Proted-ratio vel existens ban conservatio debilitata erat. | Retine scribens debilitatum. |
| `clean_numeric_identity_required` | Proposita ID non est forma connexionis integrae receptae vel numericae ID mundialis. | Certa tabularum habe; praepositionem arbitrariam numquam truncate. |
| `identity_strength_below_minimum` | Identity indicium infirmius est quam in limine felis. | Recensio tantum argumentorum. |
| `playerdata_verification_required` | Configurationis requirit PlayerData confirmatio et ratio eam non habet. | Cultum qui recognitionem tantum habeto; dominium ex tabulario non colligo. |
| `trusted_or_moderator_identity` | Ratio a fide vel moderatore civitatis munitur. | Nihil scribere licet. |
| `admin_ini_path_invalid` / `admin_ini_path_outside_saved_root` | Scopo iter invalidum est aut radicem servatam effugit. | Recte conformationem; numquam praetermittendum est iter custodiae. |
| `admin_ini_unavailable` | Nulla readable conformatus Admin.ini radix Servata intus inventa est. | Viam limitatam corrige vel necessitatem debilitatam custodi. |
| `admin_ini_read_failed` | Authoris bytes legi non potuit. | Consiste ante mutationem. |
| `admin_ini_parse_failed` | Admin.ini sanatio non defuit sine subtilius structurarum codice. | Tabellam conserva et eius sectionem ac lineam structuram inspice. |
| `admin_ini_contains_nul` | Tabellae continet NULbytes nec pro textu accipitur. | Tabellam conserva et eam extra cohortem refice. |
| `admin_ini_duplicate_banned_players_section` | Plus quam unus`[BannedPlayers]` sectionis exstat. | Merge sectiones manually dum cessat. |
| `admin_ini_banned_player_outside_section` | Ban ordo extra `[BannedPlayers]`. | recte corrige layout manually. |
| `admin_ini_invalid_banned_player_line` | A ban linea prorsus munda non est sustentata ID row. | Recte corrige lineam pravam. |
| `admin_ini_backup_failed` | Singula tergum non scripsit ac relegit byte-identice. | Mutatio nulla conceditur. |
| `admin_ini_external_change_detected` | Alius scriptor tabellam mutavit post snapshot custodiae. |  |
| `atomic_rename_unavailable` | Atomic repositum postulatum est sed Luam `os.rename`. | Nulla scripturae fidetur; runtime subnixum utere vel cogendi debilem serva. |
| `admin_ini_write_failed` | repositum imperium non complevit. | repositum errorem et tergum memoriae inspice. |
| `post_write_verification_failed` | Production bytes candidatum non aequavit. | Reprehendo `rollback_success` et `rollback_refused_external_change` ante omnem actionem. |

<a id="startup-scheduler-and-backlog-states"></a>
## Satus, schedula, ac status backlog

 Haec bona documenta sunt vitae, non probatio itineris. Legite eos currenti poll, adiutori nuntianti et imagini itinerariorum.

| Value | Means | Responsio tuta |
|---|---|---|
| `not_started` | Satus nominatus seu scaena schedula non coepit. | Per launch, expecta documentum intervallum; postea primum immutatum tempus inspice. |
| `main_lua_loaded` / `starting` |  oneratus canonicorum cucurrit et custodiae initium intravit. | Perge posterius; hoc solum promptum non est. |
| `saved_root_found` / `log_tail_initialized` / `epoch_started` | Core principium et continuum initialization inferuntur. | Nulla actio nisi proxima periodus progredi cessat. |
| `admin_state_written` / `playerdata_index_written` | Initiales indices terminati exportati sunt. | Nulla actio; manus cedularum adhuc sequi debet. |
| `watchdog_started` | Renuntiatio et speculator inscriptus est. | Confirma scheduler et capita sequentia progredi. |
| `ready_degraded` / `scan_running` | custodia currit dum historicum scannum claudatur pendente manet. | Cautio, non defectus; calculis progressus cognoscere progredi. |
| `ready` | Satus ac schedula circumscriptionis hodiernae ad paratum statum pervenit. | Reprehendo itineris probationem separatim. |
| `scan_failed` / `error` | Satus seu scan terminatur cum errore memoriae. | Sacramenta nominata errorem vel statum fasciculi conserva et egritudo istius temporis. |
| `running` | Cedularum futurum capita occasiones habet. | Confirma`poll_id` et `poll_completed_count` antecessum. |
| `manual_only` | Loop scheduling erat unavailable; solum opus explicitum currere potest. | Tractatus sine operatione ut unavailable. |
| `stopped` | Scheduler operandi finita est. | Inspice antecedentem finem et errorem probationes ante sileo. |
| `active_log_caught_up` | Nihil illectum activum-log backlog manet. | sica historica procedere potest. |
| `active_log_unavailable_nonblocking` | Tabula activa aberat, sed satus non-obturans mansit. | recordare fontem et modum et alios fontes comprobare. |
| `active_log_read_failed` | Tabula activa exstitit sed legi non potest. |  Errorem conserva et solum probatam viam vel permissu exitus. |
| `budget_exhausted` / `active_log_has_unread_bytes` | Cauda terminata saltum cum backlog remanente obstitit. | Confirma postea repulsam reducere illectum comitem. |
| `offset_commit_failed_after_events_applied` | Eventus discursum sed firmum stipes cinguli pervicacia defecerunt. | Exactio differtur; offset reponendi reparatione antequam alius cyclus confisus sit. |

<a id="scheduler-report-and-notification-codes"></a>
## Scheduler, fama, et notificationes

| Codex seu status | Means | Responsio tuta |
|---|---|---|
| `poll already in flight` | A secunda callback venit dum currens pollen- dium vitalem possidebat. | Confirma progressionem capitum existentium; aliud possessorem ansam ne addas. |
| `no_log_files_found` | Nulla figuram activam vel tergum stipes repertus est. | Verify Servatum radix et fons configurationem. |
| `current_poll_error` | Ratio currentis cycli deficiendi poll-fontis exposita est. | Read`runtime/current/poll_error.json`. |
| `cadence_deferred` | Litterae complementum nondum debitum est. | Expectatur usque ad tempus proximum terminatum. |
| `reports_disabled` | Publicus relatio generationis debilitata est. | Activare tantum si auditiones in animo sunt. |
| `local_outbox_write_failed` | A involucrum loci translati scribi non potuerunt. | Restitue runtime output directory; haec notificatio non est erroris oneraria. |
| `source_accounting_disabled` | probatio itineris integrum fontem coverage vindicare non potest. | Activare fontem rationis vel probationem explicite acceptare absentis. |
| `route_disabled` | Iter consulto debilis est. | Nulla traditio pro eo itinere expectatur. |
| `poll_owner_between_polls` | Renuntiatio laborantis in schedula inter capita suffragiorum versatur. | Expectatur tantum cum indicationibus et cursoribus progredientibus. |
| `unsafe_shell_path` | A inventarium finitum aut concha tramitem suggestum incolumem sanationem fefellit. | Viam corrige; numquam debilitare verba vel viam sanationem. |

<a id="related-procedures"></a>
## Related rationes

- [ Troubleshooting](TROUBLESHOOTING.md)
- [ Validation et recensio emissio](VALIDATION_ET_DIMITTE.md)
- [Output schema reference](OUTPUT_SCHEMA_REFERENCE.md) ad contractum campum integrum.
