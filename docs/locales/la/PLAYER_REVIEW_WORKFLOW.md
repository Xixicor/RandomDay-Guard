<a id="player-review-workflow"></a>
# Ludiens recensionis workflow

> **Canonicum Anglicum fontem:** [PLAYER_REVIEW_WORKFLOW.md](../../PLAYER_REVIEW_WORKFLOW.md).  Haec documenta localia mandata exacta, semitas, claves, valores, hashes, nomina fasciculi conservat. Si forma technica differt, fonte Anglico utere.


 Haec pagina utere uno lusore, ratione, vel casu. Propositum est reproducibilis deliberatio recensionis, non accusatio automated.

<a id="quick-path"></a>
## Cito iter

1. Open `runtime/final_logs/player_activity_latest.json`.
2. Confirma viam status in `runtime/final_logs/route_proof.json`.
3. Cgnosce quae notae vigent et quae historicae sunt.
4. Citati identitatis ac sessionis fontem p.
5. Review`case_review_latest.json` cum casu connectuntur.
6. Record incognitarum et `does_not_prove` ante actionem eligens.
7. Relinque necessitatem debilitatum nisi portae exactionis separatae probentur.

<a id="1-confirm-route-proof"></a>
## 1. Confirm iter probationem

Ludium iter interpretare ut:

| Status | Actionis |
|---|---|
| `full` | Perge, fons limites adhuc recensentes. |
| `limited_expected_empty` | Perge solum cum subjectis actualiter praesentibus; non invent ludio ludius vel absentis causa. |
| `missing` | Sine histrionis arbitrium et iter fermentum. |

salvus scheduler iter itineris non probat.

<a id="2-establish-identity"></a>
## 2. Constitue identitatem

Pone mundam rationem identificantis confirmatam a servo identitatis identitatis argumentis et, ubi in promptu sunt, PlayerData filenames. Serva fontem rudis referat.

Noli exigere a:

- a ostentationis nomen solum;
- a nomen videtur in notificatione vel tabella obnoxia;
- timens similitudinem;
- sine identitatis fiducia vel infirma;
- renuntiatio historica sine certa corroboratione.

<a id="3-separate-current-from-historical"></a>
## 3. Separate ab historicis

Monens documenta activam nuntiationem fenestrae vel epochae ministrantis describit. Argumenta historica exemplum explanare possunt, sed hiatus in fenestra currenti tacite implere non possunt.

Recordare utriusque ambitus independenter:

```text
Current observations:
Current source references:
Historical context:
Historical source references:
```

<a id="4-review-observations-and-interpretation"></a>
## 4. Observationes et interpretationes recensere

Recipe has relationes sectiones distincte:

```text
observed
interpretation
unknown
does_not_prove
next_action
source_references
```

Re-aperi argumenta citata pro quavis materia decisionis. Translatio est navigatio et explicatio, non novi argumenti.

<a id="5-calibrate-the-decision"></a>
## 5. Calibrate consilium

| Decision | utere cum |
|---|---|
| `INFO` | Normalis vel humilis contextus observationis. |
| `WATCH` | Signa debilis vel imperfecta magna vigilantia. |
| `REVIEW` | Correlated documenta indiget administratori iudicio. |
| `BAN-ELIGIBLE` | Mundae identitatis ac testimoniis configurati limina obvia sunt; scribe portas adhuc applicare. |
| `AUTO-BANNED` | Exactio explicite facta est et tergum, scribe, lecta, et audit omnia successerunt. |

Nihil sententiae label culpae vel intentae probat.

<a id="6-apply-the-evidence-boundary"></a>
## 6. quod terminus applicare ad

Crashes, reconnects, monita, object/class et casus coniunctio recensionem sustinere potest. Solae non probant fraudem, furtum, duplicationem, proprietatem, damnum directum vel causationem incidentem.

Si identitas, parsing, tergum, scribe, lecta, vel reverti invalidum est vel deficit, exactio clausa deficere debet.

<a id="review-note-template"></a>
## Review note template

```text
Review time:
Route proof status:
Coverage status:
Account ID:
Display name as observed:
Identity confidence and source:
Current observations:
Historical context:
Interpretation:
Unknown:
Does not prove:
Decision:
Next action:
Source references:
Operator:
```

<a id="related-docs"></a>
## Related docs

- [`EVIDENCE_BOUNDARY.md`](EVIDENTIA_TERMINUS.md)
- [`OUTPUT_SCHEMA_REFERENCE.md`](OUTPUT_SCHEMA_REFERENCE.md)
- [`ADMIN_INI_ENFORCEMENT.md`](ADMIN_INI_EFFECTUS.md)
- [`DETECTION_SIGNALS.md`](DETECTIO_SIGNA.md)
