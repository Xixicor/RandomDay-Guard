<a id="operations-playbook"></a>
# Kitabu cha kucheza cha uendeshaji

> **Chanzo cha Kiingereza cha Canonical:** [OPERATIONS_PLAYBOOK.md](../../OPERATIONS_PLAYBOOK.md). Hati hizi zilizojanibishwa huhifadhi amri kamili, njia, funguo, thamani za hali, heshi na majina ya faili. Ikiwa maneno ya kiufundi yanatofautiana, tumia chanzo cha Kiingereza.


Hii ndiyo mpangilio wa kawaida wa kusoma kwa RandomDayGuard. Huhitaji kujua JSON, Git, checksums, au zana za mstari wa amri kukagua seva yenye afya.

<a id="daily-operator-flow"></a>
## Mtiririko wa opereta wa kila siku

1. Fungua `runtime/final_logs/server_status_latest.txt`. Inakueleza kama Guard inafuatilia uendeshwaji wa seva ya sasa, mzunguko wake wa mwisho ulipokamilika, ni wachezaji wangapi wameunganishwa na kama chanzo au utafutaji haujakamilika.
2. Fungua `runtime/final_logs/daily_rollup_latest.txt` mara moja kwa siku. Inatoa muhtasari wa vipindi vya siku moja, kuondoka, kesi zilizotajwa, orodha ya utambulisho, na huduma ya chanzo bila kurudia kila rekodi.
3. Fungua `runtime/final_logs/player_activity_latest.txt` pekee wakati seva ilikuwa na kujiunga, kuondoka, au kipindi kinachoendelea wakati wa mchana.
4. Fungua `runtime/final_logs/case_review_latest.txt` inapotaja tu somo la sasa. Ripoti inatoa akaunti, hali ya ukaguzi, alama, chanzo cha utambulisho na rekodi za kufungua zinazofuata.
5. Fungua `runtime/final_logs/critical_guard_latest.txt` tu wakati Walinzi wanaripoti kutofaulu katika uanzishaji wake, mzunguko wa ufuatiliaji au ripoti inapoandika.

Ikiwa njia haina chochote cha kuripoti, Walinzi hurekodi matokeo yanayotarajiwa tupu. Hiyo ni ukaguzi uliokamilika, si ripoti inayokosekana.

<a id="what-to-read-inside-a-report"></a>
## Cha kusoma ndani ya ripoti

Soma sehemu hizi kwa mpangilio:

1. **Muhtasari** - ripoti hii inashughulikia nini.
2. **Nini Walinzi waliona** - mihuri halisi ya nyakati, hesabu, akaunti, vipindi, au thamani za hali zilizokusanywa kwa njia hii.
3. **Ina maana gani** - tafsiri ya lugha rahisi ya rekodi hizo.
4. **Nini bado haijulikani** - chanzo au kikomo cha skanisho ambacho huathiri matokeo.
5. **Inapendekezwa hatua inayofuata** - iwapo itafuatilia, kukagua mada iliyotajwa, au kurekebisha Walinzi.
6. **Mpaka wa ushahidi** - kikomo cha upeo wa ripoti.

Rekodi ya kiufundi na marejeleo ya chanzo huonekana mwishoni kwa wasomaji wanaohitaji kukagua ushahidi kamili ulioundwa.

<a id="when-a-report-is-missing"></a>
## Wakati ripoti inakosekana

Fungua `runtime/final_logs/route_proof.json` tu wakati ripoti inayoweza kusomeka haipo au inasema uthibitisho wake wa sasa haupo. Kila njia ina mojawapo ya matokeo haya:

| Tokeo | Maana |
|---|---|
| `full` | Mlinzi alikamilisha njia kwa ushahidi wa sasa unaomilikiwa na njia. |
| `limited_expected_empty` | Mlinzi alikamilisha njia na hakupata tukio lolote linalofaa, au alirekodi kiwango cha ukomavu kilichotajwa. |
| `missing` | Chanzo kinachohitajika, ukaguzi wa ukoo, au uandishi wa ripoti iliyooanishwa haujakamilika. |

Kwa njia inayokosekana, fuata chanzo kilichotajwa au uandike hitilafu katika ripoti. Usibadilishe njia zisizohusiana au mipangilio ya arifa kwanza.

<a id="after-a-crash-or-restart"></a>
## Baada ya ajali au anzisha upya

1. Soma Hali ya Seva kwa muhuri mpya wa muda unaoendeshwa na seva na mzunguko wa hivi punde wa ufuatiliaji uliokamilika.
2. Soma Ulinzi Muhimu kwa hitilafu ya kuanzisha au ya sasa ya kura.
3. Soma Shughuli ya Mchezaji ikiwa tu kipindi cha siku moja kilijiunga, kuondoka au kurudi baada ya mabadiliko ya mzunguko wa maisha.
4. Hifadhi rekodi ya chanzo iliyotajwa kabla ya kubadilisha usanidi.

<a id="before-enabling-optional-adminini-writes"></a>
## Kabla ya kuwezesha hiari Admin.ini anaandika

Kifurushi chaguomsingi hutazama na kuripoti bila kubadilisha `Admin.ini`. Waendeshaji mahiri wanaweza kuwezesha njia ya hiari ya utekelezaji baada ya kuipima dhidi ya nakala ya faili. Mlinzi basi huhitaji kitambulisho safi cha akaunti ya nambari, hulinda akaunti zinazoaminika, kuunda na kuthibitisha nakala, kukataa mabadiliko yanayotokea wakati mmoja, kusoma tena faili iliyohifadhiwa na kurejesha nakala ikiwa uthibitishaji hautafaulu. Tazama[`ADMIN_INI_ENFORCEMENT.md`](UTEKELEZAJI_WA_USIMAMIZI_WA_INI.md) kwa usanidi kamili na utaratibu wa majaribio.

<a id="related-guides"></a>
## Miongozo inayohusiana

- [`START_HERE.md`](ANZIA_HAPA.md)
- [`REPORT_EXAMPLES.md`](RIPOTI_MIFANO.md)
- [`PLAYER_REVIEW_WORKFLOW.md`](MTIRIRIKO_WA_KAZI_WA_MAONI_YA_MCHEZAJI.md)
- [`TROUBLESHOOTING.md`](UTATUZI_WA_MATATIZO.md)
- [`OUTPUT_SCHEMA_REFERENCE.md`](REJELEO_LA_UTARATIBU_WA_PATO.md)
