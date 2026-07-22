<a id="evidence-boundary"></a>
# Beweisgrenze

> **Kanonisch-englische Quelle:** [EVIDENCE_BOUNDARY.md](../../EVIDENCE_BOUNDARY.md). Diese lokalisierte Dokumentation bewahrt genaue Befehle, Pfade, Schlüssel, Statuswerte, Hashes und Dateinamen. Wenn der technische Wortlaut abweicht, verwenden Sie die englische Quelle.


Verwenden Sie diese Seite, um zu entscheiden, was RandomDayGuard kann berichten und was noch einer menschlichen Überprüfung bedarf.

<a id="core-rule"></a>
## Kernregel

RandomDayGuard zeichnet begrenzte Beobachtungen aus servereigenen Dateien auf. Es muss die Quelle, den Umfang, den Sammlungsstatus und die Grenzen für jede wesentliche Schlussfolgerung angeben.

Strukturierte Beweise sind maßgeblich. Ein übersetzter Bericht erläutert die Beweise; Es können keine Fakten hinzugefügt werden, die im strukturierten Datensatz fehlen.

<a id="evidence-source-classes"></a>
## Beweisquellenklassen

| Quellklasse | Typische Verwendung | Beweist nicht von selbst |
|---|---|---|
| `admin_ini` | Vorhandener Verwaltungsstatus und geprüft write/readback Kontext | Wer hat eine Vorfall |
| `active_log` | Aktuelle server/sessionEreignisse, die im aktiven Protokoll sichtbar sind | Absicht, Eigentum oder direkter Schaden |
| `recent_backup_logs` | Historischer Protokollkontext | Ein aktuelles Ereignis ist aufgetreten |
| `playerdata_filenames` | Bestätigung, dass eine saubere Kontokennung vorliegt existiert | Verhalten, Schuld oder Identitätseigentum über die offengelegte Kennung hinaus |
| `existing_cases` | Vorheriger Überprüfungskontext | Dass eine frühere Interpretation korrekt bleibt |
| `existing_reports` | Frühere Zusammenfassungen und Entscheidungen | Aktuelle Wahrheit ohne aktuelle Bestätigung |
| `existing_evidence` | Historisch strukturierte Beweise | Aktuelle Aktivität |
| Bounded World-Save Scan | Langsam world/class Kontext | Spieleraktion, Besitz, Diebstahl, Vervielfältigung oder Beschädigung |

Jede Quelle zeichnet availability/readability, Dateianzahl, Quellenverweise, aktuellen oder historischen Umfang und eine explizite `does_not_prove` Anweisung auf.

<a id="source-states"></a>
## Quellenzustände

| Status | Operatorbedeutung |
|---|---|
| `available` | Die Quelle war lesbar und Beweise wurden gesammelt. |
| `expected_empty` | Die Quelle war lesbar und hatte rechtmäßig keinen passenden Datensatz. |
| `partial` | Einige Beweise wurden gesammelt; Die Abdeckung ist unvollständig. |
| `deferred` | Begrenzte Arbeiten wurden absichtlich verschoben. |
| `unavailable` | Die Quelle ist in dieser Umgebung nicht vorhanden. |
| `malformed` | Die Quelle ist vorhanden, kann aber nicht sicher analysiert werden. |
| `permission_denied` | Dem Watchdog fehlt die Leseberechtigung. |
| `error` | Erfassung für eine andere Aufzeichnung fehlgeschlagen Grund. |

Erwartet leer ist eine gültige Beobachtung. Es darf niemals in einen erfundenen Spieler, Fall, Vorfall oder eine erfundene Anschuldigung umgewandelt werden.

<a id="current-versus-historical-evidence"></a>
## Aktuelle Beweise im Vergleich zu historischen Beweisen

Aktuelle Beweise gehören zum aktiven Sammlungsfenster oder zur Serverepoche. Historische Beweise stammen aus früheren Protokollen, Fällen, Berichten, Beweisaufzeichnungen, Backups oder Baselines.

Historische Beweise können Kontext liefern. Es kann nicht stillschweigend eine Lücke in der aktuellen Evidenz schließen. Berichte müssen beide Bereiche kennzeichnen und ihre Quellen separat zitieren.

<a id="corroboration-rule"></a>
## Bestätigungsregel

Dies sind nützliche Kontexte, aber kein direkter Beweis für sich:

- Anzeigenamen oder Namensähnlichkeit;
- zeitliche Übereinstimmung;
- Verbindung trennen oder erneut verbinden Abwanderung;
- ein Absturz oder eine Warnung;
- Klassen-, Pfad-, Akteur-, Karten- oder Objektanzahl-Tokens;
- Mitgliedschaft in einem automatisch gruppierten Fall;
- frühere Berichte ohne aktuelle Quellenbestätigung.

Behaupten Sie nicht Schuld, Vorsatz, Betrug, Eigentum, Diebstahl, Duplizierung, direkter Schaden, direkte Containernutzung, direkte Inventaraktion, genaue Live-Koordinaten, Live-Ping oder Verhalten auf Speicherebene ohne Beweise, die die Tatsache direkt aufdecken.

<a id="truthful-report-language"></a>
## Wahrhaftige Berichtssprache

Verwendung:

```text
Observed: the account was active in the recorded crash window.
Interpretation: repeated overlap warrants operator review.
Unknown: the cause of the crash.
Does not prove: that the account caused the crash.
Next action: compare the cited current session and lifecycle records.
```

Vermeiden:

```text
The player crashed the server.
The player stole or duplicated items.
The world token proves who used the object.
```

<a id="report-reading-order"></a>
## Lesereihenfolge melden

Alle Der öffentlich zugängliche Bericht sollte Folgendes erklären:

1. Klare Bedeutung.
2. Warum es wichtig ist.
3. Technische Beweise und Quellenangaben.
4. Nächste Aktion.
5. Grenzwerte, Unbekannte und Behauptungen nicht bewiesen.

<a id="related-docs"></a>
## Verwandte Dokumente

- [`OUTPUT_SCHEMA_REFERENCE.md`](REFERENZ_ZUM_AUSGABESCHEMA.md)
- [`PLAYER_REVIEW_WORKFLOW.md`](WORKFLOW_ZUR_PLAYER-%C3%9CBERPR%C3%9CFUNG.md)
- [`BAN_ID_MAPPING.md`](BAN_ID_MAPPING.md)
- [`DETECTION_SIGNALS.md`](ERKENNUNGSSIGNALE.md)
