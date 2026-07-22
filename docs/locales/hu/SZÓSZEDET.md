<a id="glossary"></a>
# Szószedet

> **Kanonikus angol forrás:** [GLOSSARY.md](../../GLOSSARY.md). Ez a lokalizált dokumentáció megőrzi a pontos parancsokat, elérési utakat, kulcsokat, állapotértékeket, kivonatokat és fájlneveket. Ha a technikai megfogalmazás eltér, használja az angol forrást.


| Időtartam | Egyszerű jelentés | Pontos műszaki jelentés |
|---|---|---|
| Aktív napló | A friss bizonyítékokhoz használt aktuális szervernapló. | Kötelező `active_log` forrás; olvashatóság plusz aktuális származás szükséges az útvonal teljesítéséhez. |
| Rendszerindítási azonosító | Egy felügyeleti folyamat elindul. | A jelenlegi futásidejű azonosító az előzetes rendszerindítás elutasítására errors/reports. |
| Epoch ID | Egy szerver folytonossági intervallum. | A normál futási időn átívelő azonosító egészen addig, amíg a folytonossági logika egy újabb korszakot nem kezd. |
| Szavazás azonosítója | Egy korlátos szavazási lehetőség. | Pozitív monoton ciklusmező; zero/missing nem tud befejezni egy útvonalat. |
| Forrás frissessége | A jelenlegi forrás és a szavazás származása megegyezik-e. | `fresh_current_poll` vagy `stale_or_unproven` időbélyegekkel és aktív napló állapottal. |
| Forrás könyvelés | A bizonyítékok elérhetőségének és korlátainak jegyzéke. | `randomdayguard.source-accounting/v1` nyolc forrásosztállyal és current/historical hatókör. |
| `available` | A rendszer talált egy forrást, és elolvasta. | A terminálforrás állapota a következővel: `available=true`, `readable=true`. |
| `expected_empty` | Egy opcionális forrás ellenőrzése megtörtént, és jogszerűen absent/empty. | Terminál olvasható forrás állapota; soha nem gyárt tárgyat. |
| `partial` | A korlátozott munkának hasznos, de hiányos eredményei vannak. | Nem terminál source/accounting állapot; visszaállítja a tulajdonos dolgozót. |
| `deferred` | A munka szándékosan függőben van. | Nem terminális forrás állapota; nem hiba vagy befejezés. |
| `unavailable` | A forrás jelenleg nem használható. | Terminális hézag; a kötelező forrás hiánya elérhetetlenné teszi a könyvelést. |
| `malformed` | Létezik egy forrás, de szerkezetileg érvénytelen. | A terminálhézag megőrzi az érvényesítési részleteket és lezárja a függő írásokat. |
| `permission_denied` | Az operációs rendszer kifejezetten elutasította a hozzáférést. | A terminálhézag különbözik a missing/unavailable. |
| `error` | Egy korlátos művelet váratlanul meghiúsult. | A megnevezett helyreállítást igénylő terminálhiba; semmilyen titkos részlet nem tartozik a nyilvános jelentésekhez. |
| `complete` | Minden elszámolt forrás terminál, hézag nélkül. | A legfelső szintű forrás elszámolási állapota. |
| `complete_with_gaps` | A szükséges jelenlegi bizonyíték működik; opcionális kapocsrések maradnak. | Legfelső szintű könyvelési állapot; az útvonalak továbbra is alkalmazzák a saját követelményeiket. |
| `full` | A szükséges, nem üres szerződéssel teljesített útvonal. | Útvonal-ellenőrző enum befejezett aktuális ciklus kimenetekkel. |
| `limited_expected_empty` | Egy útvonal elkészült, és nem talált megfelelőt subject/failure. | Útvonal-ellenőrző enum a `completed=true`, `expected_empty=true`. |
| `missing` | Az útvonal befejezésének igazolása hiányzik vagy sikertelen. | Útvonal-ellenőrző enum a `completed=false`; soha nem jogosult a kimenő mappára. |
| Strukturált jelentés | Géppel olvasható útvonalkimenet. | `<route>_latest.json` a `randomdayguard.report/v1`. |
| Lefordított jelentés | Ugyanannak az útvonalnak az ember által olvasható megjelenítése. | `<route>_latest.txt` rögzített Megfigyelt-forrás-hivatkozási sorrenddel. |
| Útvonal-ellenőrzés | Keresztútvonal-befejezési főkönyv. | `route_proof.json` kötés version/boot/epoch/poll/freshness/output elérési utak. |
| Jelenlegi bizonyítékok | Az aktív ciklus tulajdonában lévő megfigyelés. | Hatókör `current`; nem rekonstruálták a régiből filenames/reports. |
| Történelmi bizonyítékok | Megőrzött kontextus a korábbi ciklusokból vagy lassú vizsgálatból. | Hatókör `historical`; értesítheti a felülvizsgálatot, de nem igényelheti a jelenlegi jelenlétét. |
| Csak áttekintés | Ellenőrzési bizonyíték készítése Admin.ini írja. | Alapértelmezett `review_only_mode=true`, `auto_ban=false`, `write_admin_ini=false`. |
| A kitiltási lista biztonsági ellenőrzése | Egy kérdésre a Guardnak meg kell válaszolnia, mielőtt megváltozna `Admin.ini`. | Meg kell erősítenie a fiókot és pontszámot, ki kell zárnia a megbízható fiókokat és az ismétlődéseket, ellenőriznie kell a biztonsági másolatot, észlelnie kell a külső változásokat, mentenie kell a tervezett frissítést, és ellenőriznie kell vagy biztonságosan vissza kell állítania a teljes fájlt. |
| Helyi kimenő üzenetek | Opcionális szolgáltató-semleges értesítés-átadás. | JSON fájlok a következővel: `delivery_backend="none"` és `delivery_attempted=false`. |
| Alapállapot | Elkészült korlátos mentett fájl kontextus-pillanatkép. | Manifest/object/world állapot csak akkor használható újra, ha kompatibilis és elég friss. |
| Ellenőrző pont | Folytatás a pozícióba, ha nem fejeződött be a vizsgálat. | `scan_checkpoint.json`; A törlés nem az alapértelmezett helyreállítás. |
| Újraépíthető index | Újra előállítható összegzés. | Daily/weekly/forensic/final áttekintés kimenet; a forrás bizonyítéka továbbra is mérvadó. |
| A bizonyítékok határa | Korlátozza, hogy egy forrás mit támogathat. | Explicit `does_not_prove`, ismeretlenek, identitás erőssége és hatókör szabályai. |

A sémák kanonikus definíciói itt találhatók: [`OUTPUT_SCHEMA_REFERENCE.md`](KIMENETI_S%C3%89MA_HIVATKOZ%C3%81S.md); a konfigurációs feltételek a [`CONFIG_FIELD_CATALOG.md`](KONFIGUR%C3%81CI%C3%93S_MEZ%C5%90KATAL%C3%93GUS.md).
