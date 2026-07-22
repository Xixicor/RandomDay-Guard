<a id="player-review-workflow"></a>
# Mtiririko wa kazi wa ukaguzi wa mchezaji

> **Chanzo cha Kiingereza cha Canonical:** [PLAYER_REVIEW_WORKFLOW.md](../../PLAYER_REVIEW_WORKFLOW.md). Hati hizi zilizojanibishwa huhifadhi amri kamili, njia, funguo, thamani za hali, heshi na majina ya faili. Ikiwa maneno ya kiufundi yanatofautiana, tumia chanzo cha Kiingereza.


Tumia ukurasa huu kwa mchezaji mmoja, akaunti, au kesi. Madhumuni ni uamuzi wa ukaguzi unaorudiwa, si shutuma otomatiki.

<a id="quick-path"></a>
## Njia ya haraka

1. Fungua `runtime/final_logs/player_activity_latest.json`.
2. Thibitisha hali ya njia katika `runtime/final_logs/route_proof.json`.
3. Tambua ni uchunguzi upi ni wa sasa na upi ni wa kihistoria.
4. Angalia utambulisho uliotajwa na marejeleo ya chanzo cha kipindi.
5. Kagua `case_review_latest.json` wakati kesi inayohusiana ipo.
6. Rekodi zisizojulikana na `does_not_prove` kabla ya kuchagua kitendo.
7. Wacha utekelezaji umezimwa isipokuwa milango tofauti ya utekelezaji imethibitishwa.

<a id="1-confirm-route-proof"></a>
## 1. Thibitisha uthibitisho wa njia

Tafsiri njia ya kichezaji kama:

| Hali | Kitendo |
|---|---|
| `full` | Endelea, huku unaendelea kukagua vikomo vya chanzo. |
| `limited_expected_empty` | Endelea tu na masomo yaliyopo; usibuni mchezaji au kesi iliyokosekana. |
| `missing` | Simamisha uamuzi wa kichezaji na utatue njia. |

Kipanga ratiba kiafya hakichukui nafasi ya uthibitisho wa njia.

<a id="2-establish-identity"></a>
## 2. Weka utambulisho

Pendelea kitambulisho safi cha akaunti kinachothibitishwa na ushahidi wa utambulisho uliofichuliwa na seva na, inapopatikana, PlayerData majina ya faili. Weka marejeleo ya chanzo ghafi.

Usitekeleze kutoka:

- jina la kuonyesha pekee;
- jina linaloonekana kwenye kidirisha cha arifa au mwenyeji;
- kufanana kwa wakati;
- kitambulisho kisicho na ramani au kutokuwa na imani dhaifu;
- ripoti ya kihistoria bila uthibitisho wa sasa.

<a id="3-separate-current-from-historical"></a>
## 3. Tenganisha mkondo wa sasa na wa kihistoria

Ushahidi wa sasa unaelezea dirisha amilifu la kuripoti au enzi ya seva. Ushahidi wa kihistoria unaweza kueleza muundo, lakini hauwezi kujaza mapengo katika dirisha la sasa kimya kimya.

Rekodi mawanda yote mawili kwa kujitegemea:

```text
Current observations:
Current source references:
Historical context:
Historical source references:
```

<a id="4-review-observations-and-interpretation"></a>
## 4. Kagua uchunguzi na tafsiri

Soma sehemu hizi za ripoti kwa uwazi:

```text
observed
interpretation
unknown
does_not_prove
next_action
source_references
```

Fungua upya ushahidi uliotolewa uliotajwa kwa uamuzi wowote muhimu. Tafsiri ni urambazaji na maelezo, si ushahidi mpya.

<a id="5-calibrate-the-decision"></a>
## 5. Rekebisha uamuzi

| Uamuzi | Tumia wakati |
|---|---|
| `INFO` | Uangalizi wa kawaida au wa muktadha wa chini. |
| `WATCH` | Mawimbi dhaifu au yasiyokamilika yenye thamani ya ufuatiliaji. |
| `REVIEW` | Ushahidi unaohusiana unahitaji uamuzi wa msimamizi. |
| `BAN-ELIGIBLE` | Utambulisho safi na vizingiti vya ushahidi vilivyosanidiwa vinatimizwa; andika milango bado inatumika. |
| `AUTO-BANNED` | Utekelezaji uliwezeshwa kwa uwazi na kuhifadhi nakala, kuandika, kusoma tena na ukaguzi wote ulifanikiwa. |

Hakuna lebo ya uamuzi inayothibitisha hatia au nia.

<a id="6-apply-the-evidence-boundary"></a>
## 6. Tumia mpaka wa ushahidi

Kuacha kufanya kazi, miunganisho upya, maonyo, object/class tokeni, na kupanga katika vikundi kunaweza kusaidia ukaguzi. Peke yake, haidhibitishi udanganyifu, wizi, urudufishaji, umiliki, uharibifu wa moja kwa moja, au sababu ya tukio.

Ikiwa utambulisho, uchanganuzi, hifadhi rudufu, uandike, usomaji au urejeshaji ni hafifu au haufaulu, utekelezaji lazima ushindwe kufungwa.

<a id="review-note-template"></a>
## Kagua kiolezo cha dokezo

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
## Nyaraka zinazohusiana

- [`EVIDENCE_BOUNDARY.md`](MPAKA_WA_USHAHIDI.md)
- [`OUTPUT_SCHEMA_REFERENCE.md`](REJELEO_LA_UTARATIBU_WA_PATO.md)
- [`ADMIN_INI_ENFORCEMENT.md`](UTEKELEZAJI_WA_USIMAMIZI_WA_INI.md)
- [`DETECTION_SIGNALS.md`](ALAMA_ZA_UTAMBUZI.md)
