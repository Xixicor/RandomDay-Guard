# RandomDayGuard en français

**v0.4.12-alpha**

RandomDayGuard transforme les preuves délimitées d’un serveur dédié Abiotic
Factor en rapports lisibles. L’état du serveur, le bilan quotidien, l’activité
des joueurs, les dossiers à examiner et les échecs critiques restent séparés.

## Installer

Suivez le [guide d’installation](../../../INSTALL.md). Le mod doit se trouver
dans `ue4ss/Mods/RandomDayGuard` et `mods.txt` doit contenir
`RandomDayGuard : 1`. Évitez les dossiers imbriqués et les doublons `Scripts`.

## Vérifier le premier rapport

Consultez `runtime/current/startup_status.json`, puis
`runtime/final_logs/latest_dossier.json` et
`runtime/final_logs/route_proof.json`. Chaque route indique `full`,
`limited_expected_empty` ou `missing`. Le résumé et sa source doivent provenir
du même cycle.

## Configurer et exploiter

Les réglages publics commencent avec `review_only_mode = true`,
`auto_ban = false` et `write_admin_ini = false`. Utilisez [Démarrage](../../START_HERE.md),
[Opérations](../../OPERATIONS_PLAYBOOK.md), [Configuration](../../CONFIG_PROFILES.md)
et [Dépannage](../../TROUBLESHOOTING.md). Les données structurées constituent
le registre technique; la traduction en facilite la lecture.

Les commandes, chemins, clés et états restent en anglais pour correspondre aux
fichiers produits.

## Version alpha et deux parcours de preuves

Il s'agit d'une version alpha. Les parcours documentés de collecte, de rapport et de récupération ont été testés; la compatibilité, la couverture historique et la qualité des rapports continuent d'être améliorées.

Le parcours actuel utilise le journal actif, l'état actuel du démarrage et du planificateur ainsi que les sessions en cours; il peut donc écrire immédiatement les rapports actuels. Le parcours historique examine les journaux conservés, les noms PlayerData, les preuves et les dossiers existants par étapes limitées.

`runtime/current/report_worker_status.json`

Comparez `scan_cursor` et `last_progress_ts` dans `runtime/current/report_worker_status.json` pendant plusieurs cycles. S'ils avancent, l'analyse fonctionne. S'ils restent identiques alors que les rapports actuels avancent, l'analyse historique est bloquée; les faits actuels restent utilisables, mais les conclusions dépendant de l'ancien historique sont limitées.

[Troubleshooting](../../TROUBLESHOOTING.md)
