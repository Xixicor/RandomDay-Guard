<a id="status-and-error-reference"></a>
# Állapot- és hibareferencia

> **Kanonikus angol forrás:** [STATUS_AND_ERROR_REFERENCE.md](../../STATUS_AND_ERROR_REFERENCE.md). Ez a lokalizált dokumentáció megőrzi a pontos parancsokat, elérési utakat, kulcsokat, állapotértékeket, kivonatokat és fájlneveket. Ha a technikai megfogalmazás eltér, használja az angol forrást.


Használja ezt a hivatkozást, miután egy tünetet a [Hibaelhárítás](HIBAELH%C3%81R%C3%8DT%C3%81S.md). Olvassa el a hiba által megnevezett strukturált állapotfájlt. A külön kódok különálló biztonsági és életciklus-állapotokat jelentenek; ne csukja össze őket egy általános „Guard failed” eredménnyel.

<a id="route-and-source-states"></a>
## Útvonal- és forrásállapotok

| Érték | Jelentés | Üzemeltető válasza |
|---|---|---|
| `full` | Az útvonal-szerződés az aktuális ciklus forrásigazolásával elkészült. | Olvassa el az útvonal bizonyítékhatárát; nincs benne javítás. |
| `limited_expected_empty` | A befejezett útvonal és a hiányzó tevékenység jogos ehhez a ciklushoz. | Nem szintetikus player/case eseményt létre kell hozni. |
| `missing` | Hiányzik a szükséges kimenet, leszármazási mező vagy forrásigazolás. | Ellenőrizze az útvonal okát és a megnevezett forrás állapotát. |
| `available` | A megnevezett forrás olvasható és használható volt. | Nincs művelet. |
| `expected_empty` | A forrást ellenőriztük, és jogszerűen nem tartalmazott sorokat. | Nincs művelet, kivéve, ha a tevékenység függetlenül várható. |
| `partial` / `complete_with_gaps` | Létezik használható bizonyíték, de a megnevezett forrásosztályok hiányosak. | A következtetéseket az összegyűjtött bizonyítékokra korlátozza. |
| `deferred` | Korlátozott munkavégzés ütemezve egy későbbi munkavállalói lehetőséghez. | A konfiguráció módosítása előtt ellenőrizze az előrehaladást. |
| `unavailable` | A környezet nem biztosította a forrást. | Rögzítse a határértéket; csak egy bizonyított elérési utat vagy engedélyt javítson ki. |
| `malformed` | A forrás olvasható volt, de a szerkezeti ellenőrzés nem sikerült. | Őrizze meg és javítsa ki a forrást; ne tippelj. |
| `permission_denied` | A forrás létezik, de nem olvasható. | Csak a szűk, szükséges olvasási engedélyt adja meg. |
| `error` | A gyűjtés a rögzített ok miatt meghiúsult. | Őrizze meg a hibát, és diagnosztizálja azt a szakaszt. |

<a id="playerdata-and-inventory-codes"></a>
## PlayerData és készletkódok

| Kód | Jelentés | Biztonságos válasz |
|---|---|---|
| `saved_root_unavailable` | Nem volt elérhető ellenőrzött mentett gyökér a nyilvános folyamat számára. | Helyes `SavedRoot.txt`, és ellenőrizze újra az útvonal-szondát. |
| `unsafe_playerdata_root` | PlayerData a felderítés a korlátozott mentett gyökéren kívül megoldva. | Javítsa ki az elérési utat; soha ne gyengítse a határt. |
| `playerdata_discovery_not_run` | A korlátos felderítési feldolgozó még nem futott. | Ellenőrizze az ütemező és a dolgozó előrehaladását. |
| `playerdata_discovery_read_failed:*` | A felfedezés kimenete nem olvasható. | Őrizze meg az utótag részletét, és ellenőrizze a behatárolt leltár parancsot. |
| `inventory_command_open_failed` | A leltározási folyamat nem indítható el. | Győződjön meg arról, hogy a futási környezet biztosítja a konfigurált parancshidat. |
| `inventory_command_read_failed` | A készletkiadás meghiúsult az olvasás során. | Őrizze meg a részleges kimenetet, és csak a mögöttes hiba kijavítása után futtassa újra. |
| `inventory_command_close_failed` | A leltár megbízható zárási eredmény nélkül fejeződött be. | Kezelje a forrást hiányosként. |
| `identity_ledger_row_limit_exceeded` | A tartós identitásbevitel túllépte a közbiztonsági határt. | Archiválja és tekintse át a főkönyvet; ne csonkolja csendben teljes bizonyításra. |

<a id="adminini-enforcement-codes"></a>
## Admin.ini végrehajtási kódok

Az ebben a szakaszban található összes kód hibazárású. Önmagukban nem engedélyeznek manuális kitiltást.

| Kód | Jelentés | Biztonságos válasz |
|---|---|---|
| `admin_ini_write_disabled` / `admin_ini_disabled` | A nyilvánosan biztonságos írási kapuk ki vannak kapcsolva. | Csak felülvizsgálati művelet esetén várható. |
| `admin_ini_backup_disabled` / `backup_safety_gate_disabled` | A szükséges biztonsági mentési házirend nem aktív. | Tartsa letiltva az írást. |
| `enforcement_disabled` / `ban_on_threshold_disabled` / `auto_ban_disabled` | Egy explicit végrehajtási kapu ki van kapcsolva. | Várható a csak nyilvános áttekintésre vonatkozó alapértelmezett beállításoknál; ne értelmezze újra írási hibaként. |
| `review_only_mode_enabled` | A csak áttekintés mód szándékosan blokkolja a mutációt. | Csak a bizonyítékok áttekintése. |
| `duplicate_prevention_disabled` | Az ismétlődő védelem letiltva. | Tartsa letiltva az írást, amíg a biztonsági kapu vissza nem áll. |
| `readback_safety_gate_disabled` / `rollback_safety_gate_disabled` | Az írás utáni ellenőrzés vagy a visszaállítás elleni védelem le van tiltva. | Az írás letiltása; soha ne kerülje meg ezeket a kapukat. |
| `clean_id_safety_gate_disabled` / `account_specific_evidence_gate_disabled` | A tiszta személyazonosság vagy a fiókspecifikus bizonyítékok végrehajtása letiltásra került. | Állítsa vissza a kaput minden végrehajtási teszt előtt. |
| `moderator_preservation_disabled` / `existing_ban_preservation_disabled` | A védett fiók vagy a meglévő kitiltott megőrzés letiltva. | Tartsa letiltva az írást. |
| `clean_numeric_identity_required` | A javasolt azonosító nem a teljes elfogadott csatlakozási űrlap vagy tiszta numerikus azonosító. | Kerítsen ellenőrzött leképezést; soha ne csonkoljon tetszőleges előtagot. |
| `identity_strength_below_minimum` | A személyazonossági bizonyíték gyengébb, mint a beállított küszöb. | Csak a bizonyítékok áttekintése. |
| `playerdata_verification_required` | A konfigurációhoz PlayerData megerősítést, és a fiók nem rendelkezik vele. | A jelölt csak véleményezésre; ne következtessen tulajdonjogra egy fájlnévből. |
| `trusted_or_moderator_identity` | A fiókot megbízható vagy moderátor állapot védi. | Nem írható. |
| `admin_ini_path_invalid` / `admin_ini_path_outside_saved_root` | A cél elérési út érvénytelen, vagy a mentett gyökérből kikerül. | Helyes konfiguráció; soha ne kerülje meg az útvédőt. |
| `admin_ini_unavailable` | Nincs olvasható konfigurálva Admin.ini található a Mentett gyökérben. | Javítsa ki a behatárolt elérési utat, vagy hagyja kikapcsolva a betartatást. |
| `admin_ini_read_failed` | A hiteles bájtok nem olvashatók. | Megáll a mutáció előtt. |
| `admin_ini_parse_failed` | Admin.ini az érvényesítés nem sikerült pontosabb szerkezeti kód nélkül. | Őrizze meg a fájlt, és ellenőrizze a szakasz- és sorszerkezetét. |
| `admin_ini_contains_nul` | A fájl tartalmazza a következőt: NUL bájt, és nem fogadják el szövegként. | Őrizze meg a fájlt, és javítsa ki a Guard-on kívül. |
| `admin_ini_duplicate_banned_players_section` | Több mint egy `[BannedPlayers]` szakasz létezik. | A szakaszok manuális egyesítése leállításkor. |
| `admin_ini_banned_player_outside_section` | A kitiltási sor `[BannedPlayers]`. | Javítsa ki manuálisan az elrendezést. |
| `admin_ini_invalid_banned_player_line` | A tiltó sor nem éppen egy tiszta, támogatott azonosítósor. | Javítsa ki a hibás formátumú sort. |
| `admin_ini_backup_failed` | Az egyedi biztonsági másolat nem bájt azonos módon írt és olvasott vissza. | Nem engedélyezett a mutáció. |
| `admin_ini_external_change_detected` | Egy másik író megváltoztatta a fájlt Guard pillanatképe után. | Őrizze meg a külső bájtokat, és csak az írók összehangolása után próbálkozzon újra. |
| `atomic_rename_unavailable` | Atomcserét kértek, de a Lua nem biztosította `os.rename`. | Az írás nem megbízható; támogatott futtatókörnyezetet használjon, vagy tiltsa le a végrehajtást. |
| `admin_ini_write_failed` | Az ellenőrzött csere nem fejeződött be. | Ellenőrizze a rögzített cserehibát és biztonsági másolatot. |
| `post_write_verification_failed` | A termelési bájtok nem egyeztek meg a jelölttel. | Ellenőrizze `rollback_success` és `rollback_refused_external_change` bármilyen művelet előtt. |

<a id="startup-scheduler-and-backlog-states"></a>
## Indítási, ütemezői és lemaradási állapotok

Ezek az értékek életciklus-bizonyítékok, nem útvonal-bizonyítékok. Olvassa el őket az aktuális szavazás, jelentéskezelő és útvonalbiztos fájlokkal.

| Érték | Jelentés | Biztonságos válasz |
|---|---|---|
| `not_started` | A megnevezett indítási vagy ütemezői szakasz nem kezdődött el. | Indítás közben várja meg a dokumentált intervallumot; ezt követően ellenőrizze az első változatlan fázist. |
| `main_lua_loaded` / `starting` | A kanonikus betöltő futott, és a Guard elindult. | Tovább a későbbi fázisokhoz; ez önmagában még nem kész. |
| `saved_root_found` / `log_tail_initialized` / `epoch_started` | Az alapforrás és a folytonosság inicializálása továbbfejlesztve. | Nincs teendő, hacsak a következő fázis nem halad előre. |
| `admin_state_written` / `playerdata_index_written` | A kezdeti korlátos indexek exportálva. | Nincs művelet; Az ütemező átadását továbbra is követnie kell. |
| `watchdog_started` | A jelentést és a közvélemény-kutatási felügyeletet regisztrálták. | Következő lépésként erősítse meg az ütemezőt és a szavazás folyamatát. |
| `ready_degraded` / `scan_running` | A Guard fut, miközben a korlátos előzményvizsgálat függőben marad. | Vigyázat, nem hiba; ellenőrizze a folyamatszámlálók előrehaladását. |
| `ready` | Az indítás és az aktuális korlátos vizsgálat készenléti állapotba került. | Ellenőrizze az útvonal-igazolást. |
| `scan_failed` / `error` | Az indítás vagy a vizsgálat rögzített hibával fejeződött be. | Őrizze meg a megnevezett hiba- vagy állapotfájlt, és diagnosztizálja azt a szakaszt. |
| `running` | Az ütemező birtokolja a jövőbeni szavazási lehetőségeket. | Megerősítés `poll_id` és `poll_completed_count` előre. |
| `manual_only` | A hurokütemezés nem volt elérhető; csak kifejezett munka futhat. | A felügyelet nélküli műveletet elérhetetlenként kezelje. |
| `stopped` | Az ütemező művelete befejeződött. | Újraindítás előtt ellenőrizze az előző leállási és hibajelenségeket. |
| `active_log_caught_up` | Nem marad olvasatlan aktív napló hátralék. | Az előzmények vizsgálata folytatódhat. |
| `active_log_unavailable_nonblocking` | Az aktív napló nem volt jelen, de az indítás nem blokkolt. | Rögzítse a forráskorlátot, és ellenőrizze a többi forrást. |
| `active_log_read_failed` | Az aktív napló létezett, de nem olvasható. | Őrizze meg a hibát, és csak a bizonyított elérési utat vagy engedélyt javítsa. |
| `budget_exhausted` / `active_log_has_unread_bytes` | A korlátos farokátmenet leállt, és hátralék maradt. | Győződjön meg arról, hogy a későbbi szavazások csökkentik az olvasatlanok számát. |
| `offset_commit_failed_after_events_applied` | Az események feldolgozása megtörtént, de a naplózási eltolás tartós megmaradása meghiúsult. | A végrehajtás elhalasztva; javítsa ki az ofszet tárolót, mielőtt egy másik ciklusra hagyatkozna. |

<a id="scheduler-report-and-notification-codes"></a>
## Ütemező-, jelentés- és értesítési kódok

| Kód vagy állapot | Jelentés | Biztonságos válasz |
|---|---|---|
| `poll already in flight` | Második visszahívás érkezett, miközben az aktuális szavazásé volt az életciklus. | Erősítse meg a szavazás meglévő előrehaladását; ne adjon hozzá másik huroktulajdonost. |
| `no_log_files_found` | Nem található konfigurált aktív vagy biztonsági mentési napló. | Ellenőrizze a mentett gyökér- és forráskonfigurációt. |
| `current_poll_error` | Az aktuális ciklus lekérdezési forrás hibáját rögzítette. | Olvassa el `runtime/current/poll_error.json`. |
| `cadence_deferred` | A befejezési diszpécser még nem esedékes. | Várhatóan a következő korlátozott lehetőségig. |
| `reports_disabled` | A nyilvános jelentések létrehozása le van tiltva. | Csak akkor engedélyezze, ha jelentések készültek. |
| `local_outbox_write_failed` | A lefordított helyi boríték nem írható. | Javítsa meg a futásidejű kimeneti könyvtárat; ez nem egy értesítési átviteli hiba. |
| `source_accounting_disabled` | Az útvonal-ellenőrzés nem igényelheti a teljes forráslefedettséget. | Engedélyezze a forráselszámolást, vagy kifejezetten fogadja el a hiányzó bizonyítékokat. |
| `route_disabled` | Az útvonal szándékosan letiltva. | Nem várható szállítás ezen az útvonalon. |
| `poll_owner_between_polls` | A jelentéskezelő sorban áll az ütemező tulajdonában lévő szavazások közötti rés miatt. | Csak addig várható, amíg az időbélyegek és a kurzorok továbbhaladnak. |
| `unsafe_shell_path` | Egy korlátozott készlet vagy shell elérési útja sikertelen volt a platform biztonságos ellenőrzése. | Javítsa ki az elérési utat; soha ne gyengítse az idézetet vagy az útvonal érvényesítését. |

<a id="related-procedures"></a>
## Kapcsolódó eljárások

- [Hibaelhárítás](HIBAELH%C3%81R%C3%8DT%C3%81S.md) a tünetek osztályozásához és javításához.
- [Érvényesítés és kiadás felülvizsgálata](%C3%89RV%C3%89NYES%C3%8DT%C3%89S_%C3%89S_KIAD%C3%81S.md) a fixture és a csomag hibáira.
- [Kimeneti séma hivatkozás](KIMENETI_S%C3%89MA_HIVATKOZ%C3%81S.md) a teljes helyszíni szerződésekhez.
