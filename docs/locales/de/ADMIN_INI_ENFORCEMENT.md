<a id="adminini-enforcement"></a>
# Admin.ini Durchsetzung

> **Kanonisch-englische Quelle:** [ADMIN_INI_ENFORCEMENT.md](../../ADMIN_INI_ENFORCEMENT.md). Diese lokalisierte Dokumentation bewahrt genaue Befehle, Pfade, Schlüssel, Statuswerte, Hashes und Dateinamen. Wenn der technische Wortlaut abweicht, verwenden Sie die englische Quelle.


RandomDayGuard ändert die Server-Sperrliste in der Standardeinstellung nicht. Es werden nur Berichte erstellt, die ein Administrator überprüfen kann. Auf dieser Seite wird die optionale automatische Aktualisierung der Sperrliste für Administratoren erläutert, die sie absichtlich aktivieren.

<a id="what-guard-checks-before-changing-the-ban-list"></a>
## Was Guard überprüft, bevor die Sperrliste geändert wird

Guard fügt nur dann ein Verbot hinzu, wenn jede Antwort unten **ja**:

1. Wurde ein bestimmtes Konto anhand aktueller Erkenntnisse mit ausreichender Sicherheit identifiziert?
2. Ist das Konto weder ein Moderator noch ein Konto? Administrator als vertrauenswürdig markiert?
3. Befindet sich das Konto nicht bereits auf der Sperrliste?
4. Hat das Konto den konfigurierten Wert für automatische Aktionen erreicht?
5. Kann Guard den aktuellen `Admin.ini` lesen und ein identisches Backup speichern?
6. Hat `Admin.ini` unverändert bleiben, während Guard das Update vorbereitet hat?
7. Entspricht die vollständige Datei nach dem Speichern genau dem beabsichtigten Ergebnis?

ist. Wenn eine Antwort **Nein** lautet oder nicht überprüft werden kann, verlässt Guard den Status `Admin.ini` unverändert und zeichnet den Grund in seinen Berichten auf. Wenn das Speichern beginnt, aber die abschließende Prüfung fehlschlägt, stellt Guard das verifizierte Backup wieder her.

<a id="file-format"></a>
## Dateiformat

`Admin.ini` darf nur saubere Ban-Zeilen erhalten:

```ini
BannedPlayer=<ID>
```

- Keine Namen.
- Keine Kommentare.
- Keine Gründe.
- Nein Suffixe.

<a id="safe-defaults"></a>
## Sichere Standardeinstellungen

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
require_clean_ban_id = true
preserve_existing_bans = true
preserve_moderators = true
```

<a id="ban-id-source"></a>
## Ban-ID-Quelle

Beste Quelle:

```text
Login request
Name=<player>
ConnectID=<raw_id>
UniqueId=<platform_id>
```

Die Laufzeit akzeptiert entweder eine vollständig numerische ID oder das vollständig dokumentierte `<digits>_+_|<non-space token>` Verbindungsformular und leitet daraus die numerische Ban-ID ab. Beliebige numerische Präfixe mit unbekanntem Suffix werden abgelehnt; Sie werden nicht in eine Sperr-ID gekürzt.

Richtig:

```ini
BannedPlayer=2535422284688820
```

Falsch:

```ini
BannedPlayer=ExamplePlayer
```

Auch falsch:

```text
BannedPlayer=<ID>
```

<a id="exact-settings-guard-checks"></a>
## Genaue Einstellungen Guard-Prüfungen

Diese Einstellungen implementieren die oben beschriebenen Prüfungen. Jede aufgeführte Bedingung muss wahr sein:

```text
review_only_mode == false
auto_ban == true
write_admin_ini == true
ban_id is clean numeric
identity is mapped
not trusted
not moderator
threshold is met
account-specific evidence exists
```

Wenn eine Bedingung falsch ist oder nicht überprüft werden kann, lässt Guard die Sperrliste unverändert und zeichnet auf, was sie gestoppt hat.

<a id="transaction-safety"></a>
## Transaktionssicherheit

Der einzige `Admin.ini` Mutationspfad führt diese Schritte aus, um:

1. die Autorität zu lesen und strukturell zu validieren Bytes.
2. Leiten Sie den Status „Moderator“, „Vertrauenswürdig“ und „Vorhandenes Verbot“ aus demselben Snapshot ab.
3. Schreiben Sie ein eindeutiges Backup unter `runtime/backups/` und überprüfen Sie es Byte für Byte.
4. Lesen Sie `Admin.ini` unmittelbar vor dem Austausch erneut und lehnen Sie alle externen Daten ab ändern.
5. Schreiben Sie den Kandidaten über den konfigurierten kontrollierten Ersetzungspfad.
6. Erfordern Sie, dass die vollständigen Readback-Bytes den vollständigen Kandidatenbytes entsprechen.
7. Stellen Sie bei einem Readback-Fehler die verifizierte Sicherung nur wieder her, solange die aktuelle Datei noch genau der von Guard geschriebene Kandidat ist. Wenn ein anderer Autor es geändert hat, verweigert Guard ein Rollback, anstatt unbekannte externe Bytes zu überschreiben.

Doppelte IDs sind idempotent: Es werden keine zweite Zeile und kein zweites Backup geschrieben. Sicherungsnamen umfassen einen Zeitstempel, einen Quellbyte-Fingerabdruck und eine saubere ID, sodass separate Versuche den alten Dateinamen von einer Sekunde nicht gemeinsam nutzen können.

<a id="local-regression-proof"></a>
## Lokaler Regressionsnachweis

`tests/lua/enforcement_runtime_test.lua` startet den mitgelieferten Loader einmal und führt dann seinen echten lokalen `append_ban()` Abschluss für isolierte synthetische Dateien unterhalb des Repositorys aus `.tmp/` Verzeichnis. Es umfasst Einfügen, doppelte Idempotenz, moderator/trusted-Ablehnung, schwache und fehlerhafte Identitätsablehnung, bytegenaue Sicherungsüberprüfung, gleichzeitige Modifikationsablehnung, erfolgreiches Rollback nach fehlgeschlagenem Readback und die Weigerung, eine externe Änderung nach dem Schreiben zu überschreiben. Seine Dateisystem-Wrapper lehnen jede Mutation außerhalb des Fixture-Roots ab; Es wird kein echter Serverpfad oder echter `Admin.ini` verwendet.

Führen Sie es über `python tools/test_public_pipeline.py` aus. Ein Fixture-Durchlauf beweist nur das lokale Transaktionsverhalten. Es ermöglicht keine Durchsetzung, autorisiert keinen Produktionsschreibvorgang und weist auch keine hostspezifischen Berechtigungen nach.

<a id="files-to-check"></a>
## Zu überprüfende Dateien

```text
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
runtime/enforced_bans.jsonl
runtime/enforced.txt
runtime/ban_queue.json
```

<a id="rollback"></a>
## Rollback

1. Stoppen Sie den Server.
2. Stellen Sie die neueste Admin.ini Sicherung von `runtime/backups/`.
3. her. Entfernen Sie die falsche `BannedPlayer=<ID>` Zeile, wenn erforderlich.
4. Starten Sie den Server.
5. Erneut öffnen Admin.ini und bestätigen Sie, dass die Zeile bestehen bleibt oder entfernt wurde.
6. Bewahren Sie `enforced_bans.jsonl` für die Prüfung auf.

<a id="related-docs"></a>
## Verwandte Dokumente

* [`BAN_ID_MAPPING.md`](BAN_ID_MAPPING.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](WORKFLOW_ZUR_PLAYER-%C3%9CBERPR%C3%9CFUNG.md)
