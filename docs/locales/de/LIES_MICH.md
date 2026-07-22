# RandomDayGuard auf Deutsch

**v0.4.12-alpha**

RandomDayGuard wandelt begrenzte Belege eines Abiotic-Factor-Dedicated-Servers
in verständliche Betreiberberichte um. Serverstatus, Tagesübersicht,
Spieleraktivität, Fallprüfung und kritische Fehler bleiben getrennt.

## Installation

Folgen Sie der [Installationsanleitung](INSTALLATION.md). Der Mod gehört
nach `ue4ss/Mods/RandomDayGuard`; in `mods.txt` muss `RandomDayGuard : 1`
stehen. Vermeiden Sie verschachtelte Installationen und doppelte `Scripts`-Ordner.

## Ersten Bericht prüfen

Prüfen Sie `runtime/current/startup_status.json`, danach
`runtime/final_logs/latest_dossier.json` und
`runtime/final_logs/route_proof.json`. Jede Route meldet `full`,
`limited_expected_empty` oder `missing`. Bericht und zitierte Quelle müssen
zum selben Lauf gehören.

## Konfiguration und Betrieb

Die öffentlichen Voreinstellungen sind `review_only_mode = true`,
`auto_ban = false` und `write_admin_ini = false`. Lesen Sie [Start](HIER_BEGINNEN.md),
[Betrieb](OPERATIONS_PLAYBOOK.md), [Konfiguration](CONFIG_PROFILES.md)
und [Fehlerbehebung](FEHLERBEHEBUNG.md). Strukturierte Belege sind der
technische Datensatz; die Übersetzung macht ihn lesbar.

Befehle, Pfade, Schlüssel und Statuswerte bleiben zur sicheren Übernahme auf
Englisch.

## Alpha-Version und zwei Beweispfade

Dies ist eine Alpha-Version. Die dokumentierten Erfassungs-, Berichts- und Wiederherstellungswege wurden getestet; Kompatibilität, historische Abdeckung und Berichtsqualität werden weiter verbessert.

Der aktuelle Pfad verwendet aktives Log, aktuellen Start- und Schedulerzustand sowie laufende Sitzungen und kann deshalb aktuelle Berichte sofort schreiben. Der historische Pfad prüft aufbewahrte Logs, PlayerData-Dateinamen sowie vorhandene Belege und Fälle in begrenzten Schritten.

`runtime/current/report_worker_status.json`

Vergleichen Sie `scan_cursor` und `last_progress_ts` in `runtime/current/report_worker_status.json` über mehrere Zyklen. Wenn sie fortschreiten, arbeitet der Scan. Bleiben sie unverändert, während aktuelle Berichte weiterlaufen, ist der historische Scan blockiert; aktuelle Fakten bleiben nutzbar, ältere Schlussfolgerungen sind jedoch begrenzt.

[Troubleshooting](FEHLERBEHEBUNG.md)

## Vollständige Dokumentationsbibliothek

Jedes öffentliche Markdown-Dokument ist in dieser Sprache mit lokalisierten Dateinamen verfügbar.

- [Öffnen Sie den lokalisierten Dokumentationsindex](DOKUMENTATION.md)
