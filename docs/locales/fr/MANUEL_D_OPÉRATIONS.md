<a id="operations-playbook"></a>
# Manuel d'opérations

> **Source canonique en anglais:** [OPERATIONS_PLAYBOOK.md](../../OPERATIONS_PLAYBOOK.md). Cette documentation localisée conserve les commandes, chemins, clés, valeurs d'état, hachages et noms de fichiers exacts. Si la formulation technique diffère, utilisez la source anglaise.


C'est l'ordre de lecture normal pour RandomDayGuard. Vous n'avez pas besoin de connaître JSON, Git, les sommes de contrôle ou les outils de ligne de commande pour examiner un serveur sain.

<a id="daily-operator-flow"></a>
## Flux quotidien des opérateurs

1. Ouvert `runtime/final_logs/server_status_latest.txt`. Il vous indique si Guard surveille l'exécution actuelle du serveur, quand son dernier cycle est terminé, combien de joueurs sont connectés et si une source ou une analyse est incomplète.
2. Ouvert `runtime/final_logs/daily_rollup_latest.txt` une fois par jour. Il résume les sessions du même jour, les sorties, les dossiers nommés, l'inventaire des identités et la couverture des sources sans répéter chaque enregistrement individuel.
3. Ouvert `runtime/final_logs/player_activity_latest.txt` uniquement lorsque le serveur a eu une session de connexion, de sortie ou active au cours de la journée.
4. Ouvert `runtime/final_logs/case_review_latest.txt` uniquement lorsqu'il nomme un sujet actuel. Le rapport indique le compte, l'état de révision, le score, la source d'identité et les enregistrements à ouvrir ensuite.
5. Ouvert `runtime/final_logs/critical_guard_latest.txt` uniquement lorsque Guard signale un échec lors de son propre démarrage, cycle de surveillance ou écriture de rapport.

Si un itinéraire n'a rien à signaler, Guard enregistre un résultat vide attendu. Il s'agit d'une vérification terminée, pas d'un rapport manquant.

<a id="what-to-read-inside-a-report"></a>
## Ce qu'il faut lire dans un rapport

Lisez ces sections dans l'ordre :

1. **Résumé** - ce que couvre ce rapport.
2. **Ce que Guard a observé** - les horodatages, décomptes, comptes, sessions ou valeurs d'état réels collectés pour cet itinéraire.
3. **Ce que cela signifie** - l'interprétation en langage clair de ces enregistrements.
4. **Ce qui reste inconnu** - une limite de source ou d'analyse qui affecte le résultat.
5. **Prochaine étape recommandée** - s'il faut surveiller, examiner un sujet nommé ou réparer Guard.
6. **Limite des preuves** - la limite du rapport portée.

Le dossier technique et les références aux sources apparaissent à la fin pour les lecteurs qui ont besoin d'inspecter les preuves structurées exactes.

<a id="when-a-report-is-missing"></a>
## Lorsqu'un rapport est manquant

Ouvert `runtime/final_logs/route_proof.json` uniquement lorsqu'un rapport lisible est absent ou indique que sa preuve actuelle est manquante. Chaque itinéraire a l'un de ces résultats :

| Résultat | Signification |
|---|---|
| `full` | Le garde a terminé l'itinéraire avec les preuves appartenant à l'itinéraire actuel. |
| `limited_expected_empty` | Le garde a terminé l'itinéraire et n'a trouvé aucun événement admissible ni enregistré une limite de maturité nommée. |
| `missing` | Une source requise, une vérification de lignée ou une écriture de rapport couplé n'a pas été terminée. |

Pour un itinéraire manquant, suivez la source nommée ou écrivez l'erreur dans le rapport. Ne modifiez pas d'abord les itinéraires non liés ou les paramètres de notification.

<a id="after-a-crash-or-restart"></a>
## Après un crash ou un redémarrage

1. Lisez l'état du serveur pour connaître le nouvel horodatage d'exécution du serveur et le dernier cycle de surveillance terminé.
2. Lisez Critical Guard pour un démarrage ou un échec d'interrogation en cours.
3. Lisez l'activité du joueur uniquement si une session du même jour a rejoint, quitté ou est revenue après le cycle de vie. changement.
4. Conservez l'enregistrement source cité avant de modifier la configuration.

<a id="before-enabling-optional-adminini-writes"></a>
## Avant d'activer les écritures facultatives Admin.ini

Le package par défaut surveille et rapporte sans changer `Admin.ini`. Les opérateurs avancés peuvent activer le chemin d’application facultatif après l’avoir testé sur une copie du fichier. Guard exige ensuite un identifiant de compte numérique propre, protège les comptes de confiance, crée et vérifie une sauvegarde, rejette les modifications simultanées, lit le fichier enregistré et restaure la sauvegarde si la vérification échoue. Voir [`ADMIN_INI_ENFORCEMENT.md`](ADMINISTRATEUR_INI_ENFORCEMENT.md) pour la procédure complète de configuration et de test.

<a id="related-guides"></a>
## Guides associés

- [`START_HERE.md`](COMMENCER_ICI.md)
- [`REPORT_EXAMPLES.md`](EXEMPLES_DE_RAPPORTS.md)
- [`PLAYER_REVIEW_WORKFLOW.md`](FLUX_DE_TRAVAIL_DE_R%C3%89VISION_DU_LECTEUR.md)
- [`TROUBLESHOOTING.md`](D%C3%89PANNAGE.md)
- [`OUTPUT_SCHEMA_REFERENCE.md`](R%C3%89F%C3%89RENCE_DU_SCH%C3%89MA_DE_SORTIE.md)
