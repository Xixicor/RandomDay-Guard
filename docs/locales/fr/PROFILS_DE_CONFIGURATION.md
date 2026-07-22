<a id="configuration-profiles"></a>
# Profils de configuration

> **Source canonique en anglais:** [CONFIG_PROFILES.md](../../CONFIG_PROFILES.md). Cette documentation localisée conserve les commandes, chemins, clés, valeurs d'état, hachages et noms de fichiers exacts. Si la formulation technique diffère, utilisez la source anglaise.


Utilisez ce guide pratique pour choisir et appliquer un profil de configuration pratique. Pour une explication de la façon dont les groupes de paramètres interagissent, lisez [`CONFIG_REFERENCE.md`](R%C3%89F%C3%89RENCE_DE_CONFIGURATION.md). Pour les champs exacts, les valeurs par défaut, les types et les invariants, utilisez le [`CONFIG_FIELD_CATALOG.md`](CATALOGUE_DE_CHAMPS_DE_CONFIGURATION.md).

Chaque bloc Lua ci-dessous est un ensemble d'entrées de niveau supérieur qui peuvent remplacer les entrées correspondantes dans le `return { ... }` fournie.

<a id="profile-chooser"></a>
## Sélecteur de profil

| Situation | Utiliser ce profil |
|---|---|
| Première installation | Première installation sécurisée |
| Le serveur est instable et plante souvent | Preuves actuelles sans analyse lente |
| Vous souhaitez object/worldcontexte | Base de référence complète |
| Vous souhaitez consulter les anciens journaux | Forensic remplissage |
| Vous voulez des recommandations mais pas d'écriture | Tests d'application |
| Vous êtes prêt à laisser le garde interdire l'écriture | Application activée |
| Le disque est limité | Faible croissance du disque |
| Vous avez effectué une configuration de base propre | Configuration de sauvegarde persistante |

<a id="safe-first-install"></a>
## Première installation sécurisée

Utilisez-la d'abord sur un serveur actif.

```lua
enforcement = {
    review_only_mode = true,
    auto_ban = false,
    write_admin_ini = false,
},

log_tail = {
    enabled = true,
    start_at_end_on_first_run = true,
    tail_backup_logs = false,
},

scanning = {
    full_scan_on_start = true,
    resume_incomplete_scan = true,
    reuse_completed_baseline = true,
    incremental_refresh_after_baseline = true,
},

reports = {
    enabled = true,
},

notification = {
    enabled = false,
},
```

Ce que cela fait :

```text
Tracks live sessions.
Starts the baseline scan.
Does not edit Admin.ini.
Avoids treating old backup logs as fresh live events.
```

<a id="current-evidence-without-slow-scan"></a>
## Preuves actuelles sans analyse lente

Utilisez-la si le serveur est instable et que vous avez besoin crash/reconnect de preuves avant une lourde analyse.

```lua
log_tail = {
    enabled = true,
},

scanning = {
    full_scan_on_start = false,
},

enforcement = {
    review_only_mode = true,
    auto_ban = false,
    write_admin_ini = false,
},

reports = {
    enabled = true,
},

notification = {
    enabled = false,
},
```

Ce que cela fait :

```text
Tracks logins, joins, leaves, reconnects, crashes, and unclean sessions.
Delays heavy world scanning.
```

<a id="full-baseline"></a>
## Base de référence complète

Utilisez-le une fois que le serveur peut rester actif suffisamment longtemps pour analyser.

```lua
scanning = {
    full_scan_on_start = true,
    resume_incomplete_scan = true,
    reuse_completed_baseline = true,
    incremental_refresh_after_baseline = true,
},
```

Ce que cela fait :

```text
Builds object registry.
Writes world-state context.
Creates file manifest.
Enables changed-file refresh later.
```

<a id="forensic-backfill"></a>
## Forensic remplissage

Utilisez-le uniquement lors de l'examen intentionnel des journaux historiques.

```lua
log_tail = {
    start_at_end_on_first_run = false,
    tail_backup_logs = true,
    backfill_backup_logs_on_start = true,
},
```

Avant de l'utiliser :

```text
Back up runtime/log_offsets.tsv.
Expect old events to be reprocessed.
Return to live settings when finished.
```

<a id="enforcement-testing"></a>
## Tests d'application

Utilisez-le avant l'écriture réelle Admin.ini.

```lua
enforcement = {
    review_only_mode = true,
    auto_ban = false,
    write_admin_ini = false,
},
```

Ce qu'il faut inspecter :

```text
runtime/account_evidence.json
runtime/warnings/
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
```

<a id="enforcement-enabled"></a>
## Application activée

Utilisez ceci uniquement une fois que le résultat de la révision est correct.

```lua
enforcement = {
    review_only_mode = false,
    auto_ban = true,
    write_admin_ini = true,
    require_clean_ban_id = true,
    preserve_existing_bans = true,
    preserve_moderators = true,
},
```

Avant d'activer :

```text
Trusted IDs are configured.
Moderator IDs are preserved.
Admin.ini backups work.
Ban recommendations are understandable.
Thresholds are accepted by the server owner.
```

<a id="low-disk-growth"></a>
## Faible croissance du disque

Utilisez ceci lorsque les fichiers d'exécution se développent trop rapidement.

```lua
logging = {
    low_importance_mode = "aggregate",
    write_low_importance_raw_events = false,
},

retention = {
    detailed_retention_days = 7,
    rotate_jsonl_when_bytes_exceed = 5242880,
    max_raw_events_lines = 20000,
    compact_json_outputs = true,
},
```

<a id="sticky-backup-setup"></a>
## Configuration de sauvegarde persistante

Utilisez après la première ligne de base terminée.

Vérifiez qu'ils existent :

```text
runtime/scan_complete.json
runtime/object_registry.json
runtime/object_registry_counts.tsv
runtime/baselines/last_completed_baseline.json
runtime/baselines/file_manifest.tsv
runtime/world_state/current/world_state_latest.json
```

Ensuite, sauvegardez-les avec `config.lua`, `SavedRoot.txt` et `Admin.ini`.

<a id="related-docs"></a>
## Documents associés

* [`CONFIG_REFERENCE.md`](R%C3%89F%C3%89RENCE_DE_CONFIGURATION.md)
* [`FORENSIC_DAILY_ROLLUPS.md`](RAPPORTS_QUOTIDIENS_M%C3%89DICO-L%C3%89GAUX.md)
* [`ADMIN_INI_ENFORCEMENT.md`](ADMINISTRATEUR_INI_ENFORCEMENT.md)
