<a id="architecture-and-lifecycle"></a>
# Architektur und Lebenszyklus

> **Kanonisch-englische Quelle:** [ARCHITECTURE.md](../../ARCHITECTURE.md). Diese lokalisierte Dokumentation bewahrt genaue Befehle, Pfade, Schlüssel, Statuswerte, Hashes und Dateinamen. Wenn der technische Wortlaut abweicht, verwenden Sie die englische Quelle.


RandomDayGuard ist eins UE4SS Watchdog plus ein isoliertes Berichtsmodul. Es liest servereigene Dateien, behält den begrenzten lokalen Status bei und schreibt lokale Beweise und Überprüfungsausgaben. Es gibt keinen Anbieter, kein Control Panel, keinen Benachrichtigungsdienst, RandomDay oder Netzwerkabhängigkeit.

<a id="end-to-end-data-flow"></a>
## End-to-End-Datenfluss

1. UE4SS lädt den einzelnen kanonischen Einstiegspunkt `RandomDayGuard/Scripts/main.lua`. Aktuelle Pakete enthalten kein Duplikat der Kleinbuchstabenvariante.
2. Der Loader liest `config.lua`, die drei Datenwörterbücher und optional `SavedRoot.txt`. Die Versionsidentität muss mit `VERSION`, `MANIFEST.json` übereinstimmen, und `BUILD_MARKER.txt`.
3. Die Erkennung des gespeicherten Stammverzeichnisses prüft begrenzte bekannte Kandidaten und direkte bekannte Dateien. Es zeichnet auf, was in `runtime/saved_path_probe.json` lesbar war; Das Auffinden eines Verzeichnisses allein ist keine Beweissicherung.
4. Die unmittelbare Ebene verfolgt das aktive Serverprotokoll von einem sicheren Offset aus. Es normalisiert Lebenszyklus, Sitzung, Konto, Warnung, erneute Verbindung und andere beobachtete Ereignisse in reine Anhängebeweise und aktuelle Snapshots.
5. Die langsame Ebene inventarisiert gespeicherte Dateien in begrenzten Blöcken. Es schreibt Fortschritte und Prüfpunkte, nimmt unvollständige Arbeiten wieder auf, vergleicht ein geändertes Dateimanifest und erzeugt einen teilweisen und dann endgültigen object/worldKontext.
6. Die Überprüfungslogik korreliert nur die ihr zur Verfügung stehenden Beweise. Schwache Dateinamen, Timing, Klassenanzahl, relative Koordinaten, Abwanderung, ein einzelner Absturz oder Ping bleiben im Kontext und können die Durchsetzung allein nicht autorisieren.
7. Ein separater Report Worker ruft auf `Scripts/public_pipeline.lua`. Es inventarisiert Quellklassen, zeichnet den aktuellen im Vergleich zum historischen Umfang auf, bindet den Zyklus an version/boot/epoch/poll/source Aktualität, schreibt fünf routenspezifische JSON/TXT Paare und schreibt dann `route_proof.json`.
8. Bei expliziter Aktivierung kopiert der lokale Postausgang Referenzen aus einem abgeschlossenen Bericht, nachdem ein Routennachweis vorliegt. Es zeichnet `delivery_backend="none"` und `delivery_attempted=false` auf; Der Transport erfolgt außerhalb dieses Produkts.

<a id="ownership-and-asynchronous-boundaries"></a>
## Eigentum und asynchrone Grenzen

| Eigentümer | Begrenzte Arbeit | Darf nicht blockieren oder implizieren |
|---|---|---|
| Start | Konfiguration, gespeichertes Stammverzeichnis, aktives Protokoll, Epoche, Indizes, Anfangsstatus. | Eine erfolgreiche Lademarkierung beweist keine Beweise oder Routen. |
| Abfragerückruf | Neue Protokollbytes, Statusaktualisierungen, event/session/account Ausgaben, Planung. | Langsame rekursive Erkennung oder Berichtentleerung. |
| Scan-Worker | Manifesterkennung, Dateianalyse, Prüfpunkt, partial/finalBasislinie. | Aktueller Protokollfortschritt; Teilweise ist kein Fehler. |
| Berichtsarbeiter | Quellbuchhaltung, Übersetzung, Berichtspaare, Routennachweis, lokaler Postausgang. | Erzwingung oder externe Zustellung. |
| Optionale Erzwingung | Bestätigen Sie das Konto und die Bewertung, schützen Sie vertrauenswürdige Konten und Duplikate, überprüfen Sie a Sichern, externe Dateiänderungen ablehnen und dann das gespeicherte Ergebnis überprüfen. | Eine Berichtspunktzahl, einen Routenstatus oder eine Fallmitgliedschaft unter Umgehung aller erforderlichen Sicherheitsprüfungen. |

Die Umfrageschleife bleibt nur fehlerfrei, während `poll_id` fortschreitet, `poll_in_flight` „false“ zurückgibt und die Planung aktiv bleibt. Das beweist die Umfragekomponente, nicht die Berichtspipeline. Langsame Scans können `partial` oder `deferred` sein; die Standardeinstellung `slow_world_scan_blocks_current_reports=false` ermöglicht die Fortsetzung neuer aktueller Routen unter Angabe der historischen Einschränkung.

<a id="state-and-lifecycle"></a>
## Status und Lebenszyklus

| Status | Eintrag | Terminal oder nächster Status | Fehler und Wiederherstellung |
|---|---|---|---|
| Start | UE4SS ruft den Loader auf. | Ausführen poll/scan/report Worker mit einer Boot-ID und Epoche. | `startup_error` ist ein wichtiger Beweis für den aktuellen Bootvorgang; reparieren config/path/source und neu starten. |
| Aktuelle Umfrage | Geplanter begrenzter Rückruf beginnt. | Abgeschlossene Umfrage zeichnet Zeitstempel auf und plant neu. | `poll_error` ist ein wichtiger Beweis für den aktuellen Start; Stellen Sie die begrenzte Arbeit wieder her und bestätigen Sie eine neuere Umfrage. |
| Scan ausstehend | Basislinie erforderlich oder unvollständiger Prüfpunkt gefunden. | `partial`/`deferred`, dann `scan_complete`. | Prüfpunkt fortsetzen; Nur neu erstellen, wenn stale/incompatible Beweise erfasst werden. |
| Quellbuchhaltung | Report Worker inventarisiert acht Quellklassen. | `complete`, `complete_with_gaps`, `partial` oder `unavailable`. | Disabled/failed Buchhaltung erzwingt alle Routen zu `missing`. |
| Routengenerierung | Abstammungs- und Quellabrechnung im aktuellen Zyklus sind verfügbar. | `full`, `limited_expected_empty` oder `missing`. | Gepaart JSON/TXT oder ein routensicherer Schreibfehler konvergieren die Route zu `missing`. |
| Lokalem Postausgang | Eine Route wird aktiviert, abgeschlossen und berechtigt. | Ausstehendes Ergebnis des lokalen Umschlags und des Benachrichtigungsstatus. | Kein Schreiben oder unvollständiger Nachweis bedeutet, dass kein Umschlag vorhanden ist; Es wird keine Zustellung abgeleitet. |
| Durchsetzungsüberprüfung | Kontospezifische Beweise erreichen die konfigurierte Punktzahl für automatische Maßnahmen. | Nur Überprüfungsempfehlung oder ein explizit aktiviertes `Admin.ini` Update. | Eine fehlgeschlagene oder nicht verfügbare Sicherheitsüberprüfung stoppt das Update; Ein fehlgeschlagener abschließender Vergleich stellt die verifizierte Sicherung wieder her, wenn die Wiederherstellung aktiviert ist. |

<a id="current-and-historical-evidence"></a>
## Aktuelle und historische Beweise

Aktuelle Beweise gehören zum aktiven boot/poll und werden niemals allein aus beibehaltenen Dateinamen rekonstruiert. Zu den historischen Beweisen gehören rotierte Protokolle, ein dauerhafter account/session-Verlauf, ein gespeicherter cases/reports/evidence und begrenztes weltweites Scannen. Berichte legen separate aktuelle und historische Arrays und Zählungen offen. Ein stiller Neustart darf den dauerhaften Kontext nicht löschen und ein historischer Datensatz darf nicht als aktuelle Präsenz dargestellt werden.

<a id="completion-and-recovery-boundary"></a>
## Abschluss- und Wiederherstellungsgrenze

Der Abschluss für eine Route erfordert die Übereinstimmung der aktuellen Zyklusversion, der Boot-ID, der Epochen-ID, der positiven Poll-ID, des neuen aktiven Protokollstatus, beider Routenausgaben und ihres Eintrags in `route_proof.json`. Für Benachrichtigungsansprüche ist außerdem der lokale Umschlag desselben Zyklus erforderlich. Die externe Übermittlung ist niemals Teil des öffentlichen Nachweises.

Wenn Abschlussberichte fehlen oder älter als der aktuelle poll/source und fährt mit der ersten nicht übereinstimmenden Abstammung oder dem fehlgeschlagenen Schreibvorgang fort. Ändern Sie keine unabhängigen Routen, Formulierungen oder Durchsetzungseinstellungen. Sehen Sie sich die Zeilen [`OUTPUT_SCHEMA_REFERENCE.md`](REFERENZ_ZUM_AUSGABESCHEMA.md), [`TROUBLESHOOTING.md`](FEHLERBEHEBUNG.md) übereinstimmen, und [`SOURCE_MODULE_REFERENCE.md`](QUELLMODULREFERENZ.md).
