<a id="architecture-and-lifecycle"></a>
# Architectura et lifecycle

> **Canonicum Anglicum fontem:** [ARCHITECTURE.md](../../ARCHITECTURE.md).  Haec documenta localia mandata exacta, semitas, claves, valores, hashes, nomina fasciculi conservat. Si forma technica differt, fonte Anglico utere.


RandomDayGuardunus est UE4SS vigilo plus uno modulo referens separatim. Documenta server-possessorum legit, statum localem saeptum conservat, et probationes locales scribit et outputa recensebit. Nullam habet provisorem, control-panel, notificationem, RandomDay, seu dependentia retiacula.

<a id="end-to-end-data-flow"></a>
## End-ad-finem data fluunt

1. UE4SSunum ingressum canonicum onerat`RandomDayGuard/Scripts/main.lua`. Fasciculi currentes non navem duplicatam lowercase casum variantem faciunt.
2. Logamentum legit `config.lua`, tria dictionaria data, et ad libitum `SavedRoot.txt`. Versionis identitatis consentire debet cum `VERSION`, `MANIFEST.json`, et `BUILD_MARKER.txt`.
3.  Inventionis radicis servatae notas candidatos limitatas et notas imaginum directas coercet. In `runtime/saved_path_probe.json`; inventum directorium solum non est testimonio coverage.
4.  Stratum proximum caudis activum tigillum servo e tuto cingulo. Ordinat vitam cyclum, sessionem, rationem, admonitionem, reconnect, et alia quae observata sunt in appendice solum argumenta plus currentis snapshots.
5. Tardi tabulatorum inventaria, servata fasciculi in limitibus chunkis. Scribit progressus et puncta, opus incompletum repetit, mutatum manifestam comparat et partialem deinde finalem object/world context.
6. Recensio logica tantum argumenta sibi praesto sunt. Infirma filenamia, leo, comites classis, coordinatae relativae, torquent, singulus fragor aut ping manent contextus et solum cogendi permittere non possunt.
7. A relationem vocat operarius`Scripts/public_pipeline.lua`. Inventaria originis classes, commemorat currentes versus historicos ambitus, cyclum ad version/boot/epoch/poll/source viriditatem, scribit quinque meatus specialium JSON/TXTjugis, ac deinde scribens `route_proof.json`.
8. Quibus explicite parabatur, exemplarium outbox localium indiciorum ex peracta relatione post itineris probationem exstat. Is `delivery_backend="none"` et `delivery_attempted=false`; hoc productum est extra onerariam.

<a id="ownership-and-asynchronous-boundaries"></a>
## De possessione et terminis asynchronis

| Dominus | Contentus operi | Nonne intercludere vel implicare |
|---|---|---|
| Satus | Mando, salva-radix, activum, tigillum, epocha, index, status initialis. | Felix oneratus in titulum non probat documenta vel itinera. |
| Pol callback | Novi tabulae bytes, status updates, event/session/account outputs, scheduling. | Tardus inventio seu fama recursiva residuis. |
| Scan operarius | Manifesta inventio, fasciculus parsing, checkpoint, partial/final baseline. | Vena stipes progressus; partialis non est deficiendi. |
| Report opifex | Source accounting, translation, report pairs, route proof, local outbox. | Exactio seu traditio externa. |
| libitum libitum |  Rationem confirma et ustulo, rationes creditas protege et duplicata, tergum comproba, extra tabella mutationes reice, proventum servatum comproba. | A relatione score, status itineris, vel casus adiunctio praetermittens quaelibet salus reprehendo. |

Sacramentorum ansa tantum dum `poll_id`procedit, `poll_in_flight` falsum redit, et scheduling activa manet. Quod probat componentis, non pipeline fama. Tardus scans sit `partial` vel `deferred`; per default `slow_world_scan_blocks_current_reports=false` novas vias pro- currentes permittit limitationem historicam nominans.

<a id="state-and-lifecycle"></a>
## Statu et vita

| State | Ingressus | Terminalis vel proximus status | Error et recuperatio |
|---|---|---|---|
| Satus | UE4SS oneratus invocat. | Currens poll/scan/report | `startup_error` notae criticae in promptu sunt; reparare config/path/source et sileo. |
| Current poll | Scheduled terminatum callback incipit. | Completus capitum monumentorum indicatione et reschedulae. | `poll_error` notae criticae in promptu sunt; opus limitatum restituet et novo suffragio confirmet. |
| Scan pendenti | Baseline requiritur vel LAPIS imperfecta inventa. | `partial`/`deferred`, deinde `scan_complete`. | LAPIS Proin; reficere nisi cumstale/incompatible indicio perhibetur. |
| Source accounting | Referte operariorum inventaria octo fontium classes. | `complete`, `complete_with_gaps`, `partial`, vel `unavailable`. | Disabled/failed rationes omnes itinera ad `missing`. |
| Genes itineris | Current-cycli genus et origo ratio in promptu sunt. | `full`, `limited_expected_empty`, vel `missing`. | PairedJSON/TXT`missing`. |
| Locus outbox | Iter datur, perficitur, eligitur. | Involucrum loci et notificationis status pendentium. | Nulla probatio vel incompleta scribens nullum involucrum significat; nulla traditio infertur. |
| Exactio recensionis | Account-propriis indiciis figuratum attingit notam latae sententiae. | Recognosce solum commendationem vel explicite para`Admin.ini`renovatio. | Defecit vel perpendat salutem reprehendo sistit renovatio; finalis comparatio incassum verificatum tergum restaurat cum recuperatio datur. |

<a id="current-and-historical-evidence"></a>
## Current et testimonia historica

Current testimonia ad activum boot/poll numquam restituitur ex sola filenamiorum retenta. Testimonia historica includit trabes rotatas, durabiles account/sessionhistoriae, retinuerunt cases/reports/evidence, et terminatum mundum, nisi intuens. Renuntiationes varias exponunt hodiernas et historicas vestes et comites. Sileo tranquillum silere non debet vetustatem contextus delere, ac notae historicae praesentes praesentari debent.

<a id="completion-and-recovery-boundary"></a>
## Perfectio et convaluisset terminus

Perfectio unius itineris requirit adaptationem currentis cycli versionis, tabernus ID, epocha ID, positivus capita ID, status novi activus, tum itineris outputes, et introitus in `route_proof.json`. Notification petit, praeterea eundem cyclum localem involucrum requirere; externa traditio numquam est pars publicae probationis.

Si relationes finales desunt vel antiquiorem quam currentem poll/sourcestate, perge a primo inparabili genere vel scribe incassum. Non varias vias, verba, vel occasus cogendi mutare. Vide [`OUTPUT_SCHEMA_REFERENCE.md`](OUTPUT_SCHEMA_REFERENCE.md), [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md), et [`SOURCE_MODULE_REFERENCE.md`](SOURCE_MODULE_REFERENCE.md).
