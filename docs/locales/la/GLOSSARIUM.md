<a id="glossary"></a>
# Glossarium

> **Canonicum Anglicum fontem:** [GLOSSARY.md](../../GLOSSARY.md).  Haec documenta localia mandata exacta, semitas, claves, valores, hashes, nomina fasciculi conservat. Si forma technica differt, fonte Anglico utere.


| Term | Plane significatio | Respondet technicam significationem |
|---|---|---|
| Active log | The current servo stipes pro recentibus indiciis adhibitis. | Required `active_log` source; readability plus currentis generationis opus ad complementum itineris. |
| Bottus ID | Satus processus unus vigil. | Current runtime identifier utendum est ut rejiceret prior-bootariam errors/reports. |
| Epoch ID | Unus servo continuum intervallum. | Identifier spatium temporis normali usque ad continuationem logicam aliam epocham incipit. |
| Poll ID | Una capita saepta occasio est. | Positivum cycli monotonici campi; zero/missing iter perficere non potest. |
| Source viriditatis | Utrum fons vena et capitata conveniant. | `fresh_current_poll` vel `stale_or_unproven` cum indicatione temporis et status activae-logae. |
| Source accounting | Inventarium testimoniorum disponibilitate ac limitibus. | `randomdayguard.source-accounting/v1`cum octo generibus et current/historical scope. |
| `available` | Fons repertus et legebatur. | Terminal fons status cum `available=true`, `readable=true`. |
| `expected_empty` | Libitum fontem repressum ac legitime absent/empty. | Terminal fons status readable; nunquam subiectum fabricat. |
| `partial` | Opus circumscriptum utiles sed incompletos eventus habet. | Nonterminal source/accountingstatum; repeto possessorem operantem. |
| `deferred` | Laboris ex intentione pendente. | nonterminalis fons status; non error aut perfectio. |
| `unavailable` | Fons currently adhiberi non potest. | Terminal hiatus; hiatus postulatus fons perpendat rationem reddit. |
| `malformed` | Fons exstat sed constitutione invalida est. | Pagulum Terminal convalidationis retinendae et claudendi dependens scribit. |
| `permission_denied` | The OS explicite rejecit accessum. | intervallum distinctum ab missing/unavailable. |
| `error` | A operatio terminata improviso defecit. | Terminalis defectus postulat nomen recuperationis; nullum secretum singulare ad publicas relationes pertinet. |
| `complete` | Omnes fontes computati nullo hiatu terminati sunt. | Top-level fons rationis status. |
| `complete_with_gaps` | Requiritur current documenta opera; hiatus terminales ad libitum manent. | Top-gradus rationis status; itinera sua requisita adhuc adhibent. |
| `full` | Iter peracta cum contractu non-vacuo requisito. | probationis enum evulgato currenti-cyclo outputs. |
| `limited_expected_empty` | A via peracta et nihil habiles invenisubject/failure. | Probat enum cum `completed=true`, `expected_empty=true`. |
| `missing` | Probatur perfectio itineris vel deest. | Probat enum cum `completed=false`; numquam eligibile pro outbox. |
| structus fama | Machina-readable route output. | `<route>_latest.json`usura `randomdayguard.report/v1`. |
| Renuntiatio translata | Humana-readable redditio eiusdem itineris. | `<route>_latest.txt` fixis observatis ad ordinem indiciorum. |
| Probatio itineris | Cross-itineris complementi emissarii. | `route_proof.json` binding version/boot/epoch/poll/freshness/output vias. |
| Current testimonia | Observatio cycli activorum habetur. | Scopi`current`; non restituit ex antiquis filenames/reports. |
| Historiae historicae | Contextus retentus e prioribus cyclis seu scan tardus. | Scopi`historical`; recensionem certiorem facere potest sed praesentiam hodiernam petere non potest. |
| Recognosce solum | recensionem affer sine testimoniis Admin.iniscribit. | Default `review_only_mode=true`, `auto_ban=false`, `write_admin_ini=false`. |
| Ban-list salus reprehendo | Una quaestio Custodi respondere debet antequam mutetur `Admin.ini`. | Confirmare rationem debet et ustulo, rationes creditas excludere et duplicatas cognoscere, tergum verificare, extra mutationes deprehendere, nisi intenta renovatio et integram limam verificare vel tuto restitue. |
| Locus outbox | Libitum provisoris-neutralis notificationis handoff. | JSON lima cum `delivery_backend="none"` et `delivery_attempted=false`. |
| Baseline | Completus saeptum contextum servatum fasciculi snapshot. | Manifest/object/world |
| Checkpoint | Resume positio pro opere photographico incompleto. | `scan_checkpoint.json`; deletio non est defectus recuperationis. |
| redificabilis index | Summarium quod regenerari potest. | Daily/weekly/forensic/finalrecensio output; fons testimonio auctoritatis permanet. |
| Evidentia terminus | Limit quonam fons alere possit. | Explicit `does_not_prove`, incognitae, identitatis vires, praecepta et ambitus. |

Canonicae definitiones schematum in [`OUTPUT_SCHEMA_REFERENCE.md`](OUTPUT_SCHEMA_REFERENCE.md); Configurationis verba in [`CONFIG_FIELD_CATALOG.md`](CONFIG_FIELD_CATALOGUE.md).
