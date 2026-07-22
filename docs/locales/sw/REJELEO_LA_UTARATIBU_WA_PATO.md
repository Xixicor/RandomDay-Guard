<a id="output-and-state-schema-reference"></a>
# Rejeleo la pato na hali ya utaratibu

> **Chanzo cha Kiingereza cha Canonical:** [OUTPUT_SCHEMA_REFERENCE.md](../../OUTPUT_SCHEMA_REFERENCE.md). Hati hizi zilizojanibishwa huhifadhi amri kamili, njia, funguo, thamani za hali, heshi na majina ya faili. Ikiwa maneno ya kiufundi yanatofautiana, tumia chanzo cha Kiingereza.


Huu ni mkataba wa kisheria wa faili zinazotokana na opereta. Ni pekee inayomiliki njia halisi za matokeo, majina ya sehemu, thamani zinazoruhusiwa, mahitaji ya mstari na taratibu za njia. Miongozo ya kiutaratibu huunganisha hapa badala ya kufafanua upya ukweli huo.

Ushahidi wa muda wa utekelezaji ni halali; jina la faili, mapigo ya moyo ya kiratibu, ripoti iliyotafsiriwa, au kifaa cha kikasha toezi cha ndani hakithibitishi zaidi ya nyuga na ukoo wake.

<a id="public-report-routes"></a>
## Njia za ripoti ya umma

Mfanyakazi wa ripoti anamiliki njia tano chini ya `runtime/final_logs/`:

| Njia | Mkataba | `full` mahitaji | Maana tupu-inatarajiwa |
|---|---|---|---|
| `server_status` | Kipanga ratiba cha sasa, kumbukumbu-amilifu, inasubiri kuchanganua, na hali ya chanjo ya chanzo. | Ya Sasaboot/epoch/poll ukoo, kumbukumbu mpya inayotumika, accounting/history anaandika, na JSON/TXT jozi. | Haitumiki kwa mzunguko wa sasa unaofaa; nasaba inayokosekana ni `missing`. |
| `daily_rollup` | Ya Sasaday/window mwendelezo kwenye seva, vichezaji, matukio, utambazaji, na huduma. | Mwisho wa uhasibu wa kihistoria wa kutosha kwa njia na uthibitisho wa mzunguko wa sasa umekamilika. | Hakuna wachezaji waliobakizwa na hakuna kesi za ukaguzi. |
| `player_activity` | Tenganisha ya sasa na ya kihistoria player/account uchunguzi. | Uthibitisho wa mzunguko wa sasa pamoja na moja au zaidi current/historical safu mlalo. | Hakuna safu mlalo za kichezaji zinazostahiki katika ingizo zenye mipaka; hakuna somo la sintetiki. |
| `case_review` | Kesi zilizotajwa zilizobaki na za sasa review/BAN-ELIGIBLE wagombea. | Uthibitisho wa mzunguko wa sasa pamoja na kesi moja au zaidi zilizotajwa zenye marejeleo ya chanzo. | Hakuna kesi iliyotajwa iliyokidhi vigezo vya ukaguzi; hakuna kipochi cha sintetiki. |
| `critical_guard` | Kipanga ratiba cha sasa, kuanzisha, kura, au kutofaulu kwa ushahidi wa uadilifu. | Uthibitisho wa mzunguko wa sasa pamoja na hitilafu muhimu ya sasa. | Hakuna hitilafu muhimu ya sasa; makosa ya maandishi ya zamani hayamiliki njia hii. |

Kila njia iliyowezeshwa huandika `<route>_latest.json` na `<route>_latest.txt`. Jozi haijakamilika hadi `runtime/final_logs/route_proof.json` hurekodi toleo lile lile, boot, epoch, kura ya maoni, na uboreshaji chanzo.

<a id="report-json-schema"></a>
## Ripoti JSON utaratibu

Njia zote JSON hutumia `schema="randomdayguard.report/v1"`.

| Sehemu | Aina | Maana na tofauti |
|---|---|---|
| `schema` | string | Hasa `randomdayguard.report/v1`. |
| `generated_ts`, `report_date` | string | Muhuri wa muda wa uzalishaji na tarehe ya kuripoti. |
| `version` | string | Runtime/package utambulisho wa mzunguko huu. |
| `boot_id`, `epoch_id` | string | Mchakato wa kuwasha na enzi ya mwendelezo wa seva. Zote mbili zinahitajika ili kukamilika. |
| `poll_id` | jumla | Kitambulishi cha sasa cha kura ya maoni.Zero/missing haiwezi kukamilisha njia. |
| `source_freshness` | kitu | `status`, `checked_ts`, hali ya kumbukumbu-amilifu, muhuri wa muda wa mwisho wa kura, na muhuri wa muda wa mwisho wa kura iliyokamilishwa. |
| `current_cycle_proof_complete` | boolean | Ni kweli tu wakati ukoo na mpya active-log/current-pollushahidi unakubali. |
| `route` | enum | Mojawapo ya njia tano zilizo hapo juu. |
| `route_proof_status` | enum | `full`, `limited_expected_empty`, au `missing`. |
| `coverage_status` | enum | Hasa `complete`, `complete_with_gaps`, `partial`, au `unavailable`. |
| `completed`, `expected_empty` | boolean | `completed` si kweli kwa `missing`; `expected_empty` ni kweli kwa `limited_expected_empty`. |
| `observed` | msururu wa mifuatano | Saruji imehifadhiwa facts/counts/statuses. |
| `interpretation` | msururu wa mifuatano | Maana ya tahadhari yamesawazishwa kwa ushahidi. |
| `unknown` | msururu wa mifuatano | Kitambulisho kinakosekana, historia, chanzo au muktadha. |
| `does_not_prove` | msururu wa mifuatano | Hitimisho ambalo ushahidi hauwezi kuunga mkono. |
| `next_action` | string | Kitendo cha opereta kilicho na mipaka salama zaidi. |
| `source_references` | msururu wa mifuatano | Imepangwa kipekee runtime/Saved marejeleo. |
| `enforcement_authority` | boolean | Si kweli kila wakati. Ripoti kamwe hairuhusu uandishi. |
| `output_paths` | mistari miwili | JSON na TXT njia zilizoongezwa kabla ya kuoanishwa kuandikwa. |

`coverage_status` ni uhasibu wa kiwango cha juu pekee. Rekodi chanzo humiliki kivyake `available`, `expected_empty`, `partial`, `deferred`, `unavailable`, `malformed`, `permission_denied`, na `error`. Uthibitisho wa njia unamiliki kando `full`, `limited_expected_empty`, na `missing`; maadili hayavuki mipaka hii.

Viendelezi vya njia:

- `server_status`: `scheduler_status`, `active_log_status`, na `server_metrics`. Vipimo vinarekodi kipindi cha sasa cha kuanza, muhuri wa muda na kitambulisho cha kura iliyokamilika hivi karibuni, idadi ya wachezaji wanaocheza, active/backup-log hesabu, changanua pending/progress thamani, na configured/usable/unavailable uhasibu wa kikundi cha chanzo. Hazibuni muda wa ziada, hazianzishi tena hesabu, mihuri ya muda ya chelezo, au muda wa kukatika wakati hakuna chanzo kinachofichua ukweli huo.
- `player_activity`: `player_activity_present`, `movement`, `same_day_sessions`, `current_player_count`, `current_evidence_player_count`, `historical_player_count`, `historical_session_count`, `current_players`, `historical_players`, na safu tangamanifu `players`. Kila kipindi cha siku moja huhifadhi kitambulisho chake cha kipindi, kitambulisho cha akaunti, jina la onyesho linapojulikana, join/leave mihuri ya muda, bendera za kutoka na mzunguko wa maisha, na marejeleo ya vyanzo. Utambulisho uliohifadhiwa na PlayerData uwepo unabaki kuwa muktadha, sio uthibitisho wa shughuli leo.
- `case_review`: `cases`, `review_subjects`, `current_case_count`, na `retained_case_count`. Somo la uhakiki wa sasa linarekodi case/account Kitambulisho, jina la kuonyesha linapojulikana, hali, alama, imani ya utambulisho, first/last uchunguzi, hesabu za onyo, sababu, alama ya moja kwa moja ya sasa na marejeleo ya chanzo. Kesi zilizobaki haziungi mada ya sasa peke yake.
- `critical_guard`: `critical_failure_present` na `current_boot_error_only=true`.
- `daily_rollup`: `daily_maturity`, `once_per_day_continuity`, `dedupe_window`, na `daily_metrics`. Vipimo vinarekodi tarehe ya kuripoti, wachezaji wanaoendelea, akaunti zilizo na shughuli za siku moja, kujiunga, kuondoka, kutoka safi na zisizo safi, kurejesha mzunguko wa maisha, mada za ukaguzi zilizotajwa sasa, kesi zisizobadilika, current/retained idadi ya utambulisho, na chanjo ya kikundi cha chanzo.

<a id="translated-txt-schema"></a>
## Imetafsiriwa TXT utaratibu

Faili ya maandishi iliyooanishwa inaongoza kwa matokeo yanayoweza kusomeka na opereta na kusogeza maelezo ya ukoo hadi mwisho. Huhifadhi mpangilio huu wa sehemu:

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

Tafsiri hutumia sehemu za ripoti zilizoundwa tu na uundaji wa kamusi ulioidhinishwa. Haiwezi kuongeza wachezaji, kesi, uwasilishaji, sababu, umiliki, dhamira, au ustahiki wa utekelezaji bila ya ripoti iliyoundwa. Maelezo ya kiufundi yanaendelea kupatikana bila kuondoa matokeo yanayosomeka.

<a id="source-accounting-schema"></a>
## Mchoro wa uhasibu wa chanzo

`runtime/final_logs/source_accounting_latest.json` hutumia `randomdayguard.source-accounting/v1` na kizazi reason/status, enablement/disabled sababu, current/historical tofauti, faili ya maelezo iliyobadilishwa, rekodi chanzo, usable/unavailableorodha za madarasa, na kikomo cha madai.

Kila rekodi chanzo kina:

| Sehemu | Aina | Maana |
|---|---|---|
| `source_class` | string | Moja ya madarasa manane hapa chini. |
| `scope` | `current` au `historical` | Umiliki wa muda; mawanda kamwe hayaunganishwi kimyakimya. |
| `required` | boolean | Pekee `active_log` inahitajika kwa usasishaji wa njia ya mzunguko wa sasa. |
| `status` | enum | Matokeo ya chanzo yaliyoorodheshwa hapa chini. |
| `terminal` | boolean | Siyo kwa `partial` na `deferred`. |
| `available`, `readable` | boolean | Kweli kwa `available` na `expected_empty`. |
| `file_count` | jumla | Inawajibika file/referencehesabu. |
| `source_references` | safu | Chanzo cha kipekee kilichopangwa paths/references. |
| `detail` | string | Tokeo lenye mipaka au maelezo ya hitilafu. |
| `does_not_prove` | string | Kupatikana si dhamira, umiliki, uharibifu, nakala au uthibitisho wa utekelezaji. |

Madarasa ya vyanzo:

| Daraja la chanzo | Upeo | Inachochangia | Kile ambacho hakiwezi kuthibitisha |
|---|---|---|---|
| `active_log` | ya sasa, inahitajika | Rajisi amilifu inayoweza kusomeka na mstari mpya wa kura. | Historia kamili au uwajibikaji wa kichezaji. |
| `admin_ini` | ya sasa, ya hiari | Sasa halali kimuundo moderator/ban hali, au kutokuwepo kunakotarajiwa. | Tabia ya mchezaji au metadata halali ya sababu. |
| `recent_backup_logs` | ya kihistoria | Inasomeka rotated/backup marejeleo ya kumbukumbu. | Uwepo wa sasa au hali ya kuwasha ya sasa. |
| `playerdata_filenames` | muktadha wa sasa | Marejeleo ya jina la faili yanayosomeka chini ya mzizi uliochaguliwa uliohifadhiwa. | Umiliki wa faili, uwepo wa moja kwa moja, maudhui ya utambulisho, au utovu wa nidhamu. |
| `existing_cases` | ya kihistoria | Kesi yenye jina iliyohifadhiwa files/index rekodi zilizonaswa kabla ya matokeo ya sasa. | Shughuli ya sasa au usahihi wa hitimisho la zamani. |
| `existing_reports` | ya kihistoria | Imehifadhiwa final/forensic/warning ripoti marejeleo. | Ubadilishaji wa chanzo ulioidhinishwa. |
| `existing_evidence` | ya kihistoria | Marejeleo ya ushahidi yaliyobaki. | Ukamilifu wa matukio ambayo seva haikufichua. |
| `world_save_scan` | ya kihistoria | Kamili, sehemu, iliyoahirishwa, au haipatikani yenye mipaka scan/checkpointhali. | Kitendo au umiliki wa mchezaji mahususi. |

Thamani za hali ya chanzo:

| Hali | Kituo | Maana na kitendo cha opereta |
|---|---:|---|
| `available` | ndiyo | Chanzo muhimu kinachoweza kusomeka kipo; kagua marejeleo yake. |
| `expected_empty` | ndiyo | Chanzo cha hiari kiliangaliwa na kihalali absent/empty. Usivumbue data. |
| `partial` | hapana | Kikomo cha kazi iliyowekewa au hesabu hakijakamilika; ruhusu kuendelea. |
| `deferred` | hapana | Kazi inasubiri kwa makusudi; subiri mfanyakazi anayemiliki. |
| `unavailable` | ndiyo | Source/path/tool haipo au haiwezi kutumika; tengeneza ikiwa tu inahitajika kwa njia. |
| `malformed` | ndiyo | Yaliyomo imeshindwa uthibitishaji wa muundo; ihifadhi na urekebishe umbizo. |
| `permission_denied` | ndiyo | Ufikiaji ulikataliwa waziwazi; rejesha ufikiaji wa kusoma kwa upendeleo mdogo. |
| `error` | ndiyo | Kiwango cha chanzo kimefungwa probe/read imeshindwa bila kutarajiwa; kagua `detail` bila kufichua siri. |

Kiwango cha juu `coverage_status` ndiyo hasa `complete`, `complete_with_gaps`, `partial`, au `unavailable`. Kiwango cha chanzo kinachohitajika `error`, `malformed`, au `permission_denied` inasonga hadi kiwango cha juu `unavailable`; kiwango cha chanzo `deferred` inasonga hadi kiwango cha juu `partial`. Kuzima uhasibu wa chanzo bado kunaandika hali isiyopatikana na kulazimisha kila njia kwenda `missing`.

<a id="historical-status-schema"></a>
## Mchoro wa hali ya kihistoria

`runtime/final_logs/historical_backfill_latest.json` hutumia `randomdayguard.history/v1`: `generated_ts`, uhasibu `status`, `resumable=true`, `changed_file_refresh=true`, `current_evidence_is_not_history=true`, safu ya uhasibu chanzo, madarasa yasiyopatikana, na `next_action`.

`runtime/history/public_accounts.tsv` ni historia ya umma inayodumu kwa kichwa hiki:

```text
account_id	ban_id	display_name	identity_confidence	status	score	first_seen	last_seen	source_references
```

Safu mlalo hupangwa kwa kitambulisho cha akaunti, sehemu ni single-line/tab-safe, na marejeleo ni sorted/unique. Faili hii huhifadhi muktadha wa kihistoria katika uanzishaji upya wa utulivu; haibadilishi historia kuwa uwepo wa sasa.

<a id="route-proof-schema"></a>
## Ratiba ya uthibitisho wa njia

`runtime/final_logs/route_proof.json` hutumia `randomdayguard.route-proof/v1` na kurekodi muhuri wa muda wa kiwango cha juu, toleo, kuwasha, kipindi, kura ya maoni, uchangamfu wa chanzo, ukamilifu wa mzunguko wa sasa, hali zinazoruhusiwa na `routes` safu.

Kila ingizo la njia lina route/status, version/boot/epoch/poll, kitu cha upya-chanzo, ukamilifu wa mzunguko wa sasa, njia za matokeo na marejeleo ya chanzo. Njia iliyozimwa hurekodi `status="missing"` na `reason="route_disabled"`. Iwapo uandishi wa kuthibitisha njia utashindwa, kila njia itaandikwa upya kama incomplete/missing kabla ya mgombea yeyote wa arifa kukubaliwa.

<a id="notification-schemas"></a>
## Mipangilio ya arifa

Modi ya hiari ya umma ni kikasha toezi cha faili za ndani pekee.

`runtime/notifications/pending/<route>_latest.json` hutumia `randomdayguard.notification/v1` yenye muhuri wa muda uliotengenezwa, version/boot/epoch/ poll/source upya, njia, `completed_output`, hali ya uthibitisho wa njia, njia za ripoti zilizoundwa na kutafsiriwa, marejeleo ya chanzo, `delivery_backend="none"`, na `delivery_attempted=false`. Pato linalostahiki hutumia `status="ready_for_local_consumer"`, `delivery_eligible=true`, na `delivery_allowed=true`. Imesanidiwa lakini missing/ineligible route bado huandika bahasha ya ukaguzi yenye `status="suppressed_current_cycle"`, alama zote mbili za uwasilishaji si za kweli, na `suppression_reason="route_or_completion_policy_blocked"`. Kwa hivyo uwepo wa faili chini ya `pending/` haimaanishi peke yake kuwa na foleni au kustahiki.

`runtime/notifications/notification_status.json` hutumia `randomdayguard.notification-status/v1` yenye ukoo sawa, `generic_local_outbox_only=true`, `delivery_attempted=false`, na kwa kila njia `queued`/`outcome`safu.`full` inastahiki; inatarajiwa-tupu inastahiki tu wakati `include_expected_empty=true`; `missing`haistahiki kamwe. Kwa kushindwa kuandika kwa uthibitisho wa njia matokeo ya hali ni `route_proof_write_failed`; bahasha ya ukaguzi iliyokandamizwa bado inaweza kuandikwa, lakini haikubaliwi matokeo.

<a id="runtime-output-inventory"></a>
## Orodha ya pato la wakati wa utekelezaji

Faharasa ya ufuatiliaji ina safu mlalo moja ya mashine kwa kila njia au darasa badilifu la faili. Orodha hii inayoweza kusomeka inaweka pamoja faili kulingana na madhumuni ya opereta.

| Njia au muundo | Producer/trigger | Sera na hali muhimu | Failure/recovery |
|---|---|---|---|
| `runtime/loader_probe.txt`, `runtime/loader_probe.json` | Ingizo la kipakiaji. | Uanzishaji ulioandikwa upya identity/probe. | Kukosa hakuthibitishi upakiaji; kagua UE4SS kumbukumbu na kuwezesha. |
| `runtime/config_load_error.txt` | Imeshindwa kusanidi upakiaji. | Hitilafu pekee, huhifadhi sababu yenye mipaka. | Rejesha usanidi halali wa umma na uanze upya. |
| `runtime/saved_path_probe.json` | Ubora wa mizizi iliyohifadhiwa. | Candidate/readability uhasibu. | Weka `SavedRoot.txt` au rekebisha pendekezo la jumla. |
| `runtime/startup_status.json`, `runtime/startup_error.txt`, `runtime/current/startup_error.json` | Anzisha mzunguko wa maisha. | Hitilafu ya hivi punde ya uanzishaji na uanzishaji wa sasa. | Kiwanzio cha kulinganisha pekee ndicho kinachomiliki hali muhimu ya sasa. |
| `runtime/runtime_version.json`, `runtime/runtime_capabilities.json`, `runtime/public_pipeline_status.json` | Startup/report muunganisho. | Hivi karibuni version/capability/handoffhali. | Toleo au uwezo wa kuteleza huzuia madai ya kukamilisha. |
| `runtime/poll_status.json`, `runtime/current/poll_status.json`, `runtime/poll_error.txt`, `runtime/current/poll_error.json` | Kura finalizer/error. | Hivi karibuni poll/scheduler/in-flight hitilafu ya hali na ya kuwasha sasa. | Rekebisha upigaji simu wenye mipaka na uhitaji kura mpya iliyokamilishwa. |
| `runtime/logs/current.jsonl`, `runtime/raw_events.jsonl` | Kiweka kumbukumbu za tukio. | Imepakana append/rotation. | Hifadhi baiti za awali; tengeneza disk/retention kabla ya kutegemea mapungufu. |
| `runtime/log_offsets.tsv`, `runtime/log_registry.json` | Ingia tail/registry. | Vipunguzo vya hivi punde na vitambulisho vya kumbukumbu vya kisheria. | Jenga upya kwa uangalifu; kumbukumbu za chelezo hubaki kuwa za kihistoria. |
| `runtime/log_continuity_events.jsonl`, `runtime/evidence/log_continuity_events.jsonl`, `runtime/server_lifecycle_events.jsonl`, `runtime/evidence/lifecycle_events.jsonl` | Continuity/lifecycle kiboreshaji cha kawaida. | Muktadha wa nyongeza pekee. | Muktadha unaokosekana hauwezi kuthibitisha graceful/crashhali. |
| `runtime/current_server_epoch.json`, `runtime/server_epochs.jsonl`, `runtime/epochs/**` | Mmiliki wa Epoch. | Enzi za sasa za seva pamoja na zilizohifadhiwa. | Anzisha enzi mpya baada ya ukarabati; usiandike upya historia ya zamani. |
| `runtime/session_events.tsv`, `runtime/evidence/session_events.jsonl`, `runtime/sessions/**` | Mmiliki wa kipindi. | Current/historical matukio ya kipindi na vijipicha. | Safu mlalo ambazo hazijapangwa hubakia kujulikana; hakuna uvumbuzi wa utambulisho. |
| `runtime/account_evidence.tsv`, `runtime/account_evidence.json`, `runtime/history/public_accounts.tsv` | Account/session moduli ya kujumlisha na kuripoti. | Picha ya sasa pamoja na historia inayodumu. | Weka upeo tofauti na urejeshe kutoka kwa ushahidi, sio kubahatisha. |
| `runtime/current/session_state.json`, `runtime/current/active_accounts.json`, `runtime/current/spatial_context.json`, `runtime/current/actor_touch_rollup.json` | Poll/current-state waandishi. | Picha za sasa zilizoandikwa upya. | Stale/missing haijulikani, haitarajiwi kuwa tupu. |
| `runtime/days/**`, `runtime/weeks/**` | Daily/weekly muunganisho. | Faharisi zinazoweza kujengwa upya. | Unda upya kutoka kwa matukio ya mamlaka. |
| `runtime/scan_started.json`, `runtime/scan_progress.json`, `runtime/scan_checkpoint.json`, `runtime/scan_complete.json`, `runtime/scan_error.txt` | Changanua mfanyakazi. | Imeanza, partial/deferred, kituo cha ukaguzi, kamili, au hitilafu. | Rejea kituo cha ukaguzi; jenga upya kwa sababu iliyorekodiwa pekee. |
| `runtime/baselines/last_scan.json`, `runtime/baselines/last_completed_baseline.json`, `runtime/baselines/file_manifest.tsv` | Mfanyakazi wa msingi. | Hivi karibuni scan/baseline na ufungaji faili uliobadilishwa. | Stale/incompatible faili za maelezo zinahitaji uundaji upya wazi. |
| `runtime/object_registry_partial.json`, `runtime/object_registry_counts_partial.tsv`, `runtime/object_registry.json`, `runtime/object_registry_counts.tsv` | Uchanganuzi wa kitu. | Partial/final muktadha wa darasa. | Hesabu si dhibitisho la kitendo cha mchezaji; endelea au unda upya kutambaza. |
| `runtime/new_classes_detected.jsonl`, `runtime/class_deltas.jsonl` | Ulinganisho wa kitu. | Append-pekee new/delta muktadha. | Kagua mapping/baseline kabla ya makisio. |
| `runtime/playerdata_index.json`, `runtime/admin_state.json` | Faharisi za mizizi iliyohifadhiwa. | Filename/admin muktadha wa muundo. | Majina ya faili ni dhaifu; hali ya msimamizi mbovu hufunga huandika. |
| `runtime/world_state/boot/**`, `runtime/world_state/current/world_state_latest.json`, `runtime/world_state/sessions/**` | Mwandishi wa serikali ya dunia. | Boot/current/session vijipicha na tofauti. | Muktadha pekee; tengeneza upya baada ya scan/sourcetengeneza. |
| `runtime/warning_events.jsonl`, `runtime/warnings/**`, `runtime/evidence/critical_events.jsonl`, `runtime/evidence/high_events.jsonl`, `runtime/evidence/medium_events.jsonl` | Warning/evidence waandishi. | Kiambatisho kilicho na mipaka na per-player/session kagua faili. | Ripoti inayokosekana haina uthibitisho wa tukio; kagua ushahidi wa chanzo. |
| `runtime/raid_cases/**`, `runtime/raid_cases/index.jsonl`, `runtime/ban_queue.json` | Case/review muunganisho. | Imetaja nyenzo za ukaguzi na wagombeaji wa foleni. | Kesi membership/threshold haiendi kamwe malango mahususi ya akaunti. |
| `runtime/backups/Admin_*.ini`, `runtime/enforced.txt`, `runtime/enforced_bans.jsonl`, `runtime/evidence/enforced_bans.jsonl`, `runtime/evidence/enforcement_failed_*` | Si lazima Admin.ini muamala. | Hifadhi nakala, daftari la mafanikio, au wazi failure/rollbackushahidi. | Yoyotebackup/write/readback/rollback kushindwa hufunga utekelezaji; rudisha nakala rudufu. |
| `runtime/request_restart.flag`, `runtime/restart_reason.json` | Mwandishi wa alama wa hiari. | Ombi la ndani pekee. | Haithibitishi matumizi au kuwasha upya. |
| `runtime/current/forensic_today.json`, `.md`, `.txt`, `runtime/forensic_days/YYYY-MM-DD/**`, `runtime/final_logs/YYYY-MM-DD/**` | Mchanganuo wa kitaalamu. | Fahasi za ukaguzi wa sasa na wa tarehe unaoweza kujengwa upya. | Jenga upya kutoka kwa ushahidi wa chanzo; usichukue muhtasari kama mamlaka. |
| `runtime/final_logs/source_accounting_latest.json`, `historical_backfill_latest.json`, `<route>_latest.json`, `<route>_latest.txt`, `route_proof.json` | Mfanyakazi wa ripoti ya umma. | Mipangilio na sheria za ukamilishaji hapo juu. | Rekebisha haikulingana mara ya kwanza lineage/source/write; kukosa hubakia kukosa. |
| `runtime/notifications/pending/<route>_latest.json`, `runtime/notifications/notification_status.json` | Kikasha toezi cha ndani cha hiari. | Hadhi inayostahiki au iliyokandamizwa kwa njia ya ndani pamoja na bahasha ya ndani. | Missing/ineligible njia zinaweza kuwa na faili zilizokandamizwa lakini hazijawekwa kwenye foleni; kagua bendera za uwasilishaji na usifikirie kuwa hakuna uwasilishaji wa nje. |

Overwrite/append/retention tabia inadhibitiwa na sehemu ya utayarishaji katika [`CONFIG_FIELD_CATALOG.md`](CONFIG_SHAMBA_KATALOGI.md). ZIP za kifurushi zina `.gitkeep` vishika nafasi chini ya `runtime/`; yoyoteevidence/output byte katika kifurushi cha toleo imeshindwa kuthibitishwa.

<a id="failure-and-recovery-matrix"></a>
## Msuko wa kushindwa na urejeshaji

| Imeshindwa | Hali inayohitajika | Urejeshaji salama | Maelekezo batili |
|---|---|---|---|
| Ukoo wa sasa absent/stale | Njia zote `missing`. | Rejesha active-log/current-poll dhibitisho na utengeneze upya. | Faili za njia za zamani si ukamilisho wa sasa. |
| Chanzo cha hiari kinatarajiwa kuwa tupu | Chanzo `expected_empty`; njia inayostahiki inaweza kuwa `limited_expected_empty`. | Hakuna ukarabati isipokuwa chanzo kiwepo. | Tupu haipatikani na haithibitishi kutokuwepo kwa kihistoria. |
| Uchanganuzi haujakamilika | Chanzo `partial` au `deferred`. | Ruhusu kuendelea kwa mipaka; weka sera ya njia ya sasa wazi. | Sehemu si ufisadi. |
| Chanzo kinachohitajika hakipatikani | `coverage_status=unavailable`; njia tegemezi `missing`. | Rekebisha iliyochaguliwa Saved/logufikiaji. | Vyanzo vingine vya afya havichukui nafasi ya chanzo kinachohitajika. |
| Hitilafu zinazohitajika za uchunguzi wa chanzo | Hali ya chanzo `error` yenye mipaka `detail`; `coverage_status=unavailable`; njia tegemezi `missing`. | Rekebisha jina source/probe na kuzalisha mzunguko mpya zaidi. | Hitilafu ya chanzo si thamani ya tano ya chanjo ya kiwango cha juu. |
| Uandishi wa ripoti uliooanishwa umeshindwa | `coverage_status=unavailable`; njia inaungana hadi `missing`. | Rekebisha mfumo wa faili na uandike upya washiriki wote wawili pamoja na uthibitisho. | Faili ya ndugu mmoja haijakamilika, na kushindwa kuandika sio kiwango cha juu `error`. |
| Uandishi wa uthibitisho wa njia umeshindwa | Kila njia iliyoandikwa upya haipo; hakuna kisanduku toezi kinachostahiki; njia zilizosanidiwa zinaweza kupokea bahasha za ukaguzi zilizokandamizwa. | Rekebisha uandishi wa uthibitisho wa njia na uzae upya matokeo ya mzunguko sawa. | Ripoti inayoonekana ni halali JSON au bahasha iliyokandamizwa sio uthibitisho wa njia. |
| Kuandika arifa kumeshindwa | Matokeo`local_outbox_write_failed`. | Rekebisha mzizi wa pato la ndani; tengeneza upya kutoka kwa ripoti iliyokamilika. | Hakuna uwasilishaji wa nje uliotokea. |
| Admin.ini muamala haukufaulu | Utekelezaji umezuiwa na backup/write/readback/rollbackushahidi. | Rejesha nakala rudufu iliyothibitishwa; baki ukaguzi pekee. | Kizingiti au ripoti haiwezi kuhalalisha kukwepa urejeshaji. |

Angalia [`EVIDENCE_BOUNDARY.md`](MPAKA_WA_USHAHIDI.md), [`ARCHITECTURE.md`](USANIFU.md), na [`SOURCE_MODULE_REFERENCE.md`](MAREJELEO_YA_MODULI_YA_CHANZO.md).
