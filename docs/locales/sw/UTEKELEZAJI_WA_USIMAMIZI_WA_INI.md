<a id="adminini-enforcement"></a>
# Admin.ini utekelezaji

> **Chanzo cha Kiingereza cha Canonical:** [ADMIN_INI_ENFORCEMENT.md](../../ADMIN_INI_ENFORCEMENT.md). Hati hizi zilizojanibishwa huhifadhi amri kamili, njia, funguo, thamani za hali, heshi na majina ya faili. Ikiwa maneno ya kiufundi yanatofautiana, tumia chanzo cha Kiingereza.


RandomDayGuard haibadilishi orodha ya marufuku ya seva katika usanidi wake chaguomsingi. Huunda tu ripoti ili msimamizi akague. Ukurasa huu unafafanua sasisho la hiari la orodha ya marufuku kwa wasimamizi wanaoiwezesha kimakusudi.

<a id="what-guard-checks-before-changing-the-ban-list"></a>
## Nini Walinzi hukagua kabla ya kubadilisha orodha ya marufuku

Mlinzi anaongeza marufuku wakati tu kila jibu lililo hapa chini ni **ndiyo**:

1. Je, ushahidi wa sasa ulibainisha akaunti moja mahususi yenye imani ya kutosha?
2. Je, akaunti si msimamizi au akaunti ambayo msimamizi ametiwa alama kuwa inaaminika?
3. Je, akaunti tayari haiko kwenye orodha ya marufuku?
4. Je, akaunti ilifikia alama ya kitendo kiotomatiki kilichosanidiwa?
5. Je, Walinzi wanaweza kusoma ya sasa `Admin.ini` na kuhifadhi nakala rudufu inayofanana?
6. Je `Admin.ini` umekaa bila kubadilika wakati Walinzi wanatayarisha sasisho?
7. Baada ya kuhifadhi, je, faili kamili inalingana kabisa na matokeo yaliyokusudiwa?

Iwapo jibu lolote ni **hapana**, au haiwezi kuangaliwa, Mlinzi anaondoka `Admin.ini` haijabadilishwa na hurekodi sababu katika ripoti zake. Iwapo kuhifadhi kutaanza lakini hundi ya mwisho itashindikana, Walinzi hurejesha hifadhi rudufu iliyothibitishwa.

<a id="file-format"></a>
## Muundo wa faili

`Admin.ini` lazima ipokee laini safi za kupiga marufuku pekee:

```ini
BannedPlayer=<ID>
```

- Hakuna majina.
- Hakuna maoni.
- Hakuna sababu.
- Hakuna viambishi tamati.

<a id="safe-defaults"></a>
## Chaguo-msingi salama

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
require_clean_ban_id = true
preserve_existing_bans = true
preserve_moderators = true
```

<a id="ban-id-source"></a>
## Piga marufuku chanzo cha kitambulisho

Chanzo bora:

```text
Login request
Name=<player>
ConnectID=<raw_id>
UniqueId=<platform_id>
```

Muda wa utekelezaji unakubali Kitambulisho cha nambari kamili au kumbukumbu kamili `<digits>_+_|<non-space token>` fomu ya muunganisho na hupata kitambulisho cha kupiga marufuku cha nambari kutoka kwayo. Viambishi awali vya nambari vilivyo na kiambishi kisichojulikana vimekataliwa; hazijakatwa kuwa kitambulisho cha kupiga marufuku.

Sahihi:

```ini
BannedPlayer=2535422284688820
```

Si sahihi:

```ini
BannedPlayer=ExamplePlayer
```

Pia si sahihi:

```text
BannedPlayer=<ID>
```

<a id="exact-settings-guard-checks"></a>
## Mipangilio halisi Ukaguzi wa walinzi

Mipangilio hii hutekeleza ukaguzi ulioelezwa hapo juu. Kila hali iliyoorodheshwa lazima iwe kweli:

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

Ikiwa hali yoyote ni ya uwongo au haiwezi kuangaliwa, Walinzi huacha orodha ya marufuku bila kubadilishwa na kurekodi kile kilichoizuia.

<a id="transaction-safety"></a>
## Usalama wa muamala

Pekee `Admin.ini` njia ya mutation hufanya hatua hizi kwa mpangilio:

1. Soma na uthibitishe kimuundo baiti zinazoidhinishwa.
2. Pata msimamizi, anayeaminika na hali iliyopo ya kupiga marufuku kutoka kwa muhtasari huo huo.
3. Andika nakala rudufu ya kipekee chini ya `runtime/backups/` na uithibitishe kwa byte.
4. Soma tena `Admin.ini` mara moja kabla ya kubadilishwa na kukataa mabadiliko yoyote ya nje.
5. Andika mgombea kupitia njia ya uingizwaji iliyodhibitiwa iliyosanidiwa.
6. Inahitaji baiti kamili za usomaji ili kusawazisha baiti kamili za mgombea.
7. Unaposhindwa kusoma tena, rejesha nakala rudufu iliyothibitishwa pekee wakati faili ya sasa ingali ndiyo mteule kamili iliyoandikwa na Walinzi. Ikiwa mwandishi mwingine aliibadilisha, Walinzi hukataa kurejesha badala ya kubatilisha baiti za nje zisizojulikana.

Vitambulisho rudufu havina nguvu: hakuna safu ya pili na hakuna nakala rudufu ya pili iliyoandikwa. Majina ya hifadhi rudufu yanajumuisha muhuri wa muda, alama ya vidole ya chanzo-chanzo, na kitambulisho safi ili majaribio tofauti yasishiriki jina la faili la sekunde moja.

<a id="local-regression-proof"></a>
## Uthibitisho wa urejeshaji wa eneo lako

`tests/lua/enforcement_runtime_test.lua` hupakia kipakiaji kilichosafirishwa mara moja na kisha kutekeleza eneo lake halisi `append_ban()` kufungwa dhidi ya faili za sintetiki zilizotengwa chini ya hazina `.tmp/` saraka. Inashughulikia uwekaji, ujinga unaorudiwa, moderator/trusted kukataliwa, kukataliwa kwa utambulisho dhaifu na kwa hitilafu, uthibitishaji wa chelezo halisi, kukataliwa kwa urekebishaji kwa wakati mmoja, urejeshaji uliofaulu baada ya kutofanikiwa kusoma tena, na kukataa kubatilisha mabadiliko ya nje ya baada ya kuandika. Vifungashio vyake vya mfumo wa faili hukataa mabadiliko yoyote nje ya mzizi wa kurekebisha; hakuna njia halisi ya seva au halisi `Admin.ini` inatumika.

Iendeshe `python tools/test_public_pipeline.py`. Pasi ya kurekebisha inathibitisha tabia ya muamala wa ndani pekee. Haiwashi utekelezaji, kuidhinisha uandishi wa toleo la umma au kuthibitisha ruhusa maalum za mwenyeji.

<a id="files-to-check"></a>
## Faili za kukagua

```text
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
runtime/enforced_bans.jsonl
runtime/enforced.txt
runtime/ban_queue.json
```

<a id="rollback"></a>
## Rudisha

1. Simamisha seva.
2. Rejesha ya hivi punde Admin.ini chelezo kutoka `runtime/backups/`.
3. Ondoa isiyo sahihi `BannedPlayer=<ID>` line ikihitajika.
4. Anzisha seva.
5. Fungua upya Admin.ini na uthibitishe kuwa laini iliendelea au iliondolewa.
6. Hifadhi `enforced_bans.jsonl` kwa ukaguzi.

<a id="related-docs"></a>
## Nyaraka zinazohusiana

* [`BAN_ID_MAPPING.md`](PIGA_MARUFUKU_RAMANI_YA_KITAMBULISHO.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](MTIRIRIKO_WA_KAZI_WA_MAONI_YA_MCHEZAJI.md)
