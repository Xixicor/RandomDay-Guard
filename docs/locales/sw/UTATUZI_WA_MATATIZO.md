<a id="troubleshooting"></a>
# Utatuzi wa matatizo

> **Chanzo cha Kiingereza cha Canonical:** [TROUBLESHOOTING.md](../../TROUBLESHOOTING.md). Hati hizi zilizojanibishwa huhifadhi amri kamili, njia, funguo, thamani za hali, heshi na majina ya faili. Ikiwa maneno ya kiufundi yanatofautiana, tumia chanzo cha Kiingereza.


Tumia ukurasa huu wakati Walinzi hawapakii, chanzo hakiwezi kukusanywa, ripoti haionekani, au uthibitisho wa njia unakinzana na ulichotarajia. Anza na mti wa uamuzi na ufuate tawi moja. Tumia [rejeleo la hali na hitilafu](MAREJELEO_YA_HALI_NA_HITILAFU.md) baada tu ya safu iliyoshindwa kujulikana.

Hifadhi faili zinazotumika sasa kabla ya kubadilisha usanidi au kusakinisha upya. Kizalia cha zamani au kinachokosekana hutambua hatua iliyoshindwa; kuwasha upya mara kwa mara kunaweza kufuta ushahidi huo.

<a id="choose-the-failure-path"></a>
## Chagua njia ya kushindwa

<a id="1-decide-whether-guard-loaded"></a>
### 1. Amua ikiwa Walinzi wamepakia

- **Hapana `runtime/` faili zipo:** fuata [Rejesha faili zinazokosekana wakati wa utekelezaji](#restore-missing-runtime-files). Thibitisha njia ya kusakinisha, kipakiaji kanuni, `enabled.txt`, na `mods.txt` kabla ya kuchunguza ripoti.
- **Faili za hali ya sasa zipo:** Walinzi wamepakia mbali vya kutosha kuandika hali. Endelea kwa hatua ya 2; kusakinisha upya sio jibu la kwanza.

<a id="2-decide-whether-the-scheduler-is-advancing"></a>
### 2. Amua ikiwa kipanga ratiba kinaendelea

Fungua:

```text
runtime/current/startup_status.json
runtime/current/poll_status.json
```

- **Kaunta na mihuri ya muda mapema:** endelea hadi hatua ya 3.
- **`poll_id` ni tuli, `poll_in_flight` inabaki kuwa kweli, au hali ya kiratibu haifanyiki:** fuata [Rejesha mzunguko wa kura uliokwama](#recover-a-stuck-poll-loop).
- **Uchanganuzi wa kimsingi unasubiri wakati maendeleo ya kiratibu yanaendelea:** hili ni tahadhari, si uanzishaji ulioshindwa kiotomatiki. Chunguza tu ikiwa kumbukumbu nyuma au maendeleo ya kuchanganua yatakoma.

<a id="3-classify-route-proof"></a>
### 3. Panga uthibitisho wa njia

Fungua `runtime/final_logs/route_proof.json` na ukague kila njia kivyake.

- **`full`:** linganisha maneno yasiyotarajiwa na ya sasa `source_references` na ukoo. Usibadilishe uwasilishaji kwa sababu maneno pekee yanaonekana vibaya.
- **`limited_expected_empty`:** thibitisha uhasibu chanzo unaauni matokeo halali tupu. Usiunde kichezaji sanisi au kipochi.
- **`missing`:** fuata [Tambua njia inayokosekana](#diagnose-a-missing-route).

<a id="4-classify-source-coverage"></a>
### 4. Kuainisha chanzo cha habari

- **`partial`, `deferred`, `unavailable`, `malformed`, `permission_denied`, au `error`:** fuata [Tafsiri chanzo kisichokamilika](#interpret-incomplete-source-coverage), kisha utafute msimbo kamili katika [Marejeleo ya hali na makosa](MAREJELEO_YA_HALI_NA_HITILAFU.md).
- **Chanzo kilichoundwa ni cha sasa lakini matokeo yaliyotafsiriwa au yanayosubiri ni ya zamani zaidi:** tambua hati ya kukamilika kwa uwasilishaji, sio mwisho wa uwasilishaji. Hifadhi mihuri ya muda na kagua ripoti na hali ya kutuma kabla ya kubadilisha usanidi wa uwasilishaji.

<a id="5-follow-the-matching-branch"></a>
### 5. Fuata tawi linalolingana

- Utambulisho usio kamili: [Ramani kichezaji kisicho na ramani](#map-an-unmapped-player).
- Muendelezo wa kila siku haupo: [Rejesha orodha ya kila siku inayokosekana](#restore-a-missing-daily-rollup).
- Jaribio la utekelezaji lililoidhinishwa wazi halikuandika: [Tambua iliyozuiwa Admin.iniandika](#diagnose-a-blocked-adminini-write).
- ZIP uchimbaji haukufaulu: [Tatua mgongano wa kesi ya uchimbaji wa Windows](#resolve-a-windows-extraction-folder-collision).
- Urekebishaji, kifurushi, au ukaguzi wa hazina umeshindwa: [Uthibitishaji na uchapishaji wa ukaguzi](UTHIBITISHAJI_NA_KUTOLEWA.md#avoid-validation-environment-pitfalls).

<a id="6-stop-with-one-proved-outcome"></a>
### 6. Acha na tokeo moja lililothibitishwa

Pasi ya utatuzi huisha wakati:

- njia ni ya sasa na `full`;
- njia ni ya sasa na `limited_expected_empty` kwa sababu iliyotajwa;
- kizuizi kimoja kamili, njia ya ushahidi, na hatua inayofuata hurekodiwa; au
- urejeshaji nyuma umerejesha hali ya awali inayojulikana na kuhifadhi ushahidi ulioshindwa.

“Seva inafanya kazi,” mapigo ya moyo yanayoongezeka, au HTTP mafanikio pekee hayathibitishi njia ya kuripoti kukamilika.

<a id="diagnose-a-missing-route"></a>
## Tambua njia inayokosekana

Fungua `runtime/final_logs/route_proof.json` na ulinganishe `server_status`, `daily_rollup`, `player_activity`, `case_review`, na `critical_guard`.

1. Soma sababu ya njia, ukoo, muda wa uzalishaji na marejeleo ya chanzo.
2. Thibitisha chanzo kilichoundwa kilichotajwa kipo na ni cha mzunguko sawa.
3. Linganisha muda wake na towe lililotafsiriwa na bahasha inayosubiri.
4. Iwapo kumbukumbu za mwisho ni mpya zaidi kuliko toleo lililotafsiriwa au linasubiri, rekodi utumaji uliokwisha kukamilika na urekebishe mkono huo kwanza.
5. Ikiwa towe zote za ndani ni za sasa lakini uwasilishaji haupo, basi kagua usanidi wa njia na hali ya mtumaji.

Usionyeshe afya ya mratibu au arifa moja iliyofaulu kwa uthibitisho wa njia tano.

<a id="interpret-incomplete-source-coverage"></a>
## Tafsiri chanzo kisichokamilika

| Jimbo | Cha kufanya |
|---|---|
| `partial` | Tumia ushahidi uliokusanywa pekee na uepuke madai ya bima kamili. |
| `deferred` | Thibitisha maendeleo ya kazi yenye mipaka ya baadaye kabla ya kubadilisha usanidi. |
| `unavailable` | Rekodi kikomo cha mazingira; rekebisha tu njia iliyothibitishwa au suala la ruhusa. |
| `malformed` | Hifadhi chanzo na uchanganue hitilafu; usikisie thamani zinazokosekana. |
| `permission_denied` | Toa ruhusa finyu tu ya kusoma inayohitajika. |
| `error` | Hifadhi maelezo na utambue hatua iliyotajwa kabla ya kutegemea njia. |

<a id="restore-missing-runtime-files"></a>
## Rejesha faili zinazokosekana wakati wa utekelezaji

Thibitisha:

```text
mods.txt contains RandomDayGuard : 1
RandomDayGuard/enabled.txt exists
RandomDayGuard/Scripts/main.lua exists
```

Mzizi sahihi wa kusakinisha ni:

```text
AbioticFactor/Binaries/Win64/ue4ss/Mods/RandomDayGuard/
```

Kataa mpangilio huu uliowekwa:

```text
Mods/RandomDayGuard/RandomDayGuard/Scripts/main.lua
```

Kama faili ni sahihi lakini UE4SS haikuanzisha Mlinzi, hifadhi `UE4SS.log` na ulinganishe muhuri wake wa muda wa kuanza na mwanzo halisi wa mchakato wa mchezo.

<a id="resolve-a-windows-extraction-folder-collision"></a>
## Tatua mgongano wa folda ya uchimbaji wa Windows

Toleo la zamani lilitumia saraka za programu ambazo majina yake yalitofautiana kwa herufi kubwa pekee. Baadhi ya vichochezi vya Windows huunganisha majina hayo wakati ZIP inapowekwa juu ya folda iliyopo.

1. Futa tu uchimbaji wa muda ambao haukufanikiwa, si muundo uliosakinishwa au ushahidi wake.
2. Unda saraka mpya ya muda tupu.
3. Nyoa toleo la sasa hapo.
4. Thibitisha kuwa hutoa RandomDayGuard folda moja na saraka moja ya programu.
5. Ikiwa Windows bado inaripoti mgongano, pakua toleo tena na uripoti toleo la toleo na kichuna kilichotumika.

Usiwahi kutoa toleo jipya kwenye folda iliyosakinishwa. Fuata utaratibu wa kusasisha folda safi katika [`../INSTALL.md`](USAKINISHAJI.md).

<a id="load-the-expected-version"></a>
## Pakia toleo linalotarajiwa

Angalia kialamisha chanzo na kiweka alama cha kujenga:

```sh
grep -n "local VERSION" RandomDayGuard/Scripts/main.lua
cat RandomDayGuard/BUILD_MARKER.txt
```

Kama hawatakubali:

1. Simamisha seva.
2. Hifadhi nakala ya folda iliyosakinishwa, usanidi uliohakikiwa, na ushahidi wa wakati wa utekelezaji.
3. Piga hatua na uangalie kifurushi kinachokusudiwa.
4. Badilisha faili za programu na data zinazodhibitiwa na kifurushi pekee.
5. Thibitisha kuwa kipakiaji kanuni kipo na hakuna nakala ya herufi ndogo iliyoongezwa.
6. Anza mara moja na usome tena vialamisho vya sasa kabla ya kutathmini matokeo ya wakati wa utekelezaji.

<a id="correct-a-missing-saved-root"></a>
## Sahihisha mzizi Uliohifadhiwa unaokosekana

Fungua `runtime/saved_path_probe.json`. Weka njia kamili iliyothibitishwa kwa Kipengele kamili cha Abiotic `Saved/` saraka katika `SavedRoot.txt`; usionyeshe saraka ya ulimwengu pekee. Njia iliyo nje ya mzizi uliowekewa mipaka lazima ibaki imekataliwa.

<a id="recover-a-stalled-historical-scan"></a>
## Rejesha utafutaji wa kihistoria uliokwama

Ufuatiliaji wa sasa na ugunduzi wa kihistoria ni tofauti. Kumbukumbu kubwa inaweza kuhitaji mizunguko mingi iliyo na mipaka, kwa hivyo uchunguzi mmoja ambao haujabadilika haitoshi kuuita kuwa umekwama.

1. Fungua `runtime/current/report_worker_status.json`.
2. Rekodi `scan_cursor`, faili zilizogunduliwa, faili zimekamilika, na `last_progress_ts`.
3. Subiri angalau fursa mbili za kawaida za mfanyakazi wa kuripoti na ulinganishe sehemu zile zile tena.
4. Kama kielekezi, hesabu iliyokamilishwa, au muda wa maendeleo ukiendelea, uchanganuzi bado utafanya kazi. Wacha iwe na mipaka.
5. Iwapo nyanja zote za maendeleo hazijabadilika huku vitambulisho vya kura na ripoti za sasa zikiendelea, hifadhi faili ya hali na uangalie aina chanzo kilichotajwa na awamu ya mfanyakazi. Rekebisha njia hiyo ya chanzo au umeshindwa kusoma kabla ya kujaribu tena.

Uchanganuzi wa kihistoria uliokwama unapunguza hitimisho zinazohitaji rekodi za zamani. Haibatilishi ripoti ya sasa ambayo uthibitisho wa logi amilifu na mzunguko wa sasa ni mpya.

<a id="recover-a-stuck-poll-loop"></a>
## Rejesha mzunguko wa kura uliokwama

Fungua:

```text
runtime/current/poll_status.json
runtime/poll_error.txt
```

Rekodi `poll_id`, `poll_completed_count`, `poll_in_flight`, `poll_stage`, `scheduler_status`, na mihuri ya muda mara mbili kwa muda uliowekwa.

- Kaunta zikitangulia, kitanzi hakijakwama; kutambua hatua ya baadaye ya mfanyakazi.
- Kama `poll_in_flight=true` bado haijabadilishwa, hifadhi hatua ya mwisho ya maendeleo na hitilafu kabla ya kuwasha upya.
- Kama kipanga ratiba kiliacha, kagua hitilafu iliyotangulia na uanze kukabidhi.

Usiongeze mmiliki wa pili wa kitanzi ili kufidia mzunguko mmoja wa maisha uliokwama.

<a id="start-the-scan-after-log-backlog"></a>
## Anza kuchanganua baada ya kumbukumbu nyuma

Katika `runtime/current/poll_status.json`, linganisha:

```text
active_log_caught_up
active_log_unread_bytes
log_backlog_pending
```

Uchanganuzi wa kihistoria unapaswa kusubiri wakati kumbukumbu inayotumika ina baiti ambazo hazijasomwa. Thibitisha kura za baadaye kupunguza mlundikano. Hesabu isiyobadilika ambayo haijasomwa na kura zinazoendelea ni tatizo la mkia wa chanzo; kura ya maoni ni tatizo la kiratibu.

<a id="preserve-scan-progress-after-a-crash"></a>
## Hifadhi maendeleo ya utafutaji baada ya kuacha kufanya kazi

Hifadhi na ulinganishe:

```text
runtime/scan_checkpoint.json
runtime/scan_progress.json
runtime/baselines/file_manifest.tsv
```

Angalia kama sehemu ya ukaguzi au faili ya maelezo haipo, mzizi uliohifadhiwa au ulimwengu umebadilishwa, au kituo cha ukaguzi kiliwekwa alama ya zamani. Usifute msingi halali ili kufanya maendeleo yaonekane mapya zaidi.

<a id="map-an-unmapped-player"></a>
## Ramani kichezaji kisicho na ramani

Linganisha ushahidi wa kipindi na kumbukumbu halali:

```text
runtime/evidence/session_events.jsonl
Saved/Logs/AbioticFactor.log
```

Tafuta kamili`Login request` uhusiano kati ya jina la onyesho, `ConnectID`, na `UniqueId`. Ikiwa hakuna utambulisho wa muunganisho unaokubalika, weka ukaguzi wa safu mlalo pekee. Jina la kuonyesha au PlayerData jina la faili pekee si utambulisho unaoweza kutekelezeka.

<a id="diagnose-a-blocked-adminini-write"></a>
## Tambua iliyozuiwa Admin.iniandika

Fanya jaribio la utekelezaji kwa idhini ya wazi pekee na faili ya majaribio inayoweza kutumika, kamwe usitumie faili ya seva ya moja kwa moja. Kwanza thibitisha kwamba usanidi wa jaribio unauliza Walinzi kuandika:

```lua
review_only_mode = false
auto_ban = true
write_admin_ini = true
```

Kisha soma sababu iliyorekodiwa ya kushindwa. Mlinzi lazima atambue akaunti moja, alinde wasimamizi na akaunti zinazoaminika, atafute ushahidi wa kutosha kuhusu akaunti mahususi, aunde na athibitishe nakala mpya, athibitishe kuwa hakuna programu nyingine iliyobadilisha faili, kuhifadhi sasisho lililokusudiwa, na kulinganisha faili kamili iliyohifadhiwa na matokeo yaliyokusudiwa. Ikiwa hatua yoyote itashindikana au haiwezi kuangaliwa, acha orodha ya marufuku bila kubadilika. Tazama[Admin.ini utekelezaji](UTEKELEZAJI_WA_USIMAMIZI_WA_INI.md).

<a id="restore-a-missing-daily-rollup"></a>
## Rejesha orodha ya kila siku inayokosekana

Thibitisha `forensic_rollup.enabled = true`, kisha kagua:

```text
runtime/current/forensic_today.json
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

Ikiwa hizi hazipo, angalia hali ya kuanza, kura ya maoni, mfanyakazi wa ripoti na hali ya uhasibu chanzo kwa mpangilio huo. Uwasilishaji wa kila siku ni rekodi moja ya mwendelezo kwa siku, sio arifa inayojirudia ya hali ya seva.

<a id="look-up-an-exact-status-or-error"></a>
## Angalia hali halisi au hitilafu

Tumia [Marejeleo ya hali na makosa](MAREJELEO_YA_HALI_NA_HITILAFU.md) kwa njia kamili, chanzo, PlayerData, utekelezaji, kuanzisha, kipanga ratiba, ripoti na majedwali ya msimbo wa arifa. Kutenganisha majedwali ya uchunguzi huzuia ukurasa huu wa urekebishaji kuwa mwongozo wa pili wa taratibu.

<a id="related-docs"></a>
## Nyaraka zinazohusiana

- [Anzia hapa](ANZIA_HAPA.md)
- [Kitabu cha kucheza cha uendeshaji](KITABU_CHA_UENDESHAJI_CHA_UENDESHAJI.md)
- [Marejeleo ya hali na makosa](MAREJELEO_YA_HALI_NA_HITILAFU.md)
- [Uthibitishaji na uchapishaji wa ukaguzi](UTHIBITISHAJI_NA_KUTOLEWA.md)
