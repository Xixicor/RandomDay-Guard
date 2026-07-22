<a id="start-here-read-the-first-guard-report"></a>
# Hier beginnen: Lesen Sie den ersten Guard-Bericht

> **Kanonisch-englische Quelle:** [START_HERE.md](../../START_HERE.md). Diese lokalisierte Dokumentation bewahrt genaue Befehle, Pfade, Schlüssel, Statuswerte, Hashes und Dateinamen. Wenn der technische Wortlaut abweicht, verwenden Sie die englische Quelle.


Diese Anleitung beginnt, nachdem RandomDayGuard installiert und aktiviert wurde. Dies ist ein nützliches Ergebnis, ohne dass ein neuer Bediener aufgefordert wird, Quellcode, Paketinterna oder maschinenspezifische Statusdateien zu überprüfen.

<a id="what-happens-after-the-server-starts"></a>
## Was passiert nach dem Serverstart?

Guard wartet darauf, dass der Spieleserver und UE4SS geladen werden, findet die verfügbaren Datensätze des Servers und startet einen begrenzten Hintergrundscan. Es kann den aktuellen Serverzustand melden, während der ältere Verlauf noch indiziert wird.

Der erste Bericht sollte **Serverstatus** sein. Es antwortet, ob Guard jetzt die Überwachungszyklen abschließt, wann der aktuelle Serverlauf begonnen hat, ob dieser Zeitstempel verfügbar ist, wie viel active/rotated Protokoll- und Scanabdeckung vorhanden ist, wie viele Spieler verbunden sind, welche Quellgruppen fehlen und ob eine Bedieneraktion erforderlich ist.

Ein Hintergrundscan, der noch läuft, stellt eine Einschränkung der historischen Abdeckung dar und ist nicht automatisch ein Startfehler. Guard zeichnet den Scan-Cursor, abgeschlossene Dateien, erkannte Dateien und die letzte Fortschrittszeit auf. Wenn sich diese Werte über wiederholte Überwachungszyklen hinweg nicht mehr ändern, behandeln Sie den historischen Pfad als blockiert und folgen Sie dem Scan-Zweig in der Fehlerbehebung. Verwerfen Sie aktuelle Protokoll- und Sitzungsergebnisse nicht, nur weil der ältere Verlauf unvollständig ist.

<a id="read-the-first-server-status-report"></a>
## Lesen Sie den ersten Serverstatusbericht

1. Starten Sie den dedizierten Server normal.
2. Warten Sie, bis der Spielserver und UE4SS den Startvorgang abgeschlossen haben.
3. Öffnen RandomDayGuard'sOrdner „Abschlussberichte“ und wählen Sie den neuesten lesbaren Serverstatusbericht aus.
4. Bestätigen Sie, dass der Bericht Folgendes enthält:
   - **Zusammenfassung**
   - **Was Guard beobachtet hat**
   - **Was es bedeutet**
   - **Was unbekannt bleibt**
   - **Empfohlener nächster Schritt**
   - **Technischer Datensatz**
5. Vergleichen Sie in **Was Guard beobachtet hat** ist, die neuesten Überwachungszyklusfortschritte bestätigt werden und der Bericht die verfügbaren Protokoll-, Scan-, Player- und Quellenabdeckungen nennt.
6. Wenn im nächsten Schritt angegeben wird, dass kein Eingriff erforderlich ist, behalten Sie den Bericht als erstes erfolgreiches Ergebnis bei. Wenn eine fehlende Quelle oder ein gestoppter Prozess genannt wird, folgen Sie genau diesem Symptom in [Fehlerbehebung](FEHLERBEHEBUNG.md).

Der Bericht enthält möglicherweise einen Link zu technischen Beweisen für eine tiefergehende Überprüfung. Ein normaler Bediener kann den Bericht zuerst lesen und diese Referenzen nur dann öffnen, wenn das einfache Ergebnis überprüft werden muss.

<a id="understand-quiet-reports"></a>
## Stille Berichte verstehen

Spieleraktivität, Fallüberprüfung und Critical Guard sind ereignisgesteuert. Ein stiller Server sollte keinen fiktiven Spieler, Fall oder Fehler erzeugen, nur um einen Kanal zu füllen.

Das tägliche Rollup ist anders: Es bietet eine Überprüfung pro Berichtsdatum unter Verwendung der Sitzungen am selben Tag, der aktuellen Überprüfungsthemen, des beibehaltenen identity/case Kontexts, des Scan-Fortschritts und der Quellenlücken, die Guard tatsächlich lesen kann geschätzt.

<a id="test-one-ordinary-player-session"></a>
## Testen Sie eine normale Spielersitzung

Nachdem der erste Serverstatusbericht aktuell ist:

1. Lassen Sie einen bekannten Spieler normal beitreten und gehen.
2. Warten Sie auf den nächsten Berichtszyklus.
3. Öffnen Sie die Spieleraktivität.
4. Bestätigen Sie es identifiziert den für Guard verfügbaren Konto- oder Anzeigenamen, die Beitritts- und Verlassenszeiten, das saubere oder unvollständige Sitzungsergebnis, den vorherigen Verlauf, sofern verfügbar, und eine nächste Aktion.

Der Sitzungsbericht sollte die beobachteten Daten enthalten. Er sollte nicht durch eine Liste von Dateinamen oder eine generische Aussage, dass Datensätze vorhanden sind, ersetzt werden.

<a id="continue"></a>
## Weiter

- [Fünf Berichtsbeispiele](BERICHTSBEISPIELE.md)
- [Operations Playbook](OPERATIONS_PLAYBOOK.md)
- [Workflow zur Spielerüberprüfung](WORKFLOW_ZUR_PLAYER-%C3%9CBERPR%C3%9CFUNG.md)
- [Fehlerbehebung](FEHLERBEHEBUNG.md)
- [Vollständiger Dokumentationsindex](DOKUMENTATION.md)
