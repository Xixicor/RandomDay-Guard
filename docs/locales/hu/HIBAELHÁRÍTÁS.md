<a id="troubleshooting"></a>
# Hibaelhárítás

> **Kanonikus angol forrás:** [TROUBLESHOOTING.md](../../TROUBLESHOOTING.md). Ez a lokalizált dokumentáció megőrzi a pontos parancsokat, elérési utakat, kulcsokat, állapotértékeket, kivonatokat és fájlneveket. Ha a technikai megfogalmazás eltér, használja az angol forrást.


Használja ezt az oldalt, ha a Guard nem töltődik be, egy forrás nem gyűjthető, nem jelenik meg jelentés, vagy az útvonal-ellenőrzés ellentmond a vártnak. Kezdje a döntési fával, és kövesse az egyik ágat. Használja a dedikált [állapot- és hibareferencia](%C3%81LLAPOT-_%C3%89S_HIBAREFERENCIA.md) csak a sikertelen réteg ismerete után.

Őrizze meg a jelenlegi futásidejű fájlokat a konfiguráció módosítása vagy újratelepítés előtt. Egy elavult vagy hiányzó műtermék egy sikertelen szakaszt azonosít; az ismételt újraindítás törölheti ezt a bizonyítékot.

<a id="choose-the-failure-path"></a>
## Válassza ki a hiba útvonalát

<a id="1-decide-whether-guard-loaded"></a>
### 1. Döntse el, hogy a Guard be van-e töltve

- **Nem `runtime/` léteznek fájlok:** kövesse [Hiányzó futásidejű fájlok visszaállítása](#restore-missing-runtime-files). Ellenőrizze a telepítési útvonalat, a kanonikus betöltőt, `enabled.txt` és `mods.txt` a jelentések vizsgálata előtt.
- **Léteznek jelenlegi állapotfájlok:** A védelem eléggé betöltve az állapot írásához. Folytassa a 2. lépéssel; nem az újratelepítés az első válasz.

<a id="2-decide-whether-the-scheduler-is-advancing"></a>
### 2. Döntse el, hogy az ütemező halad-e

Megnyitás:

```text
runtime/current/startup_status.json
runtime/current/poll_status.json
```

- **Számlálók és időbélyegek előrehaladása:** folytassa a 3. lépéssel.
- **`poll_id` statikus, `poll_in_flight` igaz marad, vagy az ütemező állapota nem fut:** kövesse [Elakadt szavazási hurok helyreállítása](#recover-a-stuck-poll-loop).
- **Az alapszintű vizsgálat függőben van, miközben az ütemező folyamata folytatódik:** ez figyelmeztetés, nem automatikusan sikertelen indítás. Csak akkor vizsgálja meg, ha a lemaradás vagy a vizsgálat leáll.

<a id="3-classify-route-proof"></a>
### 3. Útvonal-igazolás osztályozása

Megnyitás `runtime/final_logs/route_proof.json` és minden útvonalat külön vizsgáljon meg.

- **`full`:** hasonlítsa össze a váratlan megfogalmazást a jelenlegivel `source_references` és származás. Ne módosítsa a kézbesítést, mert a megfogalmazás önmagában rossznak tűnik.
- **`limited_expected_empty`:** győződjön meg arról, hogy a forráskönyvelés támogatja a jogos üres eredményt. Ne hozzon létre szintetikus lejátszót vagy tokot.
- **`missing`:** kövesse [Hiányzó útvonal diagnosztizálása](#diagnose-a-missing-route).

<a id="4-classify-source-coverage"></a>
### 4. A forráslefedettség osztályozása

- **`partial`, `deferred`, `unavailable`, `malformed`, `permission_denied` vagy `error`:** kövesse [A forrás hiányos lefedettségének értelmezése](#interpret-incomplete-source-coverage), majd keresse meg a pontos kódot a [Állapot- és hibareferencia](%C3%81LLAPOT-_%C3%89S_HIBAREFERENCIA.md).
- **A strukturált forrás aktuális, de a lefordított vagy függőben lévő kimenet régebbi:** a befejezés átadását diagnosztizálja, nem a kézbesítési végpontot. A kézbesítési konfiguráció módosítása előtt őrizze meg az időbélyegeket, és ellenőrizze a jelentést és a feladási állapotot.

<a id="5-follow-the-matching-branch"></a>
### 5. Kövesse a megfelelő ágat

- Hiányos identitás: [Egy feltérképezetlen lejátszó feltérképezése](#map-an-unmapped-player).
- Hiányzó napi folytonosság: [Hiányzó napi összesítés visszaállítása](#restore-a-missing-daily-rollup).
- A kifejezetten jóváhagyott végrehajtási teszt nem írta: [A blokkolt állapot diagnosztizálása Admin.ini írás](#diagnose-a-blocked-adminini-write).
- ZIP kicsomagolás sikertelen: [A Windows kicsomagolási eset ütközésének feloldása](#resolve-a-windows-extraction-folder-collision).
- A rögzítés, a csomag vagy a lerakat ellenőrzése sikertelen: [Érvényesítés és kiadás felülvizsgálata](%C3%89RV%C3%89NYES%C3%8DT%C3%89S_%C3%89S_KIAD%C3%81S.md#avoid-validation-environment-pitfalls).

<a id="6-stop-with-one-proved-outcome"></a>
### 6. Hagyd abba egy bizonyított eredménnyel

A hibaelhárítási engedély akkor ér véget, amikor:

- az útvonal aktuális és `full`;
- az útvonal aktuális és `limited_expected_empty` megnevezett okból;
- egy pontos blokkoló, bizonyíték útja és a következő művelet rögzítve van; vagy
- visszaállítás visszaállította a korábbi ismert állapotot, és megőrizte a sikertelen bizonyítékokat.

"A szerver fut", növekvő szívverés vagy HTTP siker önmagában nem bizonyítja, hogy a jelentési útvonal befejeződött.

<a id="diagnose-a-missing-route"></a>
## Hiányzó útvonal diagnosztizálása

Megnyitás `runtime/final_logs/route_proof.json` és hasonlítsa össze `server_status`, `daily_rollup`, `player_activity`, `case_review` és `critical_guard`.

1. Olvassa el az útvonal okát, származását, generációs idejét és forráshivatkozásait.
2. Győződjön meg arról, hogy a megnevezett strukturált forrás létezik, és ugyanahhoz a ciklushoz tartozik.
3. Hasonlítsa össze az midőt a lefordított kimenettel és a függőben lévő borítékkal.
4. Ha a végső naplók újabbak, mint a lefordított vagy függőben lévő kimenet, rögzítse az elavult befejezés feladását, és először javítsa ki az átadást.
5. Ha minden helyi kimenet aktuális, de a kézbesítés hiányzik, akkor ellenőrizze az útvonal konfigurációját és a küldő állapotát.

Ne reklámozza az ütemező állapotát vagy egyetlen sikeres értesítést az ötútvonal-ellenőrzéshez.

<a id="interpret-incomplete-source-coverage"></a>
## A forrás hiányos lefedettségének értelmezése

| Állam | Mi a teendő |
|---|---|
| `partial` | Csak összegyűjtött bizonyítékokat használjon, és kerülje a teljes fedezetre vonatkozó állításokat. |
| `deferred` | A konfiguráció módosítása előtt erősítse meg a későbbi korlátozott munka előrehaladását. |
| `unavailable` | Rögzítse a környezeti korlátot; csak egy bizonyított elérési utat vagy engedélyt javítson ki. |
| `malformed` | A forrás és az elemzési hiba megőrzése; ne találja ki a hiányzó értékeket. |
| `permission_denied` | Csak a szükséges szűk olvasási engedélyt adja meg. |
| `error` | Őrizze meg a részleteket, és diagnosztizálja a megnevezett szakaszt, mielőtt az útvonalra hagyatkozna. |

<a id="restore-missing-runtime-files"></a>
## Hiányzó futásidejű fájlok visszaállítása

Megerősítés:

```text
mods.txt contains RandomDayGuard : 1
RandomDayGuard/enabled.txt exists
RandomDayGuard/Scripts/main.lua exists
```

A megfelelő telepítési gyökér:

```text
AbioticFactor/Binaries/Win64/ue4ss/Mods/RandomDayGuard/
```

A beágyazott elrendezés elutasítása:

```text
Mods/RandomDayGuard/RandomDayGuard/Scripts/main.lua
```

Ha a fájlok helyesek, de UE4SS nem indult el az őrzés, megőrzés `UE4SS.log` és hasonlítsa össze az indítási időbélyegét a játékfolyamat tényleges indításával.

<a id="resolve-a-windows-extraction-folder-collision"></a>
## A Windows kicsomagolási mappa ütközésének feloldása

Egy régebbi kiadás olyan programkönyvtárakat használt, amelyek nevei csak a nagybetűk miatt különböztek. Egyes Windows-kicsomagolók egyesítik ezeket a neveket, ha egy ZIP egy meglévő mappa fölé kerül.

1. Csak a sikertelen ideiglenes kicsomagolást törölje, a telepített modot vagy annak bizonyítékait ne.
2. Hozzon létre egy új üres ideiglenes könyvtárat.
3. Csomagolja ki az aktuális kiadást.
4. Győződjön meg arról, hogy egy RandomDayGuard mappát és egy programkönyvtárat hoz létre.
5. Ha a Windows továbbra is ütközést jelent, töltse le újra a kiadást, és jelentse a kiadás verzióját és a használt kivonatot.

Soha ne csomagoljon ki új kiadást a telepített mappából. Kövesse a [`../INSTALL.md`](TELEP%C3%8DT%C3%89S.md).

<a id="load-the-expected-version"></a>
## Töltse be a várt verziót

Ellenőrizze a forrásjelölőt és a buildjelölőt:

```sh
grep -n "local VERSION" RandomDayGuard/Scripts/main.lua
cat RandomDayGuard/BUILD_MARKER.txt
```

Ha nem értenek egyet:

1. Állítsa le a szervert.
2. A telepített mappáról, az áttekintett konfigurációról és a futásidejű bizonyítékokról készítsen biztonsági másolatot.
3. Állítsa be és ellenőrizze a tervezett csomagot.
4. Csak csomag által kezelt program- és adatfájlok cseréje.
5. Győződjön meg arról, hogy a kanonikus betöltő létezik, és nem lett hozzáadva kisbetűs ismétlődés.
6. Indítsa el egyszer, és olvassa vissza az aktuális jelölőket, mielőtt megítélné a futásidejű kimenetet.

<a id="correct-a-missing-saved-root"></a>
## Hiányzó mentett gyökér javítása

Megnyitás `runtime/saved_path_probe.json`. Adja meg az ellenőrzött abszolút elérési utat a teljes abiotikus faktorhoz `Saved/` könyvtár itt: `SavedRoot.txt`; ne csak egy világkönyvtárra mutasson. A behatárolt gyökéren kívüli elérési útnak visszautasítottnak kell maradnia.

<a id="recover-a-stalled-historical-scan"></a>
## Előzménybeolvasás visszaállítása

A jelenlegi megfigyelés és a történelmi felfedezés különálló. Egy nagy archívumhoz sok korlátozott ciklusra lehet szükség, így egyetlen változatlan megfigyelés sem elég ahhoz, hogy elakadtnak nevezzük.

1. Megnyitás `runtime/current/report_worker_status.json`.
2. Felvétel `scan_cursor`, felfedezett fájlok, befejezett fájlok és `last_progress_ts`.
3. Várjon meg legalább két normál jelentéskészítő lehetőséget, és hasonlítsa össze újra ugyanazokat a mezőket.
4. Ha a kurzor, a befejezett számlálás vagy a folyamatidő előrehalad, a vizsgálat továbbra is működik. Hagyja behatárolva.
5. Ha az összes folyamatmező változatlan marad, miközben a lekérdezési azonosítók és az aktuális jelentések továbbhaladnak, őrizze meg az állapotfájlt, és ellenőrizze a feldolgozói fázis által megnevezett forrásosztályt. Az újrapróbálkozás előtt javítsa ki a forrásútvonalat vagy olvasási hibát.

Egy elakadt előzményvizsgálat korlátozza a régebbi rekordokat igénylő következtetéseket. Nem érvényteleníti az aktuális jelentést, amelynek aktív naplója és aktuális ciklusa friss.

<a id="recover-a-stuck-poll-loop"></a>
## Elakadt szavazási hurok helyreállítása

Megnyitás:

```text
runtime/current/poll_status.json
runtime/poll_error.txt
```

Felvétel `poll_id`, `poll_completed_count`, `poll_in_flight`, `poll_stage`, `scheduler_status`, és időbélyegeket kétszer, korlátozott időközönként.

- Ha a számlálók előrehaladnak, a hurok nem akad el; diagnosztizálja a későbbi munkásstádiumot.
- Ha `poll_in_flight=true` változatlan marad, őrizze meg az utolsó folyamatszakaszt és a hibát az újraindítás előtt.
- Ha az ütemező leállt, ellenőrizze az előző hibát és az indítási átadást.

Ne adjon hozzá második huroktulajdonost egy elakadt életciklus kompenzálására.

<a id="start-the-scan-after-log-backlog"></a>
## A vizsgálat indítása a naplóhátralék után

In `runtime/current/poll_status.json`, hasonlítsa össze:

```text
active_log_caught_up
active_log_unread_bytes
log_backlog_pending
```

Az előzményvizsgálatnak várnia kell, amíg az aktív naplóban vannak olvasatlan bájtok. Erősítse meg, hogy a későbbi szavazások csökkentik a lemaradást. A rögzített olvasatlanok száma előrehaladott szavazásokkal forrás-végprobléma; a rögzített szavazás az ütemező probléma.

<a id="preserve-scan-progress-after-a-crash"></a>
## A vizsgálat folyamatának megőrzése összeomlás után

Őrizze meg és hasonlítsa össze:

```text
runtime/scan_checkpoint.json
runtime/scan_progress.json
runtime/baselines/file_manifest.tsv
```

Ellenőrizze, hogy az ellenőrzőpont vagy a jegyzék hiányzik-e, a mentett gyökér vagy világ megváltozott-e, vagy az ellenőrzőpont elavultnak lett-e jelölte. Ne töröljön érvényes alapvonalat, hogy az előrehaladás újabbnak tűnjön.

<a id="map-an-unmapped-player"></a>
## Egy feltérképezetlen lejátszó feltérképezése

Hasonlítsa össze a munkamenet bizonyítékait a hiteles naplóval:

```text
runtime/evidence/session_events.jsonl
Saved/Logs/AbioticFactor.log
```

Keresse meg a teljes `Login request` kapcsolat a megjelenített név között, `ConnectID` és `UniqueId`. Ha nem létezik elfogadott kapcsolati identitás, a sort tartsa csak áttekintésre. A megjelenített név vagy a PlayerData fájlnév önmagában nem érvényesíthető identitás.

<a id="diagnose-a-blocked-adminini-write"></a>
## A blokkolt állapot diagnosztizálása Admin.ini írás

Kikényszerítési tesztet csak kifejezett jóváhagyással és eldobható tesztfájllal futtasson, élő szerverfájllal soha. Először ellenőrizze, hogy a tesztkonfiguráció felkéri a Guard-t, hogy írja be:

```lua
review_only_mode = false
auto_ban = true
write_admin_ini = true
```

mappatiszta frissítési eljárást, majd olvassa el a rögzített hiba okát. A Guardnak azonosítania kell egy fiókot, meg kell védenie a moderátorokat és a megbízható fiókokat, elegendő fiókspecifikus bizonyítékot kell találnia, új biztonsági másolatot kell létrehoznia és ellenőriznie, meg kell erősítenie, hogy más program nem változtatta meg a fájlt, mentenie kell a tervezett frissítést, és össze kell hasonlítania a teljes mentett fájlt a kívánt eredménnyel. Ha valamelyik lépés sikertelen vagy nem ellenőrizhető, hagyja változatlanul a tiltólistát. Lásd: [Admin.ini végrehajtás](ADMIN_INI_V%C3%89GREHAJT%C3%81S.md).

<a id="restore-a-missing-daily-rollup"></a>
## Hiányzó napi összesítés visszaállítása

Megerősítés `forensic_rollup.enabled = true`, majd ellenőrizze:

```text
runtime/current/forensic_today.json
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

Ha ezek hiányoznak, ellenőrizze az indítási, lekérdezési, jelentéskezelői és forráskönyvelési állapotot ebben a sorrendben. A napi összesítés napi egy folytonossági rekord, nem pedig ismétlődő szerverállapot-értesítés.

<a id="look-up-an-exact-status-or-error"></a>
## Keresse meg a pontos állapotot vagy hibát

Használja a [Állapot- és hibareferencia](%C3%81LLAPOT-_%C3%89S_HIBAREFERENCIA.md) a teljes útvonalat, forrást, PlayerData-, végrehajtási, indítási, ütemező-, jelentés- és értesítési kódtáblázatokhoz. A keresési táblák külön tartása megakadályozza, hogy ez a javítási oldal egy második sémakézikönyvvé váljon.

<a id="related-docs"></a>
## Kapcsolódó dokumentumok

- [Kezdje el itt](KEZDJE_EL_ITT.md)
- [Műveleti útmutató](M%C5%B0VELETI_%C3%9ATMUTAT%C3%93.md)
- [Állapot- és hibareferencia](%C3%81LLAPOT-_%C3%89S_HIBAREFERENCIA.md)
- [Érvényesítés és kiadás felülvizsgálata](%C3%89RV%C3%89NYES%C3%8DT%C3%89S_%C3%89S_KIAD%C3%81S.md)
