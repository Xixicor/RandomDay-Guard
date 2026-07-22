<a id="glossary"></a>
# Glossar

> **Kanonisch-englische Quelle:** [GLOSSARY.md](../../GLOSSARY.md). Diese lokalisierte Dokumentation bewahrt genaue Befehle, Pfade, Schlüssel, Statuswerte, Hashes und Dateinamen. Wenn der technische Wortlaut abweicht, verwenden Sie die englische Quelle.


| Begriff | Einfache Bedeutung | Genaue technische Bedeutung |
|---|---|---|
| Aktives Protokoll | Das aktuelle Serverprotokoll, das für neue Beweise verwendet wird. | Erforderliche `active_log` Quelle; Für die Routenvervollständigung sind Lesbarkeit und aktuelle Herkunft erforderlich. |
| Boot-ID | Ein Watchdog-Prozessstart. | Aktuelle Laufzeit-ID, die zum Zurückweisen eines vorherigen Starts verwendet wird. errors/reports. |
| Epochen-ID | Ein Serverkontinuitätsintervall. | Identifikator, der sich über die normale Laufzeit erstreckt, bis die Kontinuitätslogik eine weitere Epoche startet. |
| Abfrage-ID | Eine begrenzte Abfragemöglichkeit. | Positives monotones Zyklusfeld; zero/missing kann eine Route nicht abschließen. |
| Quellenaktualität | Ob aktuelle Quelle und Umfrageherkunft übereinstimmen. | `fresh_current_poll` oder `stale_or_unproven` mit Zeitstempeln und Aktivprotokollstatus. |
| Quellbuchhaltung | Inventar der Beweisverfügbarkeit und -grenzen. | `randomdayguard.source-accounting/v1` mit acht Quellklassen und current/historical Geltungsbereich. |
| `available` | Eine Quelle wurde gefunden und gelesen. | Terminal-Quellenstatus mit `available=true`, `readable=true`. |
| `expected_empty` | Eine optionale Quelle wurde überprüft und rechtmäßig absent/empty. | Terminal lesbarer Quellenstatus; Erstellt niemals ein Subjekt. |
| `partial` | Begrenzte Arbeit hat nützliche, aber unvollständige Ergebnisse. | Nichtterminal source/accounting Status; Nehmen Sie den besitzenden Arbeiter wieder auf. |
| `deferred` | Die Arbeit steht absichtlich noch aus. | Nichtterminaler Quellstatus; kein Fehler oder Abschluss. |
| `unavailable` | Die Quelle kann derzeit nicht verwendet werden. | Terminallücke; Eine Lücke in der erforderlichen Quelle macht die Abrechnung nicht verfügbar. |
| `malformed` | Eine Quelle ist vorhanden, aber strukturell ungültig. | Terminallücke, die Validierungsdetails beibehält und abhängige Schreibvorgänge schließt. |
| `permission_denied` | Das Betriebssystem hat den Zugriff ausdrücklich abgelehnt. | Terminallücke unterscheidet sich von missing/unavailable. |
| `error` | A Der begrenzte Vorgang ist unerwartet fehlgeschlagen. | Terminalfehler, der die genannte Wiederherstellung erfordert; In öffentliche Berichte gehören keine geheimen Details. |
| `complete` | Alle erfassten Quellen sind lückenlos. | Quellenabrechnungsstatus auf oberster Ebene. |
| `complete_with_gaps` | Erforderliche aktuelle Beweise funktionieren; optionale Terminallücken bleiben bestehen. | Buchhaltungsstatus der obersten Ebene; Für Routen gelten weiterhin ihre eigenen Anforderungen. |
| `full` | Eine Route, die mit ihrem erforderlichen, nicht leeren Vertrag abgeschlossen wurde. | Routensichere Aufzählung mit abgeschlossenen Ausgaben des aktuellen Zyklus. |
| `limited_expected_empty` | Eine Route, die abgeschlossen wurde und keine geeignete subject/failure. | Routensichere Aufzählung mit `completed=true`, `expected_empty=true`. |
| `missing` | Der Nachweis der Routenvervollständigung fehlt oder ist fehlgeschlagen. | Routensichere Aufzählung mit `completed=false`; nie für den Postausgang geeignet. |
| Strukturierter Bericht | Maschinenlesbare Routenausgabe. | `<route>_latest.json` unter Verwendung von `randomdayguard.report/v1`. |
| Übersetztem Bericht | Menschenlesbarem Rendering derselben Route. | `<route>_latest.txt` mit behoben Reihenfolge der beobachteten Quellenverweise. |
| Routennachweis | Cross-Route-Vervollständigungsbuch. | `route_proof.json` Bindung version/boot/epoch/poll/freshness/output Pfade. |
| Aktuelle Beweise | Beobachtung im Besitz des Aktiven Zyklus. | Bereich `current`; nicht aus alten filenames/reports. |
| historischen Beweisen | behaltenem Kontext aus früheren Zyklen oder langsamem Scan rekonstruiert. | Bereich `historical`; kann über die Überprüfung informieren, kann aber keine aktuelle Präsenz beanspruchen. |
| Nur Überprüfung | Bewertungsnachweise erstellen ohne Admin.ini Schreibvorgänge. | Standard `review_only_mode=true`, `auto_ban=false`, `write_admin_ini=false`. |
| Sicherheitsüberprüfung der Sperrliste | Eine Frage muss der Wachmann beantworten, bevor sich etwas ändern kann `Admin.ini`. | Es muss das Konto und die Bewertung bestätigen, vertrauenswürdige Konten und Duplikate ausschließen, eine Sicherung überprüfen, externe Änderungen erkennen, das beabsichtigte Update speichern und die vollständige Datei überprüfen oder sicher wiederherstellen. |
| Lokalem Postausgang | Optionale anbieterneutrale Benachrichtigungsübergabe. | JSON Dateien mit `delivery_backend="none"` und `delivery_attempted=false`. |
| Baseline | Abgeschlossen begrenzt Schnappschuss des gespeicherten Dateikontexts. | Manifest/object/worldStatus wird nur dann wiederverwendet, wenn er kompatibel und aktuell genug ist. |
| Prüfpunkt | Position für unvollständige Scan-Arbeiten fortsetzen. | `scan_checkpoint.json`; Das Löschen ist nicht die Standardwiederherstellung. |
| Neuerstellbarer Index | Zusammenfassung, die neu generiert werden kann. | Daily/weekly/forensic/final Ausgabe überprüfen; Quellenbeweise bleiben maßgebend. |
| Beweisgrenze | Begrenzung dessen, was eine Quelle unterstützen kann. | Explizite `does_not_prove`, Unbekannte, Identitätsstärke und Geltungsbereichsregeln. |

Kanonische Definitionen für Schemas finden Sie in [`OUTPUT_SCHEMA_REFERENCE.md`](REFERENZ_ZUM_AUSGABESCHEMA.md); Konfigurationsbegriffe finden Sie in [`CONFIG_FIELD_CATALOG.md`](CONFIG_FIELD_CATALOG.md).
