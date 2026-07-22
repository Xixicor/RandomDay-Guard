<a id="status-and-error-reference"></a>
# Marejeleo ya hali na makosa

> **Chanzo cha Kiingereza cha Canonical:** [STATUS_AND_ERROR_REFERENCE.md](../../STATUS_AND_ERROR_REFERENCE.md). Hati hizi zilizojanibishwa huhifadhi amri kamili, njia, funguo, thamani za hali, heshi na majina ya faili. Ikiwa maneno ya kiufundi yanatofautiana, tumia chanzo cha Kiingereza.


Tumia marejeleo haya baada ya dalili kuainishwa katika[Utatuzi wa matatizo](UTATUZI_WA_MATATIZO.md). Soma faili ya hali iliyopangwa iliyopewa jina la hitilafu. Nambari tofauti zinawakilisha hali tofauti za usalama na mzunguko wa maisha; usizivinje katika tokeo la jumla la "Walinzi wameshindwa".

<a id="route-and-source-states"></a>
## Njia na hali chanzo

| Thamani | Maana | Jibu la Opereta |
|---|---|---|
| `full` | Mkataba wa njia umekamilika kwa uthibitisho wa chanzo wa mzunguko wa sasa. | Soma mpaka wa ushahidi wa njia; hakuna ukarabati unaodokezwa. |
| `limited_expected_empty` | Njia imekamilika na shughuli inayokosekana ni halali kwa mzunguko huu. | Hakuna sintetiki player/case tukio linapaswa kuundwa. |
| `missing` | Pato linalohitajika, sehemu ya ukoo au uthibitisho wa chanzo haupo. | Kagua sababu ya njia na hali ya chanzo iliyopewa jina. |
| `available` | Chanzo kilichotajwa kiliweza kusomeka na kutumika. | Hakuna kitendo. |
| `expected_empty` | Chanzo kiliangaliwa na hakikuwa na safu mlalo kihalali. | Hakuna hatua isipokuwa shughuli ilitarajiwa kwa kujitegemea. |
| `partial` / `complete_with_gaps` | Ushahidi unaoweza kutumika upo, lakini madarasa ya chanzo yaliyotajwa hayajakamilika. | Punguza hitimisho kwa ushahidi uliokusanywa. |
| `deferred` | Kazi iliyounganishwa imeratibiwa kwa fursa ya baadaye ya mfanyakazi. | Thibitisha maendeleo kabla ya kubadilisha usanidi. |
| `unavailable` | Mazingira hayakutoa chanzo. | Rekodi kikomo; rekebisha tu njia iliyothibitishwa au suala la ruhusa. |
| `malformed` | Chanzo kilikuwa kinasomeka lakini hakikuweza kuthibitishwa muundo. | Ihifadhi na urekebishe chanzo; usikisie. |
| `permission_denied` | Chanzo kipo lakini hakijaweza kusomeka. | Toa ruhusa finyu tu inayohitajika ya kusoma. |
| `error` | Mkusanyiko umeshindwa kwa sababu iliyorekodiwa. | Hifadhi hitilafu na utambue hatua hiyo. |

<a id="playerdata-and-inventory-codes"></a>
## PlayerData na misimbo ya orodha

| Msimbo | Maana | Jibu salama |
|---|---|---|
| `saved_root_unavailable` | Hakuna mizizi iliyothibitishwa iliyohifadhiwa inayopatikana kwa bomba la umma. | Sahihi `SavedRoot.txt` na uangalie upya uchunguzi wa njia. |
| `unsafe_playerdata_root` | PlayerDataugunduzi umetatuliwa nje ya mzizi uliowekwa uliohifadhiwa. | Rekebisha njia; usiwahi kudhoofisha mpaka. |
| `playerdata_discovery_not_run` | Mfanyakazi wa ugunduzi mwenye mipaka bado hajafanya kazi. | Angalia kiratibu na maendeleo ya mfanyakazi. |
| `playerdata_discovery_read_failed:*` | Toleo la ugunduzi halikuweza kusomeka. | Hifadhi maelezo ya kiambishi na uthibitishe amri ya hesabu yenye mipaka. |
| `inventory_command_open_failed` | Mchakato wa hesabu haukuweza kuanzishwa. | Thibitisha muda wa utekelezaji unatoa daraja la amri lililowekwa. |
| `inventory_command_read_failed` | Utoaji wa hesabu haukufaulu wakati wa kusoma. | Hifadhi sehemu ya matokeo na utekeleze upya tu baada ya hitilafu ya msingi kurekebishwa. |
| `inventory_command_close_failed` | Mali imekamilika bila matokeo ya karibu ya kuaminika. | Chukua chanzo kama hakijakamilika. |
| `identity_ledger_row_limit_exceeded` | Ingizo la utambulisho linalodumu limevuka mipaka yake ya usalama wa umma. | Hifadhi na ukague daftari; usiipunguze kimya kimya kuwa uthibitisho kamili. |

<a id="adminini-enforcement-codes"></a>
## Admin.ini misimbo ya utekelezaji

Misimbo yote katika sehemu hii imefungwa kwa kushindwa. Hawatoi idhini ya kupiga marufuku wenyewe.

| Msimbo | Maana | Jibu salama |
|---|---|---|
| `admin_ini_write_disabled` / `admin_ini_disabled` | Milango ya uandishi salama kwa Umma imezimwa. | Inatarajiwa katika operesheni ya ukaguzi pekee. |
| `admin_ini_backup_disabled` / `backup_safety_gate_disabled` | Sera ya kuhifadhi nakala inayohitajika haifanyiki. | Kipengele cha kuweka maandishi kimezimwa. |
| `enforcement_disabled` / `ban_on_threshold_disabled` / `auto_ban_disabled` | Lango moja dhahiri la utekelezaji limezimwa. | Inatarajiwa katika chaguomsingi za ukaguzi wa umma pekee; usiifasiri upya kama kushindwa kuandika. |
| `review_only_mode_enabled` | Hali ya kukagua pekee huzuia mabadiliko kimakusudi. | Kagua ushahidi pekee. |
| `duplicate_prevention_disabled` | Ulinzi wa nakala umezimwa. | Weka kuandika kwa kuzimwa hadi lango la usalama lirejeshwe. |
| `readback_safety_gate_disabled` / `rollback_safety_gate_disabled` | Uthibitishaji baada ya kuandika au ulinzi wa kurejesha nyuma umezimwa. | Kipengele cha kuweka maandishi kimezimwa; usiwahi kupita malango haya. |
| `clean_id_safety_gate_disabled` / `account_specific_evidence_gate_disabled` | Kitambulisho safi au utekelezaji wa ushahidi wa akaunti mahususi umezimwa. | Rejesha lango kabla ya jaribio lolote la utekelezaji. |
| `moderator_preservation_disabled` / `existing_ban_preservation_disabled` | Akaunti-iliyolindwa au uhifadhi wa marufuku uliopo umezimwa. | Kipengele cha kuweka maandishi kimezimwa. |
| `clean_numeric_identity_required` | Kitambulisho kilichopendekezwa si fomu kamili ya muunganisho inayokubalika au kitambulisho safi cha nambari. | Pata ramani iliyothibitishwa; usiwahi kupunguza kiambishi holela. |
| `identity_strength_below_minimum` | Ushahidi wa utambulisho ni dhaifu kuliko kiwango kilichowekwa. | Kagua ushahidi pekee. |
| `playerdata_verification_required` | Usanidi unahitaji PlayerDatauthibitisho na akaunti haina. | Weka uhakiki wa mgombea pekee; usichukulie umiliki kutoka kwa jina la faili. |
| `trusted_or_moderator_identity` | Akaunti inalindwa na hali inayoaminika au msimamizi. | Hakuna uandishi unaoruhusiwa. |
| `admin_ini_path_invalid` / `admin_ini_path_outside_saved_root` | Njia inayolengwa ni batili au inaepuka mzizi Uliohifadhiwa. | Usanidi sahihi; usiwahi kupita walinzi wa njia. |
| `admin_ini_unavailable` | Hakuna isomeka iliyosanidiwa Admin.ini ilipatikana ndani ya mizizi Iliyohifadhiwa. | Rekebisha njia iliyo na mipaka au zuia utekelezaji. |
| `admin_ini_read_failed` | Baiti zinazoidhinishwa hazikuweza kusomeka. | Simama kabla ya mabadiliko. |
| `admin_ini_parse_failed` | Admin.ini uthibitishaji umeshindwa bila msimbo mahususi zaidi wa muundo. | Hifadhi faili na ukague sehemu yake na muundo wa mstari. |
| `admin_ini_contains_nul` | Faili ina NUL byte na haikubaliwi kama maandishi. | Hifadhi faili na uirekebishe nje ya Walinzi. |
| `admin_ini_duplicate_banned_players_section` | Zaidi ya moja `[BannedPlayers]`sehemu ipo. | Unganisha sehemu mwenyewe ukiwa umesimamishwa. |
| `admin_ini_banned_player_outside_section` | Safu mlalo ya kupiga marufuku inaonekana nje `[BannedPlayers]`. | Rekebisha mpangilio wewe mwenyewe. |
| `admin_ini_invalid_banned_player_line` | Mstari wa kupiga marufuku si safu mlalo safi ya kitambulisho inayotumika. | Rekebisha laini iliyoharibika. |
| `admin_ini_backup_failed` | Hifadhi mbadala ya kipekee haikuandika na kusoma kwa njia ifananayo. | Hakuna ubadilishaji unaoruhusiwa. |
| `admin_ini_external_change_detected` | Mwandishi mwingine alibadilisha faili baada ya picha ya Walinzi. | Hifadhi baiti za nje na ujaribu tena baada ya kuratibu waandishi. |
| `atomic_rename_unavailable` | Ubadilishaji wa atomiki uliombwa lakini Lua haikutoa `os.rename`. | Hakuna uandishi unaoaminika; tumia muda wa utekelezaji unaotumika au zuia utekelezaji. |
| `admin_ini_write_failed` | Ubadilishaji unaodhibitiwa haukukamilika. | Kagua hitilafu ya uingizwaji iliyorekodiwa na chelezo. |
| `post_write_verification_failed` | Baiti za utayarishaji hazikuwa sawa na mgombea. | Angalia `rollback_success` na `rollback_refused_external_change` kabla ya kitendo chochote. |

<a id="startup-scheduler-and-backlog-states"></a>
## Hali za kuanzisha, kipanga ratiba na kumbukumbu

Thamani hizi ni ushahidi wa mzunguko wa maisha, si uthibitisho wa njia. Zisome pamoja na kura ya maoni ya sasa, mfanyakazi wa ripoti na faili zisizo na njia.

| Thamani | Maana | Jibu salama |
|---|---|---|
| `not_started` | Hatua ya kuanza au ya kiratibu iliyotajwa haijaanza. | Wakati wa uzinduzi, subiri muda ulioandikwa; kisha kagua awamu ya kwanza ambayo haijabadilika. |
| `main_lua_loaded` / `starting` | Kipakiaji kanuni kilifanya kazi na Walinzi wakaanzisha programu. | Endelea hadi awamu za baadaye; hii pekee si utayari. |
| `saved_root_found` / `log_tail_initialized` / `epoch_started` | Uanzishaji wa chanzo kikuu na mwendelezo umeboreshwa. | Hakuna hatua isipokuwa awamu inayofuata itaacha kuendelea. |
| `admin_state_written` / `playerdata_index_written` | Faharasa zilizo na mipaka za awali zilihamishwa. | Hakuna kitendo; makabidhiano ya kiratibu lazima bado yafuate. |
| `watchdog_started` | Ripoti na walinzi wa kura walisajiliwa. | Thibitisha kiratibu na upigaji kura unaendelea. |
| `ready_degraded` / `scan_running` | Mlinzi anafanya kazi huku uchunguzi wa kihistoria wenye mipaka unasubiri. | Tahadhari, si kushindwa; thibitisha vihesabu vya maendeleo mapema. |
| `ready` | Anzisha na uchanganuzi wa sasa wenye mipaka umefikia hali tayari. | Angalia uthibitisho wa njia kando. |
| `scan_failed` / `error` | Anzisha au uchanganuzi umekatizwa kwa hitilafu iliyorekodiwa. | Hifadhi hitilafu iliyotajwa au faili ya hali na utambue hatua hiyo. |
| `running` | Mratibu anamiliki fursa za kura za baadaye. | Thibitisha `poll_id` na `poll_completed_count` advance. |
| `manual_only` | Upangaji wa kitanzi haukupatikana; kazi ya wazi pekee ndiyo inaweza kufanya kazi. | Chukua utendakazi usiotunzwa kama haupatikani. |
| `stopped` | Operesheni ya kiratibu imekamilika. | Kagua komesha lililotangulia na ushahidi wa hitilafu kabla ya kuwasha upya. |
| `active_log_caught_up` | Hakuna kumbukumbu amilifu ambayo haijasomwa iliyosalia. | Uchanganuzi wa kihistoria unaweza kuendelea. |
| `active_log_unavailable_nonblocking` | Kumbukumbu inayotumika haikuwepo, lakini uanzishaji ulibaki bila kizuizi. | Rekodi kikomo cha chanzo na uthibitishe vyanzo vingine. |
| `active_log_read_failed` | Kumbukumbu inayotumika ilikuwepo lakini haikuweza kusomeka. | Hifadhi hitilafu na urekebishe njia iliyothibitishwa au suala la ruhusa pekee. |
| `budget_exhausted` / `active_log_has_unread_bytes` | Nyimbo ya mkia iliyo na mipaka ilisimamishwa na kumbukumbu iliyosalia. | Thibitisha kura za baadaye hupunguza idadi ambayo haijasomwa. |
| `offset_commit_failed_after_events_applied` | Matukio yalichakatwa lakini ung'ang'anizi wa kukabiliana na kumbukumbu umeshindwa. | Utekelezaji umeahirishwa; rekebisha hifadhi ya kuhitimisha kabla ya kutegemea mzunguko mwingine. |

<a id="scheduler-report-and-notification-codes"></a>
## Kiratibu, ripoti na misimbo ya arifa

| Msimbo au hali | Maana | Jibu salama |
|---|---|---|
| `poll already in flight` | Piga simu ya pili ilifika huku kura ya maoni ya sasa ikimiliki mzunguko wa maisha. | Thibitisha maendeleo yaliyopo ya kura; usiongeze mmiliki mwingine wa kitanzi. |
| `no_log_files_found` | Hakuna kumbukumbu inayotumika au chelezo iliyosanidiwa iliyogunduliwa. | Thibitisha usanidi wa mizizi na chanzo uliohifadhiwa. |
| `current_poll_error` | Mzunguko wa sasa ulirekodi kushindwa kwa chanzo cha kura. | Soma `runtime/current/poll_error.json`. |
| `cadence_deferred` | Kisambazaji cha kukamilisha bado hakijakamilika. | Inatarajiwa hadi fursa inayofuata yenye mipaka. |
| `reports_disabled` | Uzalishaji wa ripoti ya umma umezimwa. | Washa ikiwa ripoti zimekusudiwa pekee. |
| `local_outbox_write_failed` | Bahasha ya ndani iliyotafsiriwa haikuweza kuandikwa. | Rekebisha saraka ya towe ya wakati wa utekelezaji; hii si hitilafu ya usafiri wa arifa. |
| `source_accounting_disabled` | Uthibitisho wa njia hauwezi kudai ufikiaji kamili wa chanzo. | Washa uhasibu chanzo au ukubali uthibitisho unaokosekana kwa uwazi. |
| `route_disabled` | Njia imezimwa kimakusudi. | Hakuna uwasilishaji unaotarajiwa kwa njia hiyo. |
| `poll_owner_between_polls` | Mfanyakazi wa ripoti yuko kwenye foleni ya pengo linalomilikiwa na kiratibu kati ya kura. | Inatarajiwa pekee wakati mihuri ya muda na vielekezi vikiendelea kusonga mbele. |
| `unsafe_shell_path` | Orodha yenye mipaka au njia ya ganda imeshindwa uthibitishaji wa mfumo salama. | Rekebisha njia; usiwahi kudhoofisha nukuu au uthibitishaji wa njia. |

<a id="related-procedures"></a>
## Taratibu zinazohusiana

- [Utatuzi wa matatizo](UTATUZI_WA_MATATIZO.md) kwa uainishaji na ukarabati wa dalili.
- [Uthibitishaji na uchapishaji wa ukaguzi](UTHIBITISHAJI_NA_KUTOLEWA.md) kwa urekebishaji na hitilafu za kifurushi.
- [Rejeleo la taratibu za pato](REJELEO_LA_UTARATIBU_WA_PATO.md) kwa kandarasi kamili za uga.
