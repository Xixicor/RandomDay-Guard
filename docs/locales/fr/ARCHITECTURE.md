<a id="architecture-and-lifecycle"></a>
# Architecture et cycle de vie

> **Source canonique en anglais:** [ARCHITECTURE.md](../../ARCHITECTURE.md). Cette documentation localisée conserve les commandes, chemins, clés, valeurs d'état, hachages et noms de fichiers exacts. Si la formulation technique diffère, utilisez la source anglaise.


RandomDayGuard est un UE4SS module de reporting isolé. Il lit les fichiers appartenant au serveur, maintient l'état local limité et écrit les preuves locales et examine les sorties. panneau de contrôle, service de notification, RandomDay ou dépendance réseau.

<a id="end-to-end-data-flow"></a>
## Flux de données de bout en bout

1. UE4SS charge le point d'entrée canonique unique `RandomDayGuard/Scripts/main.lua`. Les packages actuels ne fournissent pas de doublon de variante de casse minuscule.
2. Le chargeur lit `config.lua`, les trois dictionnaires de données et `SavedRoot.txt` facultatif. L'identité de la version doit être conforme à `VERSION`, `MANIFEST.json` et `BUILD_MARKER.txt`.
3. Les vérifications de découverte de racine enregistrée délimitent les candidats connus et les fichiers connus directs. Il enregistre ce qui était lisible dans `runtime/saved_path_probe.json` ; trouver un répertoire à lui seul ne constitue pas une couverture de preuve.
4. La couche immédiate suit le journal du serveur actif à partir d'un décalage sûr. Il normalise le cycle de vie, la session, le compte, l'avertissement, la reconnexion et d'autres événements observés en preuves ajoutées uniquement ainsi qu'en instantanés actuels.
5. La couche lente inventaire les fichiers enregistrés en morceaux délimités. Il écrit la progression et les points de contrôle, reprend le travail incomplet, compare un manifeste de fichier modifié et produit un contexte object/world partiel puis final.
6. La logique de révision corrèle uniquement les preuves dont elle dispose. Les noms de fichiers faibles, le timing, le nombre de classes, les coordonnées relatives, le taux de désabonnement, un seul crash ou un ping restent contextuels et ne peuvent pas autoriser l'application à eux seuls.
7. Un générateur de rapports distinct appelle `Scripts/public_pipeline.lua`. Il inventorie les classes sources, enregistre la portée actuelle par rapport à la portée historique, lie le cycle à la version/boot/epoch/poll/source fraîcheur, écrit cinq paires JSON/TXT spécifiques à l'itinéraire, puis écrit `route_proof.json`.
8. Lorsqu'elle est explicitement activée, la boîte d'envoi locale copie les références d'un rapport terminé une fois que la preuve de l'itinéraire existe. Il enregistre `delivery_backend="none"` et `delivery_attempted=false` ; le transport est en dehors de ce produit.

<a id="ownership-and-asynchronous-boundaries"></a>
## Propriété et limites asynchrones

| Propriétaire | Travail limité | Ne doit pas bloquer ou impliquer |
|---|---|---|
| Démarrage | Config, racine enregistrée, journal actif, époque, index, statut initial. | Un marqueur de chargement réussi ne prouve ni preuves ni itinéraires. |
| Rappel d'interrogation | Nouveaux octets de journal, mises à jour d'état, event/session/account sorties, planification. | Découverte ou rapport récursif lent drainage. |
| Travailleur d'analyse | Découverte du manifeste, analyse des fichiers, point de contrôle, partial/final ligne de base. | Progression actuelle du journal ; partiel n'est pas un échec. |
| Travailleur de rapports | Comptabilité source, traduction, paires de rapports, preuve d'acheminement, boîte d'envoi locale. | Application ou livraison externe. |
| Application facultative | Confirmez le compte et le score, protégez les comptes de confiance et les doublons, vérifiez une sauvegarde, rejetez les modifications de fichiers externes, puis vérifiez le résultat enregistré. | Un score de rapport, un état d'itinéraire ou une appartenance à un cas contournant tout contrôle de sécurité requis. |

La boucle d'interrogation reste saine uniquement pendant `poll_id` avance, `poll_in_flight` renvoie false et la planification reste active. Cela prouve la composante sondage, pas le pipeline de rapports. Les analyses lentes peuvent être `partial` ou `deferred` ; la valeur par défaut `slow_world_scan_blocks_current_reports=false` permet de nouvelles routes actuelles tout en nommant la limitation historique.

<a id="state-and-lifecycle"></a>
## État et cycle de vie

| État | Entrée | Terminal ou état suivant | Erreur et récupération |
|---|---|---|---|
| Démarrage | UE4SS appelle le chargeur. | Exécuter poll/scan/report des travailleurs avec un ID de démarrage et une époque. | `startup_error` est une preuve critique du démarrage actuel ; réparez config/path/source et redémarrez. |
| Sondage en cours | Le rappel limité programmé commence. | Le sondage terminé enregistre l'horodatage et les reprogrammations. | `poll_error` est une preuve critique du démarrage actuel ; restaurez le travail limité et confirmez un sondage plus récent. |
| Analyse en attente | Base de référence requise ou point de contrôle incomplet trouvé. | `partial`/`deferred`, puis `scan_complete`. | Reprendre le point de contrôle ; reconstruire uniquement lorsque stale/incompatible des preuves sont enregistrées. |
| Comptabilité source | Le rapporteur inventaire huit classes sources. | `complete`, `complete_with_gaps`, `partial`, ou `unavailable`. | Disabled/failed la comptabilité force toutes les routes à `missing`. |
| Génération de routes | Le lignage du cycle actuel et la comptabilité source sont disponibles. | `full`, `limited_expected_empty`, ou `missing`. | L'échec d'écriture couplé JSON/TXT ou à l'épreuve des routes fait converger l'itinéraire vers `missing`. |
| Boîte d'envoi locale | Un itinéraire est activé, terminé et éligible. | En attente enveloppe locale et résultat du statut de notification. | Aucune preuve écrite ou incomplète signifie pas d'enveloppe ; aucune livraison n'est déduite. |
| Vérification de l'application | Les preuves spécifiques au compte atteignent le score configuré pour une action automatique. | Recommandation de révision uniquement ou une mise à jour `Admin.ini` explicitement activée. | Un contrôle de sécurité échoué ou indisponible arrête la mise à jour ; une comparaison finale échouée restaure la sauvegarde vérifiée lorsque la récupération est activée. |

<a id="current-and-historical-evidence"></a>
## Preuves actuelles et historiques

Les preuves actuelles appartiennent à la boot/poll active et ne sont jamais reconstruites à partir des seuls noms de fichiers conservés. Les preuves historiques incluent des bûches pivotées, durables account/session historique, conservé cases/reports/evidence et analyse limitée à l'échelle mondiale. Les rapports exposent des tableaux et des décomptes actuels et historiques distincts. Un redémarrage silencieux ne doit pas effacer le contexte durable et un enregistrement historique ne doit pas être présenté comme une présence actuelle.

<a id="completion-and-recovery-boundary"></a>
## Limite d'achèvement et de récupération

L'achèvement d'une route nécessite la correspondance de la version du cycle actuel, de l'ID de démarrage, de l'ID d'époque, de l'ID d'interrogation positif, du nouvel état du journal actif, des deux sorties de route et de son entrée dans `route_proof.json`. Les demandes de notification nécessitent en outre l’enveloppe locale du même cycle ; la livraison externe ne fait jamais partie de la preuve publique.

Si les rapports finaux sont manquants ou plus anciens que l'état actuel poll/source et continue à partir de la première lignée incompatible ou d'un échec d'écriture. Ne modifiez pas les itinéraires, la formulation ou les paramètres d’application sans rapport. Consultez les lignes [`OUTPUT_SCHEMA_REFERENCE.md`](R%C3%89F%C3%89RENCE_DU_SCH%C3%89MA_DE_SORTIE.md), [`TROUBLESHOOTING.md`](D%C3%89PANNAGE.md) et [`SOURCE_MODULE_REFERENCE.md`](R%C3%89F%C3%89RENCE_DU_MODULE_SOURCE.md).
