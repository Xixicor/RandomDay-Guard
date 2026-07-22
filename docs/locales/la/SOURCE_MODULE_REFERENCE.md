<a id="source-module-reference"></a>
# Source moduli reference

> **Canonicum Anglicum fontem:** [SOURCE_MODULE_REFERENCE.md](../../SOURCE_MODULE_REFERENCE.md).  Haec documenta localia mandata exacta, semitas, claves, valores, hashes, nomina fasciculi conservat. Si forma technica differt, fonte Anglico utere.


Hanc paginae tabulae omnis fons, configuration, notitia, convenientiae oneratus, ac cursorium placeholder classis admittit emissionem permissam. Apparatus index est [`TRACEABILITY_INDEX.json`](../../TRACEABILITY_INDEX.json); Haec pagina recitata est expositio canonica. Singula generata machina ordinis nomina distincta path/class, propositum, fons clausus possidens, occasus publicus, effectus latus, status operator-visibilis, delicta, recuperatio et documentum canonicum.

<a id="packaged-file-map"></a>
##  fasciculi fasciculi fasciculi

| Path | Responsabilitas | Ingressus punctum vel RECENS | Inputs | Outputes et effectus latus | Defectum mores | User editable |
|---|---|---|---|---|---|---|
| `LICENSE` | Project licentia in archivo root. | Institutor, redistributor, operator. | Repositoria licentia textus recognita. | Adiecta sunt verba quae ad sarcinam applicant; nulla runtime mutatio. | Omissio facit sarcinam remissionis iure incompletam et permissam impedit. | No. |
| `NOTICE.md` | Project notationes in archivo root. |  Installer et operator. | receptae notae recognitae. | Attributionem et contextum proiectum servat; nulla runtime mutatio. | Omissio facit sarcinam remissionis incompletam ac permissam impedit. | No. |
| `THIRD_PARTY_NOTICES.md` | Tertii notae factio in archivo root. | Institutor ac redistributor. | Recognita tertia-partii attributionis textus. | Servat dependentiam attributionis; nulla runtime mutatio. | Omissio facit sarcinam remissionis incompletam ac permissam impedit. | No. |
| `RandomDayGuard/enabled.txt` | UE4SS mod vexillum enable. | UE4SS mod oneratus. | `1` vel `0` fultum UE4SS. | Aut loading Disables, dat; non scribit runtime testimonio. | Vexillum debilitatum vel deforme impedit normalem probationem startup. | Etiam in install. |
| `RandomDayGuard/config.lua` | Perfice mensam publicam. | `Scripts/main.lua` satus. | Agri in [`CONFIG_FIELD_CATALOG.md`](CONFIG_FIELD_CATALOGUE.md). | Imperia inventa, rationes, relationes, portas recense, et figmenta localia ad libitum. | Lua/load/default summa caudices sanatio vel startup deficient clausa. | Etiam; tergum custodire. |
| `RandomDayGuard/SavedRoot.txt` | Libitum expressa-radix salvati primi ante. | salvatoris resolventis in `main.lua`. | Unum genus filesystem iter ad `AbioticFactor/Saved`. | Selectae radicem pro lignis servat, PlayerData filenames, et `Admin.ini`. | Missing concessum est; viae tutae, iniuriae vel unreadable non probatae manent. | Ita; numquam hic ponere documentorum. |
| `RandomDayGuard/BUILD_MARKER.txt` | Humanum-readable sarcina identitatis. |  Installer, validator, et operator. | Remissa versionem ab architecto redditam. | Nulla mutatio runtime. | Version mismatch cuneos packaging. | No. |
| `RandomDayGuard/MANIFEST.json` | Machina-readable sarcina identitatis et metadata metadata. | Validator, fabricator, instrumentum et sustentaculum. | Remissa versionem ab architecto redditam. | Nulla mutatio runtime. | JSON vel versio mismatch cuneos packaging. | No. |
| `RandomDayGuard/README.txt` | Instruitur velox reference. | Operator. | Packaged semitas et defaltas tutas. | Nulla mutatio runtime. | State viae seu verborum salus deficient documenta pari. | No. |
| `RandomDayGuard/Scripts/main.lua` | UE4SS viscus, testimonia, collectio, dominium status, schedulingum limitatio, necessitas ad libitum, et scriptorum output. | UE4SS. | Config, Fontes Radices servati, status currentis temporis, dictionarii, ac relatio moduli. | Scribit classes runtime in [`OUTPUT_SCHEMA_REFERENCE.md`](OUTPUT_SCHEMA_REFERENCE.md); probatus egestas semita rursus sursum et renovatio `Admin.ini`. | Startup/poll/write manifesto errore delicta gignunt statum et perfectionem itineris numquam demonstrant. | No. |
| `RandomDayGuard/Scripts/public_pipeline.lua` | Source accounting, current-cycli genus, report translation, iter probatio, historia publica durabilis, et outbox localis libitum. | `main.lua`refert operarius. | Read solum state/context callbacks et probationes locales retinet. | Scribit relationem JSON/TXTjugis, source/history ratio, itineris probatio, durabilis historiae ratio, et notificatio status/envelopes. | Absentis genus, fons requisitus, connexus scribe, vel probatio meatus scribe copias`missing` et cuneos queueing. | No. |
| `RandomDayGuard/data/detection_events.json` | Publicae eventus vocabulario et explicationes. | `main.lua`resnormalization/reporting. | ValidJSON dictionary. | Titulorum testimonia; observationes non facit. | Missing/malformed data cuneos repositoria sanatio. | No. |
| `RandomDayGuard/data/warning_types.json` | Monitum type dictionum et significationis recensionis. | Monitum normalization/reporting. | ValidJSON dictionary. | Labelum monitionem. | Missing/malformed data cuneos repositoria sanatio. | No. |
| `RandomDayGuard/data/object_categories.json` | Object/class vocabularium genus. | Scan and object-subcriptio renuntiantes. | ValidJSON dictionary. | Labelum contextum classium extractum. | Missing/malformed data cuneos repositoria sanatio. | No. |
| `RandomDayGuard/runtime/**/.gitkeep` | Empty install-layout placeholders only. | Package extractionis. | Inanis bytes. | Artificium directorium writable creat; nullo testimonio est bundled. | Quisquis non-placeholder runtime membrum impedit exactum allowlist. | No. |

<a id="ue4ss-loader-and-watchdog"></a>
## UE4SS oneratus et vigil

`Scripts/main.lua`object/world context, recensio scoring, `Admin.ini`salutis portis, legatis operationibus, ac singulis relationibus operariorum handoff. Providendum est ut vivere saeptum saeptum sit dum tarda historica opera independenter repetit. Pulsatio, satus titulus, vel auctio `poll_id` tantum probat illud component; iter peractum postulat ut idem tabernus, epocha, capita, fons viriditatis, fama coniugationis, iter itineris probatio.

Fontes et sarcina unam auctoritatem habent: `RandomDayGuard/Scripts/main.lua`. A lowercase `scripts/` exemplum non est de fonte arboris aut emissione. Servans unam orthographiam canonicam impedit casus-concursus defectis, cum sarcinis in Fenestra vel Linux extrahitur.

<a id="public-reporting-module"></a>
## Publicus relatio moduli

`Scripts/public_pipeline.lua` callbacks accipit pro documentorum hospitii vel adaptatores provisoris. Inventaria octo fontium classium, monumentorum terminalium et incompletorum civitatum servat lusores currentes a retenta historia separatos, unumquodque iter in ordine vertit `Observed`, `Interpretation`, `Unknown`, `Does not prove`, `Next action`, et `Source references`, deinde scribit Iter probationem. Ad libitum notificatio modus localis scribens JSON involucro tantum; numquam vindicat traditio vel fasciculos traditio endpoint/bridge.

Fixtura exsecutabile in `tests/lua/public_pipeline_runtime_test.lua` hunc modulum cum Lua onerat, plenas et expectatas vias vacuas probat, cyclus absentis fontis deficientis clausus probat, et itinera imperfecta non e labro intrant.

<a id="configuration-and-data"></a>
## Configurationis et notitia

[`CONFIG_FIELD_CATALOG.md`](CONFIG_FIELD_CATALOGUE.md) et [`TRACEABILITY_INDEX.json`](../../TRACEABILITY_INDEX.json) generantur ex `tools/generate_documentation_audit.py` ex parte non-exsecutione structurae `config.lua` involucrum permissum est, et species output-inventa. Exige contenta generata et una ad unum coverage convalidatur. Tres JSON dictionaria sunt pittacia et mappings, non testimonia fontes. Auctor creare potest config, electio radicis servatae et capacitatis; fons, dictionaria, manifestata et involucra readmes emissione possidentur.

<a id="package-layout"></a>
## Package layout

Adificator tres tantum radices legalium imaginum, in `RandomDayGuard/` superne semitas, et inania loca occupant. Imperat membra bytewise, figit ZIP metadata, fasciculi oneratus canonici semel, singula membra pro materia privata perlustrat, tradit SHA-256 singula membra, nomina ligat, et bytes in unum concoquet, et bis aedificat. Expertus omnem casum duplicis collisionis respuit et extractionem normalem probate unum prorsus efficit fasciculum physicum per ingressum archivi.

Repositio publica servat solum folder emissio hodiernam. Hic structor reprimit ipsum suum ZIP, checksum, notae, versionis venalicium, et origo arboris conveniunt.

<a id="code-comment-contract"></a>
## Code commentarium contractum

Runtime commentationes sunt contractae conservatoris contractuum, non secundae manus manualis. Unusquisque modulus exigui temporis exiguum unum debet ponere canonicum vinculum in clausura commentarii aperiendi:

```lua
-- Documentation: docs/SOURCE_MODULE_REFERENCE.md#ue4ss-loader-and-watchdog
```

State Non conspicuum, scheduling, write/readback/rollback, principium-inventionis, translationis, argumenti, output-schema, itinera-cadentiae, redactionis caudices commentationes adhibitae sunt cum his titulis ubi valent:

```lua
-- Public contract: <invariant or consequence>
-- Evidence boundary: <what the input cannot prove>
-- Failure behavior: <how the block fails closed or recovers>
-- Documentation: docs/<canonical-file>.md#<existing-anchor>
```

Oneratus principalis etiam unum commentarium possessoris focused pro oneratione config, inventionis servatae, postea nuclei, cogendi, et scheduling. Haec commentaria de re publica imperium-fluvium et limites deficiendi; non mutant mores runtime.

 Validator moduli gradus requirit `Documentation:` nexus cuiusque moduli runtivi, omnem commentarium iter et anchoram resolvit, contractum et defectum commentarium in utroque modulorum runticorum numero requirit, eosdemque canonicos nexus cum `TRACEABILITY_INDEX.json`. Commentum est vestigium, non probatio runtime.

<a id="contributor-change-checklist"></a>
## Contributor mutatio Genus

1. Renova unum modulum habendo eiusque fixturam feruntur.
2. Renova canonicam config, schema, output, probationes, sectionem vivendi.
3. Run`python -B tools/generate_documentation_audit.py --write` post config, packaged viam, generatae output genus, possessorem, contractus mutationes vel recuperatio.
4. Run`python -B tools/generate_documentation_audit.py --check``git diff --check`.
5. Recognosce generatum ZIP album membrum, checksum, et scan-privatum materiale ante emissionem creando.
