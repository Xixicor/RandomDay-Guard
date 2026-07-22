<a id="troubleshooting"></a>
# Dépannage

> **Source canonique en anglais:** [TROUBLESHOOTING.md](../../TROUBLESHOOTING.md). Cette documentation localisée conserve les commandes, chemins, clés, valeurs d'état, hachages et noms de fichiers exacts. Si la formulation technique diffère, utilisez la source anglaise.


Utilisez cette page lorsque Guard ne se charge pas, qu'une source ne peut pas être collectée, qu'un rapport n'apparaît pas ou que la preuve d'itinéraire contredit ce que vous attendiez. Commencez par l’arbre de décision et suivez une branche. Utilisez le [référence de l'état et des erreurs](R%C3%89F%C3%89RENCE_SUR_L_%C3%89TAT_ET_LES_ERREURS.md) uniquement une fois que la couche défaillante est connue.

Conservez les fichiers d'exécution actuels avant de modifier la configuration ou de réinstaller. Un artefact obsolète ou manquant identifie une étape ayant échoué ; des redémarrages répétés peuvent effacer ces preuves.

<a id="choose-the-failure-path"></a>
## Choisissez le chemin de l'échec

<a id="1-decide-whether-guard-loaded"></a>
### 1. Décidez si Guard a chargé

- **Aucun `runtime/` fichier n'existe :** suivez [Restaurez les fichiers d'exécution manquants](#restore-missing-runtime-files). Vérifiez le chemin d'installation, le chargeur canonique, `enabled.txt` et `mods.txt` avant d'examiner les rapports.
- **Les fichiers d'état actuels existent :** Guard chargé suffisamment loin pour écrire l'état. Passez à l'étape 2 ; la réinstallation n'est pas la première réponse.

<a id="2-decide-whether-the-scheduler-is-advancing"></a>
### 2. Décidez si le planificateur avance

Ouvert :

```text
runtime/current/startup_status.json
runtime/current/poll_status.json
```

- **Avance des compteurs et des horodatages :** passez à l'étape 3.
- **`poll_id` est statique, `poll_in_flight` reste vrai, ou l'état du planificateur n'est pas en cours d'exécution :** suivez [Récupérez une boucle d'interrogation bloquée](#recover-a-stuck-poll-loop).
- **L'analyse de base est en attente pendant que la progression du planificateur se poursuit :** il s'agit d'un avertissement, pas automatiquement un démarrage échoué. Enquêtez uniquement si le retard ou la progression de l'analyse s'arrête.

<a id="3-classify-route-proof"></a>
### 3. Classer la preuve d'itinéraire

Ouvert `runtime/final_logs/route_proof.json` et inspectez chaque itinéraire séparément.

- **`full`:** comparez la formulation inattendue avec la `source_references` et lignée. Ne modifiez pas la livraison car le libellé seul semble erroné.
- **`limited_expected_empty`:** actuelle confirmez que la comptabilité source prend en charge un résultat vide légitime. Ne créez pas de lecteur ou de cas synthétique.
- **`missing`:** suivez [ Diagnostiquer un itinéraire manquant](#diagnose-a-missing-route).

<a id="4-classify-source-coverage"></a>
### 4. Classer la couverture source

- **`partial`, `deferred`, `unavailable`, `malformed`, `permission_denied`, ou `error`:** suivez [Interpréter une couverture source incomplète](#interpret-incomplete-source-coverage), puis recherchez le code exact dans [Référence sur l'état et les erreurs](R%C3%89F%C3%89RENCE_SUR_L_%C3%89TAT_ET_LES_ERREURS.md).
- **La source structurée est actuelle mais la sortie traduite ou en attente est plus ancienne :** diagnostique le transfert d'achèvement, pas le point de terminaison de livraison. Conservez les horodatages et inspectez l'état du rapport et de l'envoi avant de modifier la configuration de la livraison.

<a id="5-follow-the-matching-branch"></a>
### 5. Suivez la branche correspondante

- Identité incomplète : [Mappez un joueur non mappé](#map-an-unmapped-player).
- Continuité quotidienne manquante : [Restaurer un cumul quotidien manquant](#restore-a-missing-daily-rollup).
- Le test d'application explicitement approuvé n'a pas été écrit : [Diagnostiquer une Admin.ini écriture bloquée](#diagnose-a-blocked-adminini-write).
- ZIP échec de l'extraction : [Résoudre un cas d'extraction Windows collision](#resolve-a-windows-extraction-folder-collision).
- La vérification du luminaire, du package ou du référentiel a échoué : [Validation et révision des versions](VALIDATION_ET_PUBLICATION.md#avoid-validation-environment-pitfalls).

<a id="6-stop-with-one-proved-outcome"></a>
### 6. Arrêtez avec un résultat prouvé

Une passe de dépannage se termine lorsque :

- l'itinéraire est actuel et `full`;
- l'itinéraire est actuel et `limited_expected_empty` pour une raison nommée ;
- un bloqueur exact, un chemin de preuve et une action suivante sont enregistrés ; ou
- La restauration a restauré l'état connu précédent et préservé les preuves d'échec.

« Le serveur est en cours d'exécution », un battement de cœur qui s'accélère, ou HTTP le succès seul ne prouve pas qu'un itinéraire de rapport est terminé.

<a id="diagnose-a-missing-route"></a>
##  Diagnostiquer un itinéraire manquant

Ouvert `runtime/final_logs/route_proof.json` et comparer `server_status`, `daily_rollup`, `player_activity`, `case_review` et `critical_guard`.

1.  Lire la raison, le lignage, le temps de génération de l'itinéraire, et les références de la source.
2. Confirmez que la source structurée nommée existe et appartient au même cycle.
3. Comparez son heure avec la sortie traduite et l'enveloppe en attente.
4. Si les journaux finaux sont plus récents que la sortie traduite ou en attente, enregistrez l'envoi d'achèvement périmé et réparez d'abord ce transfert.
5. Si toutes les sorties locales sont actuelles mais que la livraison est absent, puis inspectez la configuration de l'itinéraire et l'état de l'expéditeur.

Ne faites pas la promotion de l'état du planificateur ou d'une notification réussie vers une preuve à cinq itinéraires.

<a id="interpret-incomplete-source-coverage"></a>
## Interpréter une couverture source incomplète

| État | Que faire |
|---|---|
| `partial` | Utilisez uniquement les preuves collectées et évitez les réclamations de couverture complète. |
| `deferred` | Confirmez ultérieurement. le travail avance avant de changer la configuration. |
| `unavailable` | Enregistrez la limite d'environnement ; corrigez uniquement un problème de chemin ou d'autorisation prouvé. |
| `malformed` | Conservez la source et analysez l'erreur ; ne devinez pas les valeurs manquantes. |
| `permission_denied` | Accordez uniquement l'autorisation de lecture étroite requise. |
| `error` | Conservez les détails et diagnostiquez l'étape nommée avant de vous fier à l'itinéraire. |

<a id="restore-missing-runtime-files"></a>
## Restaurez les fichiers d'exécution manquants

Confirmez :

```text
mods.txt contains RandomDayGuard : 1
RandomDayGuard/enabled.txt exists
RandomDayGuard/Scripts/main.lua exists
```

La racine d'installation correcte est :

```text
AbioticFactor/Binaries/Win64/ue4ss/Mods/RandomDayGuard/
```

Rejetez cette disposition imbriquée :

```text
Mods/RandomDayGuard/RandomDayGuard/Scripts/main.lua
```

Si les fichiers sont corrects mais UE4SS n'ont pas démarré Guard, conservez `UE4SS.log` et comparez son horodatage de démarrage avec le démarrage réel du processus de jeu.

<a id="resolve-a-windows-extraction-folder-collision"></a>
## Résoudre une collision de dossiers d'extraction Windows

Une version plus ancienne utilisait des répertoires de programmes dont les noms ne différaient que par la majuscule. Certains extracteurs Windows fusionnent ces noms lorsqu'un ZIP est placé sur un dossier existant.

1. Supprimez uniquement l'extraction temporaire qui a échoué, pas le mod installé ou ses preuves.
2. Créez un nouveau répertoire temporaire vide.
3. Extractez-y la version actuelle.
4. Confirmez qu'il produit un dossier RandomDayGuard et un répertoire de programme.
5. Si Windows signale toujours une collision, téléchargez à nouveau la version et signalez la version de la version et l'extracteur utilisé.

N'extrayez jamais une nouvelle version sur le dossier installé. Suivez la procédure de mise à jour du dossier propre dans [`../INSTALL.md`](INSTALLATION.md).

<a id="load-the-expected-version"></a>
## Charger la version attendue

Vérifiez le marqueur source et le marqueur de build :

```sh
grep -n "local VERSION" RandomDayGuard/Scripts/main.lua
cat RandomDayGuard/BUILD_MARKER.txt
```

S'ils ne sont pas d'accord :

1. Arrêtez le serveur.
2. Sauvegardez le dossier installé, la configuration révisée et les preuves d'exécution.
3. Mettez en scène et inspectez le package prévu.
4. Remplacez uniquement les programmes et les fichiers de données gérés par le package.
5. Confirmez que le chargeur canonique existe et qu'aucun double en minuscule n'a été ajouté.
6. Démarrez une fois et relisez les marqueurs actuels avant de juger la sortie de l'exécution.

<a id="correct-a-missing-saved-root"></a>
## Corrigez une racine enregistrée manquante

Ouvert `runtime/saved_path_probe.json`. Mettez le chemin absolu vérifié vers le facteur abiotique complet `Saved/` dans `SavedRoot.txt` ; ne pointez pas uniquement vers un répertoire mondial. Un chemin en dehors de la racine délimitée doit rester rejeté.

<a id="recover-a-stalled-historical-scan"></a>
## Récupérer une analyse historique bloquée

La surveillance actuelle et la découverte historique sont distinctes. Une archive volumineuse peut nécessiter de nombreux cycles limités, donc une observation inchangée ne suffit pas pour la qualifier de bloquée.

1. Ouvert `runtime/current/report_worker_status.json`.
2. Enregistrez `scan_cursor`, les fichiers découverts, les fichiers terminés et `last_progress_ts`.
3. Attendez au moins deux opportunités normales de création de rapports et comparez à nouveau les mêmes champs.
4. Si le curseur, le décompte terminé ou le temps de progression avance, l'analyse fonctionne toujours. Laissez-le délimité.
5. Si tous les champs de progression restent inchangés pendant que les ID d'interrogation et les rapports actuels continuent d'avancer, conservez le fichier d'état et vérifiez la classe source nommée par la phase de travail. Réparez ce chemin source ou lisez l'échec avant de réessayer.

Une analyse historique bloquée limite les conclusions qui nécessitent des enregistrements plus anciens. Cela n'invalide pas un rapport actuel dont la preuve du journal actif et du cycle en cours est récente.

<a id="recover-a-stuck-poll-loop"></a>
## Récupérez une boucle d'interrogation bloquée

Ouvert :

```text
runtime/current/poll_status.json
runtime/poll_error.txt
```

Enregistrez `poll_id`, `poll_completed_count`, `poll_in_flight`, `poll_stage`, `scheduler_status` et horodatez deux fois à un intervalle limité.

- Si les compteurs avancent, la boucle n'est pas bloquée ; diagnostiquer l'étape de travail ultérieure.
- Si `poll_in_flight=true` reste inchangé, conservez la dernière étape de progression et la dernière erreur avant de redémarrer.
- Si le planificateur s'est arrêté, inspectez l'erreur précédente et le transfert de démarrage.

N'ajoutez pas de deuxième propriétaire de boucle pour compenser un cycle de vie bloqué.

<a id="start-the-scan-after-log-backlog"></a>
## Démarrez l'analyse après le retard du journal

Dans `runtime/current/poll_status.json`, comparez :

```text
active_log_caught_up
active_log_unread_bytes
log_backlog_pending
```

L'analyse historique doit attendre que le journal actif contienne des octets non lus. Confirmez que les sondages ultérieurs réduisent l'arriéré. Un nombre fixe de non lus avec des sondages avancés est un problème de source ; un sondage corrigé est un problème de planification.

<a id="preserve-scan-progress-after-a-crash"></a>
## Préserver la progression de l'analyse après un crash

Préserver et comparer :

```text
runtime/scan_checkpoint.json
runtime/scan_progress.json
runtime/baselines/file_manifest.tsv
```

Vérifiez si le point de contrôle ou le manifeste est manquant, si la racine ou le monde enregistré a changé, ou si le point de contrôle a été marqué comme obsolète. Ne supprimez pas une ligne de base valide pour que la progression paraisse plus récente.

<a id="map-an-unmapped-player"></a>
## Mappez un joueur non mappé

Comparez les preuves de session avec le journal faisant autorité :

```text
runtime/evidence/session_events.jsonl
Saved/Logs/AbioticFactor.log
```

Recherchez une `Login request` relation complète entre le nom d'affichage, `ConnectID` et `UniqueId`. S’il n’existe aucune identité de connexion acceptée, conservez la ligne en révision uniquement. Un nom d'affichage ou un PlayerData nom de fichier seul ne constitue pas une identité exécutoire.

<a id="diagnose-a-blocked-adminini-write"></a>
## Diagnostiquer une Admin.ini écriture bloquée

Exécutez un test d'application uniquement avec une approbation explicite et un fichier de test jetable, jamais avec un fichier de serveur actif. Confirmez d'abord que la configuration de test demande à Guard d'écrire :

```lua
review_only_mode = false
auto_ban = true
write_admin_ini = true
```

Puis lisez la raison de l'échec enregistrée. Guard doit identifier un compte, protéger les modérateurs et les comptes de confiance, trouver suffisamment de preuves spécifiques au compte, créer et vérifier une nouvelle sauvegarde, confirmer qu'aucun autre programme n'a modifié le fichier, enregistrer la mise à jour prévue et comparer l'intégralité du fichier enregistré avec le résultat souhaité. Si une étape échoue ou ne peut pas être vérifiée, laissez la liste des interdictions inchangée. Voir [Admin.ini application](ADMINISTRATEUR_INI_ENFORCEMENT.md).

<a id="restore-a-missing-daily-rollup"></a>
## Restaurer un cumul quotidien manquant

Confirmez que `forensic_rollup.enabled = true`, puis inspectez :

```text
runtime/current/forensic_today.json
runtime/forensic_days/YYYY-MM-DD/
runtime/final_logs/YYYY-MM-DD/
```

S'ils sont manquants, vérifiez le démarrage, l'interrogation, le générateur de rapports et l'état de la comptabilité source dans cet ordre. Le cumul quotidien est un enregistrement de continuité par jour, et non une notification répétée de l'état du serveur.

<a id="look-up-an-exact-status-or-error"></a>
## Recherchez un état ou une erreur exact

Utilisez [Référence sur l'état et les erreurs](R%C3%89F%C3%89RENCE_SUR_L_%C3%89TAT_ET_LES_ERREURS.md) pour l'itinéraire complet, la source, PlayerData, d'application, de démarrage, de planificateur, de rapport et de notification. Garder les tables de recherche séparées empêche cette page de réparation de devenir un deuxième manuel de schéma.

<a id="related-docs"></a>
## Documents associés

- [Commencez ici](COMMENCER_ICI.md)
- [Manuel d'opérations](MANUEL_D_OP%C3%89RATIONS.md)
- [Référence sur l'état et les erreurs](R%C3%89F%C3%89RENCE_SUR_L_%C3%89TAT_ET_LES_ERREURS.md)
- [Validation et révision des versions](VALIDATION_ET_PUBLICATION.md)
