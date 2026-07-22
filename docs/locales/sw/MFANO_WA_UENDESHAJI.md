<a id="worked-operation-examples"></a>
# Mifano ya operesheni iliyofanya kazi

> **Chanzo cha Kiingereza cha Canonical:** [EXAMPLE_RUNS.md](../../EXAMPLE_RUNS.md). Hati hizi zilizojanibishwa huhifadhi amri kamili, njia, funguo, thamani za hali, heshi na majina ya faili. Ikiwa maneno ya kiufundi yanatofautiana, tumia chanzo cha Kiingereza.


Mifano hii hutumia thamani zilizovumbuliwa kuelezea mabadiliko ya hali yanayotarajiwa; si utangamano wa moja kwa moja au ushahidi wa mchezaji.

<a id="successful-current-cycle"></a>
## Mzunguko wa sasa uliofaulu

Ingizo: kumbukumbu amilifu inayoweza kusomeka, version/boot/epoch, `poll_id=41`, kura ya maoni iliyokamilika, inayoweza kuandikwa accounting/history/report mizizi, hakuna sera ya kuzuia ya kuchanganua polepole.

Inatarajiwa:

```text
server_status = full
player_activity = full or limited_expected_empty
case_review = full or limited_expected_empty
daily_rollup = full or limited_expected_empty
critical_guard = full or limited_expected_empty
```

Kila njia iliyowezeshwa ina JSON/TXT pato na ukoo sawa katika `route_proof.json`. Hali ya njia inategemea mada zake, si ujumbe wa mafanikio wa jumla.

<a id="expected-empty-player-and-case-routes"></a>
## Kichezaji tupu na njia za kesi

Ingizo: uthibitisho wa mzunguko wa sasa umekamilika; hakuna safu za sasa au zilizobaki za wachezaji; hakuna kesi iliyobaki na hakuna ya sasa REVIEW/BAN-ELIGIBLE akaunti.

Inatarajiwa:

```text
player_activity.route_proof_status = limited_expected_empty
player_activity.expected_empty = true
player_activity.players = []

case_review.route_proof_status = limited_expected_empty
case_review.expected_empty = true
case_review.cases = []
```

Ripoti zilizotafsiriwa zinasema kwamba hakuna somo lenye mipaka linalostahiki lililozingatiwa. Pia wanasema hii haidhibitishi hakuna mtu aliyewahi kushikamana au kwamba hakuna muktadha unaokosekana. Hakuna kishika nafasi player/case imeundwa.

<a id="partial-bounded-scan"></a>
## Uchanganuzi wenye mipaka kwa kiasi

Ingizo: mkondo mpya log/poll; `scan_checkpoint.json` au `scan_progress.json` ipo; scan haijakamilika; chaguo-msingi `slow_world_scan_blocks_current_reports=false`.

Inatarajiwa:

```text
world_save_scan.status = partial
source accounting = partial
server_status may still be full for fresh current state
historical routes name the scan limitation
```

Weka `slow_world_scan_blocks_current_reports=true` pale tu opereta anapotaka chanzo hicho cha polepole kuzuia ripoti za sasa. Urejeshaji ni kuruhusu mfanyakazi wa kuchanganua kuanza tena, si kufuta kituo cha ukaguzi.

<a id="missing-current-cycle-proof"></a>
## Uthibitisho wa mzunguko wa sasa haupo

Ingizo: kumbukumbu amilifu haipatikani, `poll_id=0`, au boot/epoch/last-poll ukoo haupo.

Inatarajiwa:

```text
current_cycle_proof_complete = false
all route proof statuses = missing
each configured route envelope status = suppressed_current_cycle
delivery_eligible = false
delivery_attempted = false
```

Bahasha iliyokandamizwa ni rekodi ya ukaguzi, si uwasilishaji wa foleni. Kumbukumbu za zamani za mwisho zinabaki kuwa za kihistoria pekee. Rekebisha ya kwanza kukosa lineage/source shamba na uzalishe mzunguko mpya zaidi.

<a id="malformed-optional-adminini-source"></a>
## Hiari yenye hitilafu Admin.ini chanzo

Ingizo: `Admin.ini` ipo lakini inashindwa uthibitishaji safi wa muundo.

Inatarajiwa:

```text
admin_ini.status = malformed
source reference preserved
write/enforcement path closed
```

Hifadhi faili na urejeshe umbizo safi lililokaguliwa. Weka maandishi ya maelezo katika ushahidi wa wakati wa kukimbia; kila `Admin.ini` ingizo la kupiga marufuku linasalia tu `BannedPlayer=<ID>`.

<a id="required-active-log-probe-error"></a>
## Hitilafu inahitajika ya uchunguzi wa kumbukumbu-amilifu

Ingizo: uchunguzi wa kumbukumbu-amilifu uliopakana unaohitajika haufaulu kwa hitilafu ya kusoma iliyosafishwa.

Inatarajiwa:

```text
source_accounting.sources[active_log].status = error
source_accounting.sources[active_log].detail = "bounded active-log probe failed: <sanitized reason>"
coverage_status = unavailable
all route proof statuses = missing
```

`error` inasalia kwenye safu mlalo ya chanzo na maelezo yake yenye mipaka. Ripoti ya kiwango cha juu hutumia `unavailable`, na uthibitisho wa njia unabaki `missing` hadi mzunguko mpya wa sasa uthibitishe chanzo kinachohitajika.

<a id="incompatible-or-stale-baseline"></a>
## Msingi wa msingi usiolingana au uliochakaa

Ingizo: zimebadilishwa package/source utambulisho au stale/incompatible faili ya maelezo ya msingi.

Inatarajiwa: hali ya uthibitishaji au wakati wa utekelezaji hurekodi kutopatana; hali ya skanisho haidai kukamilika kwa matumizi tena. Hifadhi ushahidi wa awali, anza muundo wa msingi ulio wazi, na usubiri uthibitisho mpya wa mwisho. Uundaji upya wa kulazimishwa bila sababu iliyorekodiwa sio urejeshaji chaguomsingi.

<a id="paired-report-write-failure"></a>
## Imeshindwa kuandika ripoti iliyooanishwa

Ingizo: JSON kuandika kunafaulu lakini TXT kuandika kumeshindwa, au kinyume.

Inatarajiwa:

```text
route_proof_status = missing
completed = false
coverage_status = unavailable
output_write_detail = "paired JSON/TXT write failed: <sanitized reason>"
next_action = repair both route output writes
```

Juhudi bora ya mwandishi huwaandikia upya ndugu na dada wote wawili ili kukutana na kushindwa. Ndugu mmoja aliyefanikiwa hawezi kubaki kama dai la mafanikio. Maelezo ya maandishi yaliyowekewa mipaka hayaundi thamani ya chanjo ya kiwango cha tano cha juu.

<a id="route-proof-write-failure"></a>
## Imeshindwa kuandika kuthibitisha njia

Ingizo: jozi za njia ziliandikwa lakini `route_proof.json` haiwezi kubadilishwa.

Inatarajiwa: ripoti zote zimeandikwa upya `missing`, matokeo yote ya arifa ni `route_proof_write_failed`, na hakuna bahasha inayokubaliwa. Njia iliyosanidiwa inaweza kuwa na `suppressed_current_cycle` kagua bahasha yenye alama za uwasilishaji si za kweli. Rekebisha mzizi wa pato na uzae upya mzunguko ule ule wa sasa.

<a id="review-only-enforcement-example"></a>
## Mfano wa utekelezaji wa ukaguzi pekee

Sanidi:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

Inatarajiwa: alama, matukio, na mapendekezo yanaweza kuandikwa; `Admin.ini` bado haijabadilishwa. Hii ndiyo chaguomsingi ya umma.

<a id="approved-write-success-example"></a>
## Mfano wa mafanikio ya uandishi ulioidhinishwa

Jaribio lililoidhinishwa tofauti pekee ndilo linaloweza kuweka swichi zote tatu za kuandika. Lazima pia ithibitishe utambulisho safi wa nambari, trust/moderator kutengwa, ustahiki wa kiwango cha juu, halali Admin.ini path/parse, mafanikio ya kuhifadhi nakala, mafanikio ya kuandika, usawa wa kusoma tena, na ushahidi mahususi wa akaunti.

Inatarajiwa:

```text
runtime/backups/Admin_<timestamp>_<source-fingerprint>_<clean-ID>.ini
Admin.ini contains one clean BannedPlayer=<ID>
runtime/enforced_bans.jsonl and evidence mirror record success
```

Mfano uliofaulu hauwashi utekelezaji kiotomatiki kwa akaunti zingine.

<a id="writereadback-failure-with-rollback"></a>
## Write/readback kushindwa kwa kurejesha

Ingizo: kila lango la kuandika mapema limepitishwa; uandishi wa uingizwaji au usomaji umeshindwa; `rollback_on_readback_failure=true` na nakala rudufu iliyothibitishwa inapatikana.

Inatarajiwa: ushahidi wa kushindwa hurekodi hatua na `rollback_success`; asili Admin.ini byte zimerejeshwa na akaunti haijaripotiwa kama imetekelezwa. Ikiwa urejeshaji pia haufaulu, acha kuandika, hifadhi zote mbili files/evidence, na upate nafuu wewe mwenyewe kutoka kwa hifadhi rudufu.

<a id="local-outbox-example"></a>
## Mfano wa kikasha toezi cha ndani

Ingizo: arifa imewezeshwa katika `local_file_outbox` modi, njia imewashwa, uthibitisho wa njia uliokamilika, na ama `full` au inaruhusiwa kwa uwazi inayotarajiwa-tupu.

Bahasha inayotarajiwa:

```text
schema = randomdayguard.notification/v1
completed_output = true
status = ready_for_local_consumer
delivery_eligible = true
delivery_backend = none
delivery_attempted = false
```

Kwa missing/ineligible pato, njia sawa badala yake inaweza kuwa na `status=suppressed_current_cycle`, `completed_output=false`, na `delivery_eligible=false`. Faili yoyote inathibitisha maandishi ya ndani pekee. Hakuna mtoa huduma, usafiri, uwasilishaji, au risiti iliyosomwa iliyounganishwa au kukisiwa.

Angalia [`OUTPUT_SCHEMA_REFERENCE.md`](REJELEO_LA_UTARATIBU_WA_PATO.md), [`CONFIG_FIELD_CATALOG.md`](CONFIG_SHAMBA_KATALOGI.md), na [`TROUBLESHOOTING.md`](UTATUZI_WA_MATATIZO.md).
