<a id="output-and-state-schema-reference"></a>
# Kimeneti és állapotséma hivatkozás

> **Kanonikus angol forrás:** [OUTPUT_SCHEMA_REFERENCE.md](../../OUTPUT_SCHEMA_REFERENCE.md). Ez a lokalizált dokumentáció megőrzi a pontos parancsokat, elérési utakat, kulcsokat, állapotértékeket, kivonatokat és fájlneveket. Ha a technikai megfogalmazás eltér, használja az angol forrást.


Ez a gyűjtőszerződés a generált kezelői fájlok számára. Egyedül a pontos kimeneti útvonalak, mezőnevek, megengedett értékek, leszármazási követelmények és útvonalsémák birtokában van. Az eljárási útmutatók ide hivatkoznak a tények újradefiniálása helyett.

A futásidejű bizonyítékok mérvadóak; egy fájlnév, ütemező szívverése, lefordított jelentés vagy helyi kimenő objektum nem bizonyít többet, mint a saját mezői és származása.

<a id="public-report-routes"></a>
## Nyilvános jelentési útvonalak

A jelentéskezelő öt útvonallal rendelkezik a `runtime/final_logs/`:

| Útvonal | Szerződés | `full` követelmény | Várható üres jelentés |
|---|---|---|---|
| `server_status` | Aktuális ütemező, aktív napló, vizsgálat függőben és forráslefedettségi állapot. | Jelenlegi boot/epoch/poll származás, friss aktív napló, accounting/history írja, és a JSON/TXT pár. | Nem használt egyébként egészséges áramciklushoz; hiányzó származás: `missing`. |
| `daily_rollup` | Jelenlegi day/window folytonosság a szerver, a lejátszók, az esetek, a szkennelés és a lefedettség között. | A múltbeli könyvelési terminál elegendő az útvonal és az aktuális ciklus ellenőrzéséhez. | Nincsenek megtartott játékosok és nincsenek felülvizsgálati esetek. |
| `player_activity` | Válassza szét a jelenlegi és a korábbi player/account megfigyelések. | Aktuális ciklus igazolás plusz egy vagy több current/historical sor. | Nincsenek megfelelő játékossorok a korlátos bemenetekben; nincs szintetikus tárgy. |
| `case_review` | Nevesített megőrzött esetek és aktuális review/BAN-ELIGIBLE jelöltek. | Aktuális ciklus bizonyítása plusz egy vagy több elnevezett eset forráshivatkozásokkal. | Egy megnevezett eset sem felelt meg az ellenőrzési feltételeknek; nincs szintetikus tok. |
| `critical_guard` | Aktuális rendszerindítási ütemező, indítási, lekérdezési vagy bizonyítékintegritási hiba. | Aktuális ciklus ellenőrzése plusz egy aktuális kritikus hiba. | Nincs aktuális kritikus hiba; a régi szöveges hibák nem birtokolják ezt az útvonalat. |

Minden engedélyezett útvonal ír `<route>_latest.json` és `<route>_latest.txt`. A párosítás csak `runtime/final_logs/route_proof.json` ugyanazt a verziót, rendszerindítást, korszakot, szavazást és forrás frissességét rögzíti.

<a id="report-json-schema"></a>
## Jelentés JSON séma

Minden útvonal JSON használ `schema="randomdayguard.report/v1"`.

| Mező | Típus | Jelentés és változatlan |
|---|---|---|
| `schema` | karakterlánc | Pontosan `randomdayguard.report/v1`. |
| `generated_ts`, `report_date` | karakterlánc | Generációs időbélyeg és jelentés dátuma. |
| `version` | karakterlánc | Runtime/package azonosság ehhez a ciklushoz. |
| `boot_id`, `epoch_id` | karakterlánc | A folyamat jelenlegi rendszerindítási és a szerver folytonossági korszaka. Mindkettő szükséges a kitöltéshez. |
| `poll_id` | egész szám | Pozitív aktuális szavazásazonosító. Zero/missing nem tud befejezni egy útvonalat. |
| `source_freshness` | objektum | `status`, `checked_ts`, aktív napló állapota, utolsó szavazás időbélyege és utolsó befejezett szavazás időbélyege. |
| `current_cycle_proof_complete` | boolean | Csak akkor igaz, ha származási és friss active-log/current-poll bizonyítékok egyetértenek. |
| `route` | enum | A fenti öt útvonal egyike. |
| `route_proof_status` | enum | `full`, `limited_expected_empty` vagy `missing`. |
| `coverage_status` | enum | Pontosan `complete`, `complete_with_gaps`, `partial` vagy `unavailable`. |
| `completed`, `expected_empty` | boolean | `completed` csak a `missing`; `expected_empty` csak a következőre igaz: `limited_expected_empty`. |
| `observed` | karakterláncok tömbje | A beton megmaradt facts/counts/statuses. |
| `interpretation` | karakterláncok tömbje | Óvatos jelentés a bizonyítékokhoz igazítva. |
| `unknown` | karakterláncok tömbje | Hiányzó identitás, előzmény, forrás vagy kontextus. |
| `does_not_prove` | karakterláncok tömbje | Azok a következtetések, amelyeket a bizonyítékok nem tudnak alátámasztani. |
| `next_action` | karakterlánc | A legbiztonságosabb korlátos operátori művelet. |
| `source_references` | karakterláncok tömbje | Egyedi rendezés runtime/Saved hivatkozások. |
| `enforcement_authority` | boolean | Mindig hamis. A jelentés soha nem engedélyez írást. |
| `output_paths` | két karakterlánc | JSON és TXT elérési utak hozzáadva a párosított írások előtt. |

`coverage_status` csak a legfelső szintű könyvelés. A forrásrekordok külön saját `available`, `expected_empty`, `partial`, `deferred`, `unavailable`, `malformed`, `permission_denied` és `error`. Útvonaligazolás külön birtokolja a `full`, `limited_expected_empty` és `missing`; az értékek soha nem lépik át ezeket a határokat.

Útvonalbővítmények:

- `server_status`: `scheduler_status`, `active_log_status` és `server_metrics`. A mutatók rögzítik az aktuális korszak kezdetét, a legutóbb befejezett szavazás időbélyegzőjét és azonosítóját, az aktív játékosok számát, active/backup-log számol, beolvasás pending/progress értékek és configured/usable/unavailable forráscsoport elszámolása. Nem találják ki az üzemidőt, az újraindítási számlálást, az időbélyegek mentését vagy a kimaradás időtartamát, amikor egyetlen forrás sem fedi fel ezeket a tényeket.
- `player_activity`: `player_activity_present`, `movement`, `same_day_sessions`, `current_player_count`, `current_evidence_player_count`, `historical_player_count`, `historical_session_count`, `current_players`, `historical_players` és kompatibilitási tömb `players`. Minden aznapi munkamenet megtartja munkamenet-azonosítóját, fiókazonosítóját, megjelenített nevét, ha ismert, join/leave időbélyegek, tiszta kilépés és életciklus jelzők, valamint forráshivatkozások. Megőrzött személyazonosság és PlayerData jelenlét kontextus marad, nem pedig a mai tevékenység bizonyítéka.
- `case_review`: `cases`, `review_subjects`, `current_case_count` és `retained_case_count`. Egy aktuális felülvizsgálati alany rögzíti a case/account Azonosító, megjelenített név, ha ismert, állapot, pontszám, személyazonosság-bizalom, first/last megfigyelés, figyelmeztetések száma, okok, aktuális jelzés és forráshivatkozások. A megőrzött esetek önmagukban nem hoznak létre aktuális alanyt.
- `critical_guard`: `critical_failure_present` és `current_boot_error_only=true`.
- `daily_rollup`: `daily_maturity`, `once_per_day_continuity`, `dedupe_window` és `daily_metrics`. A mérőszámok rögzítik a jelentés dátumát, az aktív játékosokat, az ugyanaznapi tevékenységgel rendelkező fiókokat, a csatlakozásokat, a kilépéseket, a tiszta és tisztátalan kilépéseket, az életciklus-visszatéréseket, az aktuális megnevezett felülvizsgálati alanyokat, a megőrzött eseteket, current/retained identitásszámok és forráscsoport-lefedettség.

<a id="translated-txt-schema"></a>
## Lefordítva TXT séma

A párosított szövegfájl az operátor által olvasható eredménnyel vezet, és a végére helyezi a vonal részleteit. Pontosan ezt a szakaszrendet tartja meg:

```text
RandomDayGuard <route title>
Generated: <timestamp>

Summary
<one plain-language route summary>

What Guard observed
- ...

What it means
- ...

What remains unknown
- ...

Recommended next step
...

Evidence boundary
- ...

Rating explanation
- ...

Technical record
- Route: <route>
- Version: <version>
- Cycle: boot=<boot> epoch=<epoch> poll=<poll>
- Source freshness: <status>
- Route result: <full|limited_expected_empty|missing>
- Coverage: <status>

Translation notes
- ...

Source references
- ...
```

A fordítás csak a strukturált jelentésmezőket és a jóváhagyott szótárleképezéseket használja. Nem adhat hozzá olyan játékosokat, eseteket, szállítást, okozati összefüggést, tulajdonjogot, szándékot vagy végrehajtási jogosultságot, amely hiányzik a strukturált jelentésből. A technikai részletek továbbra is rendelkezésre állnak anélkül, hogy az olvasható eredményt elmozdítanák.

<a id="source-accounting-schema"></a>
## Forrás elszámolási séma

`runtime/final_logs/source_accounting_latest.json` használ `randomdayguard.source-accounting/v1` generálással reason/status, enablement/disabled oka, current/historical megkülönböztetés, megváltoztatott fájlok jegyzéke, forrásrekordok, usable/unavailable osztálylisták és követeléskorlát.

Minden forrásrekord a következőket tartalmazza:

| Mező | Típus | Jelentés |
|---|---|---|
| `source_class` | karakterlánc | Az alábbi nyolc osztály egyike. |
| `scope` | `current` vagy `historical` | Időtulajdon; a hatóköröket soha nem egyesítik csendben. |
| `required` | boolean | Csak `active_log` megadása szükséges az aktuális ciklus útvonalának frissességéhez. |
| `status` | enum | Az alábbi forráseredmény. |
| `terminal` | boolean | Hamis csak a `partial` és `deferred`. |
| `available`, `readable` | boolean | Csak a következőre igaz: `available` és `expected_empty`. |
| `file_count` | egész szám | Korlátozott elszámolás file/reference szám. |
| `source_references` | tömb | Rendezett egyedi forrás paths/references. |
| `detail` | karakterlánc | Korlátozott eredmény vagy hibarészlet. |
| `does_not_prove` | karakterlánc | A rendelkezésre állás nem a szándék, a tulajdonjog, a kár, a többszörözés vagy a végrehajtás bizonyítéka. |

Forrásosztályok:

| Forrásosztály | Hatókör | Mihez járul hozzá | Amit nem tud bizonyítani |
|---|---|---|---|
| `active_log` | aktuális, kötelező | Olvasható aktív szervernapló és friss szavazási vonal. | Teljes előzmények vagy játékosok hibája. |
| `admin_ini` | aktuális, nem kötelező | Szerkezetileg érvényes áram moderator/ban állapot vagy várható hiányzás. | A játékos viselkedése vagy érvényes ok metaadatai. |
| `recent_backup_logs` | történelmi | Olvasható rotated/backup naplóhivatkozások. | Jelenlegi jelenlét vagy aktuális rendszerindítási állapot. |
| `playerdata_filenames` | aktuális kontextus | Korlátozott, olvasható fájlnév-hivatkozások a kiválasztott mentett gyökér alatt. | A fájlok tulajdonjoga, élő jelenlét, személyazonossági tartalom vagy kötelességszegés. |
| `existing_cases` | történelmi | Megtartott elnevezett eset files/index az aktuális kimenetek előtt rögzített rekordok. | Jelenlegi tevékenység vagy a régi következtetések helyessége. |
| `existing_reports` | történelmi | Megőrzött final/forensic/warning jelentéshivatkozások. | Hiteles forráscsere. |
| `existing_evidence` | történelmi | Megőrzött bizonyítékhivatkozások. | A szerver által soha nem tett közzé események teljessége. |
| `world_save_scan` | történelmi | Teljes, részleges, késleltetett vagy nem elérhető korlátos scan/checkpoint állapot. | Egy adott játékos tevékenysége vagy tulajdonjoga. |

Forrás állapotértékei:

| Állapot | Terminál | Az operátor jelentése és tevékenysége |
|---|---:|---|
| `available` | igen | Létezik olvasható hasznos forrás; tekintse át hivatkozásait. |
| `expected_empty` | igen | Az opcionális forrást ellenőrizték és jogszerűen absent/empty. Ne találjon ki adatokat. |
| `partial` | nem | A korlátozott munka- vagy készletkorlát nem teljes; folytatás engedélyezése. |
| `deferred` | nem | A munka szándékosan függőben van; várja meg a tulajdonos dolgozót. |
| `unavailable` | igen | Source/path/tool hiányzik vagy használhatatlan; csak akkor javítsa, ha az útvonal azt szükségessé teszi. |
| `malformed` | igen | A tartalom strukturális ellenőrzése sikertelen; őrizze meg és javítsa ki a formátumot. |
| `permission_denied` | igen | A hozzáférést kifejezetten megtagadták; a legkisebb jogosultságokkal rendelkező olvasási hozzáférés visszaállítása. |
| `error` | igen | Forrásszintű korlátos probe/read váratlanul meghiúsult; ellenőrizni `detail` titkok felfedése nélkül. |

Legfelső szint `coverage_status` pontosan `complete`, `complete_with_gaps`, `partial` vagy `unavailable`. A szükséges forrásszint `error`, `malformed` vagy `permission_denied` a legfelső szintre gördül `unavailable`; forrásszintű `deferred` a legfelső szintre gördül `partial`. A forráskönyvelés letiltása továbbra is elérhetetlen állapotot ír, és minden útvonalat a `missing`.

<a id="historical-status-schema"></a>
## Előzmény állapotséma

`runtime/final_logs/historical_backfill_latest.json` használ `randomdayguard.history/v1`: `generated_ts`, könyvelés `status`, `resumable=true`, `changed_file_refresh=true`, `current_evidence_is_not_history=true`, a forrás-elszámolási tömb, a nem elérhető osztályok és egy korlátos `next_action`.

`runtime/history/public_accounts.tsv` tartós nyilvános előzmények a következő fejléccel:

```text
account_id	ban_id	display_name	identity_confidence	status	score	first_seen	last_seen	source_references
```

A sorok fiókazonosító szerint vannak rendezve, a mezők single-line/tab-safe, a hivatkozások pedig sorted/unique. Ez a fájl megőrzi a történelmi kontextust a csendes újraindítások során; soha nem alakítja át a történelmet aktuális jelenlétté.

<a id="route-proof-schema"></a>
## Útvonal-ellenőrzési séma

`runtime/final_logs/route_proof.json` használ `randomdayguard.route-proof/v1` és rögzíti a legfelső szintű generációs időbélyeget, verziót, rendszerindítást, korszakot, szavazást, a forrás frissességét, az aktuális ciklus teljességét, az engedélyezett állapotokat és a `routes` tömb.

Minden útvonalbejegyzés tartalmazza a route/status, version/boot/epoch/poll, forrás-frissségi objektum, aktuális ciklus teljessége, kimeneti utak és forráshivatkozások. Letiltott útvonalrekordok `status="missing"` és `reason="route_disabled"`. Ha az útvonalbiztos írás sikertelen, minden útvonal átírásra kerül incomplete/missing mielőtt bármilyen értesítésre jelöltet elfogadnak.

<a id="notification-schemas"></a>
## Értesítési sémák

Az opcionális nyilvános mód csak a helyi fájlok kimenő üzenetei.

`runtime/notifications/pending/<route>_latest.json` használ `randomdayguard.notification/v1` generált időbélyeggel, version/boot/epoch/ poll/source frissesség, útvonal, `completed_output`, útvonalbiztos állapot, strukturált és lefordított jelentési útvonalak, forráshivatkozások, `delivery_backend="none"` és `delivery_attempted=false`. Választható kimeneti felhasználások `status="ready_for_local_consumer"`, `delivery_eligible=true` és `delivery_allowed=true`. Egy konfigurált, de missing/ineligible útvonal továbbra is ír egy audit borítékot a `status="suppressed_current_cycle"`, mindkét kézbesítési jelző hamis, és `suppression_reason="route_or_completion_policy_blocked"`. Ezért egy fájl jelenléte a `pending/` önmagában nem jelent sorban állást vagy jogosultságot.

`runtime/notifications/notification_status.json` használ `randomdayguard.notification-status/v1` ugyanazzal a származással, `generic_local_outbox_only=true`, `delivery_attempted=false` és útvonalonként `queued`/`outcome` sor. `full` alkalmas; Várható üres érték csak akkor használható, ha `include_expected_empty=true`; `missing` soha nem használható. Útvonalbiztos írási hiba esetén az állapot eredménye `route_proof_write_failed`; egy letiltott ellenőrzési boríték még írható, de az nem fogadható el.

<a id="runtime-output-inventory"></a>
## Futásidejű kimeneti készlet

A nyomon követhetőségi indexben minden elérési úthoz vagy dinamikus fájlosztályhoz egy gépsor tartozik. Ez az olvasható leltár a fájlokat operátori cél szerint csoportosítja.

| Elérési út vagy minta | Producer/trigger | Irányelvek és hasznos állapotok | Failure/recovery |
|---|---|---|---|
| `runtime/loader_probe.txt`, `runtime/loader_probe.json` | Betöltő bejegyzés. | Felülírt indítás identity/probe. | A hiányzó nem bizonyítja a terhelést; ellenőrizni UE4SS naplók és engedélyezés. |
| `runtime/config_load_error.txt` | A konfiguráció betöltése hiba. | Csak hiba, megőrzi a korlátozott okot. |  Állítsa vissza az érvényes nyilvános konfigurációt, és indítsa újra. |
| `runtime/saved_path_probe.json` | Mentett gyökérfelbontás. | Candidate/readability könyvelés. | Beállítás `SavedRoot.txt` vagy javítson ki egy általános jelöltet. |
| `runtime/startup_status.json`, `runtime/startup_error.txt`, `runtime/current/startup_error.json` | Indítási életciklus. | A legutóbbi indítási és aktuális rendszerindítási hiba. | Csak a megfelelő rendszerindítás rendelkezik aktuális kritikus állapottal. |
| `runtime/runtime_version.json`, `runtime/runtime_capabilities.json`, `runtime/public_pipeline_status.json` | Startup/report integráció. | Legfrissebb version/capability/handoff állapot. | A verzió vagy a képesség eltolódása blokkolja a befejezési igényeket. |
| `runtime/poll_status.json`, `runtime/current/poll_status.json`, `runtime/poll_error.txt`, `runtime/current/poll_error.json` | Szavazás finalizer/error. | Legfrissebb poll/scheduler/in-flight állapot és aktuális rendszerindítási hiba. | Javítsa ki a korlátozott visszahívást, és kérjen egy újabb kitöltött szavazást. |
| `runtime/logs/current.jsonl`, `runtime/raw_events.jsonl` | Eseménynaplózó. | Korlátozott append/rotation. | Korábbi bájtok megőrzése; javítás disk/retention, mielőtt a hiányosságokra hagyatkozna. |
| `runtime/log_offsets.tsv`, `runtime/log_registry.json` | Napló tail/registry. | Legújabb eltolások és kanonikus naplóazonosítók. | Óvatosan építse újra; a biztonsági mentési naplók történeti maradnak. |
| `runtime/log_continuity_events.jsonl`, `runtime/evidence/log_continuity_events.jsonl`, `runtime/server_lifecycle_events.jsonl`, `runtime/evidence/lifecycle_events.jsonl` | Continuity/lifecycle normalizáló. | Csak hozzáfűzhető kontextus. | A hiányzó kontextus nem bizonyítható graceful/crash állapot. |
| `runtime/current_server_epoch.json`, `runtime/server_epochs.jsonl`, `runtime/epochs/**` | Epoch tulajdonos. | A jelenlegi és megtartott szerverkorszakok. | Új korszak indítása a javítás után; ne írd át a régi történelmet. |
| `runtime/session_events.tsv`, `runtime/evidence/session_events.jsonl`, `runtime/sessions/**` | Munkamenet tulajdonosa. | Current/historical munkamenet-események és pillanatképek. | A leképezetlen sorok ismeretlenek maradnak; nincs identitás-találmány. |
| `runtime/account_evidence.tsv`, `runtime/account_evidence.json`, `runtime/history/public_accounts.tsv` | Account/session összesítő és jelentéskészítő modul. | Jelenlegi pillanatkép és tartós előzmények. | A hatóköröket tartsa elkülönítve, és állítsa vissza a bizonyítékoktól, ne találgatásoktól. |
| `runtime/current/session_state.json`, `runtime/current/active_accounts.json`, `runtime/current/spatial_context.json`, `runtime/current/actor_touch_rollup.json` | Poll/current-state írók. | A jelenlegi pillanatképek felülírva. | Stale/missing ismeretlen, nem várható, hogy üres legyen. |
| `runtime/days/**`, `runtime/weeks/**` | Daily/weekly összesítés. | Újraépíthető indexek. | Újraépítés mérvadó eseményekből. |
| `runtime/scan_started.json`, `runtime/scan_progress.json`, `runtime/scan_checkpoint.json`, `runtime/scan_complete.json`, `runtime/scan_error.txt` | Scan worker. | Elindult, partial/deferred, ellenőrzőpont, teljes vagy hiba. | Ellenőrzőpont folytatása; csak feljegyzett okkal építsd újra. |
| `runtime/baselines/last_scan.json`, `runtime/baselines/last_completed_baseline.json`, `runtime/baselines/file_manifest.tsv` | Alapmunka. | Legfrissebb scan/baseline és a módosított fájl-összerendelés. | Stale/incompatible jegyzékek kifejezett újraépítést igényelnek. |
| `runtime/object_registry_partial.json`, `runtime/object_registry_counts_partial.tsv`, `runtime/object_registry.json`, `runtime/object_registry_counts.tsv` | Objektum vizsgálat. | Partial/final osztálykörnyezet. | A számlálók nem igazolják a játékosok akcióit; szkennelés folytatása vagy újraépítése. |
| `runtime/new_classes_detected.jsonl`, `runtime/class_deltas.jsonl` | Objektum-összehasonlítás. | Csak hozzáfűzés new/delta kontextusban. | Áttekintés mapping/baseline a következtetés előtt. |
| `runtime/playerdata_index.json`, `runtime/admin_state.json` | Mentett gyökérindexek. | Filename/admin szerkezeti kontextus. | A fájlnevek gyengék; rosszul formázott adminisztrátori állapot bezárja az írásokat. |
| `runtime/world_state/boot/**`, `runtime/world_state/current/world_state_latest.json`, `runtime/world_state/sessions/**` | Világállami író. | Boot/current/session pillanatképek és eltérések. | Csak kontextus; után regenerálódik scan/source javítás. |
| `runtime/warning_events.jsonl`, `runtime/warnings/**`, `runtime/evidence/critical_events.jsonl`, `runtime/evidence/high_events.jsonl`, `runtime/evidence/medium_events.jsonl` | Warning/evidence írók. | Korlátozott hozzáfűzés és per-player/session tekintse át a fájlokat. | A hiányzó jelentésből nem hiányzik az eseményigazolás; vizsgálja meg a forrás bizonyítékait. |
| `runtime/raid_cases/**`, `runtime/raid_cases/index.jsonl`, `runtime/ban_queue.json` | Case/review összesítés. | Elnevezett felülvizsgálati anyagok és jelöltek a sorba. | Eset membership/threshold soha nem kerüli meg a fiókspecifikus kapukat. |
| `runtime/backups/Admin_*.ini`, `runtime/enforced.txt`, `runtime/enforced_bans.jsonl`, `runtime/evidence/enforced_bans.jsonl`, `runtime/evidence/enforcement_failed_*` | Opcionális Admin.ini tranzakció. | Biztonsági másolat, sikerkönyv vagy explicit failure/rollback bizonyíték. | Bármilyen backup/write/readback/rollback hiba lezárja a végrehajtást; állítsa vissza a biztonsági másolatot. |
| `runtime/request_restart.flag`, `runtime/restart_reason.json` | Opcionális jelölőíró. | Csak helyi kérés. | Nem bizonyítja a fogyasztást vagy az újraindítást. |
| `runtime/current/forensic_today.json`, `.md`, `.txt`, `runtime/forensic_days/YYYY-MM-DD/**`, `runtime/final_logs/YYYY-MM-DD/**` | Bűnügyi összesítés. | Jelenlegi és keltezett, újraépíthető áttekintési indexek. | Újraépítés forrás bizonyítékokból; az összegzést soha ne kezelje tekintélyként. |
| `runtime/final_logs/source_accounting_latest.json`, `historical_backfill_latest.json`, `<route>_latest.json`, `<route>_latest.txt`, `route_proof.json` | Nyilvános jelentéskezelő. | Sémák és kitöltési szabályok fent. | Javítsa ki az első eltérést lineage/source/write; hiányzik hiányzik. |
| `runtime/notifications/pending/<route>_latest.json`, `runtime/notifications/notification_status.json` | Opcionális helyi kimenő üzenetek. | Jogosult vagy kifejezetten letiltott helyi boríték plusz állapot. | Missing/ineligible az útvonalak lehetnek letiltott fájlok, de soha nem állnak sorba; ellenőrizze a kézbesítési jelzőket, és következtessen arra, hogy nincs külső kézbesítés. |

Overwrite/append/retention viselkedését a [`CONFIG_FIELD_CATALOG.md`](KONFIGUR%C3%81CI%C3%93S_MEZ%C5%90KATAL%C3%93GUS.md). A ZIP-csomagok csak üres `.gitkeep` helyőrzők a `runtime/`; bármely evidence/output bájt ellenőrzése sikertelen.

<a id="failure-and-recovery-matrix"></a>
## Hiba- és helyreállítási mátrix

| Hiba | Kötelező állapot | Biztonságos helyreállítás | Érvénytelen következtetés |
|---|---|---|---|
| Jelenlegi származás absent/stale | Minden útvonal `missing`. | Visszaállítás active-log/current-poll bizonyítja és generálja újra. | A régi útvonalfájlok nem aktuálisak. |
| Opcionális forrás várt üres | Forrás `expected_empty`; alkalmas útvonal lehet `limited_expected_empty`. | Nincs javítás, kivéve, ha léteznie kell a forrásnak. | Az üres nem elérhető, és nem bizonyítja a múltbeli hiányt. |
| A beolvasás nem fejeződött be | Forrás `partial` vagy `deferred`. | Korlátozott önéletrajz engedélyezése; az aktuális útvonal-szabályzat legyen egyértelmű. | A részleges nem korrupció. |
| A szükséges forrás nem érhető el | `coverage_status=unavailable`; függő útvonalak `missing`. | Kijelölt javítás Saved/log hozzáférést. | Más egészséges források nem helyettesítik a szükséges forrást. |
| Szükséges forrásvizsgálati hibák | Forrás állapota `error` korláttal `detail`; `coverage_status=unavailable`; függő útvonalak `missing`. | Javítsa meg a nevezett source/probe és hozzon létre egy újabb ciklust. | A forráshiba nem az ötödik legfelső szintű lefedettségi érték. |
| A párosított jelentés írása sikertelen | `coverage_status=unavailable`; útvonal a `missing`. | Javítsa meg a fájlrendszert, és írja át mindkét pártagot, valamint a bizonyítékot. | Az egyik testvérfájl nem fejeződött be, és az írási hiba nem a legfelső szintű `error`. |
| Útvonalbiztos írási hiba | Minden átírt útvonal hiányzik; nincs jogosult kimenő üzenet; a konfigurált útvonalak letiltott ellenőrzési borítékokat kaphatnak. | Útvonalbiztos írás javítása és az azonos ciklusú kimenetek regenerálása. | Érvényesnek tűnő jelentés JSON vagy egy elnyomott boríték nem alkalmas az útvonalra. |
| Az értesítés írása sikertelen | Eredmény `local_outbox_write_failed`. | A helyi kimeneti gyökér javítása; elkészített jelentésből. | Nem történt külső kézbesítés. |
| Admin.ini a tranzakció sikertelen | A végrehajtás letiltva ezzel: backup/write/readback/rollback bizonyíték. | Az ellenőrzött biztonsági másolat visszaállítása; csak véleményezésre szolgál. | A küszöbérték vagy jelentés nem indokolhatja a helyreállítás megkerülését. |

Lásd [`EVIDENCE_BOUNDARY.md`](A_BIZONY%C3%8DT%C3%89KOK_HAT%C3%81RA.md), [`ARCHITECTURE.md`](ARCHITEKT%C3%9ARA.md) és [`SOURCE_MODULE_REFERENCE.md`](FORR%C3%81SMODUL_HIVATKOZ%C3%81S.md).
