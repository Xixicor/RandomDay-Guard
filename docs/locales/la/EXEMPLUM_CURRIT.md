<a id="worked-operation-examples"></a>
#  Operandi exempla

> **Canonicum Anglicum fontem:** [EXAMPLE_RUNS.md](../../EXAMPLE_RUNS.md).  Haec documenta localia mandata exacta, semitas, claves, valores, hashes, nomina fasciculi conservat. Si forma technica differt, fonte Anglico utere.


 Haec exempla utuntur bonis inventis ad explicandas status transitus expectatos; non vivant convenientiam nec testimonium lusoris sunt.

<a id="successful-current-cycle"></a>
## Felix current cyclus

Inputs: logable activorum, version/boot/epoch, `poll_id=41`, completo currenti poll, writableaccounting/history/report radices non claudunt consilium tardum.

Expectatur:

```text
server_status = full
player_activity = full or limited_expected_empty
case_review = full or limited_expected_empty
daily_rollup = full or limited_expected_empty
critical_guard = full or limited_expected_empty
```

Quaevis itineris capacitas habet JSON/TXT output et eiusdem generis in `route_proof.json`. Status itineris a suis subditis dependet, non nuntius successu generico.

<a id="expected-empty-player-and-case-routes"></a>
## ludio inanis exspectatus et casus itinera

Inputs: probatio-cycli currentis plena est; nulla vena vel retenta ordines ludio ludius; nulla retenta causa nec vena REVIEW/BAN-ELIGIBLE propter.

Expectatur:

```text
player_activity.route_proof_status = limited_expected_empty
player_activity.expected_empty = true
player_activity.players = []

case_review.route_proof_status = limited_expected_empty
case_review.expected_empty = true
case_review.cases = []
```

Renuntiationes translatae dicunt nullum subiectum eligi finitum observatum esse. Dicunt etiam hoc non probare neminem umquam coniunctum vel nullum contextum deesse. Nullus placeholder player/case creatur.

<a id="partial-bounded-scan"></a>
## scan parte partialis terminata

Inputs: recens vena log/poll; `scan_checkpoint.json` vel `scan_progress.json` exstat; scan est imperfecta; default `slow_world_scan_blocks_current_reports=false`.

Expectatur:

```text
world_save_scan.status = partial
source accounting = partial
server_status may still be full for fresh current state
historical routes name the scan limitation
```

Set `slow_world_scan_blocks_current_reports=true` tantum cum operator velit fontem tardum ad libitum intercludere nuntia. Recuperatio est permittere laboranti scandere, non LAPIS delere.

<a id="missing-current-cycle-proof"></a>
## Desunt documenti currentis-cycli

Inputs: Log active unavailable, `poll_id=0`, vel boot/epoch/last-pollgenus deest.

Expectatur:

```text
current_cycle_proof_complete = false
all route proof statuses = missing
each configured route envelope status = suppressed_current_cycle
delivery_eligible = false
delivery_attempted = false
```

Involucrum suppressum est recordatio computorum, non partus amet. Vetera omnia ultima tantum historica manent. Reparare primum absentis lineage/sourceagro et novum cyclum generant.

<a id="malformed-optional-adminini-source"></a>
## Deformes ad libitum Admin.ini

Inputs: `Admin.ini`est sed sanatio structurae purae deficit.

Expectatur:

```text
admin_ini.status = malformed
source reference preserved
write/enforcement path closed
```

Tabellam conserva et probatam formam mundam restitue. Serva textum explanatorium in runtime testimoniis; quisque `Admin.ini` introitus banni tantum remanet `BannedPlayer=<ID>`.

<a id="required-active-log-probe-error"></a>
## requiritur activum-logum specillum erroris

Inputs: saeptum inquisitum activum-logum specillum non sanitized cum errore legitur.

Expectatur:

```text
source_accounting.sources[active_log].status = error
source_accounting.sources[active_log].detail = "bounded active-log probe failed: <sanitized reason>"
coverage_status = unavailable
all route proof statuses = missing
```

`error` remanet in fonte versu cum suis terminatis. In summo gradu fama utitur `unavailable`, et probatio itineris `missing` usque ad novum cyclum currentem probat requisitum principium.

<a id="incompatible-or-stale-baseline"></a>
## Incompatible vel stativa baseline

Inputs: mutata package/sourceidentitatis vel stale/incompatible baseline manifesta.

Expectatur: convalidatio seu status runtim incompatibilitas memorat; scan status non petit reuse perficitur. Praevia probationes servate, baseline explicite reaedificate, et novam probationem terminalem expecta. Coactus aedificandi sine causa memoriae non est defectus recuperandi.

<a id="paired-report-write-failure"></a>
## Paired fama scribe defectum

Inputs: JSON scribunt succedit sed TXT scribendo deficit, aut vicissim.

Expectatur:

```text
route_proof_status = missing
completed = false
coverage_status = unavailable
output_write_detail = "paired JSON/TXT write failed: <sanitized reason>"
next_action = repair both route output writes
```

Scriptor optimus conatus rescribens utrumque siblings ad defectum tendunt. Unus frater felix manere non potest ut successus petat. Finita scribere detail non efficit quintus top-gradus coverage valorem.

<a id="route-proof-write-failure"></a>
## Route-probationis scribe defectum

Inputs: Iter paria scripta sunt sed `route_proof.json`reponi non potest.

Expectatur: omnes rumores revocentur `missing`, omnes eventus notificationes sunt `route_proof_write_failed`, et involucrum nullum accipitur. Conformatus iter habere potest `suppressed_current_cycle` audit involucrum cum vexillis traditionis falsum. Reparare radicem output et regenerare eundem currentem cursum.

<a id="review-only-enforcement-example"></a>
## Recognosce solum exigendi exemplum

Config:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

Expectata: pereuntis, casus, et commendationes scribi possunt; `Admin.ini` non mutatur. Hic est default publicus.

<a id="approved-write-success-example"></a>
## Approbata victoria exemplum scribe

Solus probatus probatus solus omnes tres virgas scribere potest. Probet etiam identitatem numerorum puram probare, trust/moderator exclusio, limina eligibility, valida Admin.ini path/parse

Expectatur:

```text
runtime/backups/Admin_<timestamp>_<source-fingerprint>_<clean-ID>.ini
Admin.ini contains one clean BannedPlayer=<ID>
runtime/enforced_bans.jsonl and evidence mirror record success
```

Felix exemplum non dat necessitatem latae sententiae ad alias rationes.

<a id="writereadback-failure-with-rollback"></a>
## Write/readback defectus cum reverti

Inputs: praevia scribe porta transierunt; repositum scribere vel readback deficit; `rollback_on_readback_failure=true` et verificatum tergum praesto est.

Expectata: defectum documentorum scaenam et `rollback_success`; the original Admin.ini bytes restituuntur ac ratio non relata feliciter urgetur. Si reverti quoque deficit, vetas scribens, utrumque serva files/evidence et manually recipias ex tergum.

<a id="local-outbox-example"></a>
## Locus outbox example

Inputs: notitia enabled in `local_file_outbox`modo, viae para, peractae itineris probationis, et vel `full` vel expresse permissa expectata vacua.

Expectata involucro:

```text
schema = randomdayguard.notification/v1
completed_output = true
status = ready_for_local_consumer
delivery_eligible = true
delivery_backend = none
delivery_attempted = false
```

For missing/ineligible output, eandem viam fortasse potius contineat `status=suppressed_current_cycle`, `completed_output=false`, et `delivery_eligible=false`. Aut fasciculus loci scribendo solum probat. Nullus provisor, transportatio, traditio, vel acceptio legitur fasciculata vel inferri.

Vide[`OUTPUT_SCHEMA_REFERENCE.md`](OUTPUT_SCHEMA_REFERENCE.md), [`CONFIG_FIELD_CATALOG.md`](CONFIG_FIELD_CATALOGUE.md), et [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md).
