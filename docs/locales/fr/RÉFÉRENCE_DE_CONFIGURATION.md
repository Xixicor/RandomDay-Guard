<a id="configuration-concepts"></a>
# Concepts de configuration

> **Source canonique en anglais:** [CONFIG_REFERENCE.md](../../CONFIG_REFERENCE.md). Cette documentation localisée conserve les commandes, chemins, clés, valeurs d'état, hachages et noms de fichiers exacts. Si la formulation technique diffère, utilisez la source anglaise.


Cette explication décrit ce que chaque zone de configuration principale contrôle, quand elle s'exécute et comment elle interagit avec les preuves et les barrières de sécurité. Il ne possède pas le catalogue de champs exact ni les procédures de profil.

Pour les préréglages orientés tâches et les étapes de modification sécurisées, utilisez [`CONFIG_PROFILES.md`](PROFILS_DE_CONFIGURATION.md). Pour chaque champ source exact, valeur par défaut, type, invariant, effet de sortie et règle de récupération, utilisez le [`CONFIG_FIELD_CATALOG.md`](CATALOGUE_DE_CHAMPS_DE_CONFIGURATION.md) généré ; le validateur requiert une ligne pour chaque `config.lua` expédié.

<a id="reading-this-page"></a>
## Lecture de cette page

Chaque zone de configuration répond :

```text
What it controls
When it runs
What to check
What can go wrong
```

<a id="top-level-safety"></a>
## Sécurité de haut niveau

| Option | Par défaut | Signification |
|---|---:|---|
| `enabled` | `true` | Interrupteur principal pour la garde |
| `enforcement.review_only_mode` | `true` | Record/recommend uniquement |
| `enforcement.auto_ban` | `false` | Ne pas bannir automatiquement par défaut |
| `enforcement.write_admin_ini` | `false` | Ne pas écrire Admin.ini par défaut |

Conservez-les en sécurité jusqu'à ce que le propriétaire du serveur examine la sortie.

<a id="saved"></a>
## `saved`

Contrôle comment le garde trouve le dossier du serveur `Saved/` et quelles familles de fichiers il peut scanner.

À utiliser quand :

```text
Saved root auto-detection fails.
World folder changed.
Provider or container path is unusual.
```

Vérifier :

```text
runtime/saved_path_probe.json
RandomDayGuard/SavedRoot.txt
```

Règle :

```text
SavedRoot.txt -> AbioticFactor/Saved
not -> Worlds/<WorldName>
```

<a id="log_tail"></a>
## `log_tail`

Contrôle la lecture du journal en direct.

Options utiles :

| Option | Valeur sûre | Pourquoi |
|---|---|---|
| `enabled` | `true` | Nécessaire pour la défense en direct |
| `start_at_end_on_first_run` | `true` | Évite les anciens journaux en tant qu'événements en direct |
| `tail_backup_logs` | `false` | Les journaux de sauvegarde sont historiques et non en direct |
| `max_lines_per_poll` | limités | Garde la réactivité de la boucle d'interrogation |

Vérifier :

```text
runtime/log_offsets.tsv
runtime/evidence/session_events.jsonl
runtime/current/poll_status.json
```

<a id="runtime"></a>
## `runtime`

Contrôle les sondages et les budgets.

Règle de santé principale :

```text
poll_id increases
poll_in_flight returns false
poll_scheduled is true
```

Vérifier :

```text
runtime/current/poll_status.json
```

Si `poll_id` s'arrête, quelque chose bloque la boucle.

<a id="source_accounting"></a>
## `source_accounting`

Contrôle la couverture et la portée des sources de preuves explicites.

| Clé | Par défaut | Signification |
|---|---:|---|
| `enabled` | `true` | Écrit la comptabilité des sources pour les rapports d'itinéraires publics. |
| `require_terminal_status` | `true` | Exige que chaque source expose un terminal explicite ou incomplet. état. |
| `distinguish_current_from_historical` | `true` | Maintient les preuves actuelles et historiques séparées. |
| `slow_world_scan_blocks_current_reports` | `false` | Permet aux rapports actuels d'indiquer que l'analyse du monde limité est différée ou partielle. |
| `changed_file_manifest` | chemin manifeste de base | Référence utilisée pour la comptabilité historical/world limitée. |

Les états sources sont `available`, `expected_empty`, `partial`, `deferred`, `unavailable`, `malformed`, `permission_denied`, ou `error`.

Le paramètre `source_accounting.enabled = false` ne supprime pas silencieusement la sortie d'état. Le pipeline écrit toujours `runtime/final_logs/source_accounting_latest.json` avec `enabled=false`, `status="unavailable"` et `disabled_reason="source_accounting_disabled"`. Il écrit également l'enregistrement de l'état historique avec une comptabilité indisponible. Étant donné que la comptabilité source fait partie du contrat de rapport, chaque itinéraire échoue à `missing` ; aucune route n'est traitée comme terminée lorsque la comptabilité est désactivée.

<a id="reports"></a>
## `reports`

Contrôle le pipeline de reporting local générique.

Les valeurs par défaut activent les cinq routes et écrivent sous `runtime/final_logs`:

```text
server_status
daily_rollup
player_activity
case_review
critical_guard
```

Chaque route doit écrire une sortie structurée et traduite ainsi qu'une preuve dans `route_proof.json`. La désactivation d'une route produit `missing` une preuve plutôt que de prétendre qu'elle est terminée.

<a id="notification"></a>
## `notification`

Boîte d'envoi de fichiers locaux génériques facultative. Il est désactivé par défaut et n'envoie rien à un fournisseur externe.

Par défaut :

```lua
notification = {
    enabled = false,
    mode = "local_file_outbox",
    include_expected_empty = false,
},
```

Chaque route de notification est désactivée par défaut. Lorsqu'elle est délibérément activée, la boîte d'envoi peut consommer uniquement un rapport traduit terminé après l'écriture de `route_proof.json`. Les preuves et rapports locaux font toujours autorité. La livraison, les points de terminaison de livraison, les informations d'identification et les ponts spécifiques au fournisseur ne font pas partie du contrat public de surveillance indépendant.

<a id="scanning"></a>
## `scanning`

Contrôle l'analyse de base, les points de contrôle et l'actualisation des fichiers modifiés.

À utiliser quand :

```text
building first world baseline
resuming after crash
refreshing changed files later
```

Vérifier :

```text
runtime/scan_progress.json
runtime/scan_checkpoint.json
runtime/scan_complete.json
runtime/baselines/file_manifest.tsv
```

Paramètres importants :

```lua
scanning = {
    resume_incomplete_scan = true,
    reuse_completed_baseline = true,
    incremental_refresh_after_baseline = true,
    changed_file_detection = true,
},
```

<a id="forensic_rollup"></a>
## `forensic_rollup`

Contrôle le package de téléchargement quotidien rapide et les journaux finaux en langage clair.

Sorties :

```text
runtime/current/forensic_today.json
runtime/current/forensic_today.md
runtime/current/forensic_today.txt
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

À utiliser quand :

```text
You want one daily folder that summarizes what happened.
You want a plain-language TXT to upload for quick analysis.
```

Vérifier :

```text
runtime/forensic_days/YYYY-MM-DD/forensic_day_summary.json
runtime/forensic_days/YYYY-MM-DD/players.tsv
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

Règle :

```text
Daily summaries are rebuildable indexes.
Source evidence remains authoritative.
```

<a id="logging"></a>
## `logging`

Contrôle le volume des événements et l'agrégation de faible importance.

À utiliser quand :

```text
actor-touch events are noisy
raw event files grow too quickly
```

Modèle sécurisé :

```lua
logging = {
    low_importance_mode = "aggregate",
    write_low_importance_raw_events = false,
},
```

<a id="retention"></a>
## `retention`

Contrôle la durée de conservation des fichiers et le moment JSONL de rotation des journaux.

À utiliser quand :

```text
disk usage grows too fast
you need more audit history
you need shorter live-history windows
```

Options importantes :

```text
detailed_retention_days
rotate_jsonl_when_bytes_exceed
max_raw_events_lines
keep_enforced_forever
keep_evidence_forever
```

<a id="warning_bursts"></a>
## `warning_bursts`

Contrôles détection de fenêtre d'avertissement.

Exemples :

```text
ActorChannelFailure
DeployableSaveWarning
UpdateActorToWorldSave
ServerMove warnings
```

Règle :

```text
Warnings are context until correlated with mapped sessions and thresholds.
```

<a id="crash_correlation"></a>
## `crash_correlation`

Contrôle les révisions répétées crash/reconnect.

Paramètres par défaut sécurisés :

```lua
crash_correlation = {
    single_crash_never_bans = true,
    require_same_account = true,
},
```

Compteurs utiles :

```text
server_crash_overlap_count
post_crash_reconnect_count
unclean_disconnect_count
```

<a id="join_leave"></a>
## `join_leave`

Contrôle le taux de désabonnement et le suivi des vagues de jointure.

Sûr par défaut :

```lua
join_leave = {
    churn_alone_never_bans = true,
},
```

Utiliser pour :

```text
rapid reconnect loops
join waves
short-session patterns
```

<a id="raid_detection"></a>
## `raid_detection`

Groupe les comptes actifs dans les fenêtres associées.

Règle :

```text
A raid case groups accounts for review.
It does not make every account guilty.
```

Chaque compte appliqué a toujours besoin de preuves spécifiques au compte.

<a id="object_registry"></a>
## `object_registry`

Contrôles object/class extraction de jeton à partir de preuves enregistrées lisibles.

Sorties :

```text
runtime/object_registry_partial.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
```

Règle :

```text
Object/class context is not a ban reason by itself.
```

<a id="world_state"></a>
## `world_state`

Contrôles boot/current/session instantanés de l'état du monde.

Sorties :

```text
runtime/world_state/current/world_state_latest.json
runtime/world_state/sessions/<date>/<session_id>_<account_id>/
```

Utiliser pour la session examen et contexte mondial.

<a id="enforcement"></a>
## `enforcement`

Recommandations de contrôle et Admin.ini écritures réelles.

Avant que Guard puisse ajouter une interdiction, chaque déclaration ci-dessous doit être vraie :

```text
review_only_mode == false
auto_ban == true
write_admin_ini == true
ban_id is clean numeric
account identity is mapped
not trusted
not moderator
threshold is met
```

Si une déclaration est fausse ou ne peut pas être vérifiée, Guard laisse `Admin.ini` inchangé et enregistre la raison.

<a id="admin_ini"></a>
## `admin_ini`

Contrôle les écritures de fichiers sécurisées.

Règles :

```text
Back up before writing.
Preserve existing bans.
Preserve moderators.
Write clean BannedPlayer=<ID> only.
```

<a id="restart_request"></a>
## `restart_request`

Contrôle les fichiers de marqueurs locaux facultatifs qu'un autre processus appartenant à un opérateur peut inspecter. Il ne redémarre ni ne tue le serveur.

Par défaut :

```lua
restart_request = {
    enabled = false,
    restart_marker_file = "runtime/request_restart.flag",
    restart_reason_file = "runtime/restart_reason.json",
},
```

Sorties :

```text
runtime/request_restart.flag
runtime/restart_reason.json
```

Aucun panneau d'hébergement, pont de fournisseur ou automatisation de redémarrage n'est fourni. L'activation de la création de marqueurs ne prouve pas qu'un processus externe a consommé la requête ou redémarré le serveur.

<a id="related-docs"></a>
## Documents associés

* [`CONFIG_PROFILES.md`](PROFILS_DE_CONFIGURATION.md)
* [`OUTPUT_SCHEMA_REFERENCE.md`](R%C3%89F%C3%89RENCE_DU_SCH%C3%89MA_DE_SORTIE.md)
* [`ADMIN_INI_ENFORCEMENT.md`](ADMINISTRATEUR_INI_ENFORCEMENT.md)
