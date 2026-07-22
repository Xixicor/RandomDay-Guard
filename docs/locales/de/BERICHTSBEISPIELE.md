<a id="examples-of-the-five-guard-reports"></a>
# Beispiele für die fünf Guard-Berichte

> **Kanonisch-englische Quelle:** [REPORT_EXAMPLES.md](../../REPORT_EXAMPLES.md). Diese lokalisierte Dokumentation bewahrt genaue Befehle, Pfade, Schlüssel, Statuswerte, Hashes und Dateinamen. Wenn der technische Wortlaut abweicht, verwenden Sie die englische Quelle.


Diese Beispiele wurden aus den in der Version enthaltenen Beispieldaten erstellt; Die Namen und Kontonummern werden erfunden. Sie zeigen die getesteten Berichtsfelder, Berechnungen und Routengrenzen. Ein echter Bericht ersetzt sie durch von diesem Server gesammelte Informationen und gibt an, wann eine Tatsache nicht verfügbar war.

Jeder Bericht hat eine Aufgabe. Der Serverzustand wiederholt den Spielerverlauf nicht, die tägliche Überprüfung wird nicht alle paar Minuten gesendet und stille Spieler- oder Fallrouten erhalten keine Füllnachrichten. Ein aktueller Bericht ist möglicherweise fertig, während der begrenzte historische Scan noch läuft; In diesem Fall benennt der Bericht die Lücke, anstatt den älteren Verlauf als vollständig darzustellen.

<a id="server-status"></a>
## Serverstatus

> **Serverstatus: Online nach Neustart**  **Aktueller Status:** Online **Verfügbar seit:** 14:07  **Neustart abgeschlossen:** 14:06  **Ausfallzeit:** 3 Minuten, 12 Sekunden **Neustartgrund:** Geplante Spielaktualisierung **Überwachung:** Aktiv. Letzte erfolgreiche Überprüfung: 14:09 **Spielprotokoll:** Verfügbar und aktualisiert **Historischer Scan:** 312 von 355 Dateien überprüft **Backups:** Letzte Überprüfung: 13:00. Nächster voraussichtlicher Termin: 15:00 Uhr. Fehler heute: 0 **Aktion:** Keine. Der Server wurde normal wiederhergestellt.

Der Serverstatus bezieht sich auf den aktuellen Betrieb des Servers: Start, Wiederherstellung nach Neustart, Ausfallzeit, Sicherungen, Planer und Guard-Zustand. Es enthält keine Spielersitzungen oder Falldetails.

<a id="daily-rollup"></a>
## Täglicher Rollup

> **Täglicher Rückblick: 19. Juli 2026**  **Serververfügbarkeit:** 23 Stunden und 47 Minuten online. 13 Minuten offline.  **Neustarts:** 2 insgesamt: 1 geplant und 1 unerwartet.  **Backups:** 23 erfolgreich. 1 fehlt oder ist fehlgeschlagen. Letzte erfolgreiche Sicherung: 23:00.  **Spieleraktivität:** 3 einzigartige Spieler. 7 Sitzungen: 6 normal abgeschlossen und 1 unterbrochen.  **Fallaktivität:** 1 neuer Fall, 2 aktualisierte Fälle, 1 Fall, der Aufmerksamkeit erfordert, und 0 kritische Fälle.  **Beweisabdeckung:** 6 von 7 erwarteten Quellengruppen waren verfügbar. Das Sicherungsprotokoll von 04:00 Uhr war nicht verfügbar.  **Tageszusammenfassung:** Der Server blieb den größten Teil des Tages verfügbar. Eine unerwartete Unterbrechung beendete eine Spielersitzung vorzeitig. Die Überwachung wurde nach der Wiederherstellung wieder aufgenommen und ein Fall steht zur Überprüfung bereit.  **Aktion:**Fall überprüfen `RDG-20260719-004`. Es sind keine weiteren sofortigen Maßnahmen erforderlich.

Der tägliche Rollup wird einmal für sein Kalenderdatum geschrieben. Es kombiniert den Tag über Ruhephasen und Neustarts, ohne dass es zu einem weiteren Serverstatus-Ping kommt.

<a id="player-activity"></a>
## Spieleraktivität

> **Spieleraktivität: Alex**  **Konto:** `76561198000000400`  **Zuerst beobachtet:** 12. Juli 2026 **Letzte Sitzung:** Eingetreten um 10:02 Uhr, Verlassen um 11:18 Uhr, Dauer 1 Stunde 16 Minuten und endete normal.  **Heute:** 3 Verbindungen, 2 abgeschlossene Sitzungen, 1 unterbrochene Sitzung und 2 schnelle Wiederverbindungen innerhalb von 10 Minuten.  **Vorherige 7 Tage:** 9 Sitzungen, 6 Stunden 18 Minuten aufgezeichnetes Spiel und 0 frühere Fälle.  **Beobachtet:** Alex kehrte kurz nach einer unterbrochenen Sitzung zweimal zurück. Die aufgezeichnete Aktivität ist vollständig genug, um als Verlauf gespeichert zu werden, sie allein erklärt jedoch nicht, warum die erneuten Verbindungen stattgefunden haben.  **Aktion:** Überwachung fortsetzen. Es sind keine sofortigen Maßnahmen erforderlich.

Die Spieleraktivität wird nur gesendet, wenn sich die unterstützten Spieler- oder Sitzungsinformationen ändern. Eine Ruhephase erstellt keine Spielernachricht.

<a id="case-review"></a>
## Fallüberprüfung

> **Fallüberprüfung: RDG-20260719-004**  **Betreff:** Alex **Konto:** `76561198000000400`  **Status:** Administratorüberprüfung angefordert **Bewertungsbewertung:** 90 – Hohe Priorität **Warum der Fall eröffnet wurde:** Das Konto hat nach einer unterbrochenen Sitzung wiederholt Verbindungsversuche unternommen und der Server hat die Anmeldeanfragen direkt aufgezeichnet.  **Bestätigte Beobachtungen:** – Eine Login-Anfrage wurde um 18:42 Uhr aufgezeichnet. - Innerhalb von 6 Minuten wurden vier Versuche aufgezeichnet. - Zwei Sitzungen endeten ohne eine normale Abfahrtsaufzeichnung. - Das gleiche Konto wurde am 12. Juli und 17. Juli beobachtet.  **Relevanter Verlauf:** Für dieses Konto ist kein früherer Fall erfasst.  **Unbekannt:** Die verfügbaren Aufzeichnungen geben keinen Aufschluss über den Grund für die erneuten Verbindungen, die Absicht des Spielers oder ob sich der Weltzustand geändert hat.  **Empfohlene Aktion:**Vergleichen Sie die Sitzungszeiten mit dem Serverprotokoll und der aufgezeichneten Weltaktivität, bevor Sie entscheiden, ob Maßnahmen erforderlich sind.

Die Fallüberprüfung enthält benanntes Überprüfungsmaterial, seine bestätigten Beobachtungen, seine Grenzen und einen spezifischen Überprüfungsschritt. Historische Präsenz allein schafft keinen neuen Fall.

<a id="critical-guard"></a>
## Critical Guard

> **Critical Guard: Berichtserstellung gestoppt**  **Gestartet:** 21:14  **Betroffene Funktion:**Ersteller von Spielerberichten**Auswirkungen:** Zusammenfassungen neuer Spieler können nicht abgeschlossen werden.  **Server:** Bleibt online.  **Überwachung:** Die Beweiserhebung wird fortgesetzt, aber lesbare Berichte verzögern sich.  **Letzter erfolgreicher Bericht:** 21:09  **Fehler:** Die Berichtsausgabe konnte nicht gespeichert werden.  **Wahrscheinlicher Grund:** Das Ziel war nicht verfügbar oder hat den Schreibvorgang abgelehnt.  **Aktion:** Überprüfen Sie den Ausgabeort der Guard-Laufzeit. Starten Sie den Spielserver nicht neu, es sei denn, die Überwachung stoppt ebenfalls.

Wenn das Problem behoben ist, zeichnet die gleiche Route die Wiederherstellung auf:

> **Kritischer Schutz behoben: Berichterstellung wiederhergestellt**  **Wiederaufnahme:** 21:22  **Unterbrechung:** 8 Minuten **Ergebnis:** Während der Unterbrechung gesammelte Beweise wurden aufbewahrt und die verspäteten Berichte wurden vervollständigt.

Critical Guard ist nur bei Fehlern aktiv. Routinestatus, Tagesverlauf, Spieleraktivität und gewöhnliche erwartete Leerergebnisse bleiben in ihren eigenen Berichten erhalten.

<a id="when-a-route-is-quiet"></a>
## Wenn eine Route ruhig ist

Eine ruhige Route zeichnet ein direktes Ergebnis auf, ohne Füllmaterial an Discord zu senden:

> **Überprüft; Nichts für diesen Bericht.** Die erforderlichen Datensätze waren verfügbar und während dieses Berichtsfensters sind keine passenden Spieleraktivitäten, Fälle oder Guard-Fehler aufgetreten.

Das ist ein völlig leeres Ergebnis. Es unterscheidet sich von einem fehlenden Bericht, bei dem eine erforderliche Quelle nicht überprüft oder die lesbare Ausgabe nicht erstellt werden konnte.

Jeder lesbare Bericht folgt demselben Pfad:

```text
collected evidence -> normalized values -> dictionary mapping -> route calculations -> readable report -> Discord notification
```

Verwenden Sie das [Betriebs-Playbook](OPERATIONS_PLAYBOOK.md), um aktuelle Berichte und das [Ausgabeschema](REFERENZ_ZUM_AUSGABESCHEMA.md) als technische Feldreferenz zu überprüfen.
