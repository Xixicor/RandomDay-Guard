<a id="architecture-and-lifecycle"></a>
# Usanifu na mzunguko wa maisha

> **Chanzo cha Kiingereza cha Canonical:** [ARCHITECTURE.md](../../ARCHITECTURE.md). Hati hizi zilizojanibishwa huhifadhi amri kamili, njia, funguo, thamani za hali, heshi na majina ya faili. Ikiwa maneno ya kiufundi yanatofautiana, tumia chanzo cha Kiingereza.


RandomDayGuard ni moja UE4SS walinzi pamoja na sehemu moja ya kuripoti. Inasoma faili zinazomilikiwa na seva, hudumisha hali ya ndani iliyo na mipaka, na huandika ushahidi wa ndani na kukagua matokeo. Haina mtoa huduma, paneli-dhibiti, huduma ya arifa, RandomDay, au utegemezi wa mtandao.

<a id="end-to-end-data-flow"></a>
## Mtiririko wa data wa mwisho-hadi-mwisho

1. UE4SS hupakia kiingilio kimoja cha kisheria `RandomDayGuard/Scripts/main.lua`. Vifurushi vya sasa havisafirishi nakala ya lahaja ya herufi ndogo.
2. Kipakiaji kinasoma `config.lua`, kamusi tatu za data, na hiari `SavedRoot.txt`. Utambulisho wa toleo lazima ukubaliane na `VERSION`, `MANIFEST.json`, na `BUILD_MARKER.txt`.
3. Ugunduzi wa Mizizi iliyohifadhiwa hukagua wagombeaji wanaojulikana na faili zinazojulikana moja kwa moja. Inarekodi kile ambacho kilikuwa kinasomeka katika `runtime/saved_path_probe.json`; kupata saraka peke yake sio chanjo ya ushahidi.
4. Safu ya papo hapo inashikilia kumbukumbu ya seva inayotumika kutoka kwa uwekaji salama. Hurekebisha mzunguko wa maisha, kipindi, akaunti, onyo, kuunganisha upya, na matukio mengine yanayozingatiwa kuwa ushahidi wa nyongeza pekee pamoja na vijipicha vya sasa.
5. Orodha za safu ya polepole Imehifadhi faili katika vipande vilivyo na mipaka. Huandika maendeleo na vituo vya ukaguzi, huanza tena kazi isiyokamilika, hulinganisha faili ya maelezo iliyobadilishwa, na kutoa sehemu kisha ya mwisho object/world muktadha.
6. Mantiki ya kukagua inahusiana tu na ushahidi unaopatikana nayo. Majina dhaifu ya faili, muda, hesabu za darasa, viwianishi jamaa, churn, ajali moja au ping husalia kuwa muktadha na haiwezi kuidhinisha utekelezaji pekee.
7. Mfanyakazi tofauti anapiga simu `Scripts/public_pipeline.lua`. Huweka aina za vyanzo vya orodha, hurekodi mawanda ya sasa dhidi ya historia, hufunga mzunguko kwa version/boot/epoch/poll/source upya, huandika njia tano mahususi JSON/TXT jozi, na kisha kuandika `route_proof.json`.
8. Ikiwashwa kwa uwazi, kisanduku toezi cha ndani kinakili marejeleo kutoka kwa ripoti iliyokamilika baada ya uthibitisho wa njia kuwepo. Inarekodi `delivery_backend="none"` na `delivery_attempted=false`; usafiri uko nje ya bidhaa hii.

<a id="ownership-and-asynchronous-boundaries"></a>
## Mipaka ya umiliki na isiyosawazisha

| Mmiliki | Kazi yenye mipaka | Lazima isizuie au kuashiria |
|---|---|---|
| Anzisha | Config, Saved-root, active-log, epoch, indexes, hali ya awali. | Kiweka alama cha kipakiaji kilichofaulu hakithibitishi ushahidi au njia. |
| Piga simu katika kura | Log byte mpya, masasisho ya hali, event/session/account matokeo, kuratibu. | Ugunduzi unaojirudia polepole au ripoti kumalizika. |
| Changanua mfanyakazi | Ugunduzi wa wazi, uchanganuzi wa faili, kituo cha ukaguzi, partial/finalmsingi. | Maendeleo ya sasa ya kumbukumbu; sehemu sio kushindwa. |
| Ripoti mfanyakazi | Uhasibu wa chanzo, tafsiri, jozi za ripoti, uthibitisho wa njia, kikasha toezi cha ndani. | Utekelezaji au uwasilishaji wa nje. |
| Utekelezaji wa hiari | Thibitisha akaunti na upate alama, linda akaunti na nakala zinazoaminika, thibitisha nakala rudufu, kataa mabadiliko ya nje ya faili, kisha uthibitishe matokeo yaliyohifadhiwa. | Alama ya ripoti, hali ya njia, au uanachama wa kesi unaopita ukaguzi wowote wa usalama unaohitajika. |

Kitanzi cha kura hubaki na afya wakati tu `poll_id` maendeleo, `poll_in_flight` hurejesha sivyo, na upangaji unabaki kuwa amilifu. Hiyo inathibitisha kipengele cha kura, si bomba la ripoti. Uchanganuzi wa polepole unaweza kuwa `partial` au `deferred`; chaguo-msingi `slow_world_scan_blocks_current_reports=false` huruhusu njia mpya za sasa kuendelea huku ikitaja kizuizi cha kihistoria.

<a id="state-and-lifecycle"></a>
## Jimbo na mzunguko wa maisha

| Jimbo | Ingizo | Kituo au hali inayofuata | Hitilafu na urejeshaji |
|---|---|---|---|
| Anzisha | UE4SS inaomba kipakiaji. | Inaendesha poll/scan/report wafanyakazi walio na kitambulisho cha kuwasha na enzi. | `startup_error` ni ushahidi muhimu wa sasa; tengeneza config/path/source na uanze upya. |
| Kura ya sasa | Piga simu iliyoratibiwa huanza. | Muhuri wa muda wa rekodi za kura ya maoni na ratiba mpya. | `poll_error` ni ushahidi muhimu wa sasa; rejesha kazi iliyowekewa mipaka na uthibitishe kura mpya zaidi. |
| Scan inasubiri | Kituo cha ukaguzi cha msingi kinahitajika au ambacho hakijakamilika kimepatikana. | `partial`/`deferred`, kisha `scan_complete`. | Rejea kituo cha ukaguzi; jenga upya tu wakati stale/incompatibleushahidi umerekodiwa. |
| Uhasibu wa chanzo | Ripoti orodha ya wafanyikazi aina nane chanzo. | `complete`, `complete_with_gaps`, `partial`, au `unavailable`. | Disabled/failed uhasibu hulazimisha njia zote kwenda `missing`. |
| Uzalishaji wa njia | Ukoo wa mzunguko wa sasa na uhasibu chanzo zinapatikana. | `full`, `limited_expected_empty`, au `missing`. | Imeoanishwa JSON/TXT au kushindwa kuandika kwa uthibitisho wa njia hubadilisha njia hadi `missing`. |
| Kikasha toezi cha ndani | Njia imewashwa, imekamilika na inastahiki. | Bahasha ya ndani inayosubiri na matokeo ya hali ya arifa. | Hakuna maandishi au uthibitisho usio kamili inamaanisha hakuna bahasha; hakuna utoaji unaokisiwa. |
| Uhakiki wa utekelezaji | Ushahidi mahususi wa akaunti hufikia alama iliyosanidiwa kwa kitendo kiotomatiki. | Pendekezo la ukaguzi pekee au umewezeshwa kwa uwazi `Admin.ini`sasisha. | Ukaguzi wa usalama umeshindwa au haupatikani husimamisha sasisho; ulinganisho wa mwisho ulioshindwa hurejesha nakala rudufu iliyothibitishwa wakati urejeshaji umewashwa. |

<a id="current-and-historical-evidence"></a>
## Ushahidi wa sasa na wa kihistoria

Ushahidi wa sasa ni wa amilifu boot/poll na haijaundwa upya kutoka kwa majina ya faili yaliyohifadhiwa pekee. Ushahidi wa kihistoria unajumuisha magogo yaliyozungushwa, yanayodumu account/session historia, imehifadhiwa cases/reports/evidence, na uchanganuzi wenye mipaka wa kuokoa ulimwengu. Ripoti hufichua safu na hesabu tofauti za sasa na za kihistoria. Kuanzisha upya kwa utulivu lazima kusifute muktadha wa kudumu, na rekodi ya kihistoria haipaswi kuwasilishwa kama uwepo wa sasa.

<a id="completion-and-recovery-boundary"></a>
## Mpaka wa kukamilisha na urejeshaji

Kukamilika kwa njia moja kunahitaji kulinganisha toleo la sasa la mzunguko, kitambulisho cha kuwasha, kitambulisho cha epoch, kitambulisho chanya cha kura, hali mpya ya kumbukumbu amilifu, matokeo ya njia zote mbili, na ingizo lake katika `route_proof.json`. Madai ya arifa pia yanahitaji bahasha ya ndani ya mzunguko sawa; utoaji wa nje kamwe sio sehemu ya uthibitisho wa umma.

Ikiwa ripoti za mwisho hazipo au za zamani kuliko za sasa poll/sourcehali, endelea kutoka kwa ukoo wa kwanza usiolingana au uandishi ulioshindwa. Usibadilishe njia zisizohusiana, maneno, au mipangilio ya utekelezaji. Tazama[`OUTPUT_SCHEMA_REFERENCE.md`](REJELEO_LA_UTARATIBU_WA_PATO.md), [`TROUBLESHOOTING.md`](UTATUZI_WA_MATATIZO.md), na [`SOURCE_MODULE_REFERENCE.md`](MAREJELEO_YA_MODULI_YA_CHANZO.md).
