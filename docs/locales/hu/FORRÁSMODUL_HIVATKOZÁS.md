<a id="source-module-reference"></a>
# Forrásmodul hivatkozás

> **Kanonikus angol forrás:** [SOURCE_MODULE_REFERENCE.md](../../SOURCE_MODULE_REFERENCE.md). Ez a lokalizált dokumentáció megőrzi a pontos parancsokat, elérési utakat, kulcsokat, állapotértékeket, kivonatokat és fájlneveket. Ha a technikai megfogalmazás eltér, használja az angol forrást.


Ez az oldal leképez minden forrást, konfigurációt, adatot, kompatibilitási betöltőt és futásidejű helyőrző osztályt, amelyet a kiadási engedélyezési lista engedélyez. A gép indexe [`TRACEABILITY_INDEX.json`](../../TRACEABILITY_INDEX.json); ez az oldal az olvasható kanonikus magyarázat. Minden generált gépsor különálló path/class, cél, forrásblokk tulajdonosa, nyilvános beállítások, mellékhatások, kezelő által látható állapotok, hibák, helyreállítás és kanonikus dokumentum.

<a id="packaged-file-map"></a>
## Csomagolt fájltérkép

| Elérési út | Felelősség | Belépési pont vagy hívó fél | Bemenetek | Kimenetek és mellékhatások | Hiba viselkedés | Felhasználó által szerkeszthető |
|---|---|---|---|---|---|---|
| `LICENSE` | A projekt licence az archívum gyökérkönyvtárában szállítva. | Telepítő, újraelosztó és üzemeltető. | Áttekintett lerakat licencszöveg. | Megmondja a csomagra vonatkozó feltételeket; nincs futásidejű mutáció. | A kihagyás jogilag hiányossá teszi a kiadási csomagot, és blokkolja az engedélyezési listát. | Nem. |
| `NOTICE.md` | A projektről szóló értesítéseket az archívum gyökérkönyvtárában szállítjuk. | Telepítő és kezelő. | Ellenőrzött projekt közlemények. | Megőrzi a szükséges hozzárendelést és a projektkörnyezetet; nincs futásidejű mutáció. | A kihagyás hiányossá teszi a kiadási csomagot, és blokkolja az engedélyezési listát. | Nem. |
| `THIRD_PARTY_NOTICES.md` | Harmadik féltől származó értesítések az archívum gyökérkönyvtárába szállítva. | Telepítő és újraterjesztő. | Harmadik féltől származó forrásmegjelölés áttekintett szövege. | Megőrzi a függőségi hozzárendelést; nincs futásidejű mutáció. | A kihagyás hiányossá teszi a kiadási csomagot, és blokkolja az engedélyezési listát. | Nem. |
| `RandomDayGuard/enabled.txt` | UE4SS mod engedélyezési jelző. | UE4SS mod betöltő. | `1` vagy `0` a UE4SS. | Engedélyezi vagy letiltja a betöltést; nem ír futásidejű bizonyítékot. | A letiltott vagy rosszul formázott jelző megakadályozza a normál indítási igazolást. | Igen, a telepítés során. |
| `RandomDayGuard/config.lua` | Töltse ki a nyilvános beállítások táblázatát. | `Scripts/main.lua` induláskor. | Katalógusban szereplő mezők [`CONFIG_FIELD_CATALOG.md`](KONFIGUR%C3%81CI%C3%93S_MEZ%C5%90KATAL%C3%93GUS.md). | Szabályozza a felfedezést, a költségvetéseket, a jelentéseket, az áttekintési kapukat és az opcionális helyi jelölőket. | Lua/load/default drift blokkolja az érvényesítést, vagy lezárja az indítást. | Igen; készítsen biztonsági másolatot. |
| `RandomDayGuard/SavedRoot.txt` | Opcionális explicit Saved-root felülírás. | Mentett gyökérfeloldó itt: `main.lua`. | Egy általános fájlrendszer-útvonal a következőhöz: `AbioticFactor/Saved`. | A naplókhoz, mentésekhez használt gyökér kiválasztása PlayerData fájlnevek és `Admin.ini`. | Hiányzó megengedett; a nem biztonságos, rossz vagy olvashatatlan elérési utak bizonyítatlanok maradnak. | Igen; soha ne helyezze el ide a hitelesítő adatokat. |
| `RandomDayGuard/BUILD_MARKER.txt` | Ember által olvasható csomagazonosító. | Telepítő, érvényesítő és kezelő. | Az építő által megjelenített kiadási verzió. | Nincs futásidejű mutáció. | A verzióeltérés blokkolja a csomagolást. | Nem. |
| `RandomDayGuard/MANIFEST.json` | Géppel olvasható csomagazonosító és elrendezési metaadatok. | Ellenőrző, építő és támogató eszközök. | Az építő által megjelenített kiadási verzió. | Nincs futásidejű mutáció. | JSON vagy verzióeltérés blokkolja a csomagolást. | Nem. |
| `RandomDayGuard/README.txt` | Telepített angol nyelvű gyorstájékoztató. | Üzemeltető. | Csomagolt elérési utak és biztonságos alapértelmezések. | Nincs futásidejű mutáció. | Az elavult elérési utak vagy a biztonsági megfogalmazás meghiúsítja a dokumentációs paritást. | Nem. |
| `RandomDayGuard/Scripts/main.lua` | UE4SS bejegyzés, bizonyítékok gyűjtése, állami tulajdon, korlátozott ütemezés, opcionális végrehajtás és kimenetírók. | UE4SS. | Konfig., Mentett gyökérforrások, aktuális futási állapot, szótárak és jelentéskészítő modul. | A futásidejű osztályokat a [`OUTPUT_SCHEMA_REFERENCE.md`](KIMENETI_S%C3%89MA_HIVATKOZ%C3%81S.md); egy jóváhagyott végrehajtási útvonal biztonsági másolatot készíthet és frissíthet `Admin.ini`. | Startup/poll/write hibák kifejezett hibaállapotot eredményeznek, és soha nem igazolják az útvonal befejezését. | Nem. |
| `RandomDayGuard/Scripts/public_pipeline.lua` | Forrás elszámolása, jelenlegi ciklus származása, jelentés fordítása, útvonal-ellenőrzés, tartós nyilvános előzmények és opcionális helyi kimenő posta. | `main.lua` jelentéskezelő. | Csak olvasható state/context visszahívások és megőrzött helyi bizonyítékok. | Jelentés írása JSON/TXT párok, source/history könyvelés, útvonal-ellenőrzés, tartós számlaelőzmények és értesítések status/envelopes. | Hiányzó származás, szükséges forrás, páros írási vagy útvonalbiztos írási erők `missing` és blokkolja a sorban állást. | Nem. |
| `RandomDayGuard/data/detection_events.json` | Nyilvános események szókincse és magyarázatok. | `main.lua` esemény normalization/reporting. | Érvényes JSON szótár. | Bizonyítékok címkézése; nem hoz létre megfigyeléseket. | Missing/malformed adatblokkolja a lerakat érvényesítését. | Nem. |
| `RandomDayGuard/data/warning_types.json` | Figyelmeztetés típusú szókincs és áttekintés jelentése. | Figyelmeztetés normalization/reporting. | Érvényes JSON szótár. | Figyelmeztető címkék. | Missing/malformed adatblokkolja a lerakat érvényesítését. | Nem. |
| `RandomDayGuard/data/object_categories.json` | Object/class kategóriaszókincs. | Vizsgálat és objektum-nyilvántartási jelentés. | Érvényes JSON szótár. | Címkézik a kivont osztálykontextust. | Missing/malformed adatblokkolja a lerakat érvényesítését. | Nem. |
| `RandomDayGuard/runtime/**/.gitkeep` | Csak üres telepítési elrendezési helyőrzők. | Csomag kibontása. | Üres bájtok. | Írható könyvtárszerkezetet hoz létre; semmilyen bizonyíték nincs csatolva. | Bármely nem helyőrző futásidejű tag blokkolja a pontos engedélyezési listát. | Nem. |

<a id="ue4ss-loader-and-watchdog"></a>
## UE4SS betöltő és őrzőkutya

`Scripts/main.lua` birtokolja a független watchdog indítást, a mentett gyökér felfedezést, az aktuális naplóvéget, a kiszolgáló korszakait és munkameneteit, a korlátos lekérdezést és keresést, object/world kontextus, értékelés pontozása, `Admin.ini` biztonsági kapuk, örökölt működési kimenetek és a különálló jelentés-dolgozó átadás. Korlátoznia kell az élő szavazást, miközben a lassú történelmi munka önállóan folytatódik. Szívverés, indításjelző vagy növekvő `poll_id` csak azt az összetevőt bizonyítja; az útvonal befejezéséhez ugyanaz az aktuális rendszerindítás, korszak, szavazás, forrásfrissség, jelentéspár és útvonal-ellenőrzés szükséges.

A forrásnak és a csomagnak egy jogosultsága van: `RandomDayGuard/Scripts/main.lua`. Egy kisbetű `scripts/` másolat nem része a forrásfának vagy a kiadásnak. Az egyetlen kanonikus helyesírás megtartása megakadályozza a kis- és nagybetűk ütközési hibáit, amikor a csomagot Windows vagy Linux rendszeren bontják ki.

<a id="public-reporting-module"></a>
## Nyilvános jelentési modul

`Scripts/public_pipeline.lua` visszahívásokat fogad a gazdagép hitelesítő adatai vagy a szolgáltatói adapterek helyett. Nyolc forrásosztályt leltároz, rögzíti a terminál és a hiányos állapotokat, elkülöníti a jelenlegi játékosokat a megőrzött előzményektől, lefordítja az egyes útvonalakat a sorrendben `Observed`, `Interpretation`, `Unknown`, `Does not prove`, `Next action` és `Source references`, majd útvonal-ellenőrzést ír. Az opcionális értesítési mód helyi JSON csak boríték; soha nem tart igényt a kiszállításra, és nem köt össze szállítást endpoint/bridge.

A végrehajtható fixture itt: `tests/lua/public_pipeline_runtime_test.lua` betölti ezt a szállított modult a Lua-val, bizonyítja a teljes és várhatóan üres útvonalakat, bizonyítja, hogy a hiányzó aktuális forrás ciklus meghiúsul, és bizonyítja, hogy a hiányos útvonalak nem kerülnek a kimenő mappába.

<a id="configuration-and-data"></a>
## Konfiguráció és adatok

[`CONFIG_FIELD_CATALOG.md`](KONFIGUR%C3%81CI%C3%93S_MEZ%C5%90KATAL%C3%93GUS.md) és [`TRACEABILITY_INDEX.json`](../../TRACEABILITY_INDEX.json) a `tools/generate_documentation_audit.py` a `config.lua`, a csomagok engedélyezési listája és a forrás által feltárt kimeneti osztályok. A pontos generált tartalom és az egy-egy lefedettség érvényesítésre kerül. A három JSON szótárak címkék és leképezések, nem bizonyítékforrások. Az operátor szerkesztheti a konfigurációt, a mentett gyökér kiválasztását és az engedélyezést; A forrás, a szótárak, a jegyzékek és a csomagolt readme-k kiadás tulajdonában vannak.

<a id="package-layout"></a>
## Csomag elrendezése

A készítő csak a három legális legális fájlt engedélyezi, a `RandomDayGuard/` elérési utat fent, és üres futásidejű helyőrzőket. A tagokat bájtonként rendezi, javítja a ZIP metaadatok, egyszer becsomagolja a kanonikus betöltőt, minden tagot átvizsgál privát anyagok után, rögzít egy SHA-256 minden taghoz, a neveket és a bájtokat egyetlen tartalomkivonatba köti, és kétszer építi fel. A tesztek minden eset-hajtás ütközést elutasítanak, és bebizonyítják, hogy a normál kibontás pontosan egy fizikai fájlt hoz létre archív bejegyzésenként.

A nyilvános adattár csak az aktuális kiadási mappát tartja meg. Az építtető ellenőrzi, hogy a ZIP, az ellenőrző összeg, a megjegyzések, a verziójelzők és a forrásfa megegyezik.

<a id="code-comment-contract"></a>
## Kód megjegyzési szerződés

A futásidejű megjegyzések tömör karbantartói szerződések, nem egy második kézikönyv. Minden szállított futásidejű modulnak el kell helyeznie egy kanonikus hivatkozást a nyitó megjegyzésblokkjában:

```lua
-- Documentation: docs/SOURCE_MODULE_REFERENCE.md#ue4ss-loader-and-watchdog
```

Nem nyilvánvaló állapot, ütemezés, write/readback/rollback, forrás-feltárás, fordítás, bizonyíték, kimeneti séma, útvonal-kadencia és szerkesztési blokkok fókuszált megjegyzéseket használnak a következő címkékkel, ahol alkalmazható:

```lua
-- Public contract: <invariant or consequence>
-- Evidence boundary: <what the input cannot prove>
-- Failure behavior: <how the block fails closed or recovers>
-- Documentation: docs/<canonical-file>.md#<existing-anchor>
```

A fő betöltőnek van egy kiemelt tulajdonosi megjegyzése a konfigurációk betöltéséhez, a mentett felfedezéshez, az atomok cseréjéhez, a végrehajtáshoz és az ütemezéshez. Ezek a megjegyzések a szabályozás-áramlás és a meghibásodás határait jelzik; nem változtatják meg a futásidejű viselkedést.

Az érvényesítő modulszintet igényel `Documentation:` hivatkozás minden futásidejű modulhoz, minden megjegyzés elérési utat és horgonyt felold, fókuszált szerződés- és hibamegjegyzéseket igényel mindkét futásidejű modulban, és ugyanazokat a kanonikus hivatkozásokat hasonlítja össze a `TRACEABILITY_INDEX.json`. A megjegyzés nyomon követhetőség, nem futásidejű bizonyíték.

<a id="contributor-change-checklist"></a>
## Közreműködő módosítási ellenőrzőlista

1. Frissítse az egyik tulajdonos modult és annak fókuszált rögzítését.
2. Frissítse a kanonikus konfigurációt, sémát, kimenetet, bizonyítékot vagy életciklus szakaszt.
3. Futtatás `python -B tools/generate_documentation_audit.py --write` a konfiguráció, a csomagolt útvonal, a generált kimeneti osztály, a tulajdonos vagy a helyreállítási szerződés megváltozása után.
4. Futtatás `python -B tools/generate_documentation_audit.py --check`, fókuszált egységtesztek, a valódi Lua fixture, ahol a Lua elérhető, a teljes érvényesítő, két független determinisztikus build és `git diff --check`.
5. Tekintse át a generált ZIP taglista, ellenőrző összeg és privát anyagok vizsgálata a kiadás létrehozása előtt.
