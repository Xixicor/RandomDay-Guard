<a id="glossary"></a>
# Glossaire

> **Source canonique en anglais:** [GLOSSARY.md](../../GLOSSARY.md). Cette documentation localisée conserve les commandes, chemins, clés, valeurs d'état, hachages et noms de fichiers exacts. Si la formulation technique diffère, utilisez la source anglaise.


| Terme | Signification simple | Signification technique exacte |
|---|---|---|
| Journal actif | Le journal du serveur actuel utilisé pour de nouvelles preuves. | Obligatoire `active_log` source ; la lisibilité et le lignage actuel sont nécessaires pour l'achèvement de l'itinéraire. |
| ID de démarrage | Démarrage d'un processus de surveillance. | Identifiant d'exécution actuel utilisé pour rejeter le démarrage préalable errors/reports. |
| ID d'époque | Un intervalle de continuité du serveur. | Identifiant couvrant la durée d'exécution normale jusqu'à ce que la logique de continuité démarre une autre époque. |
| ID d'interrogation | Une opportunité d'interrogation limitée. | Champ de cycle monotone positif ; zero/missing ne peut pas terminer un itinéraire. |
| Fraîcheur de la source | Si la source actuelle et la lignée du sondage sont d'accord. | `fresh_current_poll` ou `stale_or_unproven` avec horodatages et état du journal actif. |
| Comptabilité source | Inventaire de la disponibilité et des limites des preuves. | `randomdayguard.source-accounting/v1` avec huit classes de source et current/historical portée. |
| `available` | Une source a été trouvée et lue. | Statut de la source terminale avec `available=true`, `readable=true`. |
| `expected_empty` | Une source facultative a été vérifiée et légitimement absent/empty. | État de la source lisible sur le terminal ; ne fabrique jamais de sujet. |
| `partial` | Le travail limité a des résultats utiles mais incomplets. | Statut non terminal source/accounting ; reprendre le travailleur propriétaire. |
| `deferred` | Le travail est intentionnellement en attente. | Statut de la source non terminale ; il ne s'agit pas d'une erreur ou d'un achèvement. |
| `unavailable` | La source ne peut pas être utilisée actuellement. | Espace terminal ; un écart entre les sources requises rend la comptabilité indisponible. |
| `malformed` | Une source existe mais est structurellement invalide. | Espace terminal préservant les détails de validation et la fermeture des écritures dépendantes. |
| `permission_denied` | Le système d'exploitation a explicitement rejeté l'accès. | Espace terminal distinct de missing/unavailable. |
| `error` | Une opération limitée a échoué de manière inattendue. | Défaillance du terminal nécessitant la récupération nommée ; aucun détail secret n'a sa place dans les rapports publics. |
| `complete` | Toutes les sources comptabilisées sont terminales sans interruption. | Statut comptable de la source de niveau supérieur. |
| `complete_with_gaps` | Les preuves actuelles requises fonctionnent ; des lacunes de terminal facultatives subsistent. | Statut comptable de niveau supérieur ; les itinéraires appliquent toujours leurs propres exigences. |
| `full` | Un itinéraire terminé avec son contrat non vide requis. | Énumération de preuve d'itinéraire avec les sorties du cycle en cours terminées. |
| `limited_expected_empty` | Un itinéraire terminé et trouvé non éligible subject/failure. | Énumération de preuve d'itinéraire avec `completed=true`, `expected_empty=true`. |
| `missing` | La preuve d'achèvement d'itinéraire est absente ou échouée. | Énumération de preuve d'itinéraire avec `completed=false`; jamais éligible pour la boîte d'envoi. |
| Rapport structuré | Sortie d'itinéraire lisible par machine. | `<route>_latest.json` en utilisant `randomdayguard.report/v1`. |
| Rapport traduit | Rendu lisible par l'homme du même itinéraire. | `<route>_latest.txt` avec fixe Ordre des références observées à la source. |
| Preuve d'itinéraire | Grand livre d'achèvement des itinéraires croisés. | `route_proof.json` liaison version/boot/epoch/poll/freshness/output chemins. |
| Preuves actuelles | Observation appartenant à l'actif cycle. | Portée `current` ; non reconstruit à partir d'anciennes filenames/reports. |
| Preuves historiques | Contexte conservé des cycles précédents ou analyse lente. | Portée `historical` ; peut éclairer l'examen, mais ne peut pas revendiquer sa présence actuelle. |
| Révision uniquement | Produire des preuves d'examen sans Admin.ini écritures réelles. | Par défaut `review_only_mode=true`, `auto_ban=false`, `write_admin_ini=false`. |
| Contrôle de sécurité de la liste d'interdiction | Une question à laquelle le garde doit répondre avant qu'il puisse changer `Admin.ini`. | Il doit confirmer le compte et le score, exclure les comptes de confiance et les doublons, vérifier une sauvegarde, détecter les modifications extérieures, enregistrer la mise à jour prévue et vérifier ou en toute sécurité restaurer le fichier complet. |
| Boîte d'envoi locale | Transfert facultatif de notification indépendant du fournisseur. | JSON fichiers avec `delivery_backend="none"` et `delivery_attempted=false`. |
| Base de référence | Instantané de contexte de fichier enregistré terminé et délimité. | Manifest/object/world état réutilisé uniquement lorsqu'il est compatible et suffisamment récent. |
| Point de contrôle | Reprendre la position en cas de travail de numérisation incomplet. | `scan_checkpoint.json` ; la suppression n'est pas la récupération par défaut. |
| Index reconstructible | Résumé qui peut être régénéré. | Daily/weekly/forensic/final sortie de révision ; les preuves de la source font autorité. |
| Limite des preuves | Limitation de ce qu'une source peut prendre en charge. | Explicites `does_not_prove`, inconnues, force d'identité et règles de portée. |

Les définitions canoniques des schémas se trouvent dans [`OUTPUT_SCHEMA_REFERENCE.md`](R%C3%89F%C3%89RENCE_DU_SCH%C3%89MA_DE_SORTIE.md) ; les termes de configuration se trouvent dans le [`CONFIG_FIELD_CATALOG.md`](CATALOGUE_DE_CHAMPS_DE_CONFIGURATION.md).
