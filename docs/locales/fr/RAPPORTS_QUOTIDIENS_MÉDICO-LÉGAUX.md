<a id="forensic-daily-rollups"></a>
# Consolidations quotidiennes médico-légales

> **Source canonique en anglais:** [FORENSIC_DAILY_ROLLUPS.md](../../FORENSIC_DAILY_ROLLUPS.md). Cette documentation localisée conserve les commandes, chemins, clés, valeurs d'état, hachages et noms de fichiers exacts. Si la formulation technique diffère, utilisez la source anglaise.


Le cumul quotidien est un index reconstructible. Les sources de preuve font toujours autorité ; le dossier quotidien et le journal final sont des packages de révision rapide générés à partir des preuves d'exécution.

Utilisez cette page lorsque vous souhaitez télécharger un dossier pour une analyse rapide.

<a id="what-it-is"></a>
## Qu'est-ce que c'est
Le cumul quotidien est un résumé reconstructible des preuves brutes pour une journée.

Il ne remplace pas les preuves brutes.

```text
Source evidence = truth
Daily rollup = fast index
Final log = plain-language summary
```

<a id="where-it-writes"></a>
## Où il est écrit
Jour actuel :

```text
runtime/current/forensic_today.json
runtime/current/forensic_today.md
runtime/current/forensic_today.txt
```

Forfait quotidien :

```text
runtime/forensic_days/YYYY-MM-DD/
- forensic_day_summary.json
- forensic_day_summary.md
- forensic_day_summary.txt
- players.tsv
- sessions.tsv
- crash_reconnects.tsv
- warning_bursts.tsv
- raid_cases.tsv
- world_context.tsv
- ban_recommendations.tsv
- enforcement_audit.tsv
- evidence_index.json

## Final log contents
```text
runtime/final_logs/YYYY-MM-DD/
- final_forensic_log.txt
- final_forensic_log.md
- final_forensic_log.json

Le TXT est écrit en langage clair pour un examen rapide par l'opérateur.

<a id="what-the-final-txt-should-answer"></a>
## Que devrait répondre la TXT finale
```text
Did the guard run?
Was the scan partial or complete?
Who joined?
Who left cleanly?
Who did not leave cleanly?
Who rapidly reconnected?
Who overlapped crashes?
Who returned after crashes?
Who had warning overlap?
Who appears in a cluster?
Who is REVIEW?
Who is BAN-ELIGIBLE?
Which BannedPlayer=<ID> lines are candidates?
Which gates blocked enforcement?
What evidence files support each recommendation?
```

<a id="source-files-used"></a>
## Fichiers sources utilisés
Le cumul peut lire ces éléments lorsqu'ils sont présents :

```text
runtime/account_evidence.json
runtime/account_evidence.tsv
runtime/evidence/session_events.jsonl
runtime/session_events.tsv
runtime/server_lifecycle_events.jsonl
runtime/server_epochs.jsonl
runtime/evidence/crash_reconnect_events.jsonl
runtime/evidence/live_defense_events.jsonl
runtime/warning_events.jsonl
runtime/raid_cases/
runtime/world_state/current/world_state_latest.json
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/scan_complete.json
runtime/object_registry.json
runtime/enforced_bans.jsonl
runtime/enforced.txt
runtime/ban_queue.json
```

Les fichiers manquants doivent être marqués comme manquants et non traités comme fatals.

<a id="update-behavior"></a>
## Comportement de mise à jour
Le même jour, le gardien met à jour les mêmes fichiers.

Correct :

```text
runtime/forensic_days/2026-05-13/forensic_day_summary.json
```

Faux :

```text
forensic_day_summary_1.json
forensic_day_summary_2.json
forensic_day_summary_3.json
```

<a id="crash-safety"></a>
## Sécurité en cas de crash
Le gardien doit d'abord écrire les fichiers temporaires, puis les renommer :

```text
final_forensic_log.txt.tmp -> final_forensic_log.txt
players.tsv.tmp -> players.tsv
forensic_day_summary.json.tmp -> forensic_day_summary.json
```

Cela protège le dernier bon résumé si le serveur plante en cours d'écriture.

<a id="playerstsv-columns"></a>
## `players.tsv` colonnes
```text
date
account_id
ban_id
name
identity_confidence
playerdata_verified
first_seen
last_seen
join_count
leave_count
clean_leave_count
unclean_disconnect_count
rapid_rejoin_count
crash_overlap_count
post_crash_reconnect_count
warning_overlap_count
raid_case_count
world_context_count
score
status
recommended_action
ban_eligible
already_enforced
admin_ini_line
```

<a id="ban_recommendationstsv-columns"></a>
## `ban_recommendations.tsv` colonnes
```text
date
account_id
ban_id
name
status
recommended_action
reason
admin_ini_line
gates_passed
blocked_by
evidence_files
```

<a id="review-rule"></a>
## Règle d'examen
Un cumul quotidien peut accélérer l'examen, mais il ne doit pas être la seule preuve.

Lorsqu'une recommandation est importante, vérifiez avec :

```text
account_evidence.json
session_events.jsonl
server_lifecycle_events.jsonl
warning_events.jsonl
world_state files
enforced_bans.jsonl
```

<a id="related-docs"></a>
## Documents associés
* [`MEMORY_ECONOMY_AND_OUTPUTS.md`](%C3%89CONOMIE_DE_M%C3%89MOIRE_ET_SORTIES.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](FLUX_DE_TRAVAIL_DE_R%C3%89VISION_DU_LECTEUR.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](R%C3%89F%C3%89RENCE_DU_SCH%C3%89MA_DE_SORTIE.md)
