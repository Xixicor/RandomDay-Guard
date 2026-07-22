<a id="player-review-workflow"></a>
# Workflow zur Spielerüberprüfung

> **Kanonisch-englische Quelle:** [PLAYER_REVIEW_WORKFLOW.md](../../PLAYER_REVIEW_WORKFLOW.md). Diese lokalisierte Dokumentation bewahrt genaue Befehle, Pfade, Schlüssel, Statuswerte, Hashes und Dateinamen. Wenn der technische Wortlaut abweicht, verwenden Sie die englische Quelle.


Verwenden Sie diese Seite für einen Spieler, ein Konto oder einen Fall. Der Zweck ist eine reproduzierbare Überprüfungsentscheidung, nicht eine automatisierte Anschuldigung.

<a id="quick-path"></a>
## Schnellpfad

1. Öffnen `runtime/final_logs/player_activity_latest.json`.
2. Bestätigen Sie den Routenstatus in `runtime/final_logs/route_proof.json`.
3. Identifizieren Sie, welche Beobachtungen aktuell und welche historisch sind.
4. Überprüfen Sie die zitierten Identitäts- und Sitzungsquellenreferenzen.
5. Überprüfung `case_review_latest.json`wenn ein korrelierter Fall vorliegt.
6. Erfassen Sie Unbekannte und `does_not_prove`bevor Sie eine Aktion auswählen.
7. Lassen Sie die Durchsetzung deaktiviert, es sei denn, die separaten Durchsetzungstore werden nachgewiesen.

<a id="1-confirm-route-proof"></a>
## 1. Bestätigen Sie den Routennachweis.

Interpretieren Sie die Route des Spielers als:

| Status | Aktion |
|---|---|
| `full` | Weiter, während Sie weiterhin die Quellgrenzen überprüfen. |
| `limited_expected_empty` | Fahren Sie nur mit den tatsächlich vorhandenen Probanden fort; Erfinden Sie keinen fehlenden Spieler oder Fall. |
| `missing` | Stoppen Sie die Spielerentscheidung und beheben Sie Fehler in der Route. |

Ein gesunder Planer ersetzt nicht den Routennachweis.

<a id="2-establish-identity"></a>
## 2. Identität feststellen

Bevorzugen Sie eine saubere Kontokennung, die durch vom Server offengelegte Identitätsnachweise und, sofern verfügbar, PlayerData Dateinamen bestätigt wird. Behalten Sie die Rohquellenreferenz bei.

Nicht erzwingen aus:

- einem Anzeigenamen allein;
- einem Namen, der in einem Benachrichtigungs- oder Hosting-Panel angezeigt wird;
- zeitlicher Ähnlichkeit;
- einer nicht zugeordneten oder schwach vertrauenswürdigen Identität;
- ein historischer Bericht ohne aktuelle Bestätigung.

<a id="3-separate-current-from-historical"></a>
## 3. Aktuelle von historischen trennen

Aktuelle Beweise beschreiben das aktive Berichtsfenster oder die Server-Epoche. Historische Beweise können ein Muster erklären, aber sie können Lücken im aktuellen Fenster nicht stillschweigend füllen.

Beide Bereiche unabhängig voneinander aufzeichnen:

```text
Current observations:
Current source references:
Historical context:
Historical source references:
```

<a id="4-review-observations-and-interpretation"></a>
## 4. Überprüfen Sie Beobachtungen und Interpretationen.

Lesen Sie diese Berichtsabschnitte genau:

```text
observed
interpretation
unknown
does_not_prove
next_action
source_references
```

Öffnen Sie die zitierten strukturierten Beweise für jede wesentliche Entscheidung erneut. Eine Übersetzung ist Navigation und Erklärung, kein neuer Beweis.

<a id="5-calibrate-the-decision"></a>
## 5. Kalibrieren Sie die Entscheidung

| Entscheidung | Verwenden Sie diese, wenn |
|---|---|
| `INFO` | Normale oder kontextarme Beobachtung. |
| `WATCH` | Schwaches oder unvollständiges Signal, das überwacht werden muss. |
| `REVIEW` | Korrelierte Beweise erfordern eine Beurteilung durch den Administrator. |
| `BAN-ELIGIBLE` | Saubere Identität und konfigurierte Beweisschwellenwerte werden erfüllt; Es gelten weiterhin Schreibgatter. |
| `AUTO-BANNED` | Die Durchsetzung wurde explizit aktiviert und das Sichern, Schreiben, Zurücklesen und Überwachen war erfolgreich. |

Keine Entscheidungsbezeichnung beweist Schuld oder Absicht.

<a id="6-apply-the-evidence-boundary"></a>
## 6. Anwenden der Beweisgrenze

Abstürze, Wiederverbindungen, Warnungen, object/class Token und Fallgruppierung können die Überprüfung unterstützen. Alleine beweisen sie keinen Betrug, Diebstahl, Vervielfältigung, Besitz, direkten Schaden oder Vorfallverursachung.

Wenn Identität, Parsing, Backup, Schreiben, Readback oder Rollback schwach sind oder fehlschlagen, muss die Durchsetzung fehlschlagen.

<a id="review-note-template"></a>
## Notizvorlage überprüfen

```text
Review time:
Route proof status:
Coverage status:
Account ID:
Display name as observed:
Identity confidence and source:
Current observations:
Historical context:
Interpretation:
Unknown:
Does not prove:
Decision:
Next action:
Source references:
Operator:
```

<a id="related-docs"></a>
## Verwandte Dokumente

- [`EVIDENCE_BOUNDARY.md`](BEWEISGRENZE.md)
- [`OUTPUT_SCHEMA_REFERENCE.md`](REFERENZ_ZUM_AUSGABESCHEMA.md)
- [`ADMIN_INI_ENFORCEMENT.md`](ADMIN_INI_ENFORCEMENT.md)
- [`DETECTION_SIGNALS.md`](ERKENNUNGSSIGNALE.md)
