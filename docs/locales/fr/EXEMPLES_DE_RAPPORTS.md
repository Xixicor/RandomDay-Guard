<a id="examples-of-the-five-guard-reports"></a>
# Exemples des cinq rapports Guard

> **Source canonique en anglais:** [REPORT_EXAMPLES.md](../../REPORT_EXAMPLES.md). Cette documentation localisée conserve les commandes, chemins, clés, valeurs d'état, hachages et noms de fichiers exacts. Si la formulation technique diffère, utilisez la source anglaise.


Ces exemples ont été produits à partir des exemples de données inclus dans la version ; les noms et numéros de compte sont inventés. Ils affichent les champs du rapport testés, les calculs et les limites de l'itinéraire. Un vrai rapport les remplace par les informations collectées à partir de ce serveur et indique quand un fait n'était pas disponible.

Chaque rapport a une tâche. L’état du serveur ne répète pas l’historique des joueurs, la revue quotidienne n’est pas envoyée toutes les quelques minutes et les itinéraires silencieux des joueurs ou des cas ne reçoivent pas de messages de remplissage. Un rapport actuel peut être prêt alors que l'analyse historique limitée est encore en cours ; dans ce cas, le rapport nomme l'écart au lieu de présenter l'ancien historique comme étant complet.

<a id="server-status"></a>
## État du serveur

> **État du serveur : en ligne après le redémarrage**  **État actuel :** En ligne **Disponible depuis :** 14:07  **Redémarrage terminé :** 14:06  **Temps d'arrêt :** 3 minutes et 12 secondes **Raison du redémarrage :** Mise à jour programmée du jeu **Surveillance :** Actif. Dernière vérification réussie : 14h09 **Journal de jeu :** Disponible et mis à jour **Analyse historique :** 312 fichiers sur 355 examinés **Sauvegardes :** Dernière vérification : 13h00. Prochaine date prévue : 15h00. Échecs aujourd'hui : 0 **Action :** Aucune. Le serveur s'est rétabli normalement.

L'état du serveur concerne le fonctionnement actuel du serveur : démarrage, redémarrage, récupération, temps d'arrêt, sauvegardes, planificateur et état de santé de Guard. Il ne contient pas de sessions de joueurs ni de détails sur les cas.

<a id="daily-rollup"></a>
## Consolidation quotidienne

> **Avis quotidien : 19 juillet 2026**  **Disponibilité du serveur :** En ligne pendant 23 heures et 47 minutes. Hors ligne pendant 13 minutes.  **Redémarrages :** 2 au total : 1 planifié et 1 inattendu.  **Sauvegardes :** 23 réussi. 1 manquant ou échoué. Dernière sauvegarde réussie : 23h00.  **Activité des joueurs :** 3 joueurs uniques. 7 séances : 6 terminées normalement et 1 interrompue.  **Activité du dossier :** 1 nouveau cas, 2 cas mis à jour, 1 cas nécessitant une attention particulière et 0 cas critique.  **Couverture des preuves :** 6 des 7 groupes de sources attendus étaient disponibles. Le journal de sauvegarde de 04h00 n'était pas disponible.  **Résumé de la journée :** Le serveur est resté disponible pendant la majeure partie de la journée. Une interruption inattendue a mis fin prématurément à une session de joueur. La surveillance a repris après le rétablissement et un cas est prêt à être examiné.  **Action :** Cas de révision `RDG-20260719-004`. Aucune autre action immédiate n'est requise.

Le cumul quotidien est écrit une fois pour sa date calendaire. Il combine la journée entre des périodes calmes et redémarre sans devenir un autre ping d'état du serveur.

<a id="player-activity"></a>
## Activité du joueur

> **Activité du joueur : Alex**  **Compte :** `76561198000000400`  **Première observation :** 12 juillet 2026 **Dernière session :** Inscrit à 10h02, parti à 11h18, a duré 1 heure 16 minutes et s'est terminé normalement.  **Aujourd'hui :** 3 connexions, 2 sessions terminées, 1 session interrompue et 2 reconnexions rapides en 10 minutes.  **7 jours précédents :** 9 sessions, 6 heures 18 minutes de lecture enregistrée et 0 cas précédent.  **Observé :** Alex est revenu deux fois peu de temps après une session interrompue. L’activité enregistrée est suffisamment complète pour être conservée comme historique, mais elle n’explique pas à elle seule pourquoi les reconnexions ont eu lieu.  **Action :** Poursuivre la surveillance. Aucune action immédiate n'est requise.

L'activité du joueur est envoyée uniquement lorsque les informations sur le joueur ou la session pris en charge changent. Une période d'inactivité ne crée pas de message de joueur.

<a id="case-review"></a>
## Examen du cas

> **Examen du cas : RDG-20260719-004**  **Sujet :** Alex **Compte :** `76561198000000400`  **Statut :** Examen de l'administrateur demandé **Note de l'avis :** 90 - Haute priorité **Pourquoi le dossier a été ouvert :** Le compte a effectué des tentatives de connexion répétées après une session interrompue, et le serveur a enregistré directement les demandes de connexion.  **Observations confirmées :** - Une demande de connexion a été enregistrée à 18h42. - Quatre tentatives ont été enregistrées en 6 minutes. - Deux séances se sont terminées sans record de départ normal. - Le même récit a été observé les 12 et 17 juillet.  **Historique pertinent :** Aucun cas antérieur n'est enregistré pour ce compte.  **Inconnu :** Les enregistrements disponibles n'établissent pas la raison des reconnexions, l'intention du joueur ou si l'état du monde a changé.  **Action recommandée :** Comparez les durées de session avec le journal du serveur et l'activité mondiale enregistrée avant de décider si une action est nécessaire.

L'examen du cas contient le matériel d'examen nommé, ses observations confirmées, ses limites et une étape d'examen spécifique. La présence historique à elle seule ne crée pas un nouveau cas.

<a id="critical-guard"></a>
## Garde critique

> **Garde critique : écriture du rapport arrêtée**  **Démarré :** 21:14  **Fonction affectée :** Rédacteur de rapport du joueur **Impact :** Les résumés des nouveaux joueurs ne peuvent pas être complétés.  **Serveur :** Reste en ligne.  **Surveillance :** La collecte de preuves se poursuit, mais les rapports lisibles sont retardés.  **Dernier rapport réussi :** 21:09  **Échec :** La sortie du rapport n'a pas pu être enregistrée.  **Raison probable :** La destination n'était pas disponible ou a rejeté l'écriture.  **Action :** Vérifiez l'emplacement de sortie du runtime Guard. Ne redémarrez pas le serveur de jeu à moins que la surveillance ne s'arrête également.

Lorsque le problème disparaît, le même itinéraire enregistre la récupération :

> **Garde critique résolue : écriture du rapport restaurée**  **Reprise :** 21:22  **Interruption :** 8 minutes **Résultat :** Les preuves collectées pendant l'interruption ont été préservées et les rapports retardés ont été complétés.

Critical Guard fonctionne uniquement en cas d'échec. L'état de la routine, l'historique quotidien, l'activité des joueurs et les résultats ordinaires attendus-vides restent dans leurs propres rapports.

<a id="when-a-route-is-quiet"></a>
## Lorsqu'un itinéraire est silencieux

Un itinéraire silencieux enregistre un résultat direct sans envoyer de remplissage à Discord :

> **Vérifié ; rien pour ce rapport.** Les enregistrements requis étaient disponibles et aucune activité de joueur, cas ou échec de garde correspondant ne s'est produit pendant cette fenêtre de rapport.

C'est un résultat complètement vide. C'est différent d'un rapport manquant, dans lequel une source requise n'a pas pu être vérifiée ou la sortie lisible n'a pas pu être créée.

Chaque rapport lisible suit le même chemin :

```text
collected evidence -> normalized values -> dictionary mapping -> route calculations -> readable report -> Discord notification
```

Utilisez le [playbook des opérations](MANUEL_D_OP%C3%89RATIONS.md) pour examiner les rapports actuels et le [schéma de sortie](R%C3%89F%C3%89RENCE_DU_SCH%C3%89MA_DE_SORTIE.md) pour la référence du domaine technique.
