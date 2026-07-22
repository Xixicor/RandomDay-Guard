<a id="bad-actor-patterns-and-resilience"></a>
# Muster und Widerstandsfähigkeit von schädlichen Akteuren

> **Kanonisch-englische Quelle:** [BAD_ACTOR_PATTERNS_AND_RESILIENCE.md](../../BAD_ACTOR_PATTERNS_AND_RESILIENCE.md). Diese lokalisierte Dokumentation bewahrt genaue Befehle, Pfade, Schlüssel, Statuswerte, Hashes und Dateinamen. Wenn der technische Wortlaut abweicht, verwenden Sie die englische Quelle.


Verwenden Sie diese Seite, um zu verstehen, wie der Wächter dabei hilft, Absturzmissbrauch, Exploit-angrenzendes Verhalten und Wiederherstellungsplanung zu überprüfen.

<a id="what-the-guard-can-help-with"></a>
## Wobei der Wächter helfen kann

| Muster | Was zu überprüfen ist |
|---|---|
| Absturzkorrelierte Rückgaben | Dasselbe Konto war vor Abstürzen aktiv und kehrt nach dem Neustart zurück |
| Schnelle Überprüfung der erneuten Verbindung | Wiederholte join/leave oder timeout/reconnect Schleifen |
| Cluster mit mehreren Konten | Wellen beitreten, gemeinsame Warnfenster, gemeinsame Fehlerfenster |
| Warnungs-Burst-Stress | Wiederholte ActorChannelFailure oder Fenster mit Speicherwarnung |
| Kontext außerhalb der Grenzen | PlayerData/map/worldKontext, wenn lesbar |
| Save-Touch-Überlappung | Weltweit gespeicherter Kontext mit überlappenden zugeordneten Sitzungen |
| Identitätsverwirrung | Namen, die eine ConnectID-Zuordnung benötigen |

<a id="why-it-avoids-memory-access"></a>
## Warum Speicherzugriffe vermieden werden

RandomDayGuard funktioniert mit servereigenen Dateien:

```text
Saved/Logs/*.log
Admin.ini
World saves
PlayerData
Backups
runtime evidence
```

Das macht es weniger abhängig vom clientseitigen Speicherstatus und weniger anfällig bei Spielaktualisierungen.

Kompromiss:

```text
It cannot prove hidden live actions unless the server writes evidence.
```

<a id="crash-correlated-returners"></a>
## Absturzkorrelierte Rückkehrer

Muster:

```text
Account joins.
Server crashes or restarts.
Same account reconnects quickly.
Pattern repeats.
```

Nützliche Dateien:

```text
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/account_evidence.json
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="rapid-reconnect-probers"></a>
## Rapid-Reconnect-Prober

Muster:

```text
join -> leave -> join -> leave -> join
```

Nützliche Dateien:

```text
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/players.tsv
```

<a id="multi-account-clusters"></a>
## Cluster mit mehreren Konten

Muster:

```text
Several accounts join in the same window.
Warnings or crashes follow.
Some accounts rotate or reconnect after restart.
```

Nützliche Dateien:

```text
runtime/raid_cases/
runtime/forensic_days/YYYY-MM-DD/raid_cases.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

Regel:

```text
A cluster is not a mass-ban list.
Each account still needs its own evidence.
```

<a id="sticky-backup-recommendation"></a>
## Sticky-Backup-Empfehlung

Erstellen Sie eine Sticky Backup nach:

```text
first full baseline completes
object_registry.json exists
file_manifest.tsv exists
world_state_latest.json has scan_complete=true
Admin.ini is verified
trusted IDs are configured
```

Sichern:

```text
RandomDayGuard/config.lua
RandomDayGuard/SavedRoot.txt
RandomDayGuard/runtime/baselines/
RandomDayGuard/runtime/object_registry.json
RandomDayGuard/runtime/world_state/current/world_state_latest.json
Saved/SaveGames/Server/Admin.ini
```

<a id="recovery-model"></a>
## Wiederherstellungsmodell

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
## Verwandte Dokumente

* [`FORENSIC_DAILY_ROLLUPS.md`](FORENSISCHE_TAGESROLLUPS.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](WORKFLOW_ZUR_PLAYER-%C3%9CBERPR%C3%9CFUNG.md)
* [`WORLD_SAVE_FOLDER_CHANGES.md`](%C3%84NDERUNGEN_DES_WELTSPEICHERORDNERS.md)
