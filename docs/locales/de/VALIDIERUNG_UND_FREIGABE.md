<a id="validation-and-release"></a>
# Validierung und Freigabe

> **Kanonisch-englische Quelle:** [VALIDATION_AND_RELEASE.md](../../VALIDATION_AND_RELEASE.md). Diese lokalisierte Dokumentation bewahrt genaue Befehle, Pfade, Schlüssel, Statuswerte, Hashes und Dateinamen. Wenn der technische Wortlaut abweicht, verwenden Sie die englische Quelle.


Diese Seite richtet sich an Mitwirkende und Release-Betreuer. Serverbetreiber müssen diese Befehle nicht ausführen, um RandomDayGuard.

<a id="user-visible-proof"></a>
## Für den Benutzer sichtbar Beweis

Ein Release zu installieren, wenn ein neuer Operator es installieren, den ersten Serverstatusbericht finden, die fünf Berichtsrouten unterscheiden und einer klaren Aktion aus einem ausgearbeiteten Beispiel folgen kann. Für Leseaufgaben dürfen keine Git-, PowerShell-, Python- oder Prüfsummenkenntnisse erforderlich sein.

<a id="contributor-checks"></a>
## Mitwirkender prüft

```powershell
python -B tools/validate_repo.py
python -B tools/test_public_pipeline.py
python -B -m unittest discover tests
```

Wann `luac` ist verfügbar:

```powershell
luac -p RandomDayGuard/Scripts/main.lua
luac -p RandomDayGuard/Scripts/public_pipeline.lua
```

Die Lua-Fixture-Tests decken den Loader, den Scheduler, die Berichtsrouten und optionale Admin.ini Schreibtransaktion. Durchsetzungseinrichtungen verwenden nur temporäre Dateien und überprüfen Identität, Zurückweisung vertrauenswürdiger Konten, Schwellenwerte, Sicherung, gleichzeitige Änderungsverweigerung, Rücklesung und Rollback.

<a id="package-proof"></a>
## Paketnachweis

```powershell
python -B tools/build_release_zip.py --check
git diff --check
```

- Alle Versionsmarkierungen stimmen überein `VERSION`.
- Nur die aktuelle Version existiert unter `releases/`.
- Der ZIP enthält die kanonischen `RandomDayGuard/Scripts/main.lua`Pfad und kein Kleinbuchstaben-Varianten-Loader.
- Laufzeitausgabe, private Konfiguration, Anmeldeinformationen, lokale Pfade, Caches und Testartefakte sind ausgeschlossen.
- Die öffentliche Konfiguration bleibt bei deaktivierter Durchsetzung schreibgeschützt.
- Die fünf bearbeiteten Berichtsbeispiele bleiben mit dem Routenbesitz und dem Release-Test konsistent Fixture.
- ZIP Bytes sind deterministisch und stimmen überein `CHECKSUMS.sha256`.
- Alle lokalen Dokumentationslinks und 27 Locale-Eintragsseiten validieren.

<a id="avoid-validation-environment-pitfalls"></a>
## Fallstricke in der Validierungsumgebung vermeiden

- Führen Sie Repository-Schreibprüfungen seriell aus, um temporäre Dateikonflikte zu vermeiden.
- Unter Windows: Untersuchen Sie archivierte Mitgliedsnamen oder die Schreibweise aufgezählter Pfade, statt eine Dateisuche ohne Berücksichtigung der Groß-/Kleinschreibung durchzuführen, wenn Sie nach doppelten Ladeprogrammen suchen.
- Ein fehlender `luac`-Befehl oder eine fehlende Lua-Laufzeit ist eine nicht verfügbare Funktion, kein bestandener Syntax- oder Laufzeittest.
- Ein Fixture prüft nur seine modellierten Eingaben. Es beweist nicht, dass ein Live-Server einen aktuellen Bericht erstellt hat.
- Zeichnen Sie Befehlszeitüberschreitungen und Teilausgaben auf, anstatt von der Fertigstellung auszugehen.

<a id="repair-failed-repository-validation"></a>
## Fehler bei der Repository-Validierung reparieren

Beginnen Sie mit dem ersten gemeldeten Pfad oder Vertrag. Korrigieren Sie dieses Element, führen Sie den engen Test erneut durch und führen Sie dann die gesamte Matrix erneut aus. Verstecken Sie eine fehlende Funktion nicht, indem Sie den Test entfernen, der sie erfordert.

<a id="known-limits-and-release-decision"></a>
## Bekannte Grenzwerte und Freigabeentscheidung

Lokale Prüfungen beweisen Quellen-, Vorrichtungs-, Paket- und Dokumentationsverträge. Für eine bestimmte Serverinstallation, ein lang andauerndes Stabilitätsfenster oder eine Clientanzeige ist ein separates Integrationsergebnis erforderlich. Notieren Sie dieses Ergebnis mit Build, Konfiguration, Dauer und beobachteter Ausgabe, bevor Sie den entsprechenden Anspruch geltend machen.
