<a id="bad-actor-patterns-and-resilience"></a>
# Modèles d'acteurs malveillants et résilience

> **Source canonique en anglais:** [BAD_ACTOR_PATTERNS_AND_RESILIENCE.md](../../BAD_ACTOR_PATTERNS_AND_RESILIENCE.md). Cette documentation localisée conserve les commandes, chemins, clés, valeurs d'état, hachages et noms de fichiers exacts. Si la formulation technique diffère, utilisez la source anglaise.


Utilisez cette page pour comprendre comment le gardien aide à examiner les abus en cas de crash, les comportements adjacents aux exploits et la planification de la récupération.

<a id="what-the-guard-can-help-with"></a>
## Ce que le gardien peut vous aider

| Modèle | Que vérifier |
|---|---|
| Retours corrélés aux crashs | Même compte actif avant le crash et revenu après le redémarrage |
| Sonde de reconnexion rapide | Boucles join/leave ou timeout/reconnect répétées |
| Clusters multi-comptes | Vagues de jointure, fenêtres d'avertissement partagées, fenêtres d'échec partagées |
| Stress d'avertissement | Boucles ActorChannelFailure ou les fenêtres d'avertissement de sauvegarde |
| Contexte hors limites | PlayerData/map/world contexte lorsqu'il est lisible |
| Chevauchement des sauvegardes | Contexte de sauvegarde mondial chevauchant les sessions mappées |
| Confusion d'identité | Noms nécessitant un mappage ConnectID |

<a id="why-it-avoids-memory-access"></a>
## Pourquoi évite-t-il l'accès à la mémoire

RandomDayGuard fonctionnent à partir de fichiers appartenant au serveur :

```text
Saved/Logs/*.log
Admin.ini
World saves
PlayerData
Backups
runtime evidence
```

Cela le rend moins dépendant de l'état de la mémoire côté client et moins fragile lors des mises à jour du jeu.

Compromis :

```text
It cannot prove hidden live actions unless the server writes evidence.
```

<a id="crash-correlated-returners"></a>
## Revenants corrélés aux crashs

Modèle :

```text
Account joins.
Server crashes or restarts.
Same account reconnects quickly.
Pattern repeats.
```

Fichiers utiles :

```text
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/account_evidence.json
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="rapid-reconnect-probers"></a>
## Rapide reconnecter les sondeurs

Modèle :

```text
join -> leave -> join -> leave -> join
```

Fichiers utiles :

```text
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/players.tsv
```

<a id="multi-account-clusters"></a>
## Clusters multi-comptes

Modèle :

```text
Several accounts join in the same window.
Warnings or crashes follow.
Some accounts rotate or reconnect after restart.
```

Fichiers utiles :

```text
runtime/raid_cases/
runtime/forensic_days/YYYY-MM-DD/raid_cases.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

Règle :

```text
A cluster is not a mass-ban list.
Each account still needs its own evidence.
```

<a id="sticky-backup-recommendation"></a>
## Recommandation de sauvegarde persistante

Créer une sauvegarde persistante après :

```text
first full baseline completes
object_registry.json exists
file_manifest.tsv exists
world_state_latest.json has scan_complete=true
Admin.ini is verified
trusted IDs are configured
```

Sauvegarde :

```text
RandomDayGuard/config.lua
RandomDayGuard/SavedRoot.txt
RandomDayGuard/runtime/baselines/
RandomDayGuard/runtime/object_registry.json
RandomDayGuard/runtime/world_state/current/world_state_latest.json
Saved/SaveGames/Server/Admin.ini
```

<a id="recovery-model"></a>
## Modèle de récupération

```text
Clean install
-> verify live defense
-> complete first baseline
-> create sticky backup
-> run server normally
-> use daily rollups for review
-> restore sticky backup if needed
```

<a id="related-docs"></a>
## Documents associés

* [`FORENSIC_DAILY_ROLLUPS.md`](RAPPORTS_QUOTIDIENS_M%C3%89DICO-L%C3%89GAUX.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](FLUX_DE_TRAVAIL_DE_R%C3%89VISION_DU_LECTEUR.md)
* [`WORLD_SAVE_FOLDER_CHANGES.md`](MODIFICATIONS_DU_DOSSIER_DE_SAUVEGARDE_MONDIALE.md)
