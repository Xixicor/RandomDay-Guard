<a id="source-module-reference"></a>
# Quellenmodulreferenz

> **Kanonisch-englische Quelle:** [SOURCE_MODULE_REFERENCE.md](../../SOURCE_MODULE_REFERENCE.md). Diese lokalisierte Dokumentation bewahrt genaue Befehle, Pfade, Schlüssel, Statuswerte, Hashes und Dateinamen. Wenn der technische Wortlaut abweicht, verwenden Sie die englische Quelle.


Diese Seite bildet alle Quellen, Konfigurationen, Daten, Kompatibilitätslader und Laufzeitplatzhalter ab Klasse, die von der Freigabeliste zugelassen ist. Der Maschinenindex ist [`TRACEABILITY_INDEX.json`](../../TRACEABILITY_INDEX.json); Diese Seite ist die lesbare kanonische Erklärung. Jede generierte Maschinenzeile benennt einen eigenen path/class, Zweck, besitzenden Quellblock, öffentliche Einstellungen, Nebenwirkungen, für den Bediener sichtbare Zustände, Fehler, Wiederherstellung und ein kanonisches Dokument.

<a id="packaged-file-map"></a>
## Zuordnung gepackter Dateien

| Pfad | Verantwortung | Einstiegspunkt oder Aufrufer | Eingaben | Ausgaben und Nebenwirkungen | Fehlerverhalten | Vom Benutzer bearbeitbar |
|---|---|---|---|---|---|---|
| `LICENSE` | Projektlizenz im Stammverzeichnis des Archivs ausgeliefert. | Installer, Weiterverteiler und Betreiber. | Überprüfter Repository-Lizenztext. | Gibt die für das Paket geltenden Bedingungen an; Keine Laufzeitmutation. | Auslassung macht das Release-Paket rechtlich unvollständig und blockiert die Zulassungsliste. | Nein. |
| `NOTICE.md` | Projektmitteilungen werden im Archivstammverzeichnis versendet. | Installer und Betreiber. | Überprüfte Projektmitteilungen. | Behält die erforderliche Quellenangabe und den Projektkontext bei; Keine Laufzeitmutation. | Auslassung macht das Release-Paket unvollständig und blockiert die Zulassungsliste. | Nein. |
| `THIRD_PARTY_NOTICES.md` | Hinweise von Drittanbietern werden im Stammverzeichnis des Archivs versendet. | Installer und Weiterverteiler. | Überprüfter Quellennachweis von Drittanbietern. | Behält die Abhängigkeitszuordnung bei; keine Laufzeitmutation. | Auslassung macht das Release-Paket unvollständig und blockiert die Zulassungsliste. | Nein. |
| `RandomDayGuard/enabled.txt` | UE4SS Mod-Aktivierungsflag. | UE4SS Mod Loader. | `1` oder `0` wie unterstützt von UE4SS. | Aktiviert oder deaktiviert das Laden; schreibt keinen Laufzeitnachweis. | Ein deaktiviertes oder fehlerhaftes Flag verhindert den normalen Startnachweis. | Ja, während der Installation. |
| `RandomDayGuard/config.lua` | Vervollständigen Sie die öffentliche Einstellungstabelle. | `Scripts/main.lua` beim Start. | Felder katalogisiert in [`CONFIG_FIELD_CATALOG.md`](CONFIG_FIELD_CATALOG.md). | Steuert Erkennung, Budgets, Berichte, Überprüfungs-Gates und optionale lokale Markierungen. | Lua/load/default Drift blockiert die Validierung oder führt dazu, dass der Startvorgang fehlschlägt. | Ja; Führen Sie ein Backup durch. |
| `RandomDayGuard/SavedRoot.txt` | Optionale explizite Überschreibung des gespeicherten Stammverzeichnisses. | Auflöser des gespeicherten Stammverzeichnisses in `main.lua`. | Ein generischer Dateisystempfad zu `AbioticFactor/Saved`. | Wählt das Stammverzeichnis aus, das für Protokolle, Speicherungen, PlayerData Dateinamen und `Admin.ini`. | Fehlend verwendet wird erlaubt; unsichere, falsche oder unlesbare Pfade bleiben unbewiesen. | Ja; Platzieren Sie hier niemals Anmeldeinformationen. |
| `RandomDayGuard/BUILD_MARKER.txt` | Von Menschen lesbare Paketidentität. | Installer, Validator und Operator. | Vom Builder gerenderte Release-Version. | Keine Laufzeitmutation. | Blockiert Versionskonflikte Verpackung. | Nein. |
| `RandomDayGuard/MANIFEST.json` | Maschinenlesbare Paketidentitäts- und Layout-Metadaten. | Validator, Builder und Support-Tools. | Vom Builder gerenderte Release-Version. | Keine Laufzeitmutation. | JSON oder Versionskonflikte blockieren die Verpackung. | Nein. |
| `RandomDayGuard/README.txt` | Installierte englische Kurzreferenz. | Operator. | Paketierte Pfade und sichere Standardeinstellungen. | Keine Laufzeitmutation. | Veraltete Pfade oder Sicherheitsformulierungen versagen bei der Dokumentationsparität. | Nein. |
| `RandomDayGuard/Scripts/main.lua` | UE4SS Eintrag, Beweissammlung, Staatseigentum, begrenzte Zeitplanung, optionale Durchsetzung und Ausgabeschreiber. | UE4SS. | Konfiguration, gespeicherte Root-Quellen, aktueller Laufzeitstatus, Wörterbücher und das Berichtsmodul. | Schreibt die Laufzeitklassen in [`OUTPUT_SCHEMA_REFERENCE.md`](REFERENZ_ZUM_AUSGABESCHEMA.md); Ein genehmigter Durchsetzungspfad kann zum Sichern und Aktualisieren von `Admin.ini`. | Startup/poll/write Fehler sichern und aktualisieren, die einen expliziten Fehlerstatus erzeugen und niemals die Fertigstellung der Route beweisen. | Nein. |
| `RandomDayGuard/Scripts/public_pipeline.lua` | Quellenbuchhaltung, Abstammung im aktuellen Zyklus, Berichtsübersetzung, Routennachweis, dauerhafter öffentlicher Verlauf und optionaler lokaler Postausgang. | `main.lua` Berichtsarbeiter. | Schreibgeschützt state/context Rückrufe und beibehaltene lokale Beweise. | Schreibt Bericht JSON/TXT Paare, source/history Abrechnung, Routennachweis, dauerhaften Kontoverlauf und Benachrichtigung status/envelopes. | Fehlende Abstammung, erforderliche Quelle, gepaartes Schreiben oder routensichere Schreibkräfte `missing` und Blöcke Warteschlangen. | Nein. |
| `RandomDayGuard/data/detection_events.json` | Öffentliches Ereignisvokabular und Erklärungen. | `main.lua` Ereignis normalization/reporting. | Gültiges JSON Wörterbuch. | Beweise für Etiketten; erstellt keine Beobachtungen. | Missing/malformedDaten blockieren die Repository-Validierung. | Nein. |
| `RandomDayGuard/data/warning_types.json` | Warnungstyp-Vokabular und Überprüfungsbedeutung. | Warnung normalization/reporting. | Gültiges JSON Wörterbuch. | Beschriftet Warnungsnachweise. | Missing/malformedDaten blockieren die Repository-Validierung. | Nein. |
| `RandomDayGuard/data/object_categories.json` | Object/classKategorievokabular. | Scan- und Objektregistrierungsberichte. | Gültiges JSON Wörterbuch. | Beschriftungen extrahierten Klassenkontext. | Missing/malformedDaten blockieren die Repository-Validierung. | Nein. |
| `RandomDayGuard/runtime/**/.gitkeep` | Nur leere Installationslayout-Platzhalter. | Paketextraktion. | Leere Bytes. | Erstellt eine beschreibbare Verzeichnisstruktur; Es werden keine Beweise gebündelt. | Jedes Nicht-Platzhalter-Laufzeitmitglied blockiert die genaue Zulassungsliste. | Nein. |

<a id="ue4ss-loader-and-watchdog"></a>
## UE4SS Loader und Watchdog

`Scripts/main.lua` besitzt den Start des unabhängigen Watchdogs, die Erkennung gespeicherter Roots, das aktuelle Protokollende, Server-Epochen und -Sitzungen, begrenzte Abfragen und Scans, object/world Kontext, Überprüfungsbewertung, `Admin.ini` Sicherheitsbarrieren, veraltete Betriebsausgaben und die separate Übergabe an den Berichterstatter. Es muss dafür sorgen, dass Live-Abfragen begrenzt bleiben, während die langsame historische Arbeit selbstständig wieder aufgenommen wird. Ein Herzschlag, eine Startmarkierung oder ein zunehmender `poll_id` beweist nur diese Komponente; Für die Routenvervollständigung sind derselbe aktuelle Startvorgang, dieselbe Epoche, dieselbe Umfrage, dieselbe Quellaktualität, dasselbe Berichtspaar und derselbe Routennachweis erforderlich.

Die Quelle und das Paket haben eine Autorität: `RandomDayGuard/Scripts/main.lua`. Eine kleingeschriebene `scripts/`-Kopie ist nicht Teil des Quellbaums oder der Version. Die Beibehaltung einer kanonischen Schreibweise verhindert Groß-/Kleinschreibungsfehler, wenn das Paket unter Windows oder Linux extrahiert wird.

<a id="public-reporting-module"></a>
## Öffentliches Berichtsmodul

`Scripts/public_pipeline.lua` empfängt Rückrufe anstelle von Hostanmeldeinformationen oder Anbieteradaptern. Es inventarisiert acht Quellklassen, zeichnet End- und unvollständige Zustände auf, trennt aktuelle Spieler vom gespeicherten Verlauf, übersetzt jede Route in der Reihenfolge `Observed`, `Interpretation`, `Unknown`, `Does not prove`, `Next action` übereinstimmen, und `Source references`, schreibt dann den Routennachweis. Der optionale Benachrichtigungsmodus schreibt nur einen lokalen JSON-Umschlag; Es beansprucht niemals eine Lieferung oder bündelt eine Lieferung endpoint/bridge.

Die ausführbare Vorrichtung in `tests/lua/public_pipeline_runtime_test.lua` lädt dieses ausgelieferte Modul mit Lua, beweist vollständige und erwartete leere Routen, beweist, dass ein Zyklus mit fehlender aktueller Quelle nicht geschlossen werden kann, und beweist, dass unvollständige Routen nicht in den Postausgang gelangen.

<a id="configuration-and-data"></a>
## Konfiguration und Daten

[`CONFIG_FIELD_CATALOG.md`](CONFIG_FIELD_CATALOG.md) und [`TRACEABILITY_INDEX.json`](../../TRACEABILITY_INDEX.json) erstellt werden von `tools/generate_documentation_audit.py` aus einer nicht ausgeführten Strukturanalyse von `config.lua`, die Paketzulassungsliste und von der Quelle ermittelte Ausgabeklassen. Exakt generierte Inhalte und eine Eins-zu-eins-Abdeckung werden validiert. Die drei JSON-Wörterbücher sind Beschriftungen und Zuordnungen, keine Beweisquellen. Ein Bediener kann die Konfiguration, die Auswahl des gespeicherten Stammverzeichnisses und die Aktivierung bearbeiten. Quelle, Wörterbücher, Manifeste und gepackte Readme-Dateien sind Release-Eigentum.

<a id="package-layout"></a>
## Paketlayout

Der Builder lässt nur die drei rechtlichen Stammdateien, die oben genannten `RandomDayGuard/` Pfade oben und leere Laufzeitplatzhalter. Es ordnet Mitglieder byteweise und behebt ZIP-Metadaten, verpackt den kanonischen Loader einmal, scannt jedes Mitglied nach privatem Material, zeichnet einen SHA-256 für jedes Mitglied auf, bindet Namen und Bytes in einen Inhaltsauszug und erstellt zweimal. Tests lehnen jede Case-Fold-Kollision ab und beweisen, dass bei normaler Extraktion genau eine physische Datei pro Archiveintrag entsteht.

Das öffentliche Repository behält nur den aktuellen Release-Ordner. Der Builder überprüft, ob ZIP, Prüfsumme, Notizen, Versionsmarkierungen und Quellbaum übereinstimmen.

<a id="code-comment-contract"></a>
## Codekommentarvertrag

Laufzeitkommentare sind prägnante Betreuerverträge, kein zweites Handbuch. Jedes ausgelieferte Laufzeitmodul muss einen kanonischen Link in seinem Eröffnungskommentarblock platzieren:

```lua
-- Documentation: docs/SOURCE_MODULE_REFERENCE.md#ue4ss-loader-and-watchdog
```

Nicht offensichtlicher Status, Planung, write/readback/rollback, Quellerkennung, Übersetzung, Evidenz, Ausgabeschema, Routenkadenz und Schwärzungsblöcke verwenden gegebenenfalls fokussierte Kommentare mit diesen Bezeichnungen:

```lua
-- Public contract: <invariant or consequence>
-- Evidence boundary: <what the input cannot prove>
-- Failure behavior: <how the block fails closed or recovers>
-- Documentation: docs/<canonical-file>.md#<existing-anchor>
```

Der Hauptlader verfügt auch über einen fokussierten Eigentümerkommentar zum Laden der Konfiguration. Gespeicherte Erkennung, atomare Ersetzung, Durchsetzung und Planung. In diesen Kommentaren werden Kontrollfluss- und Fehlergrenzen angegeben. Sie ändern das Laufzeitverhalten nicht.

Der Validator erfordert einen Link auf Modulebene `Documentation:` für jedes Laufzeitmodul, löst jeden Kommentarpfad und Anker auf, erfordert fokussierte Vertrags- und Fehlerkommentare in beiden Laufzeitmodulen und vergleicht dieselben kanonischen Links mit `TRACEABILITY_INDEX.json`. Ein Kommentar dient der Rückverfolgbarkeit, nicht der Laufzeitbeweis.

<a id="contributor-change-checklist"></a>
## Checkliste für Mitwirkende-Änderungen

1. Aktualisieren Sie ein besitzendes Modul und sein fokussiertes Fixture.
2. Aktualisieren Sie den kanonischen Konfigurations-, Schema-, Ausgabe-, Beweis- oder Lebenszyklusabschnitt.
3. Ausführen `python -B tools/generate_documentation_audit.py --write`nach einer Konfiguration, einem gepackten Pfad, einer generierten Ausgabeklasse, einem Eigentümer oder einem Wiederherstellungsvertrag.
4. Ausführen `python -B tools/generate_documentation_audit.py --check`, fokussierte Unit-Tests, das echte Lua-Fixture, in dem Lua verfügbar ist, der vollständige Validator, zwei unabhängige deterministische Builds und `git diff --check`.
5. Überprüfen Sie die generierte ZIP Mitgliederliste, Prüfsumme und den Scan privater Materialien, bevor Sie die Version erstellen.
