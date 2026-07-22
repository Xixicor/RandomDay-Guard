<a id="evidence-boundary"></a>
# Mpaka wa ushahidi

> **Chanzo cha Kiingereza cha Canonical:** [EVIDENCE_BOUNDARY.md](../../EVIDENCE_BOUNDARY.md). Hati hizi zilizojanibishwa huhifadhi amri kamili, njia, funguo, thamani za hali, heshi na majina ya faili. Ikiwa maneno ya kiufundi yanatofautiana, tumia chanzo cha Kiingereza.


Tumia ukurasa huu kuamua ni niniRandomDayGuard inaweza kuripoti na kile ambacho bado kinahitaji ukaguzi wa kibinadamu.

<a id="core-rule"></a>
## Sheria kuu

RandomDayGuard hurekodi uchunguzi wenye mipaka kutoka kwa faili zinazomilikiwa na seva. Ni lazima ibainishe chanzo, upeo, hali ya mkusanyo na mipaka kwa kila hitimisho la nyenzo.

Ushahidi ulioundwa ni halali. Ripoti iliyotafsiriwa inaelezea ushahidi; haiwezi kuongeza ukweli ambao haupo kwenye rekodi iliyoundwa.

<a id="evidence-source-classes"></a>
## Madarasa ya chanzo cha ushahidi

| Daraja la chanzo | Matumizi ya kawaida | Haithibitishi yenyewe |
|---|---|---|
| `admin_ini` | Hali iliyopo ya utawala na imekaguliwa write/readback muktadha | Ni nani aliyesababisha tukio |
| `active_log` | Ya Sasaserver/session matukio yanayoonekana kwenye kumbukumbu amilifu | Nia, umiliki au uharibifu wa moja kwa moja |
| `recent_backup_logs` | Muktadha wa kumbukumbu ya kihistoria | Tukio la sasa limetokea |
| `playerdata_filenames` | Uthibitisho kwamba kitambulisho cha akaunti safi kipo | Tabia, hatia au umiliki wa utambulisho zaidi ya kitambulisho kilichofichuliwa |
| `existing_cases` | Muktadha wa ukaguzi wa awali | Kwamba tafsiri ya awali inasalia kuwa sahihi |
| `existing_reports` | Muhtasari na maamuzi ya awali | Ukweli wa sasa bila uthibitisho wa sasa |
| `existing_evidence` | Ushahidi wa muundo wa kihistoria | Shughuli ya sasa |
| uchanganuzi wa kuokoa ulimwengu ulio na mipaka | Polepole world/class muktadha | Kitendo cha mchezaji, umiliki, wizi, urudufishaji au uharibifu |

Kila chanzo kinarekodi availability/readability, idadi ya faili, marejeleo ya chanzo, upeo wa sasa au wa kihistoria, na `does_not_prove` taarifa.

<a id="source-states"></a>
## Majimbo ya chanzo

| Jimbo | Maana ya opereta |
|---|---|
| `available` | Chanzo kiliweza kusomeka na ushahidi ulikusanywa. |
| `expected_empty` | Chanzo kilisomeka na kwa uhalali hakikuwa na rekodi inayolingana. |
| `partial` | Baadhi ya ushahidi ulikusanywa; chanjo haijakamilika. |
| `deferred` | Kazi iliyowekewa mipaka iliahirishwa kimakusudi. |
| `unavailable` | Chanzo hakipo katika mazingira haya. |
| `malformed` | Chanzo kipo lakini hakiwezi kuchanganuliwa kwa usalama. |
| `permission_denied` | Msimamizi hana ruhusa ya kusoma. |
| `error` | Mkusanyiko umeshindwa kwa sababu nyingine iliyorekodiwa. |

Utupu unaotarajiwa ni uchunguzi halali. Haipaswi kamwe kugeuzwa kuwa mchezaji wa kubuni, kesi, tukio au shutuma.

<a id="current-versus-historical-evidence"></a>
## Ushahidi wa sasa dhidi ya historia

Ushahidi wa sasa ni wa dirisha amilifu la mkusanyiko au enzi ya seva. Ushahidi wa kihistoria unatokana na kumbukumbu za awali, kesi, ripoti, rekodi za ushahidi, chelezo, au misingi.

Ushahidi wa kihistoria unaweza kutoa muktadha. Haiwezi kujaza kimya pengo la ushahidi wa sasa. Ripoti lazima ziweke alama katika mawanda yote mawili na kutaja vyanzo vyake kando.

<a id="corroboration-rule"></a>
## Sheria ya uthibitishaji

Haya ni muktadha muhimu lakini si uthibitisho wa moja kwa moja wao wenyewe:

- onyesha majina au mfanano wa majina;
- sadfa ya wakati;
- ondoa au unganisha upya churn;
- mlipuko mmoja wa ajali au onyo;
- daraja, njia, mwigizaji, ramani, au tokeni za kuhesabu vitu;
- uanachama katika hali iliyopangwa kiotomatiki;
- ripoti za awali bila uthibitisho wa sasa wa chanzo.

Usidai hatia, nia, udanganyifu, umiliki, wizi, urudufishaji, uharibifu wa moja kwa moja, matumizi ya moja kwa moja ya kontena, hatua ya moja kwa moja ya hesabu, viwianishi halisi, midundo ya moja kwa moja, au tabia ya kiwango cha kumbukumbu bila ushahidi unaofichua ukweli huo moja kwa moja.

<a id="truthful-report-language"></a>
## Lugha ya ripoti ya ukweli

Tumia:

```text
Observed: the account was active in the recorded crash window.
Interpretation: repeated overlap warrants operator review.
Unknown: the cause of the crash.
Does not prove: that the account caused the crash.
Next action: compare the cited current session and lifecycle records.
```

Epuka:

```text
The player crashed the server.
The player stole or duplicated items.
The world token proves who used the object.
```

<a id="report-reading-order"></a>
## Ripoti agizo la usomaji

Kila ripoti inayoonekana hadharani inapaswa kueleza:

1. Maana dhahiri.
2. Kwa nini ni muhimu.
3. Uthibitisho wa kiufundi na marejeleo ya chanzo.
4. Kitendo kinachofuata.
5. Vikomo, visivyojulikana, na madai hayajathibitishwa.

<a id="related-docs"></a>
## Nyaraka zinazohusiana

- [`OUTPUT_SCHEMA_REFERENCE.md`](REJELEO_LA_UTARATIBU_WA_PATO.md)
- [`PLAYER_REVIEW_WORKFLOW.md`](MTIRIRIKO_WA_KAZI_WA_MAONI_YA_MCHEZAJI.md)
- [`BAN_ID_MAPPING.md`](PIGA_MARUFUKU_RAMANI_YA_KITAMBULISHO.md)
- [`DETECTION_SIGNALS.md`](ALAMA_ZA_UTAMBUZI.md)
