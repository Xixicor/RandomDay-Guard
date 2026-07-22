<a id="start-here-read-the-first-guard-report"></a>
# Commencez ici : lisez le premier rapport de la Garde

> **Source canonique en anglais:** [START_HERE.md](../../START_HERE.md). Cette documentation localisée conserve les commandes, chemins, clés, valeurs d'état, hachages et noms de fichiers exacts. Si la formulation technique diffère, utilisez la source anglaise.


Ce guide démarre après l'installation et l'activation de RandomDayGuard. Cela s'avère un résultat utile sans demander à un nouvel opérateur d'inspecter le code source, les composants internes du package ou les fichiers d'état de la machine uniquement.

<a id="what-happens-after-the-server-starts"></a>
## Que se passe-t-il après le démarrage du serveur

Guard attend que le serveur de jeu et UE4SS se chargent, trouve les enregistrements disponibles du serveur et démarre une analyse en arrière-plan limitée. Il peut signaler l'état actuel du serveur pendant que l'historique plus ancien est encore en cours d'indexation.

Le premier rapport doit être **État du serveur**. Il indique si Guard termine les cycles de surveillance maintenant, quand l'exécution actuelle du serveur a commencé si cet horodatage est disponible, combien d'active/rotated couverture de journal et d'analyse existe, combien de joueurs sont connectés, quels groupes sources sont manquants et si une action de l'opérateur est nécessaire.

Une analyse en arrière-plan qui est toujours en cours est une limitation de la couverture historique, pas automatiquement un échec de démarrage. Guard enregistre le curseur d'analyse, les fichiers terminés, les fichiers découverts et l'heure de la dernière progression. Si ces valeurs cessent de changer au cours de cycles de surveillance répétés, considérez le chemin historique comme bloqué et suivez la branche d'analyse dans Dépannage. Ne supprimez pas les résultats actuels du journal et de la session uniquement parce que l'ancien historique est incomplet.

<a id="read-the-first-server-status-report"></a>
## Lisez le premier rapport d'état du serveur

1. Démarrez le serveur dédié normalement.
2. Attendez que le serveur de jeu et UE4SS terminent le démarrage.
3. Ouvert RandomDayGuard's dossier des rapports finaux et choisissez le rapport lisible sur l'état du serveur le plus récent.
4. Confirmez que le rapport contient :
   - **Résumé**
   - **Ce que Guard a observé**
   - **Ce que cela signifie**
   - **Ce qui reste inconnu**
   - **Prochaine étape recommandée**
   - **Dossier technique**
5. Dans **Ce que Guard a observé**, confirme les dernières avancées du cycle de surveillance et les noms de rapport disponibles pour le journal, l'analyse, le lecteur et la couverture de la source.
6. Si l'étape suivante indique qu'aucune intervention n'est nécessaire, conservez le rapport comme premier résultat réussi. S'il nomme une source manquante ou un processus arrêté, suivez ce symptôme exact dans [Dépannage](D%C3%89PANNAGE.md).

Le rapport peut être lié à des preuves techniques pour un examen plus approfondi. Un opérateur normal peut d'abord lire le rapport et ouvrir ces références uniquement lorsque le résultat brut doit être vérifié.

<a id="understand-quiet-reports"></a>
## Comprendre les rapports discrets

L'activité des joueurs, l'examen des cas et la protection critique sont pilotés par les événements. Un serveur silencieux ne devrait pas produire un joueur, un cas ou un échec fictif simplement pour remplir un canal. Le résultat lisible peut indiquer que la source a été vérifiée et que rien n'appartenait à ce rapport.

Le cumul quotidien est différent : il fournit une révision par date de rapport en utilisant les sessions du même jour, les sujets de révision actuels, le contexte identity/case conservé, la progression de l'analyse et les lacunes de la source que Guard peut réellement lire. Les faits absents des enregistrements du serveur disponibles restent inconnus au lieu d'être estimés.

<a id="test-one-ordinary-player-session"></a>
## Testez une session de joueur ordinaire

Une fois le premier rapport d'état du serveur à jour :

1. Laissez un joueur connu rejoindre et quitter normalement.
2. Attendez le prochain cycle de rapport.
3. Ouvrir le lecteur activité.
4. Confirmez qu'il identifie le compte ou le nom d'affichage disponible pour Guard, les heures d'adhésion et de sortie, le résultat de session propre ou incomplet, l'historique antérieur lorsqu'il est disponible et une action suivante.

Le rapport de session doit contenir les données observées. Il ne doit pas être remplacé par une liste de noms de fichiers ou une déclaration générique indiquant que des enregistrements existent.

<a id="continue"></a>
## Continuer

- [Cinq exemples de rapports](EXEMPLES_DE_RAPPORTS.md)
- [Manuel d'opérations](MANUEL_D_OP%C3%89RATIONS.md)
- [Flux de travail d'évaluation des joueurs](FLUX_DE_TRAVAIL_DE_R%C3%89VISION_DU_LECTEUR.md)
- [Dépannage](D%C3%89PANNAGE.md)
- [Index de documentation complet](DOCUMENTATION.md)
