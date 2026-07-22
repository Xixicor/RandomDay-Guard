<a id="faq"></a>
# FAQ

> **Kanonisch-englische Quelle:** [FAQ.md](../../FAQ.md). Diese lokalisierte Dokumentation bewahrt genaue Befehle, Pfade, Schlüssel, Statuswerte, Hashes und Dateinamen. Wenn der technische Wortlaut abweicht, verwenden Sie die englische Quelle.


<a id="is-randomdayguard-the-randomday-mod"></a>
## Ist RandomDayGuardder RandomDayMod?

Nr. RandomDay Mod verändert das Servererlebnis. RandomDayGuard überwacht die Server-Beweisschicht.

<a id="does-live-defense-work-before-the-scan-completes"></a>
## Funktioniert die Live-Verteidigung, bevor der Scan abgeschlossen ist?

Ja. Live-Verteidigung verwendet Protokolle und Sitzungsereignisse. Der Basisscan verbessert später den Kontext.

<a id="why-can-the-first-scan-take-a-long-time"></a>
## Warum kann der erste Scan lange dauern?

Der erste Scan erstellt world/object Kontext, Dateimanifeste und wiederverwendbare Basisdaten.

<a id="what-do-i-check-first-after-startup"></a>
## Was überprüfe ich nach dem Start zuerst?

```text
runtime/current/poll_status.json
```

Suchen Sie nach:

```text
scheduler_status=running
poll_id increasing
poll_in_flight=false
```

<a id="where-are-player-summaries"></a>
## Wo sind Spielerzusammenfassungen?

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
```

<a id="where-is-the-daily-quick-review-package"></a>
## Wo ist das tägliche Schnellüberprüfungspaket?

```text
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

<a id="which-file-should-i-upload-for-fastest-review"></a>
## Welche Datei sollte ich für die schnellste Überprüfung hochladen?

```text
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="can-it-write-bans-automatically"></a>
## Kann es Sperren automatisch schreiben?

Nur wenn explizit aktiviert.

Standard:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

<a id="what-does-adminini-receive"></a>
## Was empfängt Admin.ini?

Nur:

```ini
BannedPlayer=<ID>
```

Keine Namen, Kommentare, Gründe oder Suffixe.

<a id="is-a-display-name-enough-to-ban"></a>
## Ist ein Anzeigename ausreichend, um zu sperren?

Nr. Verwenden Sie ein Serverprotokoll `Login request` mit `ConnectID` oder einen gleichwertigen Serverbeweis.

<a id="can-one-crash-ban-someone"></a>
## Kann ein Crash-Ban jemanden verbieten?

Standardmäßig nicht.

<a id="can-object-count-alone-ban-someone"></a>
## Kann die Objektzählung allein jemanden verbieten?

Standardmäßig nicht.

<a id="should-savedroottxt-point-to-the-world-folder"></a>
## Sollte SavedRoot.txt auf den Weltordner verweisen?

Nein. Verweisen Sie darauf: `AbioticFactor/Saved`.

<a id="what-if-the-world-folder-changes"></a>
## Was passiert, wenn sich der Weltordner ändert?

Behandeln Sie es als grundlegende Identitätsänderung. Behalten Sie die alte Grundlinie bei und erstellen Sie eine neue.

<a id="related-docs"></a>
## Verwandte Dokumente

* [`START_HERE.md`](HIER_BEGINNEN.md)
* [`FORENSIC_DAILY_ROLLUPS.md`](FORENSISCHE_TAGESROLLUPS.md)
* [`TROUBLESHOOTING.md`](FEHLERBEHEBUNG.md)
