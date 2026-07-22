<a id="install-randomdayguard"></a>
# Installieren RandomDayGuard

> **Kanonisch-englische Quelle:** [INSTALL.md](../../../INSTALL.md). Diese lokalisierte Dokumentation bewahrt genaue Befehle, Pfade, Schlüssel, Statuswerte, Hashes und Dateinamen. Wenn der technische Wortlaut abweicht, verwenden Sie die englische Quelle.


Diese Anleitung installiert `v0.4.12-alpha` auf einem dedizierten Server von Abbiotic Factor, der bereits UE4SS verwendet. Der Mod ist nicht an ein Hosting-Unternehmen oder Control Panel gebunden.

<a id="before-you-begin"></a>
## Bevor Sie beginnen

Sie benötigen:

- Zugriff zum Stoppen und Starten des dedizierten Servers;
- des Servers UE4SS `Mods` des Servers;
- eine Kopie des aktuellen RandomDayGuardOrdners, wenn Sie aktualisieren;
- eine Sicherung der Serverdaten, die Sie normalerweise schützen, bevor Sie einen Mod ändern.

Der **Mods-Ordner** ist der `ue4ss/Mods/` Verzeichnis innerhalb der Installation des dedizierten Servers. RandomDayGuard gehört direkt in diesen Ordner.

<a id="new-installation"></a>
## Neue Installation

1. Stoppen Sie den dedizierten Server.
2. Extrahieren Sie den Ordner RandomDayGuard ZIP in einen neuen leeren Ordner.
3. Kopieren Sie den extrahierten `RandomDayGuard` in den Ordner UE4SS `Mods` Ordner. Das Ergebnis sollte ein `Mods/RandomDayGuard/` des Servers, nicht in einen zweiten darin verschachtelten Ordner RandomDayGuard it.
4. Öffnen UE4SS `mods.txt` und aktivieren Sie:

   ```text
   RandomDayGuard : 1
   ```

5. Starten Sie den Server normal.
6. Warten Sie, bis UE4SS und der Spieleserver, um den Start abzuschließen, dann folgen Sie [Lesen Sie den ersten Bericht](HIER_BEGINNEN.md).

Kopieren Sie keine neue Version über eine laufende Installation. Bewahren Sie die Sicherung auf, bis die aktualisierte Installation einen aktuellen Serverstatusbericht erstellt hat.

<a id="update-an-existing-installation"></a>
## Aktualisieren Sie eine vorhandene Installation

1. Stoppen Sie den Server.
2. Kopieren Sie den vollständig installierten RandomDayGuard Ordner an einen sicheren Sicherungsort.
3. Verschieben Sie den alten Programmordner aus UE4SS `Mods`, anstatt die neue Version darüber zu legen.
4. Kopieren Sie den neuen Ordner RandomDayGuard nach `Mods`.
5. Stellen Sie nur Ihre überprüfte lokale Konfiguration und gespeicherte Beweise wieder her. Wenn im Konfigurationsleitfaden neue Felder aufgeführt sind, fügen Sie sie in die überprüfte Kopie ein, anstatt alle Einstellungen blind zu ersetzen.
6. Bestätigen Sie, dass `RandomDayGuard : 1` aktiviert bleibt.
7. Starten Sie den Server und lesen Sie den aktuellen Serverstatusbericht.

Dieses Update der Ordnerbereinigung entfernt auch veraltete Dateien aus älteren Versionen, ohne dass der Bediener aufgefordert wird, das Programm zu überprüfen Dateinamen.

<a id="help-guard-find-the-server-records"></a>
## Helfen Sie Guard, die Serverdatensätze zu finden

Guard findet das Verzeichnis Abiotischer Faktor `Saved` normalerweise automatisch. Wenn dies nicht möglich ist, geben Sie den vollständigen Pfad zu diesem Verzeichnis `Saved` in `SavedRoot.txt` innerhalb von RandomDayGuard Ordner. Zeigen Sie auf `Saved`, nicht auf eine einzelne Welt darunter.

Der erste Serverstatusbericht gibt an, ob der Speicherort des Datensatzes gefunden wurde und welche Quellgruppen verfügbar waren. Verwenden Sie [Fehlerbehebung](FEHLERBEHEBUNG.md) wenn der Standort nicht gelesen werden kann.

<a id="first-run-behavior"></a>
## Verhalten bei der ersten Ausführung

Die Standardinstallation überwacht verfügbare Datensätze und schreibt Berichte. Es ändert weder `Admin.ini` noch fügt es ein Verbot hinzu. Dadurch können Sie die Erfassung, Übersetzung und Berichtsqualität bestätigen, bevor Sie entscheiden, ob Sie eine optionale Aktion aktivieren möchten.

[Lesen Sie den ersten Bericht](HIER_BEGINNEN.md)

<a id="disable-or-remove-randomdayguard"></a>
## Deaktivieren oder entfernen RandomDayGuard

1. Stoppen Sie den Server.
2. Kopieren Sie das vollständige RandomDayGuardOrdner in ein sicheres Archiv verschieben.
3. Um den Mod zu deaktivieren, legen Sie `RandomDayGuard : 0` in UE4SS `mods.txt`.
4. Um es zu entfernen, verschieben Sie das gesamte RandomDayGuard Ordner aus `Mods`, nachdem Sie bestätigt haben, dass das Archiv geöffnet werden kann.
5. Starten Sie den Server und stellen Sie sicher, dass Guard nicht mehr startet.

Das Deaktivieren oder Entfernen von Guard stoppt die zukünftige Erfassung. Spieldaten werden nicht gelöscht, die archivierten Berichte werden nicht gelöscht und eine separate Bedieneraktion wird nicht rückgängig gemacht.

<a id="roll-back-an-update"></a>
## Ein Update rückgängig machen

Wenn die neue Installation nicht geladen wird oder keinen aktuellen Bericht erstellen kann:

1. Stoppen Sie den Server.
2. Verschieben Sie die fehlgeschlagene Installation beiseite, ohne ihre Datensätze zu löschen.
3. Stellen Sie das vollständige Vor-Update wieder her RandomDayGuardOrdner.
4. Stellen Sie die überprüfte Konfiguration und die gespeicherten Beweise aus demselben Backup wieder her.
5. Bestätigen Sie, dass der Mod aktiviert ist, und starten Sie den Server.
6. Lesen Sie den wiederhergestellten Serverstatusbericht, bevor Sie eine weitere Änderung vornehmen.

<a id="more-help"></a>
## Weitere Hilfe

- [Lesen Sie den ersten Bericht](HIER_BEGINNEN.md)
- [Operations Playbook](OPERATIONS_PLAYBOOK.md)
- [Fehlerbehebung](FEHLERBEHEBUNG.md)
- [Konfigurationsprofile](CONFIG_PROFILES.md)
- [Admin.ini Durchsetzung](ADMIN_INI_ENFORCEMENT.md)

Release-Betreuer finden Quell-, Paket- und Datenschutzprüfungen in [Validierung und Freigabe](VALIDIERUNG_UND_FREIGABE.md). Sie sind für eine normale Installation nicht erforderlich.
