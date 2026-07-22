<a id="source-module-reference"></a>
# Marejeleo ya sehemu ya chanzo

> **Chanzo cha Kiingereza cha Canonical:** [SOURCE_MODULE_REFERENCE.md](../../SOURCE_MODULE_REFERENCE.md). Hati hizi zilizojanibishwa huhifadhi amri kamili, njia, funguo, thamani za hali, heshi na majina ya faili. Ikiwa maneno ya kiufundi yanatofautiana, tumia chanzo cha Kiingereza.


Ukurasa huu unapanga kila chanzo, usanidi, data, kipakiaji uoanifu, na darasa la kishika nafasi cha wakati wa utekelezaji kinachokubaliwa na orodha ya ruhusa ya kutolewa. Faharasa ya mashine ni [`TRACEABILITY_INDEX.json`](../../TRACEABILITY_INDEX.json); ukurasa huu ni maelezo ya kisheria yanayosomeka. Kila safu mlalo ya mashine iliyotengenezwa inataja path/class, madhumuni, uzuiaji wa chanzo, mipangilio ya umma, madoido, hali zinazoonekana na opereta, kushindwa, uokoaji, na hati ya kisheria.

<a id="packaged-file-map"></a>
## Ramani ya faili iliyofungwa

| Njia | Wajibu | Mahali pa kuingilia au mpigaji | Ingizo | Mito na madhara | Tabia ya kutofaulu | Inaweza kuhaririwa na mtumiaji |
|---|---|---|---|---|---|---|
| `LICENSE` | Leseni ya mradi imetumwa kwenye mizizi ya kumbukumbu. | Kisakinishi, kisambazaji upya, na opereta. | Maandishi ya leseni ya hazina. | Inasema masharti yanayotumika kwa kifurushi; hakuna mabadiliko ya wakati wa utekelezaji. | Kutoweka hufanya kifurushi cha toleo kutokamilika kihalali na huzuia orodha ya wanaoruhusiwa. | Hapana. |
| `NOTICE.md` | Arifa za mradi husafirishwa kwa msingi wa kumbukumbu. | Kisakinishi na opereta. | Ilipitia arifa za mradi. | Huhifadhi maelezo yanayohitajika na muktadha wa mradi; hakuna mabadiliko ya wakati wa utekelezaji. | Kutokuwepo hufanya kifurushi cha toleo kutokamilika na huzuia orodha ya wanaoruhusiwa. | Hapana. |
| `THIRD_PARTY_NOTICES.md` | Ilani za watu wengine husafirishwa kwenye mizizi ya kumbukumbu. | Kisakinishi na kisambazaji upya. | Imekagua maandishi ya sifa ya mtu mwingine. | Huhifadhi sifa tegemezi; hakuna mabadiliko ya wakati wa utekelezaji. | Kutokuwepo hufanya kifurushi cha toleo kutokamilika na huzuia orodha ya wanaoruhusiwa. | Hapana. |
| `RandomDayGuard/enabled.txt` | UE4SS alamisho ya kuwezesha muundo. | UE4SS kipakiaji cha mod. | `1` au `0` kama inavyotumika na UE4SS. | Huwasha au kulemaza upakiaji; haiandiki ushahidi wa wakati wa utekelezaji. | Alama iliyozimwa au yenye hitilafu huzuia uthibitisho wa kawaida wa uanzishaji. | Ndiyo, wakati wa kusakinisha. |
| `RandomDayGuard/config.lua` | Kamilisha jedwali la mipangilio ya umma. | `Scripts/main.lua` wakati wa kuanza. | Nyumba zilizoorodheshwa katika [`CONFIG_FIELD_CATALOG.md`](CONFIG_SHAMBA_KATALOGI.md). | Hudhibiti ugunduzi, bajeti, ripoti, milango ya ukaguzi na vialamisho vya hiari vya ndani. | Lua/load/default drift huzuia uthibitishaji au hufanya uanzishaji ushindwe kufungwa. | Ndiyo; weka nakala rudufu. |
| `RandomDayGuard/SavedRoot.txt` | Hiari, ubatilishaji wa mizizi iliyohifadhiwa ya hiari. | Kitatuzi-mizizi-kilichohifadhiwa katika `main.lua`. | Njia moja ya jumla ya mfumo wa faili hadi `AbioticFactor/Saved`. | Huchagua mzizi unaotumika kwa kumbukumbu, hifadhi, PlayerData majina ya faili, na `Admin.ini`. | Kukosa kunaruhusiwa; njia zisizo salama, zisizo sahihi au zisizoweza kusomeka bado hazijathibitishwa. | Ndiyo; usiweke kitambulisho hapa. |
| `RandomDayGuard/BUILD_MARKER.txt` | Utambulisho wa kifurushi kinachoweza kusomeka na binadamu. | Kisakinishi, kithibitishaji, na opereta. | Toleo la toleo lililotolewa na mjenzi. | Hakuna mabadiliko ya wakati wa utekelezaji. | Toleo lisilolingana huzuia ufungaji. | Hapana. |
| `RandomDayGuard/MANIFEST.json` | Kitambulisho cha kifurushi kinachosomeka na mashine na metadata ya mpangilio. | Kithibitishaji, kijenzi na zana za usaidizi. | Toleo la toleo lililotolewa na mjenzi. | Hakuna mabadiliko ya wakati wa utekelezaji. | JSON au toleo lisilolingana huzuia ufungaji. | Hapana. |
| `RandomDayGuard/README.txt` | Rejeleo la haraka la Kiingereza lililosakinishwa. | Opereta. | Njia zilizofungashwa na chaguo-msingi salama. | Hakuna mabadiliko ya wakati wa utekelezaji. | Njia za zamani au maneno ya usalama yanashindwa kusawazisha hati. | Hapana. |
| `RandomDayGuard/Scripts/main.lua` | UE4SS ingizo, ukusanyaji wa ushahidi, umiliki wa serikali, upangaji wa mipaka, utekelezaji wa hiari na waandishi wa matokeo. | UE4SS. | Config, Vyanzo-mizizi vilivyohifadhiwa, hali ya sasa ya utekelezaji, kamusi na sehemu ya kuripoti. | Huandika madarasa ya wakati wa utekelezaji katika [`OUTPUT_SCHEMA_REFERENCE.md`](REJELEO_LA_UTARATIBU_WA_PATO.md); njia ya utekelezaji iliyoidhinishwa inaweza kuhifadhi nakala na kusasisha `Admin.ini`. | Startup/poll/write kufeli huleta hali ya hitilafu dhahiri na kamwe haithibitishi kukamilika kwa njia. | Hapana. |
| `RandomDayGuard/Scripts/public_pipeline.lua` | Uhasibu wa chanzo, ukoo wa mzunguko wa sasa, tafsiri ya ripoti, uthibitisho wa njia, historia ya kudumu ya umma, na kikasha toezi cha hiari cha ndani. | `main.lua` ripoti mfanyakazi. | Kusoma pekee state/context callbacks na ushahidi wa ndani uliobaki. | Huandika ripoti JSON/TXT jozi, source/history uhasibu, uthibitisho wa njia, historia ya kudumu ya akaunti, na arifa status/envelopes. | Nasaba haipo, chanzo kinachohitajika, maandishi yaliyooanishwa, au nguvu za uandishi zinazothibitisha njia `missing` na huzuia kupanga foleni. | Hapana. |
| `RandomDayGuard/data/detection_events.json` | Msamiati na maelezo ya tukio la umma. | `main.lua` tukio normalization/reporting. | Halali JSON kamusi. | Inaweka lebo ushahidi; haiundi uchunguzi. | Missing/malformed data huzuia uthibitishaji wa hazina. | Hapana. |
| `RandomDayGuard/data/warning_types.json` | Msamiati wa aina ya onyo na maana ya ukaguzi. | Tahadhari normalization/reporting. | Halali JSON kamusi. | Inaweka lebo ushahidi wa onyo. | Missing/malformed data huzuia uthibitishaji wa hazina. | Hapana. |
| `RandomDayGuard/data/object_categories.json` | Object/class kategoria ya msamiati. | Changanua na kuripoti kusajili kitu. | Halali JSON kamusi. | Lebo zilizotolewa muktadha wa darasa. | Missing/malformed data huzuia uthibitishaji wa hazina. | Hapana. |
| `RandomDayGuard/runtime/**/.gitkeep` | Kishika nafasi tupu cha mpangilio wa usakinishaji pekee. | Utoaji wa kifurushi. | Baiti tupu. | Inaunda muundo wa saraka inayoweza kuandikwa; hakuna ushahidi uliowekwa. | Mwanachama yeyote ambaye si kishikilia nafasi anazuia orodha kamili ya ruhusa. | Hapana. |

<a id="ue4ss-loader-and-watchdog"></a>
## UE4SS kipakiaji na mlinzi

`Scripts/main.lua` anamiliki uanzishaji wa shirika linalojitegemea, Ugunduzi wa Saved-root, mkia wa sasa wa kumbukumbu, vipindi na vipindi vya seva, upigaji kura wa mipaka na utambazaji, object/world muktadha, kagua alama, `Admin.ini` malango ya usalama, matokeo ya utendakazi yaliyorithiwa, na kipengee tofauti cha kukabidhi kwa mfanyakazi wa ripoti. Ni lazima kuweka upigaji kura wa moja kwa moja ukiwa na mipaka huku kazi ya polepole ya kihistoria ikiendelea kwa kujitegemea. Mapigo ya moyo, kiashirio cha kuanzia, au kuongezeka `poll_id` inathibitisha kipengele hicho pekee; ukamilisho wa njia unahitaji kuwashwa kwa sasa, enzi, kura ya maoni, ubora wa chanzo, jozi ya ripoti na uthibitisho wa njia.

Chanzo na kifurushi vina mamlaka moja: `RandomDayGuard/Scripts/main.lua`. Herufi ndogo `scripts/` nakala si sehemu ya mti chanzo au toleo. Kuweka tahajia moja ya kisheria huzuia makosa ya mgongano wa kesi wakati kifurushi kinatolewa kwenye Windows au Linux.

<a id="public-reporting-module"></a>
## Moduli ya kuripoti kwa umma

`Scripts/public_pipeline.lua` hupokea simu badala ya vitambulisho vya seva pangishi au adapta za watoa huduma. Huorodhesha madaraja manane ya chanzo, hurekodi hali ya mwisho na halijakamilika, huweka wachezaji wa sasa tofauti na historia iliyohifadhiwa, hutafsiri kila njia kwa mpangilio `Observed`, `Interpretation`, `Unknown`, `Does not prove`, `Next action`, na `Source references`, kisha huandika uthibitisho wa njia. Hali ya hiari ya arifa huandika ya ndani JSON bahasha pekee; haidai kamwe uwasilishaji au kuunganisha uwasilishaji endpoint/bridge.

Ratiba inayoweza kutekelezwa katika `tests/lua/public_pipeline_runtime_test.lua` hupakia sehemu hii iliyosafirishwa kwa kutumia Lua, inathibitisha njia kamili na zinazotarajiwa kuwa tupu, inathibitisha kwamba mzunguko wa chanzo-chanzo-chanzo-cha-sasa haujafungwa, na inathibitisha kuwa njia zisizokamilika haziingii kwenye kikasha toezi.

<a id="configuration-and-data"></a>
## Usanidi na data

[`CONFIG_FIELD_CATALOG.md`](CONFIG_SHAMBA_KATALOGI.md) na [`TRACEABILITY_INDEX.json`](../../TRACEABILITY_INDEX.json) hutengenezwa na `tools/generate_documentation_audit.py` kutoka kwa uchanganuzi wa muundo usio na utekelezaji wa `config.lua`, orodha ya ruhusa ya kifurushi, na madarasa ya matokeo yaliyogunduliwa na chanzo. Maudhui kamili yanayozalishwa na chanjo ya moja kwa moja imethibitishwa. Watatu JSON kamusi ni lebo na michoro, si vyanzo vya ushahidi. Opereta anaweza kuhariri usanidi, uteuzi wa mizizi iliyohifadhiwa, na kuwezesha; chanzo, kamusi, maonyesho, na vifurushi vya kusoma vinamilikiwa na toleo.

<a id="package-layout"></a>
## Mpangilio wa kifurushi

Mjenzi hukubali faili tatu za msingi pekee za kisheria, `RandomDayGuard/` njia zilizo juu, na vishika nafasi tupu vya wakati wa utekelezaji. Inaagiza wanachama kwa njia, kurekebisha ZIP metadata, hupakia kipakiaji kanuni mara moja, huchanganua kila mwanachama kwa nyenzo za faragha, hurekodi SHA-256 kwa kila mwanachama, huunganisha majina na baiti kwenye muhtasari mmoja wa maudhui, na huunda mara mbili. Majaribio yanakataa kila mgongano wa kisa na kuthibitisha kuwa uchimbaji wa kawaida hutoa faili moja halisi kwa kila ingizo la kumbukumbu.

Hazina ya umma huweka folda ya sasa ya toleo pekee. Mjenzi hukagua kuwa ZIP, checksum, madokezo, vialamisho vya matoleo, na mti chanzo zinakubali.

<a id="code-comment-contract"></a>
## Mkataba wa maoni ya msimbo

Maoni ya wakati wa utekelezaji ni mikataba mifupi ya watunzaji, si mwongozo wa pili. Kila sehemu ya wakati wa utekelezaji inayosafirishwa lazima iweke kiungo kimoja cha kisheria katika sehemu yake ya ufunguzi ya maoni:

```lua
-- Documentation: docs/SOURCE_MODULE_REFERENCE.md#ue4ss-loader-and-watchdog
```

Hali isiyo dhahiri, kuratibu, write/readback/rollback, ugunduzi-chanzo, tafsiri, ushahidi, utaratibu wa matokeo, miadi ya njia, na vizuizi vya urekebishaji hutumia maoni yaliyolengwa na lebo hizi inapohitajika:

```lua
-- Public contract: <invariant or consequence>
-- Evidence boundary: <what the input cannot prove>
-- Failure behavior: <how the block fails closed or recovers>
-- Documentation: docs/<canonical-file>.md#<existing-anchor>
```

Kipakiaji kikuu pia kina maoni moja ya mmiliki yaliyolengwa kwa upakiaji wa usanidi, ugunduzi uliohifadhiwa, uingizwaji wa atomiki, utekelezaji, na kuratibu. Maoni haya yanasema udhibiti wa mtiririko na mipaka ya kushindwa; hazibadilishi tabia ya wakati wa utekelezaji.

Kithibitishaji kinahitaji kiwango cha sehemu `Documentation:` kiungo kwa kila sehemu ya wakati wa utekelezaji, husuluhisha kila njia ya maoni na kiunga, huhitaji maoni mahususi ya mkataba na kutofaulu katika sehemu zote mbili za wakati wa utekelezaji, na hulinganisha viungo sawa vya kisheria na `TRACEABILITY_INDEX.json`. Maoni ni ufuatiliaji, sio uthibitisho wa wakati wa utekelezaji.

<a id="contributor-change-checklist"></a>
## Orodha tiki ya mabadiliko ya mchangiaji

1. Sasisha sehemu moja ya umiliki na muundo wake unaolenga.
2. Sasisha usanidi, taratibu, matokeo, ushahidi au sehemu ya mzunguko wa maisha.
3. Endesha `python -B tools/generate_documentation_audit.py --write` baada ya usanidi, njia iliyofungashwa, darasa la pato linalozalishwa, mmiliki, au mabadiliko ya mkataba wa urejeshaji.
4. Endesha `python -B tools/generate_documentation_audit.py --check`, majaribio ya vitengo vilivyolengwa, muundo halisi wa Lua ambapo Lua inapatikana, kithibitishaji kamili, miundo miwili huru ya kubainisha, na `git diff --check`.
5. Kagua iliyozalishwa ZIP orodha ya wanachama, cheki, na uchanganuzi wa nyenzo za kibinafsi kabla ya kuunda toleo.
