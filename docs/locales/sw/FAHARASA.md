<a id="glossary"></a>
# Faharasa

> **Chanzo cha Kiingereza cha Canonical:** [GLOSSARY.md](../../GLOSSARY.md). Hati hizi zilizojanibishwa huhifadhi amri kamili, njia, funguo, thamani za hali, heshi na majina ya faili. Ikiwa maneno ya kiufundi yanatofautiana, tumia chanzo cha Kiingereza.


| Muda | Maana dhahiri | Maana halisi ya kiufundi |
|---|---|---|
| Kumbukumbu inayotumika | Regi ya sasa ya seva inayotumika kwa ushahidi mpya. | Inahitajika `active_log` chanzo; usomaji pamoja na mstari wa sasa unahitajika kwa ajili ya kukamilisha njia. |
| Kitambulisho cha Kuanzisha | Mchakato mmoja wa walinzi unaanza. | Kitambulishi cha sasa cha muda wa utekelezaji kimetumika kukataa kuwasha kabla errors/reports. |
| Kitambulisho cha Epoch | Kipindi cha muendelezo cha seva moja. | Kitambulishi kinachotumia muda wa kawaida wa utekelezaji hadi mantiki ya mwendelezo ianze kipindi kingine. |
| Kitambulisho cha Kura | fursa moja ya kura yenye mipaka. | Sehemu chanya ya mzunguko wa monotoni; zero/missing haiwezi kukamilisha njia. |
| Upya wa chanzo | Kama chanzo cha sasa na ukoo wa kura ya maoni unakubali. | `fresh_current_poll` au `stale_or_unproven` yenye mihuri ya muda na hali ya kumbukumbu-amilifu. |
| Uhasibu wa chanzo | Orodha ya upatikanaji wa ushahidi na mipaka. | `randomdayguard.source-accounting/v1` yenye madarasa manane ya chanzo na current/historical upeo. |
| `available` | Chanzo kilipatikana na kusomwa. | Hali ya chanzo cha kituo na `available=true`, `readable=true`. |
| `expected_empty` | Chanzo cha hiari kiliangaliwa na kihalali absent/empty. | Hali ya chanzo inayoweza kusomeka ya kituo; kamwe hutengeneza somo. |
| `partial` | Kazi iliyounganishwa ina matokeo muhimu lakini hayajakamilika. | Nonterminal source/accounting hali; anzisha tena mfanyakazi anayemiliki. |
| `deferred` | Kazi inasubiri kukusudia. | Hali ya chanzo kisicho cha kawaida; sio kosa au kukamilika. |
| `unavailable` | Chanzo hakiwezi kutumika kwa sasa. | Pengo la kituo; pengo la chanzo kinachohitajika hufanya uhasibu usipatikane. |
| `malformed` | Chanzo kipo lakini ni batili kimuundo. | Pengo la kituo kuhifadhi maelezo ya uthibitishaji na kufunga maandishi tegemezi. |
| `permission_denied` | Mfumo wa uendeshaji umekataa ufikiaji waziwazi. | Pengo la kituo ni tofauti na missing/unavailable. |
| `error` | Operesheni yenye mipaka imeshindwa bila kutarajiwa. | Kushindwa kwa kituo kuhitaji urejeshaji uliotajwa; hakuna maelezo ya siri katika ripoti za umma. |
| `complete` | Vyanzo vyote vilivyohesabiwa ni vya mwisho bila pengo. | Hali ya uhasibu chanzo cha kiwango cha juu. |
| `complete_with_gaps` | Ushahidi wa sasa unaohitajika hufanya kazi; mapengo ya hiari ya vituo yamesalia. | Hali ya uhasibu ya kiwango cha juu; njia bado zinatumia mahitaji yao wenyewe. |
| `full` | Njia iliyokamilishwa kwa mkataba wake usio tupu unaohitajika. | Enum ya uthibitisho wa njia iliyo na matokeo yaliyokamilika ya mzunguko wa sasa. |
| `limited_expected_empty` | Njia imekamilika na haikuweza kustahiki subject/failure. | Enum ya uthibitisho wa njia na `completed=true`, `expected_empty=true`. |
| `missing` | Uthibitisho wa kukamilisha njia haupo au umeshindwa. | Enum ya uthibitisho wa njia na `completed=false`; kamwe haustahiki kikasha toezi. |
| Ripoti yenye muundo | Njia inayoweza kusomeka na mashine. | `<route>_latest.json` kwa kutumia `randomdayguard.report/v1`. |
| Ripoti iliyotafsiriwa | Utoaji unaoweza kusomeka na binadamu wa njia sawa. | `<route>_latest.txt` yenye mpangilio thabiti wa marejeleo ya Kuzingatiwa-kwa-Chanzo. |
| Uthibitisho wa njia | Leja ya kukamilisha njia-mbali. | `route_proof.json` inafunga version/boot/epoch/poll/freshness/output njia. |
| Ushahidi wa sasa | Uangalizi unaomilikiwa na mzunguko unaotumika. | Upeo `current`; haijaundwa upya kutoka zamani filenames/reports. |
| Ushahidi wa kihistoria | Muktadha uliohifadhiwa kutoka kwa mizunguko ya awali au uchanganuzi wa polepole. | Upeo `historical`; inaweza kuarifu ukaguzi lakini haiwezi kudai uwepo wa sasa. |
| Kagua pekee | Toa ushahidi wa ukaguzi bila Admin.ini anaandika. | Chaguo-msingi `review_only_mode=true`, `auto_ban=false`, `write_admin_ini=false`. |
| Ukaguzi wa usalama wa kupiga marufuku | Mlinzi wa swali lazima alijibu kabla halijabadilika `Admin.ini`. | Lazima ithibitishe akaunti na alama, isijumuishe akaunti zinazoaminika na nakala, ithibitishe nakala, itambue mabadiliko ya nje, kuhifadhi masasisho yaliyokusudiwa, na kuthibitisha au kurejesha faili kamili kwa usalama. |
| Kikasha toezi cha ndani | Makabidhiano ya arifa ya mtoa huduma bila upendeleo. | JSON faili zilizo na `delivery_backend="none"` na `delivery_attempted=false`. |
| Msingi | Picha ya muktadha wa faili iliyohifadhiwa yenye mipaka iliyokamilika. | Manifest/object/world hali hutumika tena wakati inaoana na safi vya kutosha. |
| Kituo cha ukaguzi | Rejesha msimamo kwa kazi isiyokamilika ya skanisho. | `scan_checkpoint.json`; kufuta sio urejeshaji chaguomsingi. |
| Kielezo kinachoweza kujengwa upya | Muhtasari ambao unaweza kufanywa upya. | Daily/weekly/forensic/final towe la ukaguzi; ushahidi wa chanzo unasalia kuwa halali. |
| Mpaka wa ushahidi | Kikomo cha kile ambacho chanzo kinaweza kuauni. | Wazi `does_not_prove`, haijulikani, nguvu ya utambulisho, na sheria za upeo. |

Ufafanuzi wa kanuni za miundo ziko katika [`OUTPUT_SCHEMA_REFERENCE.md`](REJELEO_LA_UTARATIBU_WA_PATO.md); masharti ya usanidi yako katika [`CONFIG_FIELD_CATALOG.md`](CONFIG_SHAMBA_KATALOGI.md).
