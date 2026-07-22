<a id="contributing"></a>
# Beitrag

> **Kanonisch-englische Quelle:** [CONTRIBUTING.md](../../../CONTRIBUTING.md). Diese lokalisierte Dokumentation bewahrt genaue Befehle, Pfade, Schlüssel, Statuswerte, Hashes und Dateinamen. Wenn der technische Wortlaut abweicht, verwenden Sie die englische Quelle.


RandomDayGuard akzeptiert gezielte, reproduzierbare Verbesserungen an Parsern, Dokumentation, Tests und öffentlich-sicherer Validierung. Halten Sie jede Änderung an den öffentlichen Projektvertrag gebunden und bewahren Sie das Review-First-Verhalten: Guard muss `Admin.ini` unverändert lassen, wenn eine erforderliche Sicherheitsüberprüfung nicht bestätigt werden kann.

<a id="prepare-a-safe-workspace"></a>
## Bereiten Sie einen sicheren Arbeitsbereich vor

1. Forken oder klonen Sie das Repository und erstellen Sie einen fokussierten Zweig.
2. Installieren Sie einen unterstützten Python 3-Interpreter. Installieren Sie einen Lua-Compiler, wenn Sie Lua ändern, damit `luac -p` die Syntax überprüfen kann.
3. Lesen Sie den [Dokumentationsstartseite](DOKUMENTATION.md), [Architektur](ARCHITEKTUR.md) übereinstimmen, und [Beweisgrenze](BEWEISGRENZE.md) für den Bereich, den Sie ändern möchten.
4. Überprüfen Sie `git status` vor der Bearbeitung und bewahren Sie nicht verwandte Arbeiten auf.
5. Verwenden Sie nur synthetische oder desinfizierte Geräte.

Senden Sie niemals private Serverprotokolle, gespeicherte Ordner, Spielerkennungen, `Admin.ini`, private Benachrichtigungsendpunkte, Anmeldeinformationen, private Pfade. Laufzeitausgabe oder kopierte Live-Beweise.

<a id="make-a-focused-change"></a>
## Nehmen Sie eine gezielte Änderung vor

- Befolgen Sie die vorhandene Benennung, Formatierung, Sicherheitsüberprüfungen und Modulbesitzverhältnisse.
- Behalten Sie einen kanonischen Dokumentationseigentümer für jedes Verfahren oder jede genaue Tatsache bei.
- Aktualisieren Sie Benutzerdokumentation und Beispiele, wenn sich Verhalten oder öffentliche Ausgabe ändern.
- Fügen Sie, wenn möglich, einen Regressionstest zur Fehlerbehebung hinzu.
- Schwächen Sie nicht die Kontobestätigung, den Schutz vertrauenswürdiger Konten, die Sicherungsüberprüfung, die Erkennung externer Änderungen, den Vergleich gespeicherter Dateien, die Wiederherstellung oder die Nur-Überprüfungs-Standardeinstellungen, um einen Test erfolgreich zu machen.

<a id="run-the-relevant-checks"></a>
## Führen Sie die relevanten Prüfungen durch

Für Änderungen, die nur der Dokumentation dienen, run:

```powershell
python -B tools\generate_documentation_audit.py --check
python -B -m unittest discover tests -p "test_documentation*.py"
git diff --check
```

Führen Sie für Quell-, Konfigurations-, Verpackungs- oder Teständerungen auch die entsprechenden Prüfungen aus [Validierung und Release-Überprüfung](VALIDIERUNG_UND_FREIGABE.md), einschließlich Lua-Syntaxprüfungen, Repository-Validierung, Public-Pipeline-Tests und die vollständige Unit-Test-Suite. Melden Sie jeden übersprungenen oder nicht verfügbaren Scheck. Beschreiben Sie es nicht als bestanden.

<a id="submit-the-change-for-review"></a>
## Senden Sie die Änderung zur Überprüfung.

Öffnen Sie eine fokussierte Pull-Anfrage erst, nachdem Sie den vollständigen Unterschied überprüft haben. Dazu gehören:

- das Problem und das beabsichtigte Verhalten;
- genaue Dateien und öffentliche Verträge geändert;
- ausgeführte Befehle und ihre Ergebnisse;
- Datenschutz, Kompatibilität und Auswirkungen auf die Durchsetzung; und
- verbleibende Einschränkungen oder Folgearbeiten.

Fügen Sie keine generierten Laufzeitnachweise oder Release-Archive hinzu, es sei denn, die Änderung erfordert diese ausdrücklich und validiert sie. Ein Beitrag berechtigt nicht zu einer Veröffentlichung, Bereitstellung, einem Live-Server-Test, einer Durchsetzungsmaßnahme oder einer Veröffentlichung auf einer Website eines Drittanbieters.

Schwachstellen melden über [die private Sicherheitsroute](SICHERHEIT.md), kein öffentliches Problem oder gewöhnlicher Pull-Request.
