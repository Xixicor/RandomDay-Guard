<a id="troubleshooting"></a>
#  Troubleshooting

> **Canonicum Anglicum fontem:** [TROUBLESHOOTING.md](../../TROUBLESHOOTING.md).  Haec documenta localia mandata exacta, semitas, claves, valores, hashes, nomina fasciculi conservat. Si forma technica differt, fonte Anglico utere.


Hac pagina utere, cum custodia non oneret, fons colligi non potest, vel probatio non contradicit. Incipe cum decisione arborem, et sequere unum ramum. Utere dedicato [statu et errore referente](STATUS_ATQUE_ERROR_REFERENCE.md) tantum post iacuit incassum cognoscitur.

Serva current lima ante runtime configuratione aut reinstalling mutantur. Stalu vel absentis artificium scaenam fallacem agnoscit; saepe restarts delere potest quod.

<a id="choose-the-failure-path"></a>
## Elige viam defectum

<a id="1-decide-whether-guard-loaded"></a>
### 1. Decernere num onustus custodiae

- **No `runtime/` fasciculi existunt:**sequuntur[Restitue tabellas absentes runtime](#restore-missing-runtime-files). Iter verificare installum, oneratus canonicum, `enabled.txt`, et `mods.txt` antequam percontando tradit.
- **Current status imaginum exstant:**Longe satis onustus ad scribendum custodis civitatis. 2 Perge ad gradum; reinstalling non est prima responsio.

<a id="2-decide-whether-the-scheduler-is-advancing"></a>
### 2. utrum accedat accedat

Open:

```text
runtime/current/startup_status.json
runtime/current/poll_status.json
```

- **Res et indicationes antecessum:** pergo ad 3.
- **`poll_id` stat, `poll_in_flight` verum manet, seu status scheduler non currit:**sequuntur[Recipe adhæsit poll fasciam](#recover-a-stuck-poll-loop).
- **Baseline scan pendet dum progressus scheduler pergit:**Haec cautio est, non automatice initium fallit. Investigare tantum si cessat progressus backlog vel scan.

<a id="3-classify-route-proof"></a>
### 3. Indicate iter probationem

Open `runtime/final_logs/route_proof.json` et singula itinera singula separatim inspicias.

- **`full`:** inexspectata verba cum currenti compara `source_references` et prosapiam. Noli partum mutare, quod scriptum solum nefas spectat.
- **`limited_expected_empty`:** confirmatur fons rationis subsidia legitimum inane exitum. Noli creare syntheticum ludio ludius vel casus.
- **`missing`:**sequuntur[Diagnose iter absentis](#diagnose-a-missing-route).

<a id="4-classify-source-coverage"></a>
### 4. Indicate fontem coverage

- **`partial`, `deferred`, `unavailable`, `malformed`, `permission_denied`, vel `error`:**sequuntur[Interpretare incompletum fontem coverage](#interpret-incomplete-source-coverage), vide codicem accuratum in [Status et error referuntur](STATUS_ATQUE_ERROR_REFERENCE.md).
- **Fons constructus current sed translatus vel pendens output antiquior est:** diagnose complementum handoff, non partus endpoint. Serva utrumque indicationes et famam ac litteras inspicere antequam mutato configuratione partus.

<a id="5-follow-the-matching-branch"></a>
### 5. Sequere parem rami

- identitatis imperfectae: [Mappa ludio ludius indiscreta](#map-an-unmapped-player).
- Absentis continuatio quotidiana: [Restitue absentis cotidie rollup](#restore-a-missing-daily-rollup).
- Applicte probatus cogendi test non scripsit: [Diagnose impeditum Admin.ini scribe](#diagnose-a-blocked-adminini-write).
- ZIP extraction defecit: [Resolve causam collisionem Windows extractionem](#resolve-a-windows-extraction-folder-collision).
- Fixture, involucrum, seu repositorium repositorium defecit: [ Validation et recensio emissio](VALIDATION_ET_DIMITTE.md#avoid-validation-environment-pitfalls).

<a id="6-stop-with-one-proved-outcome"></a>
### 6. Desine uno probato eventu

A fermentum transeuntium desinit cum:

- via current et `full`;
- via current et `limited_expected_empty` nominato ratione;
- unus clausor exactus, argumentorum semita, actio sequentium adnotetur; aut
- revecta priorem statum notum restituit et testimoniis incassum servavit.

"Procurator currit" pulsatio cordis increscens vel HTTPrelatum iter confectum non probat.

<a id="diagnose-a-missing-route"></a>
## Diagnose iter absentis

Open `runtime/final_logs/route_proof.json` et confer `server_status`, `daily_rollup`, `player_activity`, `case_review`, et `critical_guard`.

1. Relege rationem, genus, tempus, originem, principium indiciorum.
2. Confirmo nominatum fontem exstructum esse et ad eundem cyclum pertinet.
3. Confer mtim cum translato output et pendente involucro.
4. Si acta finalia recentiora sunt quam translati vel pendens output, litterae complementum vetustae recordarentur et primum handoff sarcirent.
5. Si omnes loci output current sed traditio abest, tum meatum configurationem ac statum mittente inspice.

Salutem scheduler noli promovere vel unam bene notificationem ad quinque-iter probationem.

<a id="interpret-incomplete-source-coverage"></a>
## Interpretare incompletum fontem coverage

| State | Quid facere |
|---|---|
| `partial` | Solummodo collectis testimoniis et cautionibus integris coverage devita. |
| `deferred` | Confirma postea opus finitum ante mutabilem configurationem. |
| `unavailable` | recordare ambitum limitis; recta tantum probatam viam aut permissio exitus. |
| `malformed` | Pac fontem et parse errorem conserva; noli divinare valores absentes. |
| `permission_denied` | Concede modo strictam licentiam legere. |
| `error` | Singulos serva et scaena nominata egritudo antequam itineris freti. |

<a id="restore-missing-runtime-files"></a>
## Restitue tabellas absentes runtime

Confirma:

```text
mods.txt contains RandomDayGuard : 1
RandomDayGuard/enabled.txt exists
RandomDayGuard/Scripts/main.lua exists
```

Recte install radix est:

```text
AbioticFactor/Binaries/Win64/ue4ss/Mods/RandomDayGuard/
```

Reiice hanc propositionem frondosam:

```text
Mods/RandomDayGuard/RandomDayGuard/Scripts/main.lua
```

Si tabellae recte sed UE4SS Cavere non incepit, serva`UE4SS.log` et eius initium indicationis cum actuali ludo-processus initio confer.

<a id="resolve-a-windows-extraction-folder-collision"></a>
## Resolve in Fenestra collectione folder

Antior emissio adhibita directoria programmatis quorum nomina tantum capitalizationis differebant. Aliquot Windows extractores nomina illa confundunt cum ZIP praeponitur folder existens.

1. Delere tantum infaustum extractionem temporalem, non inauguratum vel eius testimonium.
2. Create novum presul inane temporale.
3. Extract emissio hodiernam ibi.
4. Confirmo unum producitRandomDayGuard folder et unum directorium programmatis.
5. Si collisionem Fenestra adhuc refert, missionem iterum remitte et nuntia emissionem versionis et extractoris adhibitam.

Numquam novam emissionem extrahere in folder inauguratus. Sequere modum renovationis mundanae folder in [`../INSTALL.md`](INSTALLATION.md).

<a id="load-the-expected-version"></a>
## Load versionem exspectatam

Reprehende fontem titulum et titulum aedifica:

```sh
grep -n "local VERSION" RandomDayGuard/Scripts/main.lua
cat RandomDayGuard/BUILD_MARKER.txt
```

Si dissentiunt:

1. Desine servo.
2. Tack up folder inauguratum, configurationem recognitum, ac testimonia runtime.
3. Scaena et sarcinam intentam inspicere.
4. Restitue solum programmata involucra et acta lima.
5. Confirmo oneratus canonicorum existit et nulla duplicata minuscula addita est.
6. Incipit semel ac lege tergum currentis figuli antequam runtime output iudicet.

<a id="correct-a-missing-saved-root"></a>
## Corrige radix absentis Servata

Open `runtime/saved_path_probe.json`. Iter absolutum verificatum pone ad factorem abioticum absolutum `Saved/`retorii in `SavedRoot.txt`; non solum mundo presul designare. Semita extra radicem terminatam reicienda est.

<a id="recover-a-stalled-historical-scan"></a>
## Recipe stabulariam historicam scan

Cura magna et historica inventio separata sunt. Tabularium amplum multis cyclis circumscriptionibus egere potest, adeo ut una observatione immutata non satis sit illud stabulare.

1. Open `runtime/current/report_worker_status.json`.
2. Record`scan_cursor` imagini inventae sunt, fasciculi completi et `last_progress_ts`.
3. Exspectate duas saltem occasiones normales relationem operariorum et eosdem agros denuo comparare.
4. Si cursor, numerus completus, vel progressus temporis progressus, scan adhuc opus est. Dimitte illud terminatum.
5. Si omnes progressus agri immutati manent dum capita IDs et famae currentes progredientes pergunt, conserva statum fasciculi et fontem classis ab operario periodo nominatae. Reparare illum fontem viam vel defectum legere ante retrying.

A historicis limitibus clauduntur conclusiones quae veteribus monumentis indigent. Currentem relationem non infirmat, cuius probatio recentia sunt activa-loga et cyclus currentis.

<a id="recover-a-stuck-poll-loop"></a>
## Recipe adhæsit poll fasciam

Open:

```text
runtime/current/poll_status.json
runtime/poll_error.txt
```

Record`poll_id`, `poll_completed_count`, `poll_in_flight`, `poll_stage`, `scheduler_status` et indicationes temporis bis in termino terminato.

- Si calculis antecedat, fascia non haesit; egritudo posterioris operantis scaena.
- Si `poll_in_flight=true` immutata manet, servato ultimo progressu et errore antequam sileo.
- Si schedula cessaverit, errorem antecedentem inspice et handoff satum.

Ne alterum ansam possessori addas ut vitam unius stabulationis compenset.

<a id="start-the-scan-after-log-backlog"></a>
## Scipe scan post log backlog

In `runtime/current/poll_status.json`, compara:

```text
active_log_caught_up
active_log_unread_bytes
log_backlog_pending
```

scaenum historicum expectare debet dum activum stipes in bytes non legit. Confirmare postea capita reducere backlog. Inlectum comitem cum progressu capitum certum est problema caudae principium; fixum suffragium problema scheduler est.

<a id="preserve-scan-progress-after-a-crash"></a>
## Scan progressio conserva post ruinam

Conserve et compara:

```text
runtime/scan_checkpoint.json
runtime/scan_progress.json
runtime/baselines/file_manifest.tsv
```

Reprehendo utrum LAPIS an manifestus desit, Servata radix an mundus mutatus est, an LAPIS vetus notatus est. Noli baseline valida delere ut recentior appareat progressus.

<a id="map-an-unmapped-player"></a>
## Mappa ludio ludius indiscreta

Compare sessionem argumentorum cum auctoritative stipes:

```text
runtime/evidence/session_events.jsonl
Saved/Logs/AbioticFactor.log
```

Respice integram `Login request` inter ostentationem nominis, `ConnectID`, et `UniqueId`. Si nexus identitatis nullus acceptus existit, versu tantum recenseri potest. Ostentationem nominis vel PlayerData filename solum non urgeri identitatis est.

<a id="diagnose-a-blocked-adminini-write"></a>
## Diagnose impeditum Admin.ini scribe

Actionis exactionem tantum cum approbatione expressa et documenti documenti efficiendi, numquam cum lima servo vivo. Primum confirmamus testem configurationem rogat ut scribatur:

```lua
review_only_mode = false
auto_ban = true
write_admin_ini = true
```

Tunc scriptam defectum rationis legit. Cavere debet unam rationem cognoscere, moderatores et rationes creditas custodire, satis argumentorum specialium argumentorum invenire, novum tergum creare et cognoscere, confirmare aliam rationem tabellam mutare, praeter intentionem renovationem, et fasciculum integrum cum eo intento effectu comparare. Si quis gradus deficiat vel sisti non potest, indicem bannum non mutatum relinquit. Vide [Admin.ini](ADMIN_INI_EFFECTUS.md).

<a id="restore-a-missing-daily-rollup"></a>
## Restitue absentis cotidie rollup

Confirma`forensic_rollup.enabled = true`, deinde inspicias:

```text
runtime/current/forensic_today.json
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

Si haec desunt, initium, capita, opifex, relationem, et fons computandi status in eo ordine reprehendo. Cotidiana rollup unum est recordum continuitatis per diem, non repetitio notificationis servo-statis.

<a id="look-up-an-exact-status-or-error"></a>
## Respice exactam statum vel errorem

Usus [Status et error referuntur](STATUS_ATQUE_ERROR_REFERENCE.md) ad integrum iter, principium, PlayerData cogendi, startup, schedulae, famae ac tabulae notificatio codicis. Tabulae spectivae singulae observantes vetat hanc paginam reparare, ne fiat alterum schema manuale.

<a id="related-docs"></a>
## Related docs

- [Incipit hic](INCIPIT_HIC.md)
- [Operationes playbook](OPERATIONES_PLAYBOOK.md)
- [Status et error referuntur](STATUS_ATQUE_ERROR_REFERENCE.md)
- [ Validation et recensio emissio](VALIDATION_ET_DIMITTE.md)
