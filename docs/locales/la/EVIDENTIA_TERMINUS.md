<a id="evidence-boundary"></a>
# Evidentia terminus

> **Canonicum Anglicum fontem:** [EVIDENCE_BOUNDARY.md](../../EVIDENCE_BOUNDARY.md).  Haec documenta localia mandata exacta, semitas, claves, valores, hashes, nomina fasciculi conservat. Si forma technica differt, fonte Anglico utere.


Hac pagina utere ut quaeras quid RandomDayGuardrenuntiare potest et quid adhuc requirit humanam recensionem.

<a id="core-rule"></a>
## Core rule

RandomDayGuard observationes monumentorum finium e tabulario servo-possessorum. Cognoscere debet fontem, scopum, statum collectionis, limites ad omnem conclusionem materialem.

Evidentia structa auctoritatis est. A translata fama argumenta explicat; res absunt a monumento exstructo addere non potest.

<a id="evidence-source-classes"></a>
## Testimonium source classes

| Source class | Typical use | Non probat per se |
|---|---|---|
| `admin_ini` | Cistens status administrationis et audited write/readback contextu | Quis incident |
| `active_log` | Currentserver/session res visae in activo | Intentum, dominium, vel directum damnum |
| `recent_backup_logs` | Tabularum historicarum context | Res gestae evenerunt |
| `playerdata_filenames` | Corroboratio munda rationem identificantis existit | Morum, culpae, seu identitatis possessionis ultra identifier expositae |
| `existing_cases` | Prior contextus recensionis | Ut prior interpretatio recta maneat |
| `existing_reports` | Antiqua summaria ac decisiones | Current veritas sine praesenti corroboratione |
| `existing_evidence` | Historiae structae testimonia | actio Current |
| territum finitum-salve scan | Tardus world/class contextu | Play actio, dominium, furtum, duplicatio, vel damnum |

Utraque principia availability/readability, fasciculi comitis, fons indiciorum, currentium vel historicorum scoporum, et explicatum `does_not_prove`editio.

<a id="source-states"></a>
## Source states

| State | Operatoris significatio |
|---|---|
| `available` | Fons erat lectibilis et testimoniis collectus. |
| `expected_empty` | Fons legitimum ac legitime nullum recordum adaptans erat. |
| `partial` | Quaedam probationes collectae sunt; Coverage incompleta. |
| `deferred` | Opus circumscriptum consulto dilata est. |
| `unavailable` | Fons in hac re non adest. |
| `malformed` | Fons existit sed tuto partiri non potest. |
| `permission_denied` | Cogator permissione caret. |
| `error` | Collectio alia memoriae causa defecit. |

Inanis exspectatio valida observatio est. Numquam in fictam lusorem, casum, casum, casum, aut accusationem converti debet.

<a id="current-versus-historical-evidence"></a>
## Current versus testimonia historica

Current testimonia ad activum collectionis fenestram vel epocham ministrantem pertinet. Testimonia historica e prioribus lignis, casibus, relationibus, testimoniis monumentis, tergum, basilicis oriuntur.

Historiae argumenta contextui praebere possunt. Non potest tacite implere hiatum currentem testimonium. Renuntiationes utriusque ambitum deponere debent et fontes suos separatim citare.

<a id="corroboration-rule"></a>
## Corroboratio regulae

Hae sunt contextus utiles sed non per se ipsae probationes directae:

- praestatio nomina vel nomen similitudinem;
- timing accidit;
- disiungo vel reconnect torquent;
- cum fragore vel admonitione erupit;
-
- membrata in causa sponte collata;
- refert prior sine fonte confirmationis.

Noli reatum, intentionem, fraudem, dominium, furtum, duplicationem, directum damnum, directum vas usus, directum inventarium, exactam vitam coordinatam, vivam ping, vel memoriam gradus sine argumento quod factum directe exponit.

<a id="truthful-report-language"></a>
## Verax relatio linguae

Usus:

```text
Observed: the account was active in the recorded crash window.
Interpretation: repeated overlap warrants operator review.
Unknown: the cause of the crash.
Does not prove: that the account caused the crash.
Next action: compare the cited current session and lifecycle records.
```

Vite:

```text
The player crashed the server.
The player stole or duplicated items.
The world token proves who used the object.
```

<a id="report-reading-order"></a>
## Referte ordinem legendi

Omnis relatio publica-adversa debet explicare:

1. Plane significatum.
2. Quid refert.
3. Technicam probationem ac fontem indiciorum.
4. Proxima actio.
5. Limites, incognitas, ac petitas non probatas.

<a id="related-docs"></a>
## Related docs

- [`OUTPUT_SCHEMA_REFERENCE.md`](OUTPUT_SCHEMA_REFERENCE.md)
- [`PLAYER_REVIEW_WORKFLOW.md`](PLAYER_REVIEW_WORKFLOW.md)
- [`BAN_ID_MAPPING.md`](BAN_ID_MAPPING.md)
- [`DETECTION_SIGNALS.md`](DETECTIO_SIGNA.md)
