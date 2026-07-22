<a id="troubleshooting"></a>
# Fehlerbehebung

> **Kanonisch-englische Quelle:** [TROUBLESHOOTING.md](../../TROUBLESHOOTING.md). Diese lokalisierte Dokumentation bewahrt genaue Befehle, Pfade, Schlüssel, Statuswerte, Hashes und Dateinamen. Wenn der technische Wortlaut abweicht, verwenden Sie die englische Quelle.


Verwenden Sie diese Seite, wenn Guard nicht geladen wird, eine Quelle nicht erfasst werden kann, ein Bericht nicht angezeigt wird oder der Routennachweis Ihren Erwartungen widerspricht. Beginnen Sie mit dem Entscheidungsbaum und folgen Sie einem Zweig. Verwenden Sie das dedizierte [Status- und Fehlerreferenz](STATUS-_UND_FEHLERREFERENZ.md) erst, nachdem die ausgefallene Ebene bekannt ist.

Behalten Sie die aktuellen Laufzeitdateien bei, bevor Sie die Konfiguration ändern oder neu installieren. Ein veraltetes oder fehlendes Artefakt weist auf eine fehlgeschlagene Phase hin; Durch wiederholte Neustarts können diese Beweise gelöscht werden.

<a id="choose-the-failure-path"></a>
## Wählen Sie den Fehlerpfad

<a id="1-decide-whether-guard-loaded"></a>
### 1. Entscheiden Sie, ob Guard geladen wurde

- **Keine `runtime/` Dateien vorhanden:** folgen [Stellen Sie fehlende Laufzeitdateien wieder her](#restore-missing-runtime-files). Überprüfen Sie den Installationspfad, den kanonischen Loader, `enabled.txt` übereinstimmen, und `mods.txt`, bevor Sie Berichte untersuchen.
- **Aktuelle Statusdateien sind vorhanden:** Guard ist weit genug geladen, um den Status zu schreiben. Fahren Sie mit Schritt 2 fort; Neuinstallation ist nicht die erste Reaktion.

<a id="2-decide-whether-the-scheduler-is-advancing"></a>
### 2. Entscheiden Sie, ob der Planer voranschreitet.

Öffnen:

```text
runtime/current/startup_status.json
runtime/current/poll_status.json
```

- **Zähler und Zeitstempel werden fortgesetzt:** Fahren Sie mit Schritt 3 fort.
- **`poll_id` ist statisch, `poll_in_flight` bleibt wahr, oder der Scheduler-Status wird nicht ausgeführt:** folgen [Stellen Sie eine hängengebliebene Abfrageschleife wieder her](#recover-a-stuck-poll-loop).
- **Der Basisscan steht aus, während der Scheduler-Fortschritt fortgesetzt wird:** Dies ist keine Warnung automatisch ein fehlgeschlagener Start. Untersuchen Sie nur, wenn der Rückstand oder der Scanfortschritt stoppt.

<a id="3-classify-route-proof"></a>
### 3. Routennachweis klassifizieren

Öffnen `runtime/final_logs/route_proof.json` und jede Route separat überprüfen.

- **`full`:** vergleichen Sie unerwartete Formulierungen mit dem aktuellen `source_references` Abstammung. Ändern Sie die Lieferung nicht, da der Wortlaut allein falsch aussieht.
- **`limited_expected_empty`:** bestätigen Sie, dass die Quellbuchhaltung ein legitimes leeres Ergebnis unterstützt. Erstellen Sie keinen synthetischen Player oder Fall.
- **`missing`:** folgen [Diagnostizieren Sie eine fehlende Route](#diagnose-a-missing-route).

<a id="4-classify-source-coverage"></a>
### 4. Quellenabdeckung klassifizieren

- **`partial`, `deferred`, `unavailable`, `malformed`, `permission_denied` oder `error`:** folgen [Interpretieren Sie unvollständige Quellenabdeckung](#interpret-incomplete-source-coverage), und suchen Sie dann den genauen Code unter [Status- und Fehlerreferenz](STATUS-_UND_FEHLERREFERENZ.md).
- **Strukturierte Quelle ist aktuell, aber übersetzt oder ausstehende Ausgabe ist älter:** Diagnose der Abschlussübergabe, nicht des Bereitstellungsendpunkts. Behalten Sie beide Zeitstempel bei und überprüfen Sie den Berichts- und Versandstatus, bevor Sie die Lieferkonfiguration ändern.

<a id="5-follow-the-matching-branch"></a>
### 5. Folgen Sie dem entsprechenden Zweig

- Unvollständige Identität: [Ordnen Sie einen nicht zugeordneten Spieler zu](#map-an-unmapped-player).
- Fehlende tägliche Kontinuität: [Ein fehlendes tägliches Rollup wiederherstellen](#restore-a-missing-daily-rollup).
- Ausdrücklich genehmigter Durchsetzungstest hat nicht geschrieben: [Diagnostizieren Sie einen blockierten Admin.ini Schreibvorgang](#diagnose-a-blocked-adminini-write).
- ZIP Extraktion fehlgeschlagen: [Auflösen eine Windows-Extraktionsfallkollision](#resolve-a-windows-extraction-folder-collision).
- Fixture-, Paket- oder Repository-Prüfung fehlgeschlagen: [Validierung und Release-Überprüfung](VALIDIERUNG_UND_FREIGABE.md#avoid-validation-environment-pitfalls).

<a id="6-stop-with-one-proved-outcome"></a>
### 6. Stoppen Sie mit einem nachgewiesenen Ergebnis

Ein Fehlerbehebungsdurchgang endet, wenn

- die Route aktuell ist und `full`;
- die Route aktuell ist und `limited_expected_empty`aus einem benannten Grund besteht;
- ein genauer Blocker, ein Beweispfad und eine nächste Aktion aufgezeichnet werden; oder
- Rollback stellte den vorherigen bekannten Zustand wieder her und bewahrte fehlgeschlagene Beweise.

„Der Server läuft“, ein zunehmender Herzschlag oder HTTP Erfolg allein beweist nicht, dass eine Berichtsroute abgeschlossen ist.

<a id="diagnose-a-missing-route"></a>
## Diagnostizieren Sie eine fehlende Route

Öffnen `runtime/final_logs/route_proof.json` und vergleichen Sie `server_status`, `daily_rollup`, `player_activity`, `case_review` übereinstimmen, und `critical_guard`.

1. Lesen Sie den Grund, die Abstammung der Route, Generierungszeit und Quellreferenzen.
2. Bestätigen Sie, dass die benannte strukturierte Quelle existiert und zum selben Zyklus gehört.
3. Vergleichen Sie ihre mtime mit der übersetzten Ausgabe und dem ausstehenden Umschlag.
4. Wenn die endgültigen Protokolle neuer als die übersetzte oder ausstehende Ausgabe sind, zeichnen Sie den veralteten Abschlussversand auf und reparieren Sie diese Übergabe zuerst.
5. Wenn alle lokal Die Ausgabe ist aktuell, aber die Zustellung fehlt. Überprüfen Sie dann die Routenkonfiguration und den Absenderstatus.

Befördern Sie den Zustand des Planers oder eine erfolgreiche Benachrichtigung nicht zum Fünf-Routen-Proof.

<a id="interpret-incomplete-source-coverage"></a>
## Interpretieren Sie unvollständige Quellenabdeckung

| Status | Was zu tun ist |
|---|---|
| `partial` | Verwenden Sie nur gesammelte Beweise und vermeiden Sie Ansprüche auf vollständige Abdeckung. |
| `deferred` | Bestätigen Sie spätere begrenzte Arbeitsfortschritte, bevor Sie die Konfiguration ändern. |
| `unavailable` | Notieren Sie die Umgebungsgrenze; Korrigieren Sie nur ein nachgewiesenes Pfad- oder Berechtigungsproblem. |
| `malformed` | Behalten Sie die Quelle und den Analysefehler bei; Erraten Sie keine fehlenden Werte. |
| `permission_denied` | Gewähren Sie nur die erforderliche eingeschränkte Leseberechtigung. |
| `error` | Behalten Sie Details bei und diagnostizieren Sie die benannte Phase, bevor Sie sich auf die Route verlassen. |

<a id="restore-missing-runtime-files"></a>
## Stellen Sie fehlende Laufzeitdateien wieder her

Bestätigen:

```text
mods.txt contains RandomDayGuard : 1
RandomDayGuard/enabled.txt exists
RandomDayGuard/Scripts/main.lua exists
```

Das korrekte Installationsstammverzeichnis ist:

```text
AbioticFactor/Binaries/Win64/ue4ss/Mods/RandomDayGuard/
```

Dieses verschachtelte Layout ablehnen:

```text
Mods/RandomDayGuard/RandomDayGuard/Scripts/main.lua
```

Wenn die Dateien korrekt sind, aber UE4SS Guard nicht gestartet hat, behalten Sie bei `UE4SS.log` und vergleichen Sie seinen Startzeitstempel mit dem tatsächlichen Start des Spielprozesses.

<a id="resolve-a-windows-extraction-folder-collision"></a>
## Beheben Sie eine Kollision mit dem Windows-Extraktionsordner

Eine ältere Version verwendete Programmverzeichnisse, deren Namen sich nur durch die Groß- und Kleinschreibung unterschieden. Einige Windows-Extraktoren führen diese Namen zusammen, wenn ein ZIP über einem vorhandenen Ordner platziert wird.

1. Löschen Sie nur die fehlgeschlagene temporäre Extraktion, nicht den installierten Mod oder seine Beweise.
2. Erstellen Sie ein neues leeres temporäres Verzeichnis.
3. Extrahieren Sie die aktuelle Version dort.
4. Bestätigen Sie, dass ein RandomDayGuard Ordner und ein Programmverzeichnis erstellt werden.
5. Wenn Windows immer noch eine Kollision meldet, laden Sie die Version erneut herunter und melden Sie die Release-Version und den verwendeten Extraktor.

Entpacken Sie niemals eine neue Version über den installierten Ordner. Befolgen Sie das Verfahren zur Aktualisierung des bereinigten Ordners in [`../INSTALL.md`](INSTALLATION.md).

<a id="load-the-expected-version"></a>
## Laden Sie die erwartete Version

Überprüfen Sie den Quellmarker und den Build-Marker:

```sh
grep -n "local VERSION" RandomDayGuard/Scripts/main.lua
cat RandomDayGuard/BUILD_MARKER.txt
```

Wenn sie nicht einverstanden sind:

1. Stoppen Sie den Server.
2. Sichern Sie den installierten Ordner, die überprüfte Konfiguration und die Laufzeitnachweise.
3. Stellen Sie das beabsichtigte Paket bereit und prüfen Sie es.
4. Nur paketverwaltete Programm- und Datendateien ersetzen.
5. Bestätigen Sie, dass der kanonische Loader vorhanden ist und kein Duplikat in Kleinbuchstaben hinzugefügt wurde.
6. Starten Sie einmal und lesen Sie die aktuellen Markierungen zurück, bevor Sie die Laufzeitausgabe beurteilen.

<a id="correct-a-missing-saved-root"></a>
## Korrigieren Sie ein fehlendes gespeichertes Stammverzeichnis

Öffnen `runtime/saved_path_probe.json`. Geben Sie den verifizierten absoluten Pfad zum vollständigen abiotischen Faktor an `Saved/` in `SavedRoot.txt`; verweisen Sie nicht nur auf ein Weltverzeichnis. Ein Pfad außerhalb der begrenzten Wurzel muss abgelehnt bleiben.

<a id="recover-a-stalled-historical-scan"></a>
## Einen blockierten historischen Scan wiederherstellen

Aktuelle Überwachung und historische Erkennung sind getrennt. Ein großes Archiv benötigt möglicherweise viele begrenzte Zyklen, sodass eine unveränderte Beobachtung nicht ausreicht, um es als blockiert zu bezeichnen.

1. Öffnen `runtime/current/report_worker_status.json`.
2. Aufzeichnen `scan_cursor`, entdeckter Dateien, abgeschlossener Dateien und `last_progress_ts`.
3. Warten Sie auf mindestens zwei normale Report-Worker-Möglichkeiten und vergleichen Sie dieselben Felder erneut.
4. Wenn der Cursor, die Anzahl der abgeschlossenen Dateien oder die Fortschrittszeit vorrücken, Der Scan funktioniert immer noch. Lassen Sie es begrenzt.
5. Wenn alle Fortschrittsfelder unverändert bleiben, während Umfrage-IDs und aktuelle Berichte weiter voranschreiten, behalten Sie die Statusdatei bei und überprüfen Sie die von der Worker-Phase benannte Quellklasse. Reparieren Sie den Quellpfad oder den Lesefehler, bevor Sie es erneut versuchen.

Ein blockierter historischer Scan schränkt Schlussfolgerungen ein, die ältere Datensätze benötigen. Ein aktueller Bericht, dessen aktives Protokoll und der aktuelle Zyklusnachweis aktuell sind, wird dadurch nicht ungültig.

<a id="recover-a-stuck-poll-loop"></a>
## Stellen Sie eine hängengebliebene Abfrageschleife wieder her

Öffnen:

```text
runtime/current/poll_status.json
runtime/poll_error.txt
```

Aufzeichnen `poll_id`, `poll_completed_count`, `poll_in_flight`, `poll_stage`, `scheduler_status` und zweimal in einem begrenzten Intervall Zeitstempel.

- Wenn die Zähler vorrücken, bleibt die Schleife nicht hängen; Diagnostizieren Sie die spätere Worker-Phase.
- Wenn `poll_in_flight=true` bleibt unverändert, bewahren Sie die letzte Fortschrittsphase und den letzten Fehler vor dem Neustart auf.
- Wenn der Scheduler angehalten hat, überprüfen Sie den vorherigen Fehler und die Startübergabe.

Fügen Sie keinen zweiten Schleifenbesitzer hinzu, um einen blockierten Lebenszyklus zu kompensieren.

<a id="start-the-scan-after-log-backlog"></a>
## Starten Sie den Scan nach dem Protokoll Rückstand

Vergleichen Sie in `runtime/current/poll_status.json`:

```text
active_log_caught_up
active_log_unread_bytes
log_backlog_pending
```

Der historische Scan sollte warten, während das aktive Protokoll ungelesene Bytes enthält. Bestätigen Sie, dass spätere Umfragen den Rückstand verringern. Eine feste ungelesene Anzahl bei fortschreitenden Umfragen ist ein Source-Tail-Problem; Eine feste Abfrage ist ein Problem mit dem Zeitplaner.

<a id="preserve-scan-progress-after-a-crash"></a>
## Scan-Fortschritt nach einem Absturz beibehalten

Behalten und vergleichen:

```text
runtime/scan_checkpoint.json
runtime/scan_progress.json
runtime/baselines/file_manifest.tsv
```

Überprüfen Sie, ob der Prüfpunkt oder das Manifest fehlt, das gespeicherte Stammverzeichnis oder die gespeicherte Welt geändert wurde oder der Prüfpunkt als veraltet markiert wurde. Löschen Sie keine gültige Baseline, damit der Fortschritt neuer erscheint.

<a id="map-an-unmapped-player"></a>
## Ordnen Sie einen nicht zugeordneten Spieler zu

Vergleichen Sie Sitzungsnachweise mit dem maßgeblichen Protokoll:

```text
runtime/evidence/session_events.jsonl
Saved/Logs/AbioticFactor.log
```

Suchen Sie nach einem vollständigen `Login request` Beziehung zwischen Anzeigenamen, `ConnectID` übereinstimmen, und `UniqueId`. Wenn keine akzeptierte Verbindungsidentität vorhanden ist, behalten Sie die Zeile nur zur Überprüfung bei. Ein Anzeigename oder PlayerData Dateiname allein ist keine durchsetzbare Identität.

<a id="diagnose-a-blocked-adminini-write"></a>
## Diagnostizieren Sie einen blockierten Admin.ini Schreibvorgang

Führen Sie einen Durchsetzungstest nur mit ausdrücklicher Genehmigung und einer verfügbaren Testdatei durch, niemals mit einer Live-Serverdatei. Bestätigen Sie zunächst, dass die Testkonfiguration Guard auffordert, Folgendes zu schreiben:

```lua
review_only_mode = false
auto_ban = true
write_admin_ini = true
```

Lesen Sie dann die aufgezeichnete Fehlerursache. Guard muss ein Konto identifizieren, Moderatoren und vertrauenswürdige Konten schützen, genügend kontospezifische Beweise finden, ein neues Backup erstellen und überprüfen, bestätigen, dass kein anderes Programm die Datei geändert hat, das beabsichtigte Update speichern und die vollständig gespeicherte Datei mit dem beabsichtigten Ergebnis vergleichen. Wenn ein Schritt fehlschlägt oder nicht überprüft werden kann, lassen Sie die Sperrliste unverändert. Siehe [Admin.ini Durchsetzung](ADMIN_INI_ENFORCEMENT.md).

<a id="restore-a-missing-daily-rollup"></a>
## Ein fehlendes tägliches Rollup wiederherstellen

Bestätigen Sie, dass `forensic_rollup.enabled = true` und dann überprüfen:

```text
runtime/current/forensic_today.json
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

Wenn diese fehlen, überprüfen Sie den Startup-, Poll-, Report-Worker- und Source-Accounting-Status in dieser Reihenfolge. Beim täglichen Rollup handelt es sich um einen Kontinuitätsdatensatz pro Tag und nicht um eine sich wiederholende Serverstatusbenachrichtigung.

<a id="look-up-an-exact-status-or-error"></a>
## Suchen Sie nach einem genauen Status oder Fehler

Verwenden Sie [Status- und Fehlerreferenz](STATUS-_UND_FEHLERREFERENZ.md) für die vollständige Route, Quelle, PlayerData, Durchsetzungs-, Start-, Zeitplaner-, Berichts- und Benachrichtigungscodetabellen. Durch die Trennung der Nachschlagetabellen wird verhindert, dass diese Reparaturseite zu einem zweiten Schemahandbuch wird.

<a id="related-docs"></a>
## Verwandte Dokumente

- [Hier beginnen](HIER_BEGINNEN.md)
- [Operations Playbook](OPERATIONS_PLAYBOOK.md)
- [Status- und Fehlerreferenz](STATUS-_UND_FEHLERREFERENZ.md)
- [Validierung und Release-Überprüfung](VALIDIERUNG_UND_FREIGABE.md)
