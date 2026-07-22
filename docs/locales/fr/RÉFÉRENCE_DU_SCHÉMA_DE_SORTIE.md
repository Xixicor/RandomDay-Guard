<a id="output-and-state-schema-reference"></a>
# Référence du schéma de sortie et d'état

> **Source canonique en anglais:** [OUTPUT_SCHEMA_REFERENCE.md](../../OUTPUT_SCHEMA_REFERENCE.md). Cette documentation localisée conserve les commandes, chemins, clés, valeurs d'état, hachages et noms de fichiers exacts. Si la formulation technique diffère, utilisez la source anglaise.


Il s'agit du contrat canonique pour les fichiers générés destinés à l'opérateur. Lui seul possède les chemins de sortie exacts, les noms de champs, les valeurs autorisées, les exigences de lignage et les schémas de route. Les guides de procédure établissent un lien ici au lieu de redéfinir ces faits.

Les preuves d'exécution font autorité ; un nom de fichier, un battement de cœur de planificateur, un rapport traduit ou un objet de boîte d'envoi local ne prouvent rien de plus que ses propres champs et lignées.

<a id="public-report-routes"></a>
## Itinéraires de rapport publics

Le générateur de rapports possède cinq itinéraires conformément aux exigences `runtime/final_logs/`:

| Itinéraire | Contrat | `full` | Signification attendue vide |
|---|---|---|---|
| `server_status` | Planificateur actuel, journal actif, analyse en attente et état de couverture de la source. | Événements boot/epoch/poll lignée, nouveau journal actif, accounting/history écritures et JSON/TXT paire. | Non utilisé pour un cycle actuel par ailleurs sain ; la lignée manquante est `missing`. |
| `daily_rollup` | Événements day/window la continuité entre le serveur, les joueurs, les cas, l'analyse et la couverture. | Terminal de comptabilité historique suffisant pour la preuve complète de l'itinéraire et du cycle actuel. | Aucun joueur retenu et aucun cas de révision. |
| `player_activity` | Séparez les observations actuelles et historiques player/account. | Preuve du cycle actuel plus une ou plusieurs current/historical lignes. | Aucune ligne de lecteur éligible dans les entrées limitées ; aucun sujet synthétique. |
| `case_review` | Cas nommés retenus et review/BAN-ELIGIBLE candidats actuels. | Preuve du cycle actuel plus un ou plusieurs cas nommés avec références sources. | Aucun cas nommé ne répond aux critères d'examen ; aucun cas synthétique. |
| `critical_guard` | Échec du planificateur de démarrage actuel, du démarrage, de l'interrogation ou de l'intégrité des preuves. | Preuve du cycle actuel plus une défaillance critique actuelle. | Aucune défaillance critique actuelle ; les anciennes erreurs de texte ne possèdent pas cette route. |

Chaque route activée écrit `<route>_latest.json` et `<route>_latest.txt`. La paire n'est pas terminée tant que `runtime/final_logs/route_proof.json` n'enregistre pas la même version, le même démarrage, la même époque, le même sondage et la même fraîcheur de source.

<a id="report-json-schema"></a>
## Rapport JSON schéma

Tous les chemins d'itinéraire JSON utilise `schema="randomdayguard.report/v1"`.

| Champ | Type | Signification et invariant |
|---|---|---|
| `schema` | chaîne | Exactement `randomdayguard.report/v1`. |
| `generated_ts`, `report_date` | chaîne | Horodatage de génération et date de rapport. |
| `version` | chaîne | Runtime/package identité pour ce cycle. |
| `boot_id`, `epoch_id` | chaîne | Époque de démarrage du processus actuel et de continuité du serveur. Les deux sont requis pour terminer. |
| `poll_id` | entier | Identificateur de sondage actuel positif. Zero/missing ne peut pas terminer un itinéraire. |
| `source_freshness` | objet | `status`, `checked_ts`, état du journal actif, horodatage du dernier sondage et horodatage du dernier sondage terminé. |
| `current_cycle_proof_complete` | booléen | Vrai uniquement lorsque la lignée et les nouvelles active-log/current-poll preuves concordent. |
| `route` | enum | L'une des cinq routes ci-dessus. |
| `route_proof_status` | enum | `full`, `limited_expected_empty`, ou `missing`. |
| `coverage_status` | enum | Exactement `complete`, `complete_with_gaps`, `partial`, ou `unavailable`. |
| `completed`, `expected_empty` | booléen | `completed` est faux uniquement pour `missing`; `expected_empty` est vrai uniquement pour `limited_expected_empty`. |
| `observed` | tableau de chaînes | Béton conservé facts/counts/statuses. |
| `interpretation` | tableau de chaînes | Signification prudente calibrée en fonction des preuves. |
| `unknown` | tableau de chaînes | Identité manquante, historique, source ou contexte. |
| `does_not_prove` | tableau de chaînes | Conclusions que les preuves ne peuvent pas appuyer. |
| `next_action` | chaîne | Action limitée de l'opérateur la plus sûre. |
| `source_references` | tableau de chaînes | Références uniques triées runtime/Saved. |
| `enforcement_authority` | booléen | Toujours fausses. Un rapport n'autorise jamais une écriture. |
| `output_paths` | deux chaînes | JSON et TXT ajoutés avant les écritures appariées. |

`coverage_status` concerne uniquement la comptabilité de niveau supérieur. Les enregistrements source sont propriétaires séparément `available`, `expected_empty`, `partial`, `deferred`, `unavailable`, `malformed`, `permission_denied` et `error`. La preuve d'itinéraire possède séparément `full`, `limited_expected_empty` et `missing` ; les valeurs ne franchissent jamais ces limites.

Extensions d'itinéraire :

- `server_status`: `scheduler_status`, `active_log_status` et `server_metrics`. Les métriques enregistrent le début de l'époque actuelle, l'horodatage et l'ID du dernier sondage terminé, le nombre de joueurs actifs, le nombre de active/backup-log, les valeurs d'analyse pending/progress et configured/usable/unavailable la comptabilité des groupes sources. Ils n'inventent pas la disponibilité, le nombre de redémarrages, les horodatages de sauvegarde ou la durée des pannes lorsqu'aucune source n'expose ces faits.
- `player_activity`: `player_activity_present`, `movement`, `same_day_sessions`, `current_player_count`, `current_evidence_player_count`, `historical_player_count`, `historical_session_count`, `current_players`, `historical_players` et tableau de compatibilité `players`. Chaque session du jour même conserve son ID de session, son ID de compte, son nom d'affichage lorsqu'il est connu, join/leave horodatages, indicateurs de sortie propre et de cycle de vie et références sources. L'identité conservée et PlayerData la présence restent aujourd'hui un contexte, et non une preuve d'activité.
- `case_review`: `cases`, `review_subjects`, `current_case_count` et `retained_case_count`. Un sujet d'examen en cours enregistre son case/account ID, son nom d'affichage lorsqu'il est connu, son statut, son score, la confiance de son identité, first/last son observation, le nombre d'avertissements, les raisons, l'indicateur en cours et les références de source. Les cas conservés ne créent pas de sujet actuel par eux-mêmes.
- `critical_guard`: `critical_failure_present` et `current_boot_error_only=true`.
- `daily_rollup`: `daily_maturity`, `once_per_day_continuity`, `dedupe_window` et `daily_metrics`. Les métriques enregistrent la date du rapport, les joueurs actifs, les comptes avec une activité le jour même, les jointures, les sorties, les sorties propres et impures, les retours du cycle de vie, les sujets de révision nommés actuels, les cas retenus, current/retained le nombre d'identités et la couverture du groupe source.

<a id="translated-txt-schema"></a>
## Traduit TXT schéma

Le fichier texte apparié mène avec le résultat et les mouvements lisibles par l'opérateur. détails de la lignée jusqu'à la fin. Il conserve cet ordre exact des sections :

```text
RandomDayGuard <route title>
Generated: <timestamp>

Summary
<one plain-language route summary>

What Guard observed
- ...

What it means
- ...

What remains unknown
- ...

Recommended next step
...

Evidence boundary
- ...

Rating explanation
- ...

Technical record
- Route: <route>
- Version: <version>
- Cycle: boot=<boot> epoch=<epoch> poll=<poll>
- Source freshness: <status>
- Route result: <full|limited_expected_empty|missing>
- Coverage: <status>

Translation notes
- ...

Source references
- ...
```

La traduction utilise uniquement les champs du rapport structuré et les mappages de dictionnaire approuvés. Il ne peut pas ajouter d'acteurs, de cas, de livraison, de causalité, de propriété, d'intention ou d'éligibilité à l'application du rapport structuré. Les détails techniques restent disponibles sans déplacer le résultat lisible.

<a id="source-accounting-schema"></a>
## Schéma de comptabilité source

`runtime/final_logs/source_accounting_latest.json` utilise `randomdayguard.source-accounting/v1` avec la reason/status, enablement/disabled raison de génération, current/historical distinction, manifeste de fichier modifié, enregistrements source, usable/unavailable classe des listes et une limite de réclamation.

Chaque enregistrement source contient :

| Champ | Type | Signification |
|---|---|---|
| `source_class` | chaîne | Une des huit classes ci-dessous. |
| `scope` | `current` ou `historical` | Propriété temporelle ; les étendues ne sont jamais fusionnées silencieusement. |
| `required` | booléen | Seul `active_log` est requis pour la fraîcheur de l'itinéraire cyclable actuel. |
| `status` | enum | Résultat source répertorié ci-dessous. |
| `terminal` | booléen | Faux uniquement pour `partial` et `deferred`. |
| `available`, `readable` | booléen | Vrai uniquement pour `available` et `expected_empty`. |
| `file_count` | entier | Comptabilisé limité file/reference nombre. |
| `source_references` | tableau | Source unique triée paths/references. |
| `detail` | chaîne | Résultat limité ou détail de l'erreur. |
| `does_not_prove` | chaîne | La disponibilité ne constitue pas une preuve d'intention, de propriété, de dommage, de duplication ou d'application. |

Classes sources :

| Classe source | Portée | Ce qu'il apporte | Ce qu'il ne peut pas prouver |
|---|---|---|---|
| `active_log` | actuel, requis | Journal du serveur actif lisible et nouvelle lignée de sondages. | Historique complet ou culpabilité du joueur. |
| `admin_ini` | actuel, facultatif | État actuel moderator/ban structurellement valide, ou absence prévue. | Comportement du joueur ou métadonnées de raison valable. |
| `recent_backup_logs` | historique | Références de journal lisibles rotated/backup. | Présence actuelle ou état de démarrage actuel. |
| `playerdata_filenames` | contexte actuel | Références de nom de fichier lisibles limitées sous la racine enregistrée sélectionnée. | Propriété du fichier, présence en direct, contenu d'identité ou mauvaise conduite. |
| `existing_cases` | historique | Cas nommé conservé files/index enregistrements capturés avant les sorties actuelles. | Activité actuelle ou exactitude des anciennes conclusions. |
| `existing_reports` | historique | Conservé final/forensic/warning références de rapport. | Remplacement de source faisant autorité. |
| `existing_evidence` | historique | Références de preuves conservées. | Exhaustivité des événements que le serveur n'a jamais exposés. |
| `world_save_scan` | historique | État limité complet, partiel, différé ou indisponible scan/checkpoint. | Un état spécifique l'action ou la propriété du joueur. |

Valeurs d'état de la source :

| Statut | Terminal | Signification et action de l'opérateur |
|---|---:|---|
| `available` | oui | Une source utile lisible existe ; revoir ses références. |
| `expected_empty` | oui | La source facultative a été vérifiée et légitimement absent/empty. N'inventez pas de données. |
| `partial` | non | Le travail limité ou la limite d'inventaire est incomplet ; autoriser la reprise. |
| `deferred` | non | Le travail est intentionnellement en attente ; attendez le travailleur propriétaire. |
| `unavailable` | oui | Source/path/tool est absent ou inutilisable ; réparer uniquement si l'itinéraire l'exige. |
| `malformed` | oui | La validation structurelle du contenu a échoué ; préservez-le et réparez le format. |
| `permission_denied` | oui | L'accès a été explicitement refusé ; restaurer l'accès en lecture avec le moindre privilège. |
| `error` | oui | La limite au niveau de la source probe/read a échoué de manière inattendue ; inspectez `detail` sans exposer de secrets. |

Le niveau supérieur `coverage_status` est exactement `complete`, `complete_with_gaps`, `partial`, ou `unavailable`. Un niveau source requis `error`, `malformed`, ou `permission_denied` remonte au niveau supérieur `unavailable` ; niveau source `deferred` remonte au niveau supérieur `partial`. La désactivation de la comptabilité source écrit toujours un statut indisponible et force chaque itinéraire vers le `missing`.

<a id="historical-status-schema"></a>
## Schéma de statut historique

`runtime/final_logs/historical_backfill_latest.json` utilise `randomdayguard.history/v1`: `generated_ts`, la comptabilité `status`, `resumable=true`, `changed_file_refresh=true`, `current_evidence_is_not_history=true`, le tableau de comptabilité source, les classes indisponibles et un `next_action`.

`runtime/history/public_accounts.tsv` limité est un historique public durable avec cet en-tête :

```text
account_id	ban_id	display_name	identity_confidence	status	score	first_seen	last_seen	source_references
```

Les lignes sont triées par ID de compte, les champs sont single-line/tab-safe et les références sont sorted/unique. Ce fichier préserve le contexte historique lors des redémarrages silencieux ; il ne convertit jamais l'histoire en présence actuelle.

<a id="route-proof-schema"></a>
## Schéma de preuve d'itinéraire

`runtime/final_logs/route_proof.json` utilise `randomdayguard.route-proof/v1` et enregistre l'horodatage de génération de niveau supérieur, la version, le démarrage, l'époque, le sondage, la fraîcheur de la source, l'intégralité du cycle en cours, les statuts autorisés et un tableau `routes`.

Chaque entrée de route contient route/status, version/boot/epoch/poll, un objet source-freshness, l'exhaustivité du cycle actuel, les chemins de sortie et les références sources. Un itinéraire désactivé enregistre `status="missing"` et `reason="route_disabled"`. Si l'écriture à l'épreuve des routes échoue, chaque route est réécrite en incomplete/missing avant qu'une notification candidate ne soit acceptée.

<a id="notification-schemas"></a>
## Schémas de notification

Le mode public facultatif est uniquement la boîte d'envoi de fichiers locaux.

`runtime/notifications/pending/<route>_latest.json` utilise `randomdayguard.notification/v1` avec horodatage généré, version/boot/epoch/ poll/source fraîcheur, route, `completed_output`, statut de sécurité, chemins de rapports structurés et traduits, références sources, `delivery_backend="none"` et `delivery_attempted=false`. Les résultats éligibles utilisent `status="ready_for_local_consumer"`, `delivery_eligible=true` et `delivery_allowed=true`. Une route configurée mais missing/ineligible écrit toujours une enveloppe d'audit avec `status="suppressed_current_cycle"`, les deux indicateurs de livraison faux et `suppression_reason="route_or_completion_policy_blocked"`. Par conséquent, la présence d'un fichier sous `pending/` ne signifie pas en soi qu'il est mis en file d'attente ou éligible.

`runtime/notifications/notification_status.json` utilise `randomdayguard.notification-status/v1` avec la même lignée, `generic_local_outbox_only=true`, `delivery_attempted=false` et par route `queued`/`outcome` lignes. `full` est éligible ; attendu-vide n'est éligible que lorsque `include_expected_empty=true`; `missing` n'est jamais éligible. En cas d'échec d'écriture à l'épreuve du routage, le résultat de l'état est `route_proof_write_failed` ; une enveloppe d'audit supprimée peut toujours être écrite, mais elle n'est pas une sortie acceptée.

<a id="runtime-output-inventory"></a>
## Inventaire de sortie d'exécution

L'index de traçabilité comporte une ligne de machine pour chaque chemin ou classe de fichier dynamique. Cet inventaire lisible regroupe les fichiers par objectif de l'opérateur.

| Chemin ou modèle | Producer/trigger | Politique et états utiles | Failure/recovery |
|---|---|---|---|
| `runtime/loader_probe.txt`, `runtime/loader_probe.json` | Entrée du chargeur. | Démarrage écrasé identity/probe. | Le manque ne prouve pas la charge ; inspectez UE4SS les journaux et l'activation. |
| `runtime/config_load_error.txt` | Échec du chargement de la configuration. | Erreur uniquement, préserve la raison limitée. | Restaurez la configuration publique valide et redémarrez. |
| `runtime/saved_path_probe.json` | Résolution de la racine enregistrée. | Candidate/readability limitée. | Défini `SavedRoot.txt` ou réparez un candidat générique. |
| `runtime/startup_status.json`, `runtime/startup_error.txt`, `runtime/current/startup_error.json` | Cycle de vie de démarrage. | Dernière erreur de démarrage et de démarrage actuel. | Seul le démarrage correspondant possède l'état critique actuel. |
| `runtime/runtime_version.json`, `runtime/runtime_capabilities.json`, `runtime/public_pipeline_status.json` | Startup/report intégration. | Dernière version/capability/handoff. | La dérive de version ou de fonctionnalité bloque les revendications d'achèvement. |
| `runtime/poll_status.json`, `runtime/current/poll_status.json`, `runtime/poll_error.txt`, `runtime/current/poll_error.json` | Interroger finalizer/error. | Dernière poll/scheduler/in-flight l'état et l'erreur de démarrage en cours. | Réparer le rappel limité et exiger une interrogation terminée plus récente. |
| `runtime/logs/current.jsonl`, `runtime/raw_events.jsonl` | Enregistreur d'événements. | Bounded append/rotation. | Conserver les octets précédents ; réparation disk/retention avant de vous fier aux écarts. |
| `runtime/log_offsets.tsv`, `runtime/log_registry.json` | Journal tail/registry. | Derniers décalages et identités canoniques des journaux. | Reconstruisez soigneusement ; les journaux de sauvegarde restent historiques. |
| `runtime/log_continuity_events.jsonl`, `runtime/evidence/log_continuity_events.jsonl`, `runtime/server_lifecycle_events.jsonl`, `runtime/evidence/lifecycle_events.jsonl` | Continuity/lifecycle normalisateur. | Contexte d'ajout uniquement. | Le contexte manquant ne peut pas prouver graceful/crash. |
| `runtime/current_server_epoch.json`, `runtime/server_epochs.jsonl`, `runtime/epochs/**` | Propriétaire de l'époque. | Époques de serveur actuelles et conservées. | Démarrer une nouvelle époque après réparation; ne réécrivez pas l'ancien historique. |
| `runtime/session_events.tsv`, `runtime/evidence/session_events.jsonl`, `runtime/sessions/**` | Propriétaire de la session. | Current/historical événements et instantanés de session. | Les lignes non mappées restent inconnues ; aucune invention d'identité. |
| `runtime/account_evidence.tsv`, `runtime/account_evidence.json`, `runtime/history/public_accounts.tsv` | Account/session module d'agrégation et de reporting. | instantané actuel et historique durable. | Gardez les étendues séparées et restaurez à partir des preuves, pas des suppositions. |
| `runtime/current/session_state.json`, `runtime/current/active_accounts.json`, `runtime/current/spatial_context.json`, `runtime/current/actor_touch_rollup.json` | Poll/current-state rédacteurs. | instantanés actuels écrasés. | Stale/missing est inconnu, ne devrait pas être vide. |
| `runtime/days/**`, `runtime/weeks/**` | Daily/weekly agrégation. | Index reconstructibles. | Reconstruire à partir d'événements faisant autorité. |
| `runtime/scan_started.json`, `runtime/scan_progress.json`, `runtime/scan_checkpoint.json`, `runtime/scan_complete.json`, `runtime/scan_error.txt` | Travailleur d'analyse. | Démarré, partial/deferred, point de contrôle, terminé ou erreur. | Reprendre le point de contrôle ; reconstruire uniquement avec une raison enregistrée. |
| `runtime/baselines/last_scan.json`, `runtime/baselines/last_completed_baseline.json`, `runtime/baselines/file_manifest.tsv` | Travailleur de base. | Dernière scan/baseline et liaison de fichier modifié. | Stale/incompatible les manifestes nécessitent une reconstruction explicite. |
| `runtime/object_registry_partial.json`, `runtime/object_registry_counts_partial.tsv`, `runtime/object_registry.json`, `runtime/object_registry_counts.tsv` | Analyse d'objets. | Partial/final contexte de classe. | Les décomptes ne sont pas la preuve de l'action du joueur ; reprendre ou reconstruire l'analyse. |
| `runtime/new_classes_detected.jsonl`, `runtime/class_deltas.jsonl` | Comparaison d'objets. | Ajout uniquement new/delta partiel puis final. | Examen mapping/baseline avant l'inférence. |
| `runtime/playerdata_index.json`, `runtime/admin_state.json` | Index racine enregistrés. | Filename/admin contexte de structure. | Les noms de fichiers sont faibles ; un état d'administration mal formé ferme les écritures. |
| `runtime/world_state/boot/**`, `runtime/world_state/current/world_state_latest.json`, `runtime/world_state/sessions/**` | Écrivain d'état mondial. | Boot/current/session instantanés et différences. | Contexte uniquement ; régénérer après scan/source réparation. |
| `runtime/warning_events.jsonl`, `runtime/warnings/**`, `runtime/evidence/critical_events.jsonl`, `runtime/evidence/high_events.jsonl`, `runtime/evidence/medium_events.jsonl` | Warning/evidence rédacteurs. | Ajout limité et per-player/session révision des fichiers. | Le rapport manquant ne manque pas de preuve d'événement ; inspecter les preuves sources. |
| `runtime/raid_cases/**`, `runtime/raid_cases/index.jsonl`, `runtime/ban_queue.json` | Case/review agrégation. | Matériel d'examen nommé et candidats en file d'attente. | Cas membership/threshold ne contourne jamais les portes spécifiques au compte. |
| `runtime/backups/Admin_*.ini`, `runtime/enforced.txt`, `runtime/enforced_bans.jsonl`, `runtime/evidence/enforced_bans.jsonl`, `runtime/evidence/enforcement_failed_*` | Transaction Admin.ini facultative. | Sauvegarde, registre de réussite ou failure/rollback. | tout échec backup/write/readback/rollback met fin à l'application ; restaurer la sauvegarde. |
| `runtime/request_restart.flag`, `runtime/restart_reason.json` | Enregistreur de marqueurs facultatif. | Demande locale uniquement. | Ne prouve pas la consommation ou le redémarrage. |
| `runtime/current/forensic_today.json`, `.md`, `.txt`, `runtime/forensic_days/YYYY-MM-DD/**`, `runtime/final_logs/YYYY-MM-DD/**` | Consolidation médico-légale. | Index d'examen reconstructibles actuels et datés. | Reconstruire à partir de la source preuves; ne traitez jamais le résumé comme une autorité. |
| `runtime/final_logs/source_accounting_latest.json`, `historical_backfill_latest.json`, `<route>_latest.json`, `<route>_latest.txt`, `route_proof.json` | Travailleur de rapports publics. | Schémas et règles de complétion ci-dessus. | Réparer d'abord les erreurs de correspondance lineage/source/write ; manquant reste manquant. |
| `runtime/notifications/pending/<route>_latest.json`, `runtime/notifications/notification_status.json` | Boîte d'envoi locale facultative. | Enveloppe locale éligible ou explicitement supprimée et statut. | Missing/ineligible les routes peuvent avoir des fichiers supprimés mais ne sont jamais mises en file d'attente ; inspecter les indicateurs de livraison et déduire aucune livraison externe. |

Overwrite/append/retention le comportement est contrôlé par la section de production dans [`CONFIG_FIELD_CATALOG.md`](CATALOGUE_DE_CHAMPS_DE_CONFIGURATION.md). Les ZIP des packages ne contiennent que des `.gitkeep` vides sous `runtime/` ; tout evidence/output octet d'un package de version échoue à la validation.

<a id="failure-and-recovery-matrix"></a>
## Matrice de panne et de récupération

| Échec | État requis | Récupération sécurisée | Inférence non valide |
|---|---|---|---|
| Lignée actuelle absent/stale | Toutes les routes `missing`. | Restaurer active-log/current-poll vérifier et régénérer. | Les anciens fichiers d'itinéraire ne sont pas actuellement terminés. |
| Source facultative attendue vide | Source `expected_empty` ; L'itinéraire éligible peut être `limited_expected_empty`. | Aucune réparation à moins que la source n'existe. | Vide n'est pas indisponible et ne prouve pas une absence historique. |
| Analyse incomplète | Source `partial` ou `deferred`. | Autoriser la reprise limitée ; garder la politique de routage actuelle explicite. | Partiel n'est pas une corruption. |
| Source requise indisponible | `coverage_status=unavailable` ; routes dépendantes `missing`. | Réparer l'accès sélectionné Saved/log. | Les autres sources saines ne remplacent pas la source requise. |
| Erreurs de sonde de source requises | État de la source `error` avec `detail`; `coverage_status=unavailable` ; routes dépendantes `missing`. | Réparez le source/probe nommé et générez un cycle plus récent. | Une erreur source n'est pas une cinquième valeur de couverture de niveau supérieur. |
| Échec de l'écriture du rapport apparié | `coverage_status=unavailable` ; la route converge vers `missing`. | Réparer le système de fichiers et réécrire les deux membres de la paire ainsi que la preuve. | Un fichier frère n'est pas terminé et l'échec d'écriture n'est pas de niveau supérieur `error`. |
| Échec de l'écriture à l'épreuve de la route | Chaque route réécrite est manquante ; aucune boîte d'envoi éligible ; Les routes configurées peuvent recevoir des enveloppes d'audit supprimées. | Réparez l'écriture à l'épreuve des routes et régénérez les sorties du même cycle. | Rapport d'apparence valide JSON ou une enveloppe supprimée ne constitue pas une preuve d'itinéraire. |
| Échec de l'écriture de la notification | Résultat `local_outbox_write_failed`. | Réparer la racine de sortie locale ; régénérer à partir du rapport terminé. | Aucune livraison externe n'a eu lieu. |
| Admin.ini la transaction échoue | Application bloquée avec backup/write/readback/rollback. | Restaurer la sauvegarde vérifiée ; restent en révision uniquement. | Un seuil ou un rapport ne peut pas justifier le contournement de la récupération. |

Voir [`EVIDENCE_BOUNDARY.md`](LIMITE_DES_PREUVES.md), [`ARCHITECTURE.md`](ARCHITECTURE.md) et [`SOURCE_MODULE_REFERENCE.md`](R%C3%89F%C3%89RENCE_DU_MODULE_SOURCE.md).
