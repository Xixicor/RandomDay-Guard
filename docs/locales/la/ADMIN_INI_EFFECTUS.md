<a id="adminini-enforcement"></a>
# Admin.ini

> **Canonicum Anglicum fontem:** [ADMIN_INI_ENFORCEMENT.md](../../ADMIN_INI_ENFORCEMENT.md).  Haec documenta localia mandata exacta, semitas, claves, valores, hashes, nomina fasciculi conservat. Si forma technica differt, fonte Anglico utere.


RandomDayGuard servo bannum album in suo defectu non mutat. Tantum refert ut admin ad recensendum creat. Haec pagina indicat libitum automatic bannum album renovationis pro admins qui ex industria id faciant.

<a id="what-guard-checks-before-changing-the-ban-list"></a>
## Quae custodia coercet antequam mutando tabulam bannum

custodia bannum addit tantum cum singulis infra respondetur, **yes**:

1. Numen documenta certae notae satis fiduciae sunt?
2. Estne ratio nec moderator nec ratio admin credita?
3. Numquid ratio non iam in indice banno est?
4. Numquid ratio peruenit ad score figuram latae actionis?
5. Potest legere hodiernam`Admin.ini` et serva idem tergum?
6. Num `Admin.ini` immota manere dum Custodiae renovationem parabat?
7. sensit,ne completa fasciculus congruens intentos effectus?

Si quis respondeat, **no** aut cohiberi non potest, folia custodi`Admin.ini` immutata ac notat rationem in suis relationibus. Si salutaris incipit sed finalis perscriptio deficit, custodia verificatum tergum restaurat.

<a id="file-format"></a>
## Tabulae forma

`Admin.ini` ban lineas puras recipere debet tantum:

```ini
BannedPlayer=<ID>
```

- No nomina nulla.
- Commentationes nullae.
- Nulla rationes.
- Nulla suffixa.

<a id="safe-defaults"></a>
## defaltis tutus

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
require_clean_ban_id = true
preserve_existing_bans = true
preserve_moderators = true
```

<a id="ban-id-source"></a>
## Ban ID source

Optimus fons:

```text
Login request
Name=<player>
ConnectID=<raw_id>
UniqueId=<platform_id>
```

Runtime aut numerum ID plene aut documentum completum `<digits>_+_|<non-space token>`connexionem formam et bannum ID numerorum trahit ab ea. Arbitraria praepositiones numerorum cum suffixis ignotis rejiciuntur; non sunt mutila in bannum ID.

Recte:

```ini
BannedPlayer=2535422284688820
```

Nefas:

```ini
BannedPlayer=ExamplePlayer
```

Perperam etiam:

```text
BannedPlayer=<ID>
```

<a id="exact-settings-guard-checks"></a>
## Exact occasus custodiae compescit

Hae uncinis complendae compescit de quibus supra. Omnis conditio recensita verum esse debet:

```text
review_only_mode == false
auto_ban == true
write_admin_ini == true
ban_id is clean numeric
identity is mapped
not trusted
not moderator
threshold is met
account-specific evidence exists
```

Si aliqua conditio falsa sit vel cohiberi non possit, Cohortis bannum indicem inmutatum relinquit et ea quae in eo morantur narrat.

<a id="transaction-safety"></a>
## Transactionis salus

Sola`Admin.ini`

1. Read ac constitutione auctoritatem bytes convalidant.
2.  Moderatorem suum, creditum et bannum statum ex eodem snapshot.
3. Scribe unicum tergum sub `runtime/backups/` byte pro byte et verificandum.
4. Re-legere `Admin.ini` statim ante reponendam et externam mutationem rejiciunt.
5. Scribe candidatum per figuram regente iter repositum.
6. Require integram readbackum bytes ut candidatum integrum bytes aequaret.
7. De defectione lecta, tergum verificatum tantum restitue dum fasciculus currens adhuc candidatus accuratus a custodia scriptus est. Si alius scriptor vertit, Cave reverti recusat potius quam ignota externa bytes rescribere.

Duplicata IDs idempotent: nulla secunda linea nec posterior tergum scribuntur. Tergum nomina includunt indicationem, fons-byte fingerprints, et id mundare tam separati conatus non possunt veterem titulum electronicum communicare.

<a id="local-regression-proof"></a>
## Locus regressionis probatio

`tests/lua/enforcement_runtime_test.lua` ocreas oneratus uit semel ac deinde realem localem suum exequitur `append_ban()` clausurae contra fasciculos syntheticos solitarios infra repositorium `.tmp/` presul. Insertionem tegit, duplicatam idempotentiam, moderator/trusted recusatio, identitas infirma et deformis repudiatio, probatio tergum exacta, recusatio concurrens modificatio, regressus prosperus post lecta retro defecit, et recusatio rescribere post-scribere mutationem externam. Fasciculi eius involucri mutationem ullam extra radicem fixturam reiciunt; nullum verum servo iter seu verum `Admin.ini` adhibetur.

Per`python tools/test_public_pipeline.py`. A fixture saltum probat loci transactionis mores tantum. Non dat cogendi, auctoris producendi scribendo vel probandi licentias hospites speciales.

<a id="files-to-check"></a>
## Limae ad reprimendam

```text
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
runtime/enforced_bans.jsonl
runtime/enforced.txt
runtime/ban_queue.json
```

<a id="rollback"></a>
## Rollback

1. Desine servo.
2. Redde novissimam Admin.ini tergum e `runtime/backups/`.
3. Remove falsa `BannedPlayer=<ID>` linea si opus fuerit.
4. Incipit servo.
5. Reopen Admin.ini et perstare vel remotum linea confirmare.
6. Conserve`enforced_bans.jsonl` audit.

<a id="related-docs"></a>
## Related docs

* [`BAN_ID_MAPPING.md`](BAN_ID_MAPPING.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](PLAYER_REVIEW_WORKFLOW.md)
