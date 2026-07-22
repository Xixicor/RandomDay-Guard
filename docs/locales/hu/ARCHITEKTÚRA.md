<a id="architecture-and-lifecycle"></a>
# Architektúra és életciklus

> **Kanonikus angol forrás:** [ARCHITECTURE.md](../../ARCHITECTURE.md). Ez a lokalizált dokumentáció megőrzi a pontos parancsokat, elérési utakat, kulcsokat, állapotértékeket, kivonatokat és fájlneveket. Ha a technikai megfogalmazás eltér, használja az angol forrást.


RandomDayGuard az egyik UE4SS watchdog plusz egy elszigetelt jelentési modul. Beolvassa a kiszolgáló tulajdonában lévő fájlokat, fenntartja a korlátozott helyi állapotot, valamint helyi bizonyítékokat és áttekintési kimeneteket ír. Nincs szolgáltatója, vezérlőpultja, értesítési szolgáltatása, RandomDay vagy hálózatfüggőség.

<a id="end-to-end-data-flow"></a>
## Végpontok közötti adatfolyam

1. UE4SS betölti az egyetlen kanonikus belépési pontot `RandomDayGuard/Scripts/main.lua`. A jelenlegi csomagok nem szállítanak kisbetűs változatú másolatot.
2. A betöltő beolvassa a `config.lua`, a három adatszótár és az opcionális `SavedRoot.txt`. A verzióazonosítónak meg kell egyeznie a következővel: `VERSION`, `MANIFEST.json` és `BUILD_MARKER.txt`.
3. A mentett gyökérfelderítés ellenőrzi a korlátozott ismert jelölteket és az ismert fájlokat. Azt rögzíti, ami a `runtime/saved_path_probe.json`; A címtár megtalálása önmagában nem jelent bizonyítékot.
4. A közvetlen réteg az aktív szervernaplót egy biztonságos eltolástól követi. Normalizálja az életciklust, a munkamenetet, a fiókot, a figyelmeztetést, az újracsatlakozást és az egyéb megfigyelt eseményeket, csak hozzáfűzhető bizonyítékokká és aktuális pillanatképekké.
5. A lassú réteg leltárai A mentett fájlok korlátozott darabokban. Megírja az előrehaladást és az ellenőrzőpontokat, folytatja a befejezetlen munkát, összehasonlítja a módosított fájl jegyzékét, és előállítja a részleges, majd a végleges object/world kontextusban.
6. A felülvizsgálati logika csak a rendelkezésére álló bizonyítékokat korrelálja. A gyenge fájlnevek, az időzítés, az osztályok száma, a relatív koordináták, a lemorzsolódás, az egyetlen összeomlás vagy a ping kontextusban maradnak, és nem engedélyezhetik a végrehajtást.
7. Külön jelentéskészítő hív `Scripts/public_pipeline.lua`. Leltározza a forrásosztályokat, rögzíti az aktuális és a történelmi hatókört, a ciklust a version/boot/epoch/poll/source frissesség, ír öt útvonal-specifikus JSON/TXT párokat, majd ír `route_proof.json`.
8. Ha kifejezetten engedélyezve van, a helyi kimenő mappák az útvonal-ellenőrzés megléte után átmásolják a hivatkozásokat az elkészült jelentésből. Rögzíti a `delivery_backend="none"` és `delivery_attempted=false`; a szállítás ezen a terméken kívül történik.

<a id="ownership-and-asynchronous-boundaries"></a>
## Tulajdonjog és aszinkron határok

| Tulajdonos | Korlátozott munka | Nem blokkolhatja vagy sugalmazhatja |
|---|---|---|
| Indítás | Konfig., Mentett gyökér, aktív napló, epocha, indexek, kezdeti állapot. | A sikeres rakodójelölő nem bizonyít bizonyítékot vagy útvonalat. |
| Szavazás visszahívása | Új naplóbájtok, állapotfrissítések, event/session/account kimenetek, ütemezés. | Lassú rekurzív felderítés vagy jelentés ürítés. |
| Scan worker | Manifest-felderítés, fájlelemzés, ellenőrzőpont, partial/final alapvonal. | Jelenlegi naplófolyamat; részleges nem hiba. |
| Munkavállaló bejelentése | Forrás könyvelés, fordítás, jelentéspárok, útvonal-ellenőrzés, helyi kimenő üzenetek. | Végrehajtás vagy külső kézbesítés. |
| Opcionális betartatás | Erősítse meg a fiókot és pontozzon, védje meg a megbízható fiókokat és a másolatokat, ellenőrizze a biztonsági másolatot, utasítsa el a külső fájl módosításait, majd ellenőrizze a mentett eredményt. | Jelentés pontszáma, útvonal állapota vagy esettagság, amely megkerül minden szükséges biztonsági ellenőrzést. |

A szavazási hurok csak addig marad egészséges, amíg `poll_id` előlegek, `poll_in_flight` false értéket ad vissza, és az ütemezés aktív marad. Ez a szavazás komponensét bizonyítja, nem a jelentésfolyamatot. A lassú keresés `partial` vagy `deferred`; az alapértelmezett `slow_world_scan_blocks_current_reports=false` lehetővé teszi a friss, aktuális útvonalak folytatását, miközben elnevezi a korábbi korlátozást.

<a id="state-and-lifecycle"></a>
## Állapot és életciklus

| Állam | Bejegyzés | Terminál vagy következő állapot | Hiba és helyreállítás |
|---|---|---|---|
| Indítás | UE4SS meghívja a betöltőt. | Fut poll/scan/report rendszerindítási azonosítóval és korszakkal rendelkező dolgozók. | `startup_error` az aktuális rendszerindítás kritikus bizonyítéka; javítás config/path/source és indítsa újra. |
| Aktuális szavazás | Elkezdődik az ütemezett korlátos visszahívás. | A befejezett szavazás rögzíti az időbélyeget és az átütemezéseket. | `poll_error` az aktuális rendszerindítás kritikus bizonyítéka; állítsa vissza a korlátozott munkát, és erősítsen meg egy újabb szavazást. |
| Szkennelés függőben | A rendszer szükséges vagy hiányos ellenőrzőpontot talált. | `partial`/`deferred`, majd `scan_complete`. | Ellenőrzőpont folytatása; csak akkor építse újra, ha stale/incompatible bizonyítékot rögzítenek. |
| Forrás könyvelés | Nyolc forrásosztály leltárának jelentése. | `complete`, `complete_with_gaps`, `partial` vagy `unavailable`. | Disabled/failed elszámolás minden útvonalat a `missing`. |
| Útvonalgenerálás | Elérhető az aktuális ciklus származása és a forrás elszámolása. | `full`, `limited_expected_empty` vagy `missing`. | Párosítva JSON/TXT vagy útvonalbiztos írási hiba az útvonalat a `missing`. |
| Helyi kimenő üzenetek | Egy útvonal engedélyezve van, elkészült és jogosult. | Függőben lévő helyi boríték és értesítési állapot eredménye. | Az írás hiánya vagy hiányos bizonyítéka azt jelenti, hogy nincs boríték; nincs kézbesítés. |
| Végrehajtási felülvizsgálat | A fiókspecifikus bizonyítékok elérik az automatikus művelethez beállított pontszámot. | Csak áttekintésre szánt ajánlás vagy kifejezetten engedélyezett `Admin.ini` frissítés. | A sikertelen vagy nem elérhető biztonsági ellenőrzés leállítja a frissítést; a sikertelen végső összehasonlítás visszaállítja az ellenőrzött biztonsági másolatot, ha a helyreállítás engedélyezve van. |

<a id="current-and-historical-evidence"></a>
## Jelenlegi és történelmi bizonyítékok

A jelenlegi bizonyítékok az aktívhoz tartoznak boot/poll és soha nem rekonstruálható csak a megőrzött fájlnevekből. A történelmi bizonyítékok közé tartoznak az elforgatott rönkök, tartósak account/session előzmények, megőrizve cases/reports/evidence és korlátozott, világmentő szkennelés. A jelentések külön aktuális és történelmi tömböket és számlálásokat tesznek közzé. A csendes újraindítás nem törölheti el a tartós kontextust, és nem szabad jelenlétként megjeleníteni egy történelmi rekordot.

<a id="completion-and-recovery-boundary"></a>
## Befejezés és helyreállítás határa

Egy útvonal teljesítéséhez egyező aktuális ciklusverzió, rendszerindítási azonosító, korszakazonosító, pozitív lekérdezési azonosító, friss aktív naplóállapot, mindkét útvonalkimenet és annak bejegyzése szükséges a `route_proof.json`. A bejelentési igényekhez emellett az azonos ciklusú helyi borítékra is szükség van; a külső kézbesítés soha nem része a nyilvános bizonyításnak.

Ha a végső jelentések hiányoznak vagy régebbiek a jelenleginél poll/source állapot, folytassa az első nem egyező vonaltól vagy a sikertelen írástól. Ne módosítsa a nem kapcsolódó útvonalakat, szövegezést vagy végrehajtási beállításokat. Lásd: [`OUTPUT_SCHEMA_REFERENCE.md`](KIMENETI_S%C3%89MA_HIVATKOZ%C3%81S.md), [`TROUBLESHOOTING.md`](HIBAELH%C3%81R%C3%8DT%C3%81S.md) és [`SOURCE_MODULE_REFERENCE.md`](FORR%C3%81SMODUL_HIVATKOZ%C3%81S.md).
