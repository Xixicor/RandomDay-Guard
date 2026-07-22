<a id="faq"></a>
# FAQ

> **Source canonique en anglais:** [FAQ.md](../../FAQ.md). Cette documentation localisée conserve les commandes, chemins, clés, valeurs d'état, hachages et noms de fichiers exacts. Si la formulation technique diffère, utilisez la source anglaise.


<a id="is-randomdayguard-the-randomday-mod"></a>
## Est RandomDayGuard le RandomDay Mod ?

Non. RandomDay Le mod change l'expérience du serveur. RandomDayGuard surveille la couche de preuves du serveur.

<a id="does-live-defense-work-before-the-scan-completes"></a>
## La défense en direct fonctionne-t-elle avant la fin de l'analyse ?

Oui. La défense en direct utilise les journaux et les événements de session. L'analyse de base améliore le contexte plus tard.

<a id="why-can-the-first-scan-take-a-long-time"></a>
## Pourquoi la première analyse peut-elle prendre beaucoup de temps ?

La première analyse crée world/object le contexte, les manifestes de fichiers et les données de base réutilisables.

<a id="what-do-i-check-first-after-startup"></a>
## Que dois-je vérifier en premier après le démarrage ?

```text
runtime/current/poll_status.json
```

Recherchez :

```text
scheduler_status=running
poll_id increasing
poll_in_flight=false
```

<a id="where-are-player-summaries"></a>
## Où se trouvent les joueurs résumés ?

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
```

<a id="where-is-the-daily-quick-review-package"></a>
## Où se trouve le package de révision rapide quotidienne ?

```text
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

<a id="which-file-should-i-upload-for-fastest-review"></a>
## Quel fichier dois-je télécharger pour une révision plus rapide ?

```text
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="can-it-write-bans-automatically"></a>
## Peut-il écrire des interdictions automatiquement ?

Uniquement s'il est explicitement activé.

Par défaut :

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

<a id="what-does-adminini-receive"></a>
## Que reçoit Admin.ini ?

Uniquement :

```ini
BannedPlayer=<ID>
```

Aucun nom, commentaire, motif ou suffixe.

<a id="is-a-display-name-enough-to-ban"></a>
## Un nom d'affichage suffit-il pour interdire ?

Non. Utilisez un journal du serveur `Login request` avec `ConnectID` ou une preuve de serveur équivalente.

<a id="can-one-crash-ban-someone"></a>
## Peut-on bannir quelqu'un en crash ?

Non par défaut.

<a id="can-object-count-alone-ban-someone"></a>
## Le nombre d'objets peut-il à lui seul bannir quelqu'un ?

Non par défaut.

<a id="should-savedroottxt-point-to-the-world-folder"></a>
## Devrait-il SavedRoot.txt pointer vers le monde dossier ?

Non. Pointez-le vers `AbioticFactor/Saved`.

<a id="what-if-the-world-folder-changes"></a>
## Et si le dossier mondial change ?

Traitez-le comme un changement d'identité de base. Conservez l'ancienne référence et créez-en une nouvelle.

<a id="related-docs"></a>
## Documents associés

* [`START_HERE.md`](COMMENCER_ICI.md)
* [`FORENSIC_DAILY_ROLLUPS.md`](RAPPORTS_QUOTIDIENS_M%C3%89DICO-L%C3%89GAUX.md)
* [`TROUBLESHOOTING.md`](D%C3%89PANNAGE.md)
