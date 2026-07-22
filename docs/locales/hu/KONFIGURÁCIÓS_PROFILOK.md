<a id="configuration-profiles"></a>
# Konfigurációs profilok

> **Kanonikus angol forrás:** [CONFIG_PROFILES.md](../../CONFIG_PROFILES.md). Ez a lokalizált dokumentáció megőrzi a pontos parancsokat, elérési utakat, kulcsokat, állapotértékeket, kivonatokat és fájlneveket. Ha a technikai megfogalmazás eltér, használja az angol forrást.


Használja ezt az útmutatót egy praktikus konfigurációs profil kiválasztásához és alkalmazásához. A beállításcsoportok interakciójának magyarázatához olvassa el a [`CONFIG_REFERENCE.md`](KONFIGUR%C3%81CI%C3%93S_HIVATKOZ%C3%81S.md). A pontos mezők, alapértelmezett értékek, típusok és változatlanok esetén használja a generált [`CONFIG_FIELD_CATALOG.md`](KONFIGUR%C3%81CI%C3%93S_MEZ%C5%90KATAL%C3%93GUS.md).

Minden alábbi Lua blokk legfelső szintű bejegyzések készlete, amelyek helyettesíthetik a megfelelő bejegyzéseket a leszállított `return { ... }` táblázat.

<a id="profile-chooser"></a>
## Profilválasztó

| Helyzet | Használja ezt a profilt |
|---|---|
| Első telepítés | Biztonságos első telepítés |
| A szerver instabil, és gyakran összeomlik | Jelenlegi bizonyítékok lassú vizsgálat nélkül |
| Azt szeretné object/world kontextus | Teljes alapvonal |
| Szeretné áttekinteni a régi naplókat | Törvényszéki háttérkitöltés |
| Javaslatokat szeretne, de nem írt | Végrehajtási tesztelés |
| Készen állsz, hogy az őr tiltást írjon | Kérvényesítés engedélyezve |
| A lemez korlátozott | Alacsony lemeznövekedés |
| Tiszta alapvonalat hajtott végre | Rögzített biztonsági mentés beállítása |

<a id="safe-first-install"></a>
## Biztonságos első telepítés

Használja ezt először élő szerveren.

```lua
enforcement = {
    review_only_mode = true,
    auto_ban = false,
    write_admin_ini = false,
},

log_tail = {
    enabled = true,
    start_at_end_on_first_run = true,
    tail_backup_logs = false,
},

scanning = {
    full_scan_on_start = true,
    resume_incomplete_scan = true,
    reuse_completed_baseline = true,
    incremental_refresh_after_baseline = true,
},

reports = {
    enabled = true,
},

notification = {
    enabled = false,
},
```

Mit tesz ez:

```text
Tracks live sessions.
Starts the baseline scan.
Does not edit Admin.ini.
Avoids treating old backup logs as fresh live events.
```

<a id="current-evidence-without-slow-scan"></a>
## Jelenlegi bizonyítékok lassú vizsgálat nélkül

Használja ezt, ha a szerver instabil, és szüksége van rá crash/reconnect bizonyítékot a súlyos vizsgálat előtt.

```lua
log_tail = {
    enabled = true,
},

scanning = {
    full_scan_on_start = false,
},

enforcement = {
    review_only_mode = true,
    auto_ban = false,
    write_admin_ini = false,
},

reports = {
    enabled = true,
},

notification = {
    enabled = false,
},
```

Mit tesz ez:

```text
Tracks logins, joins, leaves, reconnects, crashes, and unclean sessions.
Delays heavy world scanning.
```

<a id="full-baseline"></a>
## Teljes alapvonal

Használja ezt azután, hogy a szerver elég sokáig fent tud maradni a vizsgálathoz.

```lua
scanning = {
    full_scan_on_start = true,
    resume_incomplete_scan = true,
    reuse_completed_baseline = true,
    incremental_refresh_after_baseline = true,
},
```

Mit tesz ez:

```text
Builds object registry.
Writes world-state context.
Creates file manifest.
Enables changed-file refresh later.
```

<a id="forensic-backfill"></a>
## Törvényszéki háttérkitöltés

Csak akkor használja, ha szándékosan tekinti át az előzménynaplókat.

```lua
log_tail = {
    start_at_end_on_first_run = false,
    tail_backup_logs = true,
    backfill_backup_logs_on_start = true,
},
```

Használat előtt:

```text
Back up runtime/log_offsets.tsv.
Expect old events to be reprocessed.
Return to live settings when finished.
```

<a id="enforcement-testing"></a>
## Végrehajtási tesztelés

Használja ezt a tényleges előtt Admin.ini írás.

```lua
enforcement = {
    review_only_mode = true,
    auto_ban = false,
    write_admin_ini = false,
},
```

Mit kell ellenőrizni:

```text
runtime/account_evidence.json
runtime/warnings/
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="enforcement-enabled"></a>
## Kérvényesítés engedélyezve

Csak akkor használja, ha az ellenőrzés eredménye helyes.

```lua
enforcement = {
    review_only_mode = false,
    auto_ban = true,
    write_admin_ini = true,
    require_clean_ban_id = true,
    preserve_existing_bans = true,
    preserve_moderators = true,
},
```

Engedélyezés előtt:

```text
Trusted IDs are configured.
Moderator IDs are preserved.
Admin.ini backups work.
Ban recommendations are understandable.
Thresholds are accepted by the server owner.
```

<a id="low-disk-growth"></a>
## Alacsony lemeznövekedés

Használja ezt, ha a futásidejű fájlok túl gyorsan növekednek.

```lua
logging = {
    low_importance_mode = "aggregate",
    write_low_importance_raw_events = false,
},

retention = {
    detailed_retention_days = 7,
    rotate_jsonl_when_bytes_exceed = 5242880,
    max_raw_events_lines = 20000,
    compact_json_outputs = true,
},
```

<a id="sticky-backup-setup"></a>
## Rögzített biztonsági mentés beállítása

Használja az első befejezett alapvonal után.

Ellenőrizze, hogy léteznek-e ezek:

```text
runtime/scan_complete.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
runtime/world_state/current/world_state_latest.json
```

Ezután készítsen biztonsági másolatot a `config.lua`, `SavedRoot.txt` és `Admin.ini`.

<a id="related-docs"></a>
## Kapcsolódó dokumentumok

* [`CONFIG_REFERENCE.md`](KONFIGUR%C3%81CI%C3%93S_HIVATKOZ%C3%81S.md)
* [`FORENSIC_DAILY_ROLLUPS.md`](B%C5%B0N%C3%9CGYI_NAPI_%C3%96SSZES%C3%8DT%C3%89SEK.md)
* [`ADMIN_INI_ENFORCEMENT.md`](ADMIN_INI_V%C3%89GREHAJT%C3%81S.md)
