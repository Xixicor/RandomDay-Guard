<a id="status-and-error-reference"></a>
# Status- und Fehlerreferenz

> **Kanonisch-englische Quelle:** [STATUS_AND_ERROR_REFERENCE.md](../../STATUS_AND_ERROR_REFERENCE.md). Diese lokalisierte Dokumentation bewahrt genaue Befehle, Pfade, Schlüssel, Statuswerte, Hashes und Dateinamen. Wenn der technische Wortlaut abweicht, verwenden Sie die englische Quelle.


Verwenden Sie diese Referenz, nachdem ein Symptom in [Fehlerbehebung](FEHLERBEHEBUNG.md) klassifiziert wurde. Lesen Sie die im Fehler genannte strukturierte Statusdatei. Eindeutige Codes repräsentieren unterschiedliche Sicherheits- und Lebenszykluszustände. Reduzieren Sie sie nicht in einem generischen „Guard-fehlgeschlagen“-Ergebnis.

<a id="route-and-source-states"></a>
## Routen- und Quellstatus

| Wert | Bedeutung | Antwort des Betreibers |
|---|---|---|
| `full` | Der Routenvertrag wurde mit dem Quellennachweis des aktuellen Zyklus abgeschlossen. | Beweisgrenze der Route lesen; Es ist keine Reparatur impliziert. |
| `limited_expected_empty` | Die Route wurde abgeschlossen und die fehlende Aktivität ist für diesen Zyklus legitim. | Es sollte kein synthetisches player/caseEreignis erstellt werden. |
| `missing` | Eine erforderliche Ausgabe, ein Herkunftsfeld oder ein Quellennachweis fehlt. | Überprüfen Sie den Routengrund und den Status der benannten Quelle. |
| `available` | Die benannte Quelle war lesbar und verwendbar. | Keine Aktion. |
| `expected_empty` | Die Quelle wurde überprüft und hatte rechtmäßig keine Zeilen. | Keine Aktion, es sei denn, Aktivität wurde unabhängig erwartet. |
| `partial` / `complete_with_gaps` | Verwertbare Beweise liegen vor, aber benannte Quellklassen sind unvollständig. | Beschränken Sie Schlussfolgerungen auf gesammelte Beweise. |
| `deferred` | Begrenzte Arbeit ist für eine spätere Arbeitsmöglichkeit geplant. | Bestätigen Sie Fortschrittsfortschritte, bevor Sie die Konfiguration ändern. |
| `unavailable` | Die Umgebung hat die Quelle nicht bereitgestellt. | Notieren Sie den Grenzwert; Korrigieren Sie nur ein nachgewiesenes Pfad- oder Berechtigungsproblem. |
| `malformed` | Die Quelle war lesbar, hat jedoch die strukturelle Validierung nicht bestanden. | Bewahren Sie sie auf und reparieren Sie die Quelle; Nicht raten. |
| `permission_denied` | Die Quelle existiert, konnte aber nicht gelesen werden. | Gewähren Sie nur die eingeschränkte erforderliche Leseberechtigung. |
| `error` | Erfassung ist aus dem aufgezeichneten Grund fehlgeschlagen. | Behalten Sie den Fehler bei und diagnostizieren Sie diese Phase. |

<a id="playerdata-and-inventory-codes"></a>
## PlayerData und Inventarcodes

| Code | Bedeutung | Sichere Antwort |
|---|---|---|
| `saved_root_unavailable` | Für die öffentliche Pipeline war kein verifizierter gespeicherter Stamm verfügbar. | Richtig `SavedRoot.txt` und überprüfen Sie die Pfadprüfung erneut. |
| `unsafe_playerdata_root` | PlayerData Erkennung außerhalb der gelöst bounded Gespeichertes Stammverzeichnis. | Korrigieren Sie den Pfad; Schwächen Sie niemals die Grenze. |
| `playerdata_discovery_not_run` | Der begrenzte Discovery-Worker wurde noch nicht ausgeführt. | Überprüfen Sie den Planer- und Worker-Fortschritt. |
| `playerdata_discovery_read_failed:*` | Discovery-Ausgabe konnte nicht gelesen werden. | Behalten Sie die Suffixdetails bei und überprüfen Sie den begrenzten Inventarisierungsbefehl. |
| `inventory_command_open_failed` | Der Inventarisierungsprozess konnte nicht gestartet werden. | Überprüfen Sie, ob die Laufzeit die konfigurierte Befehlsbrücke bereitstellt. |
| `inventory_command_read_failed` | Inventarausgabe ist während des Lesens fehlgeschlagen. | Teilweise Ausgabe beibehalten und erst erneut ausführen, nachdem der zugrunde liegende Fehler behoben wurde. |
| `inventory_command_close_failed` | Inventarisierung ohne vertrauenswürdiges Abschlussergebnis abgeschlossen. | Behandeln Sie die Quelle als unvollständig. |
| `identity_ledger_row_limit_exceeded` | Die dauerhafte Identitätseingabe hat ihre öffentliche Sicherheitsgrenze überschritten. | Archivieren und überprüfen Sie das Hauptbuch; kürzen Sie es nicht stillschweigend auf einen vollständigen Beweis. |

<a id="adminini-enforcement-codes"></a>
## Admin.ini Durchsetzungscodes

Alle Codes in diesem Abschnitt sind fehlerfrei. Sie genehmigen selbst kein manuelles Verbot.

| Code | Bedeutung | Sichere Antwort |
|---|---|---|
| `admin_ini_write_disabled` / `admin_ini_disabled` | Öffentlich sichere Schreibtore sind deaktiviert. | Wird im Nur-Überprüfungsbetrieb erwartet. |
| `admin_ini_backup_disabled` / `backup_safety_gate_disabled` | Erforderliche Sicherungsrichtlinie ist nicht aktiv. | Schreibvorgänge deaktiviert lassen. |
| `enforcement_disabled` / `ban_on_threshold_disabled` / `auto_ban_disabled` | Ein explizites Erzwingungstor ist deaktiviert. | Wird in Nur-Überprüfungs-Standardeinstellungen erwartet; Interpretieren Sie es nicht als Schreibfehler. |
| `review_only_mode_enabled` | Der Nur-Überprüfungsmodus blockiert absichtlich die Mutation. | Nur Überprüfungsnachweise. |
| `duplicate_prevention_disabled` | Der Duplikatschutz wurde deaktiviert. | Schreibvorgänge deaktiviert lassen, bis die Sicherheitstür wiederhergestellt ist. |
| `readback_safety_gate_disabled` / `rollback_safety_gate_disabled` | Post-Write-Überprüfung oder Rollback-Schutz war deaktiviert. | Schreibvorgänge deaktiviert lassen; Umgehen Sie diese Tore niemals. |
| `clean_id_safety_gate_disabled` / `account_specific_evidence_gate_disabled` | Die Durchsetzung sauberer Identitäten oder kontospezifischer Beweise wurde deaktiviert. | Stellen Sie das Tor vor jedem Durchsetzungstest wieder her. |
| `moderator_preservation_disabled` / `existing_ban_preservation_disabled` | Die Beibehaltung geschützter Konten oder bestehender Sperren wurde deaktiviert. | Schreibvorgänge deaktiviert lassen. |
| `clean_numeric_identity_required` | Die vorgeschlagene ID ist nicht das vollständig akzeptierte Verbindungsformular oder die saubere numerische ID. | Erhalten Sie eine verifizierte Zuordnung; Schneiden Sie niemals ein willkürliches Präfix ab. |
| `identity_strength_below_minimum` | Der Identitätsnachweis ist schwächer als der konfigurierte Schwellenwert. | Nur Überprüfungsnachweise. |
| `playerdata_verification_required` | Die Konfiguration erfordert PlayerData eine Bestätigung und das Konto verfügt nicht über diese. | Behalten Sie den Kandidaten nur zur Überprüfung bei; Leiten Sie den Besitz nicht aus einem Dateinamen ab. |
| `trusted_or_moderator_identity` | Das Konto ist durch den Status „Vertrauenswürdig“ oder „Moderator“ geschützt. | Schreiben ist nicht zulässig. |
| `admin_ini_path_invalid` / `admin_ini_path_outside_saved_root` | Der Zielpfad ist ungültig oder entgeht dem gespeicherten Stammverzeichnis. | Korrekte Konfiguration; Umgehen Sie niemals den Pfadschutz. |
| `admin_ini_unavailable` | Keine lesbare Konfiguration Admin.ini wurde im gespeicherten Stammverzeichnis gefunden. | Korrigieren Sie den begrenzten Pfad oder lassen Sie die Durchsetzung deaktiviert. |
| `admin_ini_read_failed` | Authoritative Bytes konnten nicht gelesen werden. | Vor der Mutation anhalten. |
| `admin_ini_parse_failed` | Admin.ini Die Validierung ist ohne einen spezifischeren Strukturcode fehlgeschlagen. | Behalten Öffnen Sie die Datei und überprüfen Sie ihre Abschnitts- und Zeilenstruktur. |
| `admin_ini_contains_nul` | Die Datei enthält NUL Bytes und wird nicht als Text akzeptiert. | Bewahren Sie die Datei auf und reparieren Sie sie außerhalb von Guard. |
| `admin_ini_duplicate_banned_players_section` | Es gibt mehr als einen `[BannedPlayers]` Abschnitt. | Führen Sie Abschnitte im angehaltenen Zustand manuell zusammen. |
| `admin_ini_banned_player_outside_section` | Eine Ban-Zeile erscheint außerhalb `[BannedPlayers]`. | Korrigieren Sie das Layout manuell. |
| `admin_ini_invalid_banned_player_line` | Eine Ban-Zeile ist nicht gerade eine sauber unterstützte ID-Zeile. | Korrigieren Sie die fehlerhafte Zeile. |
| `admin_ini_backup_failed` | Das eindeutige Backup hat nicht byteidentisch geschrieben und zurückgelesen. | Keine Mutation ist zulässig. |
| `admin_ini_external_change_detected` | Ein anderer Autor hat die Datei nach dem Schnappschuss von Guard geändert. | Behalten Sie die externen Bytes bei und versuchen Sie es erst erneut, nachdem Sie die Autoren koordiniert haben. |
| `atomic_rename_unavailable` | Atomarer Ersatz wurde angefordert, aber Lua hat nicht bereitgestellt `os.rename`. | Kein Schreibvorgang ist vertrauenswürdig; Verwenden Sie eine unterstützte Laufzeit oder lassen Sie die Durchsetzung deaktiviert. |
| `admin_ini_write_failed` | Die kontrollierte Ersetzung wurde nicht abgeschlossen. | Überprüfen Sie den aufgezeichneten Ersetzungsfehler und die Sicherung. |
| `post_write_verification_failed` | Produktionsbytes stimmten nicht mit dem Kandidaten überein. | Überprüfen `rollback_success` und `rollback_refused_external_change` vor jeder Aktion. |

<a id="startup-scheduler-and-backlog-states"></a>
## Start-, Planer- und Backlog-Status

Diese Werte sind Lebenszyklusbeweise, keine Routenbeweise. Lesen Sie sie mit aktuellen Poll-, Report-Worker- und Route-Proof-Dateien.

| Wert | Bedeutung | Sichere Antwort |
|---|---|---|
| `not_started` | Die genannte Start- oder Scheduler-Phase hat noch nicht begonnen. | Warten Sie während des Starts auf das dokumentierte Intervall; Überprüfen Sie anschließend die erste unveränderte Phase. |
| `main_lua_loaded` / `starting` | Der kanonische Loader wurde ausgeführt und Guard trat in den Startvorgang ein. | Fahren Sie mit späteren Phasen fort; Dies allein ist keine Bereitschaft. |
| `saved_root_found` / `log_tail_initialized` / `epoch_started` | Kernquelle und Kontinuitätsinitialisierung fortgeschritten. | Keine Aktion, es sei denn, die nächste Phase schreitet nicht voran. |
| `admin_state_written` / `playerdata_index_written` | Anfängliche begrenzte Indizes wurden exportiert. | Keine Aktion; Die Übergabe des Zeitplaners muss noch erfolgen. |
| `watchdog_started` | Der Report- und Poll-Watchdog wurde registriert. | Bestätigen Sie als nächstes den Scheduler- und Poll-Fortschritt. |
| `ready_degraded` / `scan_running` | Guard läuft, während der begrenzte historische Scan noch aussteht. | Vorsicht, kein Fehler; Fortschrittszähler überprüfen. |
| `ready` | Start und der aktuelle Bounded Scan haben den Bereitschaftsstatus erreicht. | Routennachweis separat prüfen. |
| `scan_failed` / `error` | Start oder Scan mit einem aufgezeichneten Fehler beendet. | Behalten Sie die benannte Fehler- oder Statusdatei bei und diagnostizieren Sie diese Phase. |
| `running` | Der Planer besitzt zukünftige Umfragemöglichkeiten. | Bestätigen Sie, dass `poll_id` und `poll_completed_count`Vorab. |
| `manual_only` | Loop-Planung war nicht verfügbar; Es können nur explizite Arbeiten ausgeführt werden. | Behandeln Sie unbeaufsichtigte Vorgänge als nicht verfügbar. |
| `stopped` | Scheduler-Vorgang beendet. | Vorhergehende Stopp- und Fehlernachweise vor dem Neustart prüfen. |
| `active_log_caught_up` | Es verbleibt kein ungelesener Aktivprotokoll-Rückstand. | Historischer Scan kann fortgesetzt werden. |
| `active_log_unavailable_nonblocking` | Das aktive Protokoll war nicht vorhanden, aber der Start blockierte weiterhin nicht. | Zeichnen Sie das Quelllimit auf und überprüfen Sie andere Quellen. |
| `active_log_read_failed` | Das aktive Protokoll war vorhanden, konnte aber nicht gelesen werden. | Behalten Sie den Fehler bei und korrigieren Sie nur den nachgewiesenen Pfad oder das Berechtigungsproblem. |
| `budget_exhausted` / `active_log_has_unread_bytes` | Der begrenzte Tail Pass wurde mit verbleibendem Rückstand gestoppt. | Bestätigen Sie, dass spätere Abfragen die Anzahl der ungelesenen Daten reduzieren. |
| `offset_commit_failed_after_events_applied` | Ereignisse wurden verarbeitet, aber die dauerhafte Persistenz des Protokolloffsets ist fehlgeschlagen. | Die Durchsetzung wird verzögert; Reparieren Sie den Offset-Speicher, bevor Sie sich auf einen anderen Zyklus verlassen. |

<a id="scheduler-report-and-notification-codes"></a>
## Planer-, Berichts- und Benachrichtigungscodes

| Code oder Status | Bedeutung | Sichere Antwort |
|---|---|---|
| `poll already in flight` | Ein zweiter Rückruf ist eingetroffen, während die aktuelle Umfrage den Lebenszyklus besaß. | Bestätigen Sie die vorhandenen Umfragefortschritte; Fügen Sie keinen weiteren Schleifeneigentümer hinzu. |
| `no_log_files_found` | Es wurde kein konfiguriertes aktives oder Backup-Protokoll erkannt. | Gespeicherte Stamm- und Quellkonfiguration überprüfen. |
| `current_poll_error` | Der aktuelle Zyklus hat einen Abfragequellenfehler aufgezeichnet. | Lesen `runtime/current/poll_error.json`. |
| `cadence_deferred` | Der Abschluss-Dispatcher ist noch nicht fällig. | Wird bis zur nächsten begrenzten Gelegenheit erwartet. |
| `reports_disabled` | Die Erstellung öffentlicher Berichte ist deaktiviert. | Nur aktivieren, wenn Berichte beabsichtigt sind. |
| `local_outbox_write_failed` | Ein übersetzter lokaler Umschlag konnte nicht geschrieben werden. | Reparieren Sie das Laufzeitausgabeverzeichnis. Hierbei handelt es sich nicht um einen Benachrichtigungstransportfehler. |
| `source_accounting_disabled` | Routennachweis kann keine vollständige Quellenabdeckung beanspruchen. | Quellenabrechnung aktivieren oder fehlende Beweise explizit akzeptieren. |
| `route_disabled` | Die Route ist absichtlich deaktiviert. | Für diese Route wird keine Zustellung erwartet. |
| `poll_owner_between_polls` | Der Berichtsarbeiter steht in der Warteschlange für die Lücke zwischen dem Planer Umfragen. | Wird nur erwartet, während Zeitstempel und Cursor weiter voranschreiten. |
| `unsafe_shell_path` | Ein begrenzter Inventar- oder Shell-Pfad ist bei der plattformsicheren Validierung fehlgeschlagen. | Korrigieren Sie den Pfad; Schwächen Sie niemals die Angebots- oder Pfadvalidierung. |

<a id="related-procedures"></a>
## Verwandte Verfahren

- [Fehlerbehebung](FEHLERBEHEBUNG.md) für die Symptomklassifizierung und -reparatur.
- [Validierung und Release-Überprüfung](VALIDIERUNG_UND_FREIGABE.md) für Vorrichtungs- und Paketfehler.
- [Ausgabeschema-Referenz](REFERENZ_ZUM_AUSGABESCHEMA.md) für vollständige Feldverträge.
