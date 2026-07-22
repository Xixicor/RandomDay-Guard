<a id="detection-signals"></a>
# Alama za utambuzi

> **Chanzo cha Kiingereza cha Canonical:** [DETECTION_SIGNALS.md](../../DETECTION_SIGNALS.md). Hati hizi zilizojanibishwa huhifadhi amri kamili, njia, funguo, thamani za hali, heshi na majina ya faili. Ikiwa maneno ya kiufundi yanatofautiana, tumia chanzo cha Kiingereza.


Ishara ni pembejeo za ukaguzi, si shutuma za kiotomatiki.

<a id="signal-table"></a>
## Jedwali la mawimbi

| Ishara | Maana | Ina nguvu zaidi wakati... | Haitoshi yenyewe |
|---|---|---|---|
| Kitambulisho cha kuingia | Jina la Ramani kwa kitambulisho cha akaunti | ConnectID ipo | Piga marufuku |
| Likizo safi | Kufungwa kwa kipindi cha kawaida | Jiunge na uache inayolingana | Tuhuma |
| Unganisha upya kwa haraka | Churn/probing muktadha | Hurudiwa haraka | Piga marufuku |
| Tenganisha najisi | Kipindi hakikufungwa vizuri | Hurudia au kuingiliana mivurugiko | Piga marufuku |
| Muingiliano wa kuacha kufanya kazi | Akaunti inatumika karibu na kuacha kufanya kazi | Akaunti sawa hurudiwa | Piga marufuku |
| Rejesha baada ya ajali | Akaunti hurejeshwa baada ya kuanza upya | Hurudiwa katika nyakati | Piga marufuku kwa tukio moja |
| Ilani ya onyo imeongezeka | Dirisha la onyo la seva | Hupishana vipindi vilivyopangwa | Piga marufuku mara moja |
| Mguso wa hifadhi ya mwigizaji | Muktadha wa kuokoa ulimwengu | Inahusiana na vipindi | Uthibitisho wa use/theft |
| Delta ya kitu | World/class badilisha | Inahusiana na vipindi | Piga marufuku kuhesabu pekee |
| Kesi ya uvamizi | Kundi la akaunti nyingi | Akaunti kuu hurudiwa | Piga marufuku kwa wingi akaunti zote |

<a id="login-identity"></a>
## Kitambulisho cha kuingia

Chanzo bora:

```text
Login request
Name=
ConnectID=
UniqueId=
```

Itumie kutengeneza ramani:

```text
display/log name -> account_id -> ban_id
```

<a id="rapid-reconnect"></a>
## Unganisha upya kwa haraka

Muundo:

```text
join -> leave -> join -> leave -> join
```

Tumia kwa ukaguzi inaporudiwa.

Usalama:

```text
churn_alone_never_bans = true
```

<a id="crash-overlap-and-post-crash-return"></a>
## Muingiliano wa ajali na urejeshaji wa baada ya kuacha kufanya kazi

Muundo:

```text
account active before crash
server restarts
same account returns quickly
```

Tumia kwa ukaguzi inaporudiwa katika vipindi vyote.

Usalama:

```text
single_crash_never_bans = true
```

<a id="warning-bursts"></a>
## Milipuko ya ilani

Mifano:

```text
ActorChannelFailure
DeployableSaveWarning
UpdateActorToWorldSave
ServerMove warnings
```

Tumia kama muktadha hadi uunganishwe na vipindi na vizingiti vilivyopangwa.

<a id="actor-save-touch"></a>
## Mguso wa hifadhi ya mwigizaji

Maana:

```text
The server evidence referenced a class or actor.
```

Haina maana:

```text
A player opened it.
A player stole from it.
A player duplicated through it.
A player damaged it.
```

<a id="raid-cases"></a>
## Kesi za uvamizi

Kesi ya uvamizi hukusanya akaunti kwa kuweka saa na madirisha yaliyoshirikiwa.

Sheria:

```text
Do not auto-ban every account in a raid case.
Each account needs account-specific evidence.
```

<a id="related-docs"></a>
## Nyaraka zinazohusiana

* [`BAD_ACTOR_PATTERNS_AND_RESILIENCE.md`](MIUNDO_NA_USTAHIMILIVU_MBAYA_WA_WAIGIZAJI.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](MTIRIRIKO_WA_KAZI_WA_MAONI_YA_MCHEZAJI.md)
