<a id="memory-economy-and-output-files"></a>
# Économie de mémoire et fichiers de sortie

> **Source canonique en anglais:** [MEMORY_ECONOMY_AND_OUTPUTS.md](../../MEMORY_ECONOMY_AND_OUTPUTS.md). Cette documentation localisée conserve les commandes, chemins, clés, valeurs d'état, hachages et noms de fichiers exacts. Si la formulation technique diffère, utilisez la source anglaise.


Cette page explique quels fichiers se développent, quels fichiers sont écrasés et quoi télécharger pour un examen rapide.

<a id="fast-answer"></a>
## Réponse rapide

| Question | Ouverte |
|---|---|
| Le garde est-il vivant ? | `runtime/current/poll_status.json` |
| Qui a été vu ? | `runtime/account_evidence.json` |
| Qu'est-il arrivé aux sessions ? | `runtime/evidence/session_events.jsonl` |
| Que s'est-il passé aujourd'hui ? | `runtime/forensic_days/YYYY-MM-DD/` |
| Quel est le langage clair résumé ? | `runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt` |
| Qu'est-ce que la progression de l'analyse ? | `runtime/scan_progress.json` |
| Quel est le contexte mondial ? | `runtime/world_state/current/world_state_latest.json` |
| Quelles interdictions ont été écrites ? | `runtime/enforced_bans.jsonl` |

<a id="output-model"></a>
## Modèle de sortie

| Type | Comportement | Exemples |
|---|---|---|
| Instantanés actuels | Écrasés | `runtime/current/*.json` |
| Journaux d'événements | Ajout uniquement | `runtime/evidence/*.jsonl` |
| Tableaux | Mises à jour ou ajoutées | `*.tsv` |
| Lignes de référence | Réutilisé une fois terminé | `runtime/baselines/*` |
| Rapports quotidiens | Mise à jour sur place | `runtime/forensic_days/YYYY-MM-DD/*` |
| Journaux finaux | Résumés quotidiens en langage clair | `runtime/final_logs/YYYY-MM-DD/*` |

<a id="current-snapshots"></a>
## Instantanés actuels

Ceux-ci restent petits et répondent à « ce qui est vrai maintenant ».

```text
runtime/current/poll_status.json
runtime/current/session_state.json
runtime/current/active_accounts.json
runtime/current/forensic_today.json
runtime/current/forensic_today.md
runtime/current/forensic_today.txt
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/world_state/current/world_state_latest.json
```

<a id="player-summaries"></a>
## Résumés des joueurs

Ce sont les premiers fichiers à vérifier pour l'examen du compte.

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
```

Ils résument :

```text
account_id
ban_id
name
identity_confidence
first_seen
last_seen
join_count
leave_count
status
score
```

<a id="event-logs"></a>
## Journaux d'événements

Ceux-ci préservent la chronologie.

```text
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/warning_events.jsonl
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/evidence/live_defense_events.jsonl
```

<a id="daily-forensic-rollups"></a>
## Rapports médico-légaux quotidiens

Ce sont les packages de téléchargement rapide.

```text
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

Téléchargez l'un de ces dossiers lorsque vous souhaitez une analyse périodique rapide.

<a id="scan-and-baseline-files"></a>
## Fichiers d'analyse et de référence

Utilisez-les pour comprendre si le contexte mondial est partiel ou complet.

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/scan_complete.json
runtime/object_registry_partial.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
```

<a id="enforcement-files"></a>
## Fichiers d'application

Utilisez-les uniquement lorsque l'application est activée.

```text
runtime/enforced.txt
runtime/enforced_bans.jsonl
runtime/ban_queue.json
runtime/evidence/enforced_bans.jsonl
```

`Admin.ini` devraient recevoir uniquement :

```ini
BannedPlayer=<ID>
```

<a id="what-updates-when-a-player-joins"></a>
## Quelles mises à jour lorsqu'un joueur rejoint

Mises à jour attendues :

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/current/session_state.json
runtime/forensic_days/YYYY-MM-DD/players.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="what-updates-when-the-server-crashes-or-restarts"></a>
## Quelles mises à jour lorsque le serveur plante ou redémarre

Mises à jour attendues :

```text
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/crash_reconnects.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="what-updates-when-the-scan-progresses"></a>
## Ce qui est mis à jour au fur et à mesure de la progression de l'analyse

Mises à jour attendues :

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/object_registry_partial.json
runtime/world_state/current/world_state_latest.json
runtime/forensic_days/YYYY-MM-DD/forensic_day_summary.json
```

<a id="what-to-upload-for-quick-analysis"></a>
## Ce qu'il faut télécharger pour une analyse rapide

Meilleur package :

```text
runtime/final_logs/YYYY-MM-DD/
```

Package plus complet :

```text
runtime/forensic_days/YYYY-MM-DD/
```

Package de preuves complet :

```text
runtime/account_evidence.json
runtime/evidence/session_events.jsonl
runtime/server_lifecycle_events.jsonl
runtime/warning_events.jsonl
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

<a id="related-docs"></a>
## Documents associés

* [`FORENSIC_DAILY_ROLLUPS.md`](RAPPORTS_QUOTIDIENS_M%C3%89DICO-L%C3%89GAUX.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](R%C3%89F%C3%89RENCE_DU_SCH%C3%89MA_DE_SORTIE.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](FLUX_DE_TRAVAIL_DE_R%C3%89VISION_DU_LECTEUR.md)
