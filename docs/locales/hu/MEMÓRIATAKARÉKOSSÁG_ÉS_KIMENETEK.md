<a id="memory-economy-and-output-files"></a>
# Memóriatakarékosság és kimeneti fájlok

> **Kanonikus angol forrás:** [MEMORY_ECONOMY_AND_OUTPUTS.md](../../MEMORY_ECONOMY_AND_OUTPUTS.md). Ez a lokalizált dokumentáció megőrzi a pontos parancsokat, elérési utakat, kulcsokat, állapotértékeket, kivonatokat és fájlneveket. Ha a technikai megfogalmazás eltér, használja az angol forrást.


Ez az oldal elmagyarázza, hogy mely fájlok növekednek, mely fájlok kerülnek felülírásra, és mit kell feltölteni a gyors ellenőrzés érdekében.

<a id="fast-answer"></a>
## Gyors válasz

| Kérdés | Megnyitás |
|---|---|
| Él az őr? | `runtime/current/poll_status.json` |
| Kit láttak? | `runtime/account_evidence.json` |
| Mi történt a munkamenetekkel? | `runtime/evidence/session_events.jsonl` |
| Mi történt ma? | `runtime/forensic_days/YYYY-MM-DD/` |
| Mi az egyszerű nyelvű összefoglaló? | `runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt` |
| Mi az a vizsgálat folyamata? | `runtime/scan_progress.json` |
| Mi a világ kontextusa? | `runtime/world_state/current/world_state_latest.json` |
| Milyen tiltásokat írtak? | `runtime/enforced_bans.jsonl` |

<a id="output-model"></a>
## Kimeneti modell

| Típus | Viselkedés | Példák |
|---|---|---|
| Jelenlegi pillanatképek | Felülírva | `runtime/current/*.json` |
| Eseménynaplók | Csak hozzáfűzés | `runtime/evidence/*.jsonl` |
| Táblázatok | Frissítve vagy hozzáfűzve | `*.tsv` |
| Alapvonalak | Befejezés után újra felhasználva | `runtime/baselines/*` |
| Napi összesítések | A helyén frissítve | `runtime/forensic_days/YYYY-MM-DD/*` |
| Végső naplók | Egyszerű nyelvű napi összefoglaló | `runtime/final_logs/YYYY-MM-DD/*` |

<a id="current-snapshots"></a>
## Jelenlegi pillanatképek

Ezek kicsik maradnak, és azt válaszolják, hogy „mi igaz most?”

```text
runtime/current/poll_status.json
runtime/current/session_state.json
runtime/current/active_accounts.json
runtime/current/forensic_today.json
runtime/current/forensic_today.md
runtime/current/forensic_today.txt
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/world_state/current/world_state_latest.json
```

<a id="player-summaries"></a>
## Játékos összefoglalók

Ezek az első fájlok, amelyek ellenőrizték a fiók ellenőrzését.

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
```

Összefoglalják:

```text
account_id
ban_id
name
identity_confidence
first_seen
last_seen
join_count
leave_count
status
score
```

<a id="event-logs"></a>
## Eseménynaplók

Ezek megőrzik az idővonalat.

```text
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/warning_events.jsonl
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/evidence/live_defense_events.jsonl
```

<a id="daily-forensic-rollups"></a>
## Napi kriminalisztikai összesítés

Ezek a gyors feltöltési csomagok.

```text
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

Töltse fel az egyik mappát, ha gyors időszakelemzést szeretne.

<a id="scan-and-baseline-files"></a>
## Fájlok vizsgálata és kiindulási állapota

Ezekkel megtudhatja, hogy a világkörnyezet részleges vagy teljes.

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/scan_complete.json
runtime/object_registry_partial.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
```

<a id="enforcement-files"></a>
## Végrehajtási fájlok

Csak akkor használja ezeket, ha a betartatás engedélyezve van.

```text
runtime/enforced.txt
runtime/enforced_bans.jsonl
runtime/ban_queue.json
runtime/evidence/enforced_bans.jsonl
```

`Admin.ini` csak a következőket kapja:

```ini
BannedPlayer=<ID>
```

<a id="what-updates-when-a-player-joins"></a>
## Mi frissül, ha egy játékos csatlakozik

Várható frissítések:

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/current/session_state.json
runtime/forensic_days/YYYY-MM-DD/players.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="what-updates-when-the-server-crashes-or-restarts"></a>
## Mi frissül, ha a szerver összeomlik vagy újraindul

Várható frissítések:

```text
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/crash_reconnects.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="what-updates-when-the-scan-progresses"></a>
## Mi frissül a vizsgálat előrehaladtával

Várható frissítések:

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/object_registry_partial.json
runtime/world_state/current/world_state_latest.json
runtime/forensic_days/YYYY-MM-DD/forensic_day_summary.json
```

<a id="what-to-upload-for-quick-analysis"></a>
## Mit kell feltölteni a gyors elemzéshez

Legjobb csomag:

```text
runtime/final_logs/YYYY-MM-DD/
```

Teljesebb csomag:

```text
runtime/forensic_days/YYYY-MM-DD/
```

Teljes bizonyítékcsomag:

```text
runtime/account_evidence.json
runtime/evidence/session_events.jsonl
runtime/server_lifecycle_events.jsonl
runtime/warning_events.jsonl
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

<a id="related-docs"></a>
## Kapcsolódó dokumentumok

* [`FORENSIC_DAILY_ROLLUPS.md`](B%C5%B0N%C3%9CGYI_NAPI_%C3%96SSZES%C3%8DT%C3%89SEK.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](KIMENETI_S%C3%89MA_HIVATKOZ%C3%81S.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](J%C3%81T%C3%89KOS_ELLEN%C5%90RZ%C3%89SI_MUNKAFOLYAMAT.md)
