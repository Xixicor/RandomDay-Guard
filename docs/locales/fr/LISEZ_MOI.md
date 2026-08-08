# RandomDayGuard en français

> [!IMPORTANT]
> ## État du projet — essais de RandomDay terminés
>
> L’opération d’essai de RandomDay est terminée et le serveur d’essai public fermera bientôt.
>
> Pendant cette opération, RandomDay et RandomDayGuard ont fonctionné ensemble au fil de rotations répétées de profils, de redémarrages normaux et interrompus du serveur, de vérifications de récupération et de retour arrière, de l’intégration de mods étendus, de la collecte de preuves serveur et de l’examen des rapports d’exploitation.
>
> Nous avons ainsi obtenu les connaissances recherchées : le comportement des profils sandbox rotatifs sur de véritables cycles de vie de serveur dédié, l’interaction de RandomDay avec les mods étendus pris en charge et la mesure dans laquelle RandomDayGuard peut transformer les preuves écrites par le serveur en une surveillance utile et prudente, sans présenter des lacunes ou des suppositions comme des faits.
>
> **Pile utilisée sur le serveur d’essai:**
>
> - RandomDay version de développement privée `v0.41.76`
> - RandomDayGuard version de développement privée `v0.46.130`
> - Chaotic Spawn Engine / DynamicSpawns `0.8.5 Hotfix 1`
> - Lethal Lasers `1.0 UE4SS`
> - ANTE Up `0.26`
> - Encounter Director integration — une extension DynamicSpawns appartenant à RandomDay, et non un mod distribué séparément
> - UE4SS `v3.0.1 Beta #0` (Git `01e0a584`; Nexus `v3.0.1-940-g01e0a584`)
> - serveur dédié Abiotic Factor `1.4.0.27939`
>
> Les paquets actuellement publiés restent RandomDay `v0.3.16-alpha` et RandomDayGuard `v0.4.12-alpha`.
>
> Le développement des deux projets est désormais en pause. Les versions et la documentation existantes resteront disponibles, et nous pourrons revenir lorsque nous ressentirons de nouveau l’envie de poursuivre le travail.
>
> Cette pile décrit ce qui a été utilisé pendant l’opération ; elle ne constitue ni une exigence de version minimale ni une garantie de compatibilité avec des versions ultérieures du jeu, du chargeur ou des mods. Le dernier cycle officiellement consigné utilisait Abiotic Factor `1.4.0.27939`.

**v0.4.12-alpha**

RandomDayGuard transforme les preuves délimitées d’un serveur dédié Abiotic
Factor en rapports lisibles. L’état du serveur, le bilan quotidien, l’activité
des joueurs, les dossiers à examiner et les échecs critiques restent séparés.

## Installer

Suivez le [guide d’installation](INSTALLATION.md). Le mod doit se trouver
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
`auto_ban = false` et `write_admin_ini = false`. Utilisez [Démarrage](COMMENCER_ICI.md),
[Opérations](MANUEL_D_OP%C3%89RATIONS.md), [Configuration](PROFILS_DE_CONFIGURATION.md)
et [Dépannage](D%C3%89PANNAGE.md). Les données structurées constituent
le registre technique; la traduction en facilite la lecture.

Les commandes, chemins, clés et états restent en anglais pour correspondre aux
fichiers produits.

## Version alpha et deux parcours de preuves

Il s'agit d'une version alpha. Les parcours documentés de collecte, de rapport et de récupération ont été testés; la compatibilité, la couverture historique et la qualité des rapports continuent d'être améliorées.

Le parcours actuel utilise le journal actif, l'état actuel du démarrage et du planificateur ainsi que les sessions en cours; il peut donc écrire immédiatement les rapports actuels. Le parcours historique examine les journaux conservés, les noms PlayerData, les preuves et les dossiers existants par étapes limitées.

`runtime/current/report_worker_status.json`

Comparez `scan_cursor` et `last_progress_ts` dans `runtime/current/report_worker_status.json` pendant plusieurs cycles. S'ils avancent, l'analyse fonctionne. S'ils restent identiques alors que les rapports actuels avancent, l'analyse historique est bloquée; les faits actuels restent utilisables, mais les conclusions dépendant de l'ancien historique sont limitées.

[Troubleshooting](D%C3%89PANNAGE.md)

## Bibliothèque de documentation complète

Chaque document public Markdown est disponible dans cette langue avec des noms de fichiers localisés.

- [Ouvrir l'index de la documentation localisée](DOCUMENTATION.md)
