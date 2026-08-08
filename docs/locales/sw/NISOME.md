# Mwongozo wa RandomDayGuard kwa Kiswahili

> [!IMPORTANT]
> ## Hali ya mradi — majaribio ya RandomDay yamekamilika
>
> Operesheni ya majaribio ya RandomDay imekamilika, na seva ya majaribio ya umma itafungwa hivi karibuni.
>
> Wakati wa operesheni hii, RandomDay na RandomDayGuard ziliendeshwa pamoja kupitia mizunguko ya mara kwa mara ya wasifu, uanzishaji upya wa seva wa kawaida na uliokatizwa, ukaguzi wa urejeshaji na kurudisha nyuma, ujumuishaji wa mod zilizopanuliwa, ukusanyaji wa ushahidi wa seva na mapitio ya ripoti za mwendeshaji.
>
> Hili limetupa maarifa tuliyolenga kupata: jinsi wasifu wa sandbox unaozunguka unavyofanya kazi katika mizunguko halisi ya maisha ya seva maalumu; jinsi RandomDay inavyoshirikiana na mod zilizopanuliwa zinazotumika; na kiwango ambacho RandomDayGuard inaweza kubadili ushahidi ulioandikwa na seva kuwa ufuatiliaji wenye manufaa na tahadhari bila kuonyesha mapengo au makisio kama ukweli.
>
> **Muundo uliotumika kwenye seva ya majaribio:**
>
> - RandomDay build ya maendeleo ya faragha `v0.41.76`
> - RandomDayGuard build ya maendeleo ya faragha `v0.46.130`
> - Chaotic Spawn Engine / DynamicSpawns `0.8.5 Hotfix 1`
> - Lethal Lasers `1.0 UE4SS`
> - ANTE Up `0.26`
> - Encounter Director integration — kiendelezi cha DynamicSpawns kinachomilikiwa na RandomDay, si mod inayosambazwa kando
> - UE4SS `v3.0.1 Beta #0` (Git `01e0a584`; Nexus `v3.0.1-940-g01e0a584`)
> - seva maalumu ya Abiotic Factor `1.4.0.27939`
>
> Vifurushi vilivyochapishwa sasa vinaendelea kuwa RandomDay `v0.3.16-alpha` na RandomDayGuard `v0.4.12-alpha`.
>
> Maendeleo ya miradi yote miwili yamesitishwa kwa sasa. Matoleo na nyaraka zilizopo zitaendelea kupatikana, na tunaweza kurudi tutakapohisi tena hamu ya kuendelea na kazi.
>
> Muundo huu unaandika kilichotumika wakati wa operesheni; si hitaji la toleo la chini wala dhamana ya utangamano na matoleo ya baadaye ya mchezo, loader au mod. Mzunguko wa mwisho uliorekodiwa rasmi ulitumia Abiotic Factor `1.4.0.27939`.

**v0.4.12-alpha**

RandomDayGuard hubadilisha ushahidi uliowekewa mipaka kutoka seva maalum ya
Abiotic Factor kuwa taarifa zinazoeleweka kwa msimamizi. Hali ya seva, muhtasari
wa siku, shughuli za wachezaji, mapitio ya kesi na hitilafu kubwa hubaki katika
njia tofauti.

## Kusakinisha

Fuata [mwongozo wa usakinishaji](USAKINISHAJI.md). Folda sahihi ni
`ue4ss/Mods/RandomDayGuard` na `mods.txt` lazima iwe na
`RandomDayGuard : 1`. Epuka usakinishaji ulio ndani ya mwingine na folda mbili za `Scripts`.

## Kuthibitisha taarifa ya kwanza

Fungua `runtime/current/startup_status.json`, kisha
`runtime/final_logs/latest_dossier.json` na
`runtime/final_logs/route_proof.json`. Kila njia lazima ionyeshe `full`,
`limited_expected_empty` au `missing`. Taarifa na chanzo chake lazima viwe vya
mzunguko mmoja.

## Kusanidi na kuendesha

Mipangilio ya awali ni `review_only_mode = true`, `auto_ban = false` na
`write_admin_ini = false`. Soma [Mwanzo](ANZIA_HAPA.md),
[Uendeshaji](KITABU_CHA_UENDESHAJI_CHA_UENDESHAJI.md), [Usanidi](SANIDI_WASIFU.md)
na [Utatuzi](UTATUZI_WA_MATATIZO.md).

Amri, njia, funguo na thamani za hali hubaki kwa Kiingereza ili zilingane na
faili halisi.

## Toleo la alfa na njia mbili za ushahidi

Hili ni toleo la alfa. Njia zilizoandikwa za ukusanyaji, ripoti na urejeshaji zimejaribiwa; uoanifu, historia inayofunikwa na ubora wa ripoti vinaendelea kuboreshwa.

Njia ya sasa hutumia logi hai, hali ya kuanza na ratiba ya sasa, na vipindi vinavyoendelea, hivyo inaweza kuandika ripoti za sasa mara moja. Njia ya historia hukagua logi zilizohifadhiwa, majina ya PlayerData, ushahidi na kesi za zamani kwa hatua zenye mipaka.

`runtime/current/report_worker_status.json`

Linganisha `scan_cursor` na `last_progress_ts` katika `runtime/current/report_worker_status.json` kwa mizunguko kadhaa. Zikisonga, ukaguzi unafanya kazi. Zikibaki vilevile huku ripoti za sasa zikisonga, ukaguzi wa historia umekwama; taarifa za sasa zinafaa, lakini hitimisho linalohitaji historia ya zamani lina mipaka.

[Troubleshooting](UTATUZI_WA_MATATIZO.md)

## Kamilisha maktaba ya hati

Kila hati ya Markdown ya umma inapatikana katika lugha hii yenye majina ya faili yaliyojanibishwa.

- [Fungua faharasa ya hati iliyojanibishwa](HATI.md)
