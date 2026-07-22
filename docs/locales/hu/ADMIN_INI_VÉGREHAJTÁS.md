<a id="adminini-enforcement"></a>
# Admin.ini végrehajtás

> **Kanonikus angol forrás:** [ADMIN_INI_ENFORCEMENT.md](../../ADMIN_INI_ENFORCEMENT.md). Ez a lokalizált dokumentáció megőrzi a pontos parancsokat, elérési utakat, kulcsokat, állapotértékeket, kivonatokat és fájlneveket. Ha a technikai megfogalmazás eltér, használja az angol forrást.


RandomDayGuard nem módosítja a szerver tiltólistáját az alapértelmezett beállításban. Csak jelentéseket hoz létre az adminisztrátor számára, hogy ellenőrizzék. Ez az oldal ismerteti az opcionális automatikus kitiltási lista frissítését azon rendszergazdák számára, akik szándékosan engedélyezik ezt.

<a id="what-guard-checks-before-changing-the-ban-list"></a>
## Mit ellenőriz a Guard a kitiltási lista módosítása előtt

A Guard csak akkor ad hozzá tiltást, ha minden alábbi válasz **igen**:

1. A jelenlegi bizonyítékok kellő biztonsággal azonosítottak egy konkrét fiókot?
2. A fiók sem moderátor, sem az adminisztrátor nem megbízhatóként jelölt meg?
3. A fiók nincs még a kitiltási listán?
4. Elérte a fiók a konfigurált automatikus műveleti pontszámot?
5. A Guard be tudja olvasni az aktuálisat `Admin.ini` és ment egy azonos biztonsági másolatot?
6. Megtette `Admin.ini` változatlan marad, amíg a Guard előkészíti a frissítést?
7. Mentés után a teljes fájl pontosan megegyezik a kívánt eredménnyel?

Ha a válasz **nem**, vagy nem ellenőrizhető, Őr távozik `Admin.ini` változatlan, és az okot rögzíti a jelentéseiben. Ha a mentés megkezdődik, de a végső ellenőrzés sikertelen, a Guard visszaállítja az ellenőrzött biztonsági másolatot.

<a id="file-format"></a>
## Fájlformátum

`Admin.ini` csak tiszta tiltó sorokat kaphat:

```ini
BannedPlayer=<ID>
```

- Nincsenek nevek.
- Nincs megjegyzés.
- Nincs ok.
- Nincsenek utótagok.

<a id="safe-defaults"></a>
## Biztonságos alapértelmezések

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
require_clean_ban_id = true
preserve_existing_bans = true
preserve_moderators = true
```

<a id="ban-id-source"></a>
## Az azonosító forrásának kitiltása

Legjobb forrás:

```text
Login request
Name=<player>
ConnectID=<raw_id>
UniqueId=<platform_id>
```

A futási környezet vagy teljesen numerikus azonosítót vagy a teljes dokumentált `<digits>_+_|<non-space token>` csatlakozási űrlapot, és ebből származtatja a numerikus tiltó azonosítót. Az ismeretlen utótagú tetszőleges numerikus előtagok elutasítva; nem csonkolják tiltó azonosítóvá.

Helyes:

```ini
BannedPlayer=2535422284688820
```

Rossz:

```ini
BannedPlayer=ExamplePlayer
```

Szintén rossz:

```text
BannedPlayer=<ID>
```

<a id="exact-settings-guard-checks"></a>
## Pontos beállítások Védőellenőrzések

Ezek a beállítások végrehajtják a fent leírt ellenőrzéseket. Minden felsorolt ​​feltételnek igaznak kell lennie:

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

Ha bármely feltétel hamis vagy nem ellenőrizhető, a Guard változatlanul hagyja a kitiltási listát, és rögzíti, hogy mi akadályozta meg.

<a id="transaction-safety"></a>
## Tranzakcióbiztonság

A talp `Admin.ini` mutációs útvonal a következő lépéseket hajtja végre:

1. Olvassa el és strukturálisan érvényesítse a mérvadó bájtokat.
2. Szerezzen le ugyanabból a pillanatképből a moderátor, megbízható és meglévő tiltott állapotot.
3. Írjon egyedi biztonsági másolatot a `runtime/backups/`, és bájtonként ellenőrizze.
4. Olvassa el újra `Admin.ini` közvetlenül a csere előtt, és utasítson el minden külső változtatást.
5. Írja be a jelöltet a konfigurált ellenőrzött helyettesítési útvonalon.
6. A teljes visszaolvasási bájtok megkövetelése, hogy megegyezzenek a teljes jelölt bájtokkal.
7. A visszaolvasási hiba esetén csak akkor állítsa vissza az ellenőrzött biztonsági másolatot, amíg az aktuális fájl még mindig pontosan a Guard által írt jelölt. Ha egy másik író megváltoztatta, a Guard megtagadja a visszaállítást, ahelyett, hogy felülírná az ismeretlen külső bájtokat.

A duplikált azonosítók idempotensek: nincs második sor és második biztonsági másolat sem. A biztonsági másolat nevei tartalmaznak időbélyeget, forrásbájtos ujjlenyomatot és tiszta azonosítót, így a külön próbálkozások nem oszthatják meg a régi, egymásodperces fájlnevet.

<a id="local-regression-proof"></a>
## Helyi regressziós bizonyíték

`tests/lua/enforcement_runtime_test.lua` egyszer elindítja a szállított betöltőt, majd végrehajtja a valódi helyi `append_ban()` zárás az elszigetelt szintetikus fájlok ellen a tároló alatt `.tmp/` könyvtár. Ez magában foglalja a beszúrást, a duplikált idempotenciát, moderator/trusted elutasítás, gyenge és hibás identitás elutasítása, bájtpontos biztonsági mentés ellenőrzése, egyidejű módosítás elutasítása, sikeres visszaállítás sikertelen visszaolvasás után, valamint az írás utáni külső módosítás felülírásának megtagadása. Fájlrendszer-burkolói visszautasítanak minden, a fixture gyökéren kívüli mutációt; nincs valódi szerver elérési út vagy valódi `Admin.ini` használatban van.

Futtassa végig `python tools/test_public_pipeline.py`. A fixture pass csak a helyi tranzakciós viselkedést bizonyítja. Nem teszi lehetővé a végrehajtást, nem engedélyezi az éles írást, és nem bizonyítja a gazdagép-specifikus engedélyeket.

<a id="files-to-check"></a>
## Ellenőrzendő fájlok

```text
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
runtime/enforced_bans.jsonl
runtime/enforced.txt
runtime/ban_queue.json
```

<a id="rollback"></a>
## Visszaállítás

1. Állítsa le a szervert.
2. A legújabb Admin.ini biztonsági mentés innen: `runtime/backups/`.
3. Távolítsa el a hibás részt `BannedPlayer=<ID>` sor, ha szükséges.
4. Indítsa el a szervert.
5. Újranyitás Admin.ini, és ellenőrizze, hogy a vonal megmaradt vagy eltávolították.
6. Megőrzés `enforced_bans.jsonl` az ellenőrzéshez.

<a id="related-docs"></a>
## Kapcsolódó dokumentumok

* [`BAN_ID_MAPPING.md`](ID_MAPPING_KITILT%C3%81SA.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](J%C3%81T%C3%89KOS_ELLEN%C5%90RZ%C3%89SI_MUNKAFOLYAMAT.md)
