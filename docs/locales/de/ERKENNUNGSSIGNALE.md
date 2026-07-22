<a id="detection-signals"></a>
# Erkennungssignale

> **Kanonisch-englische Quelle:** [DETECTION_SIGNALS.md](../../DETECTION_SIGNALS.md). Diese lokalisierte Dokumentation bewahrt genaue Befehle, Pfade, Schlüssel, Statuswerte, Hashes und Dateinamen. Wenn der technische Wortlaut abweicht, verwenden Sie die englische Quelle.


Signale sind Überprüfungseingaben, keine automatischen Anschuldigungen.

<a id="signal-table"></a>
## Signaltabelle

| Signal | Bedeutung | Stärker, wenn... | Alleine nicht ausreichen |
|---|---|---|---|
| Anmeldeidentität | Ordnet Namen der Konto-ID zu | ConnectID ist vorhanden | Verbot |
| Sauberes Verlassen | Normales Schließen der Sitzung | Beitreten und Spiel verlassen | Verdacht |
| Schnelle Wiederherstellung der Verbindung | Churn/probing Kontext | Wiederholt sich schnell | Verbot |
| Unsaubere Trennung | Sitzung wurde nicht sauber geschlossen | Wiederholt oder überlappt Abstürze | Verbot |
| Absturzüberlappung | Konto In der Nähe des Absturzes aktiv | Dasselbe Konto wird wiederholt | Verbot |
| Nach dem Absturz zurückgegeben | Das Konto wird nach dem Neustart zurückgegeben | Wiederholt sich über Epochen hinweg | Sperrung um ein Ereignis |
| Warnungsstoß | Server-Warnfenster | Überlappt zugeordnete Sitzungen | Sperrung um einen Stoß |
| Akteurspeicherung touch | Weltweit gültiger Kontext | Korreliert mit Sitzungen | Nachweis von use/theft |
| Objektdelta | World/classÄnderung | Korreliert mit Sitzungen | Verbot der alleinigen Zählung |
| Raid case | Multi-Account-Cluster | Zentrale Kontowiederholungen | Alle Konten massenhaft sperren |

<a id="login-identity"></a>
## Anmeldeidentität

Beste Quelle:

```text
Login request
Name=
ConnectID=
UniqueId=
```

Zur Zuordnung verwenden:

```text
display/log name -> account_id -> ban_id
```

<a id="rapid-reconnect"></a>
## Schnelle Wiederherstellung der Verbindung

Muster:

```text
join -> leave -> join -> leave -> join
```

Bei Wiederholung zur Überprüfung verwenden.

Sicherheit:

```text
churn_alone_never_bans = true
```

<a id="crash-overlap-and-post-crash-return"></a>
## Absturzüberlappung und Rückkehr nach dem Absturz

Muster:

```text
account active before crash
server restarts
same account returns quickly
```

Verwendung zur Überprüfung bei epochenübergreifender Wiederholung.

Sicherheit:

```text
single_crash_never_bans = true
```

<a id="warning-bursts"></a>
## Warnungsausbrüche

Beispiele:

```text
ActorChannelFailure
DeployableSaveWarning
UpdateActorToWorldSave
ServerMove warnings
```

Verwendung als Kontext, bis eine Verknüpfung mit zugeordneten Sitzungen und Schwellenwerten erfolgt.

<a id="actor-save-touch"></a>
## Akteurspeicherung touch

Bedeutung:

```text
The server evidence referenced a class or actor.
```

Nicht gemeint:

```text
A player opened it.
A player stole from it.
A player duplicated through it.
A player damaged it.
```

<a id="raid-cases"></a>
## Raid-Fälle

Ein Raid-Fall gruppiert Konten nach Zeitpunkt und gemeinsamen Fenstern.

Regel:

```text
Do not auto-ban every account in a raid case.
Each account needs account-specific evidence.
```

<a id="related-docs"></a>
## Verwandte Dokumente

* [`BAD_ACTOR_PATTERNS_AND_RESILIENCE.md`](BAD_ACTOR_PATTERNS_AND_RESILIENCE.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](WORKFLOW_ZUR_PLAYER-%C3%9CBERPR%C3%9CFUNG.md)
