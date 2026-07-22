<a id="worked-operation-examples"></a>
# Beispiele für funktionierende Operationen

> **Kanonisch-englische Quelle:** [EXAMPLE_RUNS.md](../../EXAMPLE_RUNS.md). Diese lokalisierte Dokumentation bewahrt genaue Befehle, Pfade, Schlüssel, Statuswerte, Hashes und Dateinamen. Wenn der technische Wortlaut abweicht, verwenden Sie die englische Quelle.


Diese Beispiele verwenden erfundene Werte, um erwartete Zustandsübergänge zu erklären; Sie sind keine Live-Kompatibilität oder Spielerbeweise.

<a id="successful-current-cycle"></a>
## Erfolgreicher aktueller Zyklus

Eingaben: lesbares aktives Protokoll, version/boot/epoch, `poll_id=41`, abgeschlossene aktuelle Umfrage, beschreibbare accounting/history/report Roots, keine blockierende Slow-Scan-Richtlinie.

Erwartet:

```text
server_status = full
player_activity = full or limited_expected_empty
case_review = full or limited_expected_empty
daily_rollup = full or limited_expected_empty
critical_guard = full or limited_expected_empty
```

Jede aktivierte Route hat eine JSON/TXT Ausgabe und die gleiche Herkunft in `route_proof.json`. Der Routenstatus hängt von seinen eigenen Themen ab, nicht von einer generischen Erfolgsmeldung.

<a id="expected-empty-player-and-case-routes"></a>
## Erwartete-leere Spieler- und Fallrouten

Eingaben: Der Nachweis des aktuellen Zyklus ist abgeschlossen; keine aktuellen oder beibehaltenen Spielerreihen; kein beibehaltener Fall und kein aktuelles REVIEW/BAN-ELIGIBLEKonto.

Erwartet:

```text
player_activity.route_proof_status = limited_expected_empty
player_activity.expected_empty = true
player_activity.players = []

case_review.route_proof_status = limited_expected_empty
case_review.expected_empty = true
case_review.cases = []
```

Die übersetzten Berichte besagen, dass kein berechtigtes begrenztes Subjekt beobachtet wurde. Sie sagen auch, dass dies nicht beweist, dass sich nie jemand verbunden hat oder dass kein Kontext fehlt. Es wird kein Platzhalter player/case erstellt.

<a id="partial-bounded-scan"></a>
## Partial Bounded Scan

Eingaben: Neue aktuelle log/poll; `scan_checkpoint.json` oder `scan_progress.json` vorhanden; Scan ist unvollständig; Standard `slow_world_scan_blocks_current_reports=false`.

Erwartet:

```text
world_save_scan.status = partial
source accounting = partial
server_status may still be full for fresh current state
historical routes name the scan limitation
```

Legen Sie `slow_world_scan_blocks_current_reports=true` nur fest, wenn der Betreiber möchte, dass diese optionale langsame Quelle aktuelle Berichte blockiert. Bei der Wiederherstellung soll es dem Scan-Worker ermöglicht werden, fortzufahren, und nicht, den Prüfpunkt zu löschen.

<a id="missing-current-cycle-proof"></a>
## Fehlender Nachweis des aktuellen Zyklus

Eingaben: Aktives Protokoll nicht verfügbar, `poll_id=0` oder boot/epoch/last-poll Abstammung fehlt.

Erwartet:

```text
current_cycle_proof_complete = false
all route proof statuses = missing
each configured route envelope status = suppressed_current_cycle
delivery_eligible = false
delivery_attempted = false
```

Der unterdrückte Umschlag ist ein Prüfdatensatz, keine Lieferung in der Warteschlange. Alte endgültige Protokolle bleiben nur historisch. Reparieren Sie das erste fehlende lineage/source-Feld und einen neueren Zyklus generieren.

<a id="malformed-optional-adminini-source"></a>
## Falsch formatierte optionale Admin.ini-Quelle

Eingaben: `Admin.ini` ist vorhanden, schlägt aber bei der sauberen Strukturvalidierung fehl.

Erwartet:

```text
admin_ini.status = malformed
source reference preserved
write/enforcement path closed
```

Bewahren Sie die Datei auf und stellen Sie ein überprüftes sauberes Format wieder her. Behalten Sie erläuternden Text im Laufzeitbeweis bei; Jeder `Admin.ini` Ban-Eintrag bleibt nur bestehen. `BannedPlayer=<ID>`.

<a id="required-active-log-probe-error"></a>
## Erforderlicher Active-Log-Probe-Fehler

Eingaben: Der begrenzte erforderliche Active-Log-Probe schlägt mit einem bereinigten Lesefehler fehl.

Erwartet:

```text
source_accounting.sources[active_log].status = error
source_accounting.sources[active_log].detail = "bounded active-log probe failed: <sanitized reason>"
coverage_status = unavailable
all route proof statuses = missing
```

`error` bleibt mit seinem begrenzten Detail in der Quellzeile. Der Bericht der obersten Ebene verwendet `unavailable` und der Routennachweis bleibt `missing` bestehen, bis ein neuerer aktueller Zyklus die erforderliche Quelle nachweist.

<a id="incompatible-or-stale-baseline"></a>
## Inkompatible oder veraltete Basislinie

Eingaben: geänderte package/source Identität oder stale/incompatible Basismanifest.

Erwartet: Validierung oder Laufzeitstatus zeichnen die Inkompatibilität auf; Der Scan-Status erhebt keinen Anspruch auf eine abgeschlossene Wiederverwendung. Behalten Sie frühere Beweise bei, starten Sie eine explizite Baseline-Neuerstellung und warten Sie auf neue Terminalbeweise. Eine erzwungene Neuerstellung ohne aufgezeichneten Grund ist nicht die Standardwiederherstellung.

<a id="paired-report-write-failure"></a>
## Fehler beim Schreiben gepaarter Berichte

Eingaben: JSONSchreiben ist erfolgreich, aber TXTSchreiben schlägt fehl, oder umgekehrt.

Erwartet:

```text
route_proof_status = missing
completed = false
coverage_status = unavailable
output_write_detail = "paired JSON/TXT write failed: <sanitized reason>"
next_action = repair both route output writes
```

Der Writer schreibt nach besten Kräften beide Geschwister neu, um bei einem Fehler zu konvergieren. Ein erfolgreiches Geschwisterkind kann nicht als Erfolgsanspruch bestehen bleiben. Das begrenzte Schreibdetail erstellt keinen fünften Abdeckungswert der obersten Ebene.

<a id="route-proof-write-failure"></a>
## Routensicherer Schreibfehler

Eingaben: Routenpaare wurden geschrieben, aber `route_proof.json` können nicht ersetzt werden.

Erwartet: Alle Berichte werden neu geschrieben `missing`, alle Benachrichtigungsergebnisse sind `route_proof_write_failed` und es wird kein Umschlag akzeptiert. Eine konfigurierte Route verfügt möglicherweise über einen `suppressed_current_cycle`-Prüfumschlag mit den Zustellungsflags „false“. Reparieren Sie das Ausgabestammverzeichnis und generieren Sie denselben aktuellen Zyklus neu.

<a id="review-only-enforcement-example"></a>
## Nur Überprüfungsbeispiel für die Durchsetzung

Konfiguration:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

Erwartet: Bewertungen, Fälle und Empfehlungen können geschrieben werden; `Admin.ini` bleibt unverändert. Dies ist die öffentliche Standardeinstellung.

<a id="approved-write-success-example"></a>
## Genehmigtes Schreiberfolgsbeispiel

Nur ein separat genehmigter Test darf alle drei Schreibschalter setzen. Es muss außerdem eine saubere numerische Identität, trust/moderator Ausschluss, Schwellenwertberechtigung, Gültigkeit Admin.ini path/parse, Sicherungserfolg, Schreiberfolg, Lesegleichheit und kontospezifische Beweise nachweisen.

Erwartet:

```text
runtime/backups/Admin_<timestamp>_<source-fingerprint>_<clean-ID>.ini
Admin.ini contains one clean BannedPlayer=<ID>
runtime/enforced_bans.jsonl and evidence mirror record success
```

Das erfolgreiche Beispiel ermöglicht keine automatische Durchsetzung für andere Konten.

<a id="writereadback-failure-with-rollback"></a>
## Write/readback Fehler mit Rollback

Eingaben: jedes übergebene Pre-Write-Gate; Ersatzschreiben oder Rücklesen schlägt fehl; `rollback_on_readback_failure=true` und das verifizierte Backup ist verfügbar.

Erwartet: Fehlernachweis zeichnet die Phase auf und `rollback_success`; Die ursprünglichen Admin.ini Bytes werden wiederhergestellt und das Konto wird nicht als erfolgreich erzwungen gemeldet. Wenn das Rollback ebenfalls fehlschlägt, stoppen Sie die Schreibvorgänge, behalten Sie beide files/evidence bei und stellen Sie die Sicherung manuell wieder her.

<a id="local-outbox-example"></a>
## Beispiel für einen lokalen Postausgang

Eingaben: Benachrichtigung im `local_file_outbox`-Modus aktiviert, Route aktiviert, Routennachweis abgeschlossen und entweder `full` oder explizit erlaubt erwartet-leer.

Erwarteter Umschlag:

```text
schema = randomdayguard.notification/v1
completed_output = true
status = ready_for_local_consumer
delivery_eligible = true
delivery_backend = none
delivery_attempted = false
```

Für missing/ineligible ausgegeben, kann derselbe Pfad stattdessen `status=suppressed_current_cycle`, `completed_output=false` übereinstimmen, und `delivery_eligible=false` enthalten. Jede Datei weist nur einen lokalen Schreibvorgang nach. Es wird kein Anbieter, Transport, Lieferung oder Lesebestätigung gebündelt oder abgeleitet.

Siehe [`OUTPUT_SCHEMA_REFERENCE.md`](REFERENZ_ZUM_AUSGABESCHEMA.md), [`CONFIG_FIELD_CATALOG.md`](CONFIG_FIELD_CATALOG.md) übereinstimmen, und [`TROUBLESHOOTING.md`](FEHLERBEHEBUNG.md).
