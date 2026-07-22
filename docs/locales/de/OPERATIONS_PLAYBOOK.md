<a id="operations-playbook"></a>
# Operations Playbook

> **Kanonisch-englische Quelle:** [OPERATIONS_PLAYBOOK.md](../../OPERATIONS_PLAYBOOK.md). Diese lokalisierte Dokumentation bewahrt genaue Befehle, Pfade, Schlüssel, Statuswerte, Hashes und Dateinamen. Wenn der technische Wortlaut abweicht, verwenden Sie die englische Quelle.


Dies ist die normale Lesereihenfolge für RandomDayGuard. Sie müssen sich nicht mit JSON, Git, Prüfsummen oder Befehlszeilentools auskennen, um einen funktionsfähigen Server zu überprüfen.

<a id="daily-operator-flow"></a>
## Täglicher Bedienerablauf

1. Öffnen `runtime/final_logs/server_status_latest.txt`. Hier erfahren Sie, ob Guard den aktuellen Serverlauf überwacht, wann der letzte Zyklus abgeschlossen ist, wie viele Spieler verbunden sind und ob eine Quelle oder ein Scan unvollständig ist.
2. Öffnen `runtime/final_logs/daily_rollup_latest.txt` einmal pro Tag. Es fasst Sitzungen am selben Tag, Austritte, benannte Fallarbeit, Identitätsinventur und Quellenabdeckung zusammen, ohne jeden einzelnen Datensatz zu wiederholen.
3. Öffnen `runtime/final_logs/player_activity_latest.txt` nur, wenn der Server tagsüber eine Beitritts-, Austritts- oder aktive Sitzung hatte.
4. Öffnen `runtime/final_logs/case_review_latest.txt` nur, wenn er ein aktuelles Thema benennt. Der Bericht gibt das Konto, den Überprüfungsstatus, die Punktzahl, die Identitätsquelle und die Datensätze an, die als Nächstes geöffnet werden sollen.
5. Öffnen `runtime/final_logs/critical_guard_latest.txt`nur wenn Guard einen Fehler in seinem eigenen Start, Überwachungszyklus oder Berichtsschreibvorgängen meldet.

Wenn eine Route nichts zu melden hat, zeichnet Guard ein Ergebnis „erwartet leer“ auf. Das ist eine abgeschlossene Prüfung, kein fehlender Bericht.

<a id="what-to-read-inside-a-report"></a>
## Was in einem Bericht zu lesen ist

Lesen Sie diese Abschnitte der Reihe nach:

1. **Zusammenfassung** – was dieser Bericht abdeckt.
2. **Was Guard beobachtet hat** – tatsächliche Zeitstempel, Zählungen, Konten, Sitzungen oder Statuswerte, die für diese Route erfasst wurden.
3. **Was es bedeutet** - die Klartextinterpretation dieser Datensätze.
4. **Was unbekannt bleibt** - eine Quelle oder ein Scan-Limit, das sich auf das Ergebnis auswirkt.
5. **Empfohlener nächster Schritt** - ob überwacht, ein benanntes Subjekt überprüft oder Guard repariert werden soll.
6. **Beweisgrenze** - das Limit des Berichts Geltungsbereich.

Der technische Datensatz und die Quellenangaben erscheinen am Ende für Leser, die die genauen strukturierten Beweise einsehen müssen.

<a id="when-a-report-is-missing"></a>
## Wenn ein Bericht fehlt

Öffnen `runtime/final_logs/route_proof.json` nur, wenn ein lesbarer Bericht fehlt oder sagt, dass sein aktueller Beweis fehlt. Für jede Route gibt es eines dieser Ergebnisse:

| Ergebnis | Bedeutung |
|---|---|
| `full` | Der Wachmann hat die Route mit aktuellen Beweisen abgeschlossen, die der Route gehören. |
| `limited_expected_empty` | Der Wachmann hat die Route abgeschlossen und kein qualifizierendes Ereignis gefunden oder eine benannte Reifegrenze aufgezeichnet. |
| `missing` | Eine erforderliche Quelle, Abstammungsprüfung oder das Schreiben eines gepaarten Berichts wurde nicht abgeschlossen. |

Folgen Sie bei einer fehlenden Route der benannten Quelle oder dem Schreibfehler im Bericht. Ändern Sie nicht zuerst unabhängige Routen oder Benachrichtigungseinstellungen.

<a id="after-a-crash-or-restart"></a>
## Nach einem Absturz oder Neustart

1. Lesen Sie den Serverstatus für den neuen Zeitstempel der Serverausführung und den letzten abgeschlossenen Überwachungszyklus.
2. Lesen Sie Critical Guard für einen aktuellen Start- oder Abfragefehler.
3. Lesen Sie die Player-Aktivität nur, wenn eine Sitzung am selben Tag beigetreten ist, verlassen wurde oder nach dem Lebenszyklus zurückgegeben wurde ändern.
4. Behalten Sie den zitierten Quelldatensatz bei, bevor Sie die Konfiguration ändern.

<a id="before-enabling-optional-adminini-writes"></a>
## Bevor Sie optionale Admin.ini Schreibvorgänge aktivieren

Das Standardpaket überwacht und meldet, ohne dass `Admin.ini`. Fortgeschrittene Bediener können den optionalen Durchsetzungspfad aktivieren, nachdem sie ihn anhand einer Kopie der Datei getestet haben. Guard benötigt dann eine saubere numerische Konto-ID, schützt vertrauenswürdige Konten, erstellt und überprüft ein Backup, lehnt gleichzeitige Änderungen ab, liest die gespeicherte Datei zurück und stellt das Backup wieder her, wenn die Überprüfung fehlschlägt. Unter [`ADMIN_INI_ENFORCEMENT.md`](ADMIN_INI_ENFORCEMENT.md) finden Sie den vollständigen Einrichtungs- und Testvorgang.

<a id="related-guides"></a>
## Verwandte Leitfäden

- [`START_HERE.md`](HIER_BEGINNEN.md)
- [`REPORT_EXAMPLES.md`](BERICHTSBEISPIELE.md)
- [`PLAYER_REVIEW_WORKFLOW.md`](WORKFLOW_ZUR_PLAYER-%C3%9CBERPR%C3%9CFUNG.md)
- [`TROUBLESHOOTING.md`](FEHLERBEHEBUNG.md)
- [`OUTPUT_SCHEMA_REFERENCE.md`](REFERENZ_ZUM_AUSGABESCHEMA.md)
