<a id="operations-playbook"></a>
# Műveleti útmutató

> **Kanonikus angol forrás:** [OPERATIONS_PLAYBOOK.md](../../OPERATIONS_PLAYBOOK.md). Ez a lokalizált dokumentáció megőrzi a pontos parancsokat, elérési utakat, kulcsokat, állapotértékeket, kivonatokat és fájlneveket. Ha a technikai megfogalmazás eltér, használja az angol forrást.


Ez a RandomDayGuard. Nem kell tudnia JSON, Git, ellenőrző összegek vagy parancssori eszközök az egészséges szerver ellenőrzéséhez.

<a id="daily-operator-flow"></a>
## Napi operátorfolyam

1. Megnyitás `runtime/final_logs/server_status_latest.txt`. Megmondja, hogy a Guard figyeli-e az aktuális szerverfutást, mikor fejeződött be az utolsó ciklus, hány játékos csatlakozik, és hogy a forrás vagy a vizsgálat nem teljes-e.
2. Megnyitás `runtime/final_logs/daily_rollup_latest.txt` naponta egyszer. Összefoglalja az aznapi munkameneteket, kilépéseket, megnevezett esetmunkát, identitásleltárt és forráslefedettséget anélkül, hogy minden egyes rekordot megismételne.
3. Megnyitás `runtime/final_logs/player_activity_latest.txt` csak akkor, ha a szervernek a nap folyamán csatlakozási, kilépési vagy aktív munkamenete volt.
4. Megnyitás `runtime/final_logs/case_review_latest.txt` csak akkor, ha aktuális tárgyat nevez meg. A jelentés megadja a fiókot, az áttekintés állapotát, a pontszámot, az identitásforrást és a következőleg megnyitandó rekordokat.
5. Megnyitás `runtime/final_logs/critical_guard_latest.txt` csak akkor, ha a Guard hibát jelez saját indítási, megfigyelési ciklusában vagy jelentésírásában.

Ha egy útvonalon nincs jelentenivaló, a Guard várt üres eredményt rögzít. Ez egy befejezett ellenőrzés, nem pedig egy hiányzó jelentés.

<a id="what-to-read-inside-a-report"></a>
## Mit kell olvasni a jelentésben?

Olvassa el ezeket a szakaszokat sorrendben:

1. **Összefoglaló** – mit tartalmaz ez a jelentés.
2. **Amit Guard megfigyelt** – az útvonalhoz gyűjtött tényleges időbélyegek, számok, fiókok, munkamenetek vagy állapotértékek.
3. **Mit jelent?** – a rekordok egyszerű nyelvű értelmezése.
4. **Ami ismeretlen marad** – az eredményt befolyásoló forrás vagy keresési korlát.
5. **Ajánlott következő lépés** – figyelni, áttekinteni egy megnevezett témát vagy javítani a Guard-t.
6. **A bizonyítékok határa** – a jelentés hatókörének korlátja.

A műszaki feljegyzés és a forráshivatkozások a végén jelennek meg azon olvasók számára, akiknek meg kell nézniük a pontos strukturált bizonyítékot.

<a id="when-a-report-is-missing"></a>
## Ha hiányzik egy jelentés

Megnyitás `runtime/final_logs/route_proof.json` csak akkor, ha egy olvasható jelentés hiányzik, vagy azt mondja, hogy hiányzik az aktuális bizonyítéka. Minden útvonalon a következő eredmények találhatók:

| Eredmény | Jelentés |
|---|---|
| `full` | Az őr befejezte az útvonalat a jelenlegi útvonal tulajdonában lévő bizonyítékokkal. |
| `limited_expected_empty` | Az őr teljesítette az útvonalat, és nem talált kvalifikációs eseményt, vagy egy megnevezett korhatárt rögzített. |
| `missing` | A szükséges forrás-, leszármazási ellenőrzés vagy páros jelentésírás nem fejeződött be. |

Hiányzó útvonal esetén kövesse a megnevezett forrást, vagy írjon hibát a jelentésbe. Először ne módosítsa a nem kapcsolódó útvonalakat vagy értesítési beállításokat.

<a id="after-a-crash-or-restart"></a>
## Összeomlás vagy újraindítás után

1. Olvassa el a kiszolgáló állapotát az új szerverfutási időbélyeghez és a legutóbbi befejezett megfigyelési ciklushoz.
2. Olvassa el a Critical Guard-t az aktuális indítási vagy lekérdezési hibáért.
3. Csak akkor olvassa el a játékostevékenységet, ha egy aznapi munkamenet csatlakozott, kilépett vagy visszatért az életciklus-módosítás után.
4. Őrizze meg az idézett forrásrekordot a konfiguráció módosítása előtt.

<a id="before-enabling-optional-adminini-writes"></a>
## Az opcionális engedélyezése előtt Admin.ini ír

Az alapértelmezett csomag változtatás nélkül figyel és jelentéseket készít `Admin.ini`. A haladó operátorok engedélyezhetik az opcionális végrehajtási útvonalat, miután tesztelték azt a fájl másolatával. A Guard ezután tiszta numerikus fiókazonosítót igényel, megvédi a megbízható fiókokat, biztonsági másolatot hoz létre és ellenőrzi, elutasítja az egyidejű változtatásokat, visszaolvassa a mentett fájlt, és visszaállítja a biztonsági másolatot, ha az ellenőrzés sikertelen. Lásd: [`ADMIN_INI_ENFORCEMENT.md`](ADMIN_INI_V%C3%89GREHAJT%C3%81S.md) a teljes beállítási és tesztelési eljáráshoz.

<a id="related-guides"></a>
## Kapcsolódó útmutatók

- [`START_HERE.md`](KEZDJE_EL_ITT.md)
- [`REPORT_EXAMPLES.md`](P%C3%89LD%C3%81K_JELENT%C3%89SRE.md)
- [`PLAYER_REVIEW_WORKFLOW.md`](J%C3%81T%C3%89KOS_ELLEN%C5%90RZ%C3%89SI_MUNKAFOLYAMAT.md)
- [`TROUBLESHOOTING.md`](HIBAELH%C3%81R%C3%8DT%C3%81S.md)
- [`OUTPUT_SCHEMA_REFERENCE.md`](KIMENETI_S%C3%89MA_HIVATKOZ%C3%81S.md)
