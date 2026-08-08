# RandomDayGuard auf Deutsch

> [!IMPORTANT]
> ## Projektstatus — RandomDay-Testphase abgeschlossen
>
> Der RandomDay-Testbetrieb ist abgeschlossen; der öffentliche Testserver wird demnächst geschlossen.
>
> Während dieses Betriebs liefen RandomDay und RandomDayGuard gemeinsam durch wiederholte Profilwechsel, normale und unterbrochene Serverneustarts, Wiederherstellungs- und Rollback-Prüfungen, die Einbindung erweiterter Mods, die Sammlung von Servernachweisen und die Prüfung der Betreiberberichte.
>
> Damit haben wir das angestrebte Wissen gewonnen: wie sich wechselnde Sandbox-Profile über reale Lebenszyklen eines dedizierten Servers verhalten, wie RandomDay mit unterstützten erweiterten Mods zusammenspielt und in welchem Umfang RandomDayGuard die vom Server geschriebenen Nachweise in eine nützliche, vorsichtige Überwachung umwandeln kann, ohne Lücken oder Vermutungen als Tatsachen darzustellen.
>
> **Verwendeter Testserver-Stack:**
>
> - RandomDay private Entwicklungsversion `v0.41.76`
> - RandomDayGuard private Entwicklungsversion `v0.46.130`
> - Chaotic Spawn Engine / DynamicSpawns `0.8.5 Hotfix 1`
> - Lethal Lasers `1.0 UE4SS`
> - ANTE Up `0.26`
> - Encounter Director integration — eine RandomDay-eigene DynamicSpawns-Erweiterung, keine separat vertriebene Mod
> - UE4SS `v3.0.1 Beta #0` (Git `01e0a584`; Nexus `v3.0.1-940-g01e0a584`)
> - dedizierter Abiotic-Factor-Server `1.4.0.27939`
>
> Die derzeit veröffentlichten Pakete bleiben RandomDay `v0.3.16-alpha` und RandomDayGuard `v0.4.12-alpha`.
>
> Die Entwicklung beider Projekte ist vorerst pausiert. Die bestehenden Releases und Dokumentationen bleiben verfügbar; möglicherweise kehren wir zurück, wenn wir wieder den Wunsch verspüren, die Arbeit fortzusetzen.
>
> Dieser Stack dokumentiert, was während des Betriebs eingesetzt wurde; er ist weder eine Mindestversionsanforderung noch eine Kompatibilitätsgarantie für spätere Spiel-, Loader- oder Mod-Versionen. Der letzte formell dokumentierte Zyklus verwendete Abiotic Factor `1.4.0.27939`.

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
