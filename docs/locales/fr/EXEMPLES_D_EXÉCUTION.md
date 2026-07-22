<a id="worked-operation-examples"></a>
# Exemples d'opérations travaillées

> **Source canonique en anglais:** [EXAMPLE_RUNS.md](../../EXAMPLE_RUNS.md). Cette documentation localisée conserve les commandes, chemins, clés, valeurs d'état, hachages et noms de fichiers exacts. Si la formulation technique diffère, utilisez la source anglaise.


Ces exemples utilisent des valeurs inventées pour expliquer les transitions d'état attendues ; ils ne constituent pas une compatibilité en direct ni une preuve de joueur.

<a id="successful-current-cycle"></a>
## Cycle actuel réussi

Entrée : journal actif lisible, version/boot/epoch, `poll_id=41`, sondage actuel terminé, accounting/history/report racines inscriptibles, pas de politique d'analyse lente bloquante.

Attendu :

```text
server_status = full
player_activity = full or limited_expected_empty
case_review = full or limited_expected_empty
daily_rollup = full or limited_expected_empty
critical_guard = full or limited_expected_empty
```

Chaque itinéraire activé a JSON/TXT sortie et même lignée dans `route_proof.json`. L'état de la route dépend de ses propres sujets, et non d'un message de réussite générique.

<a id="expected-empty-player-and-case-routes"></a>
## Routes de lecteur et de cas attendues vides

Entrées : la preuve du cycle en cours est terminée ; aucune rangée de joueurs actuels ou conservés ; aucun cas retenu et aucun compte REVIEW/BAN-ELIGIBLE actuel.

Attendu :

```text
player_activity.route_proof_status = limited_expected_empty
player_activity.expected_empty = true
player_activity.players = []

case_review.route_proof_status = limited_expected_empty
case_review.expected_empty = true
case_review.cases = []
```

Les rapports traduits indiquent qu'aucun sujet délimité éligible n'a été observé. Ils disent également que cela ne prouve pas que personne n’ait jamais été connecté ni qu’aucun contexte ne manque. Aucun espace réservé player/case n'est créé.

<a id="partial-bounded-scan"></a>
## Analyse partielle limitée

Entrées : courant frais log/poll; `scan_checkpoint.json` ou `scan_progress.json` existe ; l'analyse est incomplète ; par défaut `slow_world_scan_blocks_current_reports=false`.

Attendu :

```text
world_save_scan.status = partial
source accounting = partial
server_status may still be full for fresh current state
historical routes name the scan limitation
```

Défini `slow_world_scan_blocks_current_reports=true` uniquement lorsque l'opérateur souhaite que cette source lente facultative bloque les rapports actuels. La récupération vise à permettre à l'analyseur de reprendre, et non de supprimer le point de contrôle.

<a id="missing-current-cycle-proof"></a>
## Preuve du cycle en cours manquante

Entrées : journal actif indisponible, `poll_id=0`, ou boot/epoch/last-poll lignée manquante.

Attendu :

```text
current_cycle_proof_complete = false
all route proof statuses = missing
each configured route envelope status = suppressed_current_cycle
delivery_eligible = false
delivery_attempted = false
```

L'enveloppe supprimée est un enregistrement d'audit, pas une livraison en file d'attente. Les anciens journaux finaux restent uniquement historiques. Réparez le premier champ lineage/source manquant et générez un cycle plus récent.

<a id="malformed-optional-adminini-source"></a>
## Source facultative Admin.ini malformée

Entrées : `Admin.ini` existe mais échoue à la validation structurelle propre.

Attendu :

```text
admin_ini.status = malformed
source reference preserved
write/enforcement path closed
```

Conservez le fichier et restaurez-le. un format propre revu. Conserver le texte explicatif dans les preuves d'exécution ; chaque `Admin.ini` entrée d'interdiction reste uniquement `BannedPlayer=<ID>`.

<a id="required-active-log-probe-error"></a>
## Erreur de sonde de journal actif requise

Entrées : la sonde de journal actif requise et limitée échoue avec une erreur de lecture nettoyée.

Attendu :

```text
source_accounting.sources[active_log].status = error
source_accounting.sources[active_log].detail = "bounded active-log probe failed: <sanitized reason>"
coverage_status = unavailable
all route proof statuses = missing
```

`error` reste sur la ligne source avec ses détails limités. Le rapport de niveau supérieur utilise `unavailable`, et la preuve d'itinéraire reste `missing` jusqu'à ce qu'un cycle actuel plus récent prouve la source requise.

<a id="incompatible-or-stale-baseline"></a>
## Base de référence incompatible ou obsolète

Entrée : package/source identité ou stale/incompatible base de référence modifiée manifest.

Attendu : la validation ou l'état d'exécution enregistre l'incompatibilité ; l'état de l'analyse ne revendique pas une réutilisation terminée. Conservez les preuves antérieures, démarrez une reconstruction de base explicite et attendez une nouvelle preuve de terminal. Une reconstruction forcée sans raison enregistrée n'est pas la récupération par défaut.

<a id="paired-report-write-failure"></a>
## Échec d'écriture de rapport apparié

Entrées : JSON l'écriture réussit mais TXT l'écriture échoue, ou l'inverse.

Attendu :

```text
route_proof_status = missing
completed = false
coverage_status = unavailable
output_write_detail = "paired JSON/TXT write failed: <sanitized reason>"
next_action = repair both route output writes
```

Le rédacteur s'efforce de réécrire les deux frères et sœurs pour converger vers l'échec. Un frère ou une sœur qui réussit ne peut pas rester un prétendant au succès. Les détails d'écriture limités ne créent pas de cinquième valeur de couverture de niveau supérieur.

<a id="route-proof-write-failure"></a>
## Échec d'écriture à l'épreuve des routes

Entrée : les paires de routes ont été écrites mais `route_proof.json` ne peuvent pas être remplacées.

Attendu : tous les rapports sont réécrits `missing`, tous les résultats de notification sont `route_proof_write_failed`, et aucune enveloppe n'est acceptée. Une route configurée peut avoir une enveloppe d'audit `suppressed_current_cycle` avec des indicateurs de livraison faux. Réparez la racine de sortie et régénérez le même cycle actuel.

<a id="review-only-enforcement-example"></a>
## Exemple d'application pour révision uniquement

Config :

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

Attendu : des scores, des cas et des recommandations peuvent être écrits ; `Admin.ini` reste inchangé. Il s'agit de la valeur publique par défaut.

<a id="approved-write-success-example"></a>
## Exemple de réussite d'écriture approuvée

Seul un test approuvé séparément peut définir les trois commutateurs d'écriture. Il doit également prouver une identité numérique claire, trust/moderator l'exclusion, le seuil d'éligibilité, la validité Admin.ini path/parse, la réussite de la sauvegarde, la réussite de l'écriture, l'égalité de relecture et les preuves spécifiques au compte.

Attendu :

```text
runtime/backups/Admin_<timestamp>_<source-fingerprint>_<clean-ID>.ini
Admin.ini contains one clean BannedPlayer=<ID>
runtime/enforced_bans.jsonl and evidence mirror record success
```

L'exemple réussi ne permet pas l'application automatique pour les autres comptes.

<a id="writereadback-failure-with-rollback"></a>
## Write/readback échec avec la restauration

Entrée : toutes les porte de pré-écriture franchie ; l'écriture ou la relecture de remplacement échoue ; `rollback_on_readback_failure=true` et la sauvegarde vérifiée est disponible.

Attendu : la preuve de défaillance enregistre l'étape et `rollback_success` ; les Admin.ini octets d'origine sont restaurés et le compte n'est pas signalé comme appliqué avec succès. Si la restauration échoue également, arrêtez les écritures, conservez les deux files/evidence et récupérez manuellement à partir de la sauvegarde.

<a id="local-outbox-example"></a>
## Exemple de boîte d'envoi locale

Entrées : notification activée en mode `local_file_outbox`, itinéraire activé, preuve d'itinéraire terminée et `full` ou explicitement autorisé attendu-vide.

Enveloppe attendue :

```text
schema = randomdayguard.notification/v1
completed_output = true
status = ready_for_local_consumer
delivery_eligible = true
delivery_backend = none
delivery_attempted = false
```

Pour missing/ineligible sortie, le même chemin peut contenir à la place `status=suppressed_current_cycle`, `completed_output=false` et `delivery_eligible=false`. L'un ou l'autre fichier prouve une écriture locale uniquement. Aucun fournisseur, transport, livraison ou accusé de lecture n'est regroupé ou déduit.

Voir [`OUTPUT_SCHEMA_REFERENCE.md`](R%C3%89F%C3%89RENCE_DU_SCH%C3%89MA_DE_SORTIE.md), [`CONFIG_FIELD_CATALOG.md`](CATALOGUE_DE_CHAMPS_DE_CONFIGURATION.md) et [`TROUBLESHOOTING.md`](D%C3%89PANNAGE.md).
