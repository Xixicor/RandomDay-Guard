<a id="adminini-enforcement"></a>
# Admin.ini application

> **Source canonique en anglais:** [ADMIN_INI_ENFORCEMENT.md](../../ADMIN_INI_ENFORCEMENT.md). Cette documentation localisée conserve les commandes, chemins, clés, valeurs d'état, hachages et noms de fichiers exacts. Si la formulation technique diffère, utilisez la source anglaise.


RandomDayGuard ne modifie pas la liste d'interdiction du serveur dans sa configuration par défaut. Il crée uniquement des rapports qu'un administrateur peut examiner. Cette page explique la mise à jour automatique facultative de la liste d'interdiction pour les administrateurs qui l'activent délibérément.

<a id="what-guard-checks-before-changing-the-ban-list"></a>
## Qu'est-ce que Guard vérifie avant de modifier la liste des interdictions

Guard ajoute une interdiction uniquement lorsque chaque réponse ci-dessous est **oui**:

1. Les preuves actuelles ont-elles identifié un compte spécifique avec suffisamment de confiance ?
2. Le compte n'est-il ni un modérateur ni un compte que l'administrateur a marqué comme fiable ?
3. Le compte n'est-il pas déjà sur la liste des interdictions ?
4. Le compte a-t-il atteint le score d'action automatique configuré ?
5. Guard peut-il lire le `Admin.ini` et enregistrer une sauvegarde identique ?
6. Est-ce que `Admin.ini` est resté inchangé pendant que Guard préparait la mise à jour ?
7. Après l'enregistrement, le fichier complet correspond-il exactement au résultat attendu ?

Si une réponse est **non** ou ne peut pas être vérifiée, Guard quitte l'état `Admin.ini` inchangé et en consigne la raison dans ses rapports. Si l'enregistrement commence mais que la vérification finale échoue, Guard restaure la sauvegarde vérifiée.

<a id="file-format"></a>
## Le format de fichier

`Admin.ini` doit recevoir uniquement des lignes d'interdiction claires :

```ini
BannedPlayer=<ID>
```

- Aucun nom.
- Aucun commentaire.
- Aucune raison.
- Non suffixes.

<a id="safe-defaults"></a>
## Paramètres par défaut

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
require_clean_ban_id = true
preserve_existing_bans = true
preserve_moderators = true
```

<a id="ban-id-source"></a>
## Source d'ID d'interdiction

Meilleure source :

```text
Login request
Name=<player>
ConnectID=<raw_id>
UniqueId=<platform_id>
```

Le runtime accepte soit un ID entièrement numérique, soit le formulaire de connexion `<digits>_+_|<non-space token>` documenté complet et en dérive l'ID d'interdiction numérique. Les préfixes numériques arbitraires avec un suffixe inconnu sont rejetés ; ils ne sont pas tronqués en un identifiant d'interdiction.

Correct :

```ini
BannedPlayer=2535422284688820
```

Faux :

```ini
BannedPlayer=ExamplePlayer
```

Faux également :

```text
BannedPlayer=<ID>
```

<a id="exact-settings-guard-checks"></a>
## Paramètres exacts des contrôles de garde

Ces paramètres implémentent les contrôles décrits ci-dessus. Chaque condition répertoriée doit être vraie :

```text
review_only_mode == false
auto_ban == true
write_admin_ini == true
ban_id is clean numeric
identity is mapped
not trusted
not moderator
threshold is met
account-specific evidence exists
```

Si une condition est fausse ou ne peut pas être vérifiée, Guard laisse la liste d'interdiction inchangée et enregistre ce qui l'a arrêtée.

<a id="transaction-safety"></a>
## Sécurité des transactions

Le seul chemin de mutation `Admin.ini` effectue ces étapes dans l'ordre :

1. Lire et valider structurellement les octets faisant autorité.
2. Dériver l'état du modérateur, de confiance et d'interdiction existante à partir de ce même instantané.
3. Écrivez une sauvegarde unique sous `runtime/backups/` et vérifiez-le octet par octet.
4. Relis `Admin.ini` immédiatement avant le remplacement et rejetez toute modification externe.
5. Écrivez le candidat via le chemin de remplacement contrôlé configuré.
6. Exigez que les octets de relecture complets soient égaux aux octets candidats complets.
7. Activé. échec de relecture, restaurez la sauvegarde vérifiée uniquement pendant que le fichier actuel est toujours le candidat exact écrit par Guard. Si un autre rédacteur l'a modifié, Guard refuse la restauration plutôt que d'écraser les octets externes inconnus.

Les ID en double sont idempotents : aucune deuxième ligne ni aucune deuxième sauvegarde ne sont écrites. Les noms de sauvegarde incluent un horodatage, une empreinte digitale de l'octet source et un ID propre afin que des tentatives distinctes ne puissent pas partager l'ancien nom de fichier d'une seconde.

<a id="local-regression-proof"></a>
## La preuve de régression locale

`tests/lua/enforcement_runtime_test.lua` démarre le chargeur fourni une fois, puis exécute sa véritable fermeture locale `append_ban()` sur les fichiers synthétiques isolés sous le répertoire du référentiel `.tmp/`. Il couvre l'insertion, l'idempotence en double, le rejet moderator/trusted, le rejet d'identité faible et mal formée, la vérification de sauvegarde exacte, le rejet de modification simultanée, la restauration réussie après un échec de relecture et le refus d'écraser une modification externe post-écriture. Ses wrappers de système de fichiers rejettent toute mutation en dehors de la racine du luminaire ; aucun chemin de serveur réel ou `Admin.ini` réel n'est utilisé.

Exécutez-le via `python tools/test_public_pipeline.py`. Une passe de luminaire prouve uniquement le comportement de la transaction locale. Il ne permet pas l'application, n'autorise pas une écriture de production ou ne prouve pas les autorisations spécifiques à l'hôte.

<a id="files-to-check"></a>
## Fichiers à vérifier

```text
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
runtime/enforced_bans.jsonl
runtime/enforced.txt
runtime/ban_queue.json
```

<a id="rollback"></a>
## Restaurer

1. Arrêtez le serveur.
2. Restaurer la dernière Admin.ini sauvegarde à partir de `runtime/backups/`.
3. Supprimez la ligne `BannedPlayer=<ID>` incorrecte si nécessaire.
4. Démarrez le serveur.
5. Rouvrez Admin.ini et confirmez que la ligne a persisté ou a été supprimée.
6. Conservez `enforced_bans.jsonl` pour audit.

<a id="related-docs"></a>
## Documents associés

* [`BAN_ID_MAPPING.md`](MAPPAGE_DES_IDENTIFIANTS_D_INTERDICTION.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](FLUX_DE_TRAVAIL_DE_R%C3%89VISION_DU_LECTEUR.md)
