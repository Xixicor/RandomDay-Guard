# Mwongozo wa RandomDayGuard kwa Kiswahili

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
