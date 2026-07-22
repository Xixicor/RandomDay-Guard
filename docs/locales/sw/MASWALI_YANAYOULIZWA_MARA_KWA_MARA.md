<a id="faq"></a>
# FAQ

> **Chanzo cha Kiingereza cha Canonical:** [FAQ.md](../../FAQ.md). Hati hizi zilizojanibishwa huhifadhi amri kamili, njia, funguo, thamani za hali, heshi na majina ya faili. Ikiwa maneno ya kiufundi yanatofautiana, tumia chanzo cha Kiingereza.


<a id="is-randomdayguard-the-randomday-mod"></a>
## Ni RandomDayGuard the RandomDay Mod?

Na. RandomDay Mod hubadilisha hali ya utumiaji wa seva. RandomDayGuard hutazama safu ya ushahidi wa seva.

<a id="does-live-defense-work-before-the-scan-completes"></a>
## Je, ulinzi wa moja kwa moja hufanya kazi kabla ya upekuzi kukamilika?

Ndiyo. Ulinzi wa moja kwa moja hutumia kumbukumbu na matukio ya kikao. Uchanganuzi wa kimsingi huboresha muktadha baadaye.

<a id="why-can-the-first-scan-take-a-long-time"></a>
## Kwa nini uchanganuzi wa kwanza unaweza kuchukua muda mrefu?

Uchanganuzi wa kwanza huunda world/object muktadha, maonyesho ya faili, na data ya msingi inayoweza kutumika tena.

<a id="what-do-i-check-first-after-startup"></a>
## Je, nitaangalia nini kwanza baada ya kuanzisha?

```text
runtime/current/poll_status.json
```

Tafuta:

```text
scheduler_status=running
poll_id increasing
poll_in_flight=false
```

<a id="where-are-player-summaries"></a>
## Muhtasari wa wachezaji uko wapi?

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
```

<a id="where-is-the-daily-quick-review-package"></a>
## Kifurushi cha ukaguzi wa haraka cha kila siku kiko wapi?

```text
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

<a id="which-file-should-i-upload-for-fastest-review"></a>
## Ni faili gani ninapaswa kupakia kwa ukaguzi wa haraka zaidi?

```text
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="can-it-write-bans-automatically"></a>
## Je, inaweza kuandika marufuku kiotomatiki?

Ikiwa imewezeshwa kwa uwazi pekee.

Chaguo-msingi:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

<a id="what-does-adminini-receive"></a>
## Hufanya nini Admin.ini kupokea?

Pekee:

```ini
BannedPlayer=<ID>
```

Hakuna majina, maoni, sababu, au viambishi tamati.

<a id="is-a-display-name-enough-to-ban"></a>
## Je, jina linaloonyeshwa linatosha kupiga marufuku?

Hapana. Tumia kumbukumbu ya seva `Login request` na `ConnectID` au ushahidi sawa wa seva.

<a id="can-one-crash-ban-someone"></a>
## Je, tukio moja la kuacha kufanya kazi linaweza kupiga marufuku mtu?

Hapana kwa chaguo-msingi.

<a id="can-object-count-alone-ban-someone"></a>
## Je, kitu pekee kinaweza kupiga marufuku mtu?

Hapana kwa chaguo-msingi.

<a id="should-savedroottxt-point-to-the-world-folder"></a>
## Inapaswa SavedRoot.txt ungependa kuelekeza kwenye folda ya ulimwengu?

Hapana. Ielekeze kwa `AbioticFactor/Saved`.

<a id="what-if-the-world-folder-changes"></a>
## Je, ikiwa folda ya ulimwengu itabadilika?

Ichukulie kama badiliko la msingi la utambulisho. Hifadhi msingi wa zamani na uunde mpya.

<a id="related-docs"></a>
## Nyaraka zinazohusiana

* [`START_HERE.md`](ANZIA_HAPA.md)
* [`FORENSIC_DAILY_ROLLUPS.md`](MAJARIBIO_YA_KILA_SIKU_YA_UCHUNGUZI_WA_UCHUNGUZI.md)
* [`TROUBLESHOOTING.md`](UTATUZI_WA_MATATIZO.md)
