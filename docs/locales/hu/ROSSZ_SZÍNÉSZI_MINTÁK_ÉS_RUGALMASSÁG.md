<a id="bad-actor-patterns-and-resilience"></a>
# Rossz szereplők mintái és rugalmasság

> **Kanonikus angol forrás:** [BAD_ACTOR_PATTERNS_AND_RESILIENCE.md](../../BAD_ACTOR_PATTERNS_AND_RESILIENCE.md). Ez a lokalizált dokumentáció megőrzi a pontos parancsokat, elérési utakat, kulcsokat, állapotértékeket, kivonatokat és fájlneveket. Ha a technikai megfogalmazás eltér, használja az angol forrást.


Ezen az oldalon megtudhatja, hogyan segít az őr áttekinteni az összeomlásokkal kapcsolatos visszaéléseket, a szomszédos kizsákmányolást és a helyreállítási tervezést.

<a id="what-the-guard-can-help-with"></a>
## Miben segíthet az őr

| Minta | Mit kell ellenőrizni |
|---|---|
| Az összeomlással korrelált visszatérések | Ugyanaz a fiók, amely az összeomlások előtt aktív, és az újraindítás után visszatér |
| Gyors újracsatlakozási szondázás | Ismétlődő join/leave vagy timeout/reconnect hurkok |
| Többfiókos fürtök | Csatlakozás hullámokhoz, megosztott figyelmeztető ablakok, megosztott hibaablakok |
| Figyelmeztető robbanásszerű stressz | Ismétlődő ActorChannelFailure vagy mentési figyelmeztető ablakok |
| Határokon kívüli kontextus | PlayerData/map/world kontextus, ha olvasható |
| Érintésmentési átfedés | Világkímélő kontextus átfedő leképezett munkamenetek |
| Identitászavar | Nevek, amelyekhez ConnectID hozzárendelésre van szükség |

<a id="why-it-avoids-memory-access"></a>
## Miért kerüli el a memóriahozzáférést

RandomDayGuard a szerver tulajdonában lévő fájlokból működik:

```text
Saved/Logs/*.log
Admin.ini
World saves
PlayerData
Backups
runtime evidence
```

Ez kevésbé függ az ügyféloldali memória állapotától, és kevésbé törékeny a játékfrissítések során.

Kiváltás:

```text
It cannot prove hidden live actions unless the server writes evidence.
```

<a id="crash-correlated-returners"></a>
## Az összeomlással korrelált visszatérők

Minta:

```text
Account joins.
Server crashes or restarts.
Same account reconnects quickly.
Pattern repeats.
```

Hasznos fájlok:

```text
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/account_evidence.json
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="rapid-reconnect-probers"></a>
## Gyors újracsatlakozási vizsgálók

Minta:

```text
join -> leave -> join -> leave -> join
```

Hasznos fájlok:

```text
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/players.tsv
```

<a id="multi-account-clusters"></a>
## Többfiókos fürtök

Minta:

```text
Several accounts join in the same window.
Warnings or crashes follow.
Some accounts rotate or reconnect after restart.
```

Hasznos fájlok:

```text
runtime/raid_cases/
runtime/forensic_days/YYYY-MM-DD/raid_cases.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

Szabály:

```text
A cluster is not a mass-ban list.
Each account still needs its own evidence.
```

<a id="sticky-backup-recommendation"></a>
## Rögzített biztonsági mentési javaslat

Hozzon létre egy ragadós biztonsági másolatot a következő után:

```text
first full baseline completes
object_registry.json exists
file_manifest.tsv exists
world_state_latest.json has scan_complete=true
Admin.ini is verified
trusted IDs are configured
```

Biztonsági mentés:

```text
RandomDayGuard/config.lua
RandomDayGuard/SavedRoot.txt
RandomDayGuard/runtime/baselines/
RandomDayGuard/runtime/object_registry.json
RandomDayGuard/runtime/world_state/current/world_state_latest.json
Saved/SaveGames/Server/Admin.ini
```

<a id="recovery-model"></a>
## Helyreállítási modell

```text
Clean install
-> verify live defense
-> complete first baseline
-> create sticky backup
-> run server normally
-> use daily rollups for review
-> restore sticky backup if needed
```

<a id="related-docs"></a>
## Kapcsolódó dokumentumok

* [`FORENSIC_DAILY_ROLLUPS.md`](B%C5%B0N%C3%9CGYI_NAPI_%C3%96SSZES%C3%8DT%C3%89SEK.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](J%C3%81T%C3%89KOS_ELLEN%C5%90RZ%C3%89SI_MUNKAFOLYAMAT.md)
* [`WORLD_SAVE_FOLDER_CHANGES.md`](WORLD_SAVE_MAPPA_M%C3%93DOS%C3%8DT%C3%81SOK.md)
