<a id="configuration-concepts"></a>
# Konfigurációs koncepciók

> **Kanonikus angol forrás:** [CONFIG_REFERENCE.md](../../CONFIG_REFERENCE.md). Ez a lokalizált dokumentáció megőrzi a pontos parancsokat, elérési utakat, kulcsokat, állapotértékeket, kivonatokat és fájlneveket. Ha a technikai megfogalmazás eltér, használja az angol forrást.


Ez a magyarázat leírja, hogy az egyes nagyobb konfigurációs területek mit szabályoznak, mikor futnak, és hogyan hatnak egymásra a bizonyítékokkal és a biztonsági kapukkal. Nem birtokolja a pontos mezőkatalógust vagy profileljárásokat.

A feladatorientált előre beállított értékekhez és a biztonságos módosítási lépésekhez használja a [`CONFIG_PROFILES.md`](KONFIGUR%C3%81CI%C3%93S_PROFILOK.md). Minden pontos forrásmezőhöz, alapértelmezetthez, típushoz, invariánshoz, kimeneti effektushoz és helyreállítási szabályhoz használja a generált [`CONFIG_FIELD_CATALOG.md`](KONFIGUR%C3%81CI%C3%93S_MEZ%C5%90KATAL%C3%93GUS.md); az érvényesítő minden szállított `config.lua` levélmező.

<a id="reading-this-page"></a>
## Az oldal olvasása

Minden konfigurációs terület válaszol:

```text
What it controls
When it runs
What to check
What can go wrong
```

<a id="top-level-safety"></a>
## Legfelső szintű biztonság

| Opció | Alapértelmezett | Jelentés |
|---|---:|---|
| `enabled` | `true` | Főkapcsoló az őrhöz |
| `enforcement.review_only_mode` | `true` | Record/recommend csak |
| `enforcement.auto_ban` | `false` | Alapértelmezés szerint ne tiltsa automatikusan |
| `enforcement.write_admin_ini` | `false` | Ne írjon Admin.ini alapértelmezés szerint |

Őrizze meg ezeket biztonságban, amíg a szerver tulajdonosa át nem tekinti a kimenetet.

<a id="saved"></a>
## `saved`

Szabályozza, hogy az őr hogyan találja meg a szervert `Saved/` mappát, és mely fájlcsaládokat tudja ellenőrizni.

Használja amikor:

```text
Saved root auto-detection fails.
World folder changed.
Provider or container path is unusual.
```

Ellenőrizze:

```text
runtime/saved_path_probe.json
RandomDayGuard/SavedRoot.txt
```

Szabály:

```text
SavedRoot.txt -> AbioticFactor/Saved
not -> Worlds/<WorldName>
```

<a id="log_tail"></a>
## `log_tail`

Az élő naplóolvasást vezérli.

Hasznos lehetőségek:

| Opció | Biztonságos érték | Miért |
|---|---|---|
| `enabled` | `true` | Az élő védelemhez szükséges |
| `start_at_end_on_first_run` | `true` | Kerüli a régi naplókat élő eseményként |
| `tail_backup_logs` | `false` | A biztonsági mentési naplók előzmények, nem élnek |
| `max_lines_per_poll` | korlátozott | A lekérdezési hurkot érzékenyen tartja |

Ellenőrizze:

```text
runtime/log_offsets.tsv
runtime/evidence/session_events.jsonl
runtime/current/poll_status.json
```

<a id="runtime"></a>
## `runtime`

Szabályozza a szavazást és a költségvetést.

Fő állapotszabály:

```text
poll_id increases
poll_in_flight returns false
poll_scheduled is true
```

Ellenőrizze:

```text
runtime/current/poll_status.json
```

Ha `poll_id` leáll, valami blokkolja a hurkot.

<a id="source_accounting"></a>
## `source_accounting`

Szabályozza az explicit bizonyítékforrás lefedettségét és hatókörét.

| Kulcs | Alapértelmezett | Jelentés |
|---|---:|---|
| `enabled` | `true` | A nyilvános útvonaljelentésekhez forráskönyvelést ír. |
| `require_terminal_status` | `true` | Minden forrásnak explicit terminált vagy hiányos állapotot kell felfednie. |
| `distinguish_current_from_historical` | `true` | Elkülöníti a jelenlegi és a történelmi bizonyítékokat. |
| `slow_world_scan_blocks_current_reports` | `false` | Lehetővé teszi, hogy az aktuális jelentések közöljék, hogy a korlátos világ vizsgálata elhalasztott vagy részleges. |
| `changed_file_manifest` | alapvonali jegyzékútvonal | A korláthoz használt hivatkozás historical/world könyvelés. |

A forrásállapotok `available`, `expected_empty`, `partial`, `deferred`, `unavailable`, `malformed`, `permission_denied` vagy `error`.

Beállítás `source_accounting.enabled = false` nem távolítja el csendben az állapotkimenetet. A csővezeték még mindig `runtime/final_logs/source_accounting_latest.json` és `enabled=false`, `status="unavailable"` és `disabled_reason="source_accounting_disabled"`. Megírja a történeti állapotú rekordot is, nem elérhető könyveléssel. Mivel a forrás elszámolása a jelentési szerződés része, minden útvonalat sikertelen lezárni a `missing`; ha a könyvelés le van tiltva, a rendszer egyetlen útvonalat sem kezel befejezettnek.

<a id="reports"></a>
## `reports`

Az általános helyi jelentési folyamatot vezérli.

Az alapértelmezések engedélyezik mind az öt útvonalat, és írjon a `runtime/final_logs`:

```text
server_status
daily_rollup
player_activity
case_review
critical_guard
```

Minden útvonalnak strukturált és lefordított kimenetet, valamint bizonyítékot kell írnia `route_proof.json`. Egy útvonal letiltása `missing` bizonyítja, ahelyett, hogy úgy tesz, mintha befejeződött volna.

<a id="notification"></a>
## `notification`

Opcionális általános helyi fájl kimenő postafiók. Alapértelmezés szerint le van tiltva, és nem küld semmit külső szolgáltatónak.

Alapértelmezések:

```lua
notification = {
    enabled = false,
    mode = "local_file_outbox",
    include_expected_empty = false,
},
```

Alapértelmezés szerint minden értesítési útvonal le van tiltva. Szándékosan engedélyezve a kimenő posta csak a `route_proof.json` van írva. A helyi bizonyítékok és jelentések továbbra is mérvadóak. A szolgáltató-specifikus kézbesítés, a kézbesítési végpontok, a hitelesítési adatok és a hidak nem részei a független őrzőkutyás nyilvános szerződésnek.

<a id="scanning"></a>
## `scanning`

Vezérli az alapszintű vizsgálatot, az ellenőrzőpontokat és a módosított fájlok frissítését.

Használja amikor:

```text
building first world baseline
resuming after crash
refreshing changed files later
```

Ellenőrizze:

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/scan_complete.json
runtime/baselines/file_manifest.tsv
```

Fontos beállítások:

```lua
scanning = {
    resume_incomplete_scan = true,
    reuse_completed_baseline = true,
    incremental_refresh_after_baseline = true,
    changed_file_detection = true,
},
```

<a id="forensic_rollup"></a>
## `forensic_rollup`

Vezérli a gyors napi feltöltési csomagot és a végső egyszerű nyelvű naplókat.

Kimenetek:

```text
runtime/current/forensic_today.json
runtime/current/forensic_today.md
runtime/current/forensic_today.txt
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

Használja amikor:

```text
You want one daily folder that summarizes what happened.
You want a plain-language TXT to upload for quick analysis.
```

Ellenőrizze:

```text
runtime/forensic_days/YYYY-MM-DD/forensic_day_summary.json
runtime/forensic_days/YYYY-MM-DD/players.tsv
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

Szabály:

```text
Daily summaries are rebuildable indexes.
Source evidence remains authoritative.
```

<a id="logging"></a>
## `logging`

Szabályozza az események mennyiségét és az alacsony jelentőségű összesítést.

Használja amikor:

```text
actor-touch events are noisy
raw event files grow too quickly
```

Biztonságos minta:

```lua
logging = {
    low_importance_mode = "aggregate",
    write_low_importance_raw_events = false,
},
```

<a id="retention"></a>
## `retention`

Szabályozza, hogy mennyi ideig és mikor kerüljön tárolásra a fájlok JSONL a naplók forognak.

Használja amikor:

```text
disk usage grows too fast
you need more audit history
you need shorter live-history windows
```

Fontos lehetőségek:

```text
detailed_retention_days
rotate_jsonl_when_bytes_exceed
max_raw_events_lines
keep_enforced_forever
keep_evidence_forever
```

<a id="warning_bursts"></a>
## `warning_bursts`

A figyelmeztető ablak észlelését vezérli.

Példák:

```text
ActorChannelFailure
DeployableSaveWarning
UpdateActorToWorldSave
ServerMove warnings
```

Szabály:

```text
Warnings are context until correlated with mapped sessions and thresholds.
```

<a id="crash_correlation"></a>
## `crash_correlation`

A vezérlők ismétlődnek crash/reconnect áttekintést.

Biztonságos alapértelmezések:

```lua
crash_correlation = {
    single_crash_never_bans = true,
    require_same_account = true,
},
```

Hasznos számlálók:

```text
server_crash_overlap_count
post_crash_reconnect_count
unclean_disconnect_count
```

<a id="join_leave"></a>
## `join_leave`

Vezérli a lemorzsolódást és a csatlakozási hullám követését.

Biztonságos alapértelmezés:

```lua
join_leave = {
    churn_alone_never_bans = true,
},
```

Használat:

```text
rapid reconnect loops
join waves
short-session patterns
```

<a id="raid_detection"></a>
## `raid_detection`

A kapcsolódó ablakokban aktív fiókok csoportjai.

Szabály:

```text
A raid case groups accounts for review.
It does not make every account guilty.
```

Minden kényszerített fiókhoz továbbra is fiókspecifikus bizonyítékra van szükség.

<a id="object_registry"></a>
## `object_registry`

Vezérlők object/class jelkivonat olvasható mentett bizonyítékokból.

Kimenetek:

```text
runtime/object_registry_partial.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
```

Szabály:

```text
Object/class context is not a ban reason by itself.
```

<a id="world_state"></a>
## `world_state`

Vezérlők boot/current/session világállami pillanatfelvételek.

Kimenetek:

```text
runtime/world_state/current/world_state_latest.json
runtime/world_state/sessions/<date>/<session_id>_<account_id>/
```

Használja munkamenetek áttekintésére és világkörnyezetre.

<a id="enforcement"></a>
## `enforcement`

Szabályozza a javaslatokat és a tényleges Admin.ini írja.

Mielőtt a Guard eltiltást adhatna hozzá, minden alábbi állításnak igaznak kell lennie:

```text
review_only_mode == false
auto_ban == true
write_admin_ini == true
ban_id is clean numeric
account identity is mapped
not trusted
not moderator
threshold is met
```

Ha az egyik állítás hamis vagy nem ellenőrizhető, az őr távozik `Admin.ini` változatlan, és rögzíti az okot.

<a id="admin_ini"></a>
## `admin_ini`

A biztonságos fájlírást vezérli.

Szabályok:

```text
Back up before writing.
Preserve existing bans.
Preserve moderators.
Write clean BannedPlayer=<ID> only.
```

<a id="restart_request"></a>
## `restart_request`

Vezérli az opcionális helyi jelölőfájlokat, amelyeket egy másik üzemeltető tulajdonában lévő folyamat ellenőrizhet. Nem indítja újra és nem öli meg a szervert.

Alapértelmezések:

```lua
restart_request = {
    enabled = false,
    restart_marker_file = "runtime/request_restart.flag",
    restart_reason_file = "runtime/restart_reason.json",
},
```

Kimenetek:

```text
runtime/request_restart.flag
runtime/restart_reason.json
```

Nincs tárhelypanel, szolgáltatói híd vagy újraindítási automatizálás. A jelölő létrehozásának engedélyezése nem bizonyítja, hogy egy külső folyamat felhasználta a kérést vagy újraindította a kiszolgálót.

<a id="related-docs"></a>
## Kapcsolódó dokumentumok

* [`CONFIG_PROFILES.md`](KONFIGUR%C3%81CI%C3%93S_PROFILOK.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](KIMENETI_S%C3%89MA_HIVATKOZ%C3%81S.md)
* [`ADMIN_INI_ENFORCEMENT.md`](ADMIN_INI_V%C3%89GREHAJT%C3%81S.md)
