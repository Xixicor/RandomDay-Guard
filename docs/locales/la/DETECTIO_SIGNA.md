<a id="detection-signals"></a>
# Detectio annuit

> **Canonicum Anglicum fontem:** [DETECTION_SIGNALS.md](../../DETECTION_SIGNALS.md).  Haec documenta localia mandata exacta, semitas, claves, valores, hashes, nomina fasciculi conservat. Si forma technica differt, fonte Anglico utere.


signalia recensentur inputationes, non accusationes latae.

<a id="signal-table"></a>
## Tabula signum

| Signum | Means | Fortius cum... | Non satis per se |
|---|---|---|---|
| Login identitatis | Mapis nominamus ut ID | ConnectID adest | Ban |
| Exeundi munda | Normalis sessionis clausurae | Coniunge et relinque par | Suspicio |
| Rapido reconnect | Churn/probing contextu |  celeriter repetit | Ban |
| Immune disconnect | Sessio non pressit nitide | Repetit vel ruinas premit | Ban |
| Cash overlap | Activae Rationis prope fragorem | Eadem ratio repetit | Ban |
| Post ruinam reditus | Ratio redit post sileo | Repetit trans epochae | Ban uno eventu |
| Monitio ruptis | Festram ministrator monens | Overlaps sessiones divisi | Ban uno impetu |
| Actor praeter tactum | World-salve context | Correlates cum sessionibus | Probouse/theft |
| Objecto della | World/class mutationem | Correlates cum sessionibus | Ban ex solo comite |
| raid causa | Multi-ratio botri | Centralis ratio repetit | Massa-ban omnium rationum |

<a id="login-identity"></a>
## Login identitatis

Optimus fons:

```text
Login request
Name=
ConnectID=
UniqueId=
```

Utere ea ad tabulam:

```text
display/log name -> account_id -> ban_id
```

<a id="rapid-reconnect"></a>
## Rapido reconnect

Pattern:

```text
join -> leave -> join -> leave -> join
```

retractatione adhibita recenseri.

Safety:

```text
churn_alone_never_bans = true
```

<a id="crash-overlap-and-post-crash-return"></a>
## Cash aliudque et post-fragorem reditus

Pattern:

```text
account active before crash
server restarts
same account returns quickly
```

retractatione adhibita per epochae iteratae.

Safety:

```text
single_crash_never_bans = true
```

<a id="warning-bursts"></a>
## Monitio erumpit

Exempla:

```text
ActorChannelFailure
DeployableSaveWarning
UpdateActorToWorldSave
ServerMove warnings
```

Pro contextu utere donec ad praescripta sessiones et limina coniungantur.

<a id="actor-save-touch"></a>
## Actor praeter tactum

Significatio:

```text
The server evidence referenced a class or actor.
```

Non significatum:

```text
A player opened it.
A player stole from it.
A player duplicated through it.
A player damaged it.
```

<a id="raid-cases"></a>
## raid casus

Causus caesus circulorum rationes leo et fenestras communicavit.

Rule:

```text
Do not auto-ban every account in a raid case.
Each account needs account-specific evidence.
```

<a id="related-docs"></a>
## Related docs

* [`BAD_ACTOR_PATTERNS_AND_RESILIENCE.md`](MALA_ACTOR_PATTERNS_ET_RESILIENTIAE.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](PLAYER_REVIEW_WORKFLOW.md)
