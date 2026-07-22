<a id="evidence-boundary"></a>
# Limite des preuves

> **Source canonique en anglais:** [EVIDENCE_BOUNDARY.md](../../EVIDENCE_BOUNDARY.md). Cette documentation localisée conserve les commandes, chemins, clés, valeurs d'état, hachages et noms de fichiers exacts. Si la formulation technique diffère, utilisez la source anglaise.


Utilisez cette page pour décider quoi RandomDayGuard peut signaler ce qui nécessite encore un examen humain.

<a id="core-rule"></a>
## Règle de base

RandomDayGuard enregistre les observations limitées à partir de fichiers appartenant au serveur. Il doit identifier la source, la portée, l'état de la collection et les limites de chaque conclusion importante.

Les preuves structurées font autorité. Un rapport traduit explique les preuves ; il ne peut pas ajouter des faits qui sont absents de l'enregistrement structuré.

<a id="evidence-source-classes"></a>
## Classes de source de preuves

| Classe source | Utilisation typique | Ne prouve pas par lui-même |
|---|---|---|
| `admin_ini` | État d'administration existant et audité write/readbackcontexte | Qui a causé un incident |
| `active_log` | Événements server/session actuels visibles dans le journal actif | Intention, propriété ou dommage direct |
| `recent_backup_logs` | Contexte du journal historique | Un événement en cours s'est produit |
| `playerdata_filenames` | Corroboration d'un identifiant de compte propre existe | Comportement, culpabilité ou propriété de l'identité au-delà de l'identifiant exposé |
| `existing_cases` | Contexte d'examen préalable | Une interprétation antérieure reste correcte |
| `existing_reports` | Résumés et décisions antérieurs | Vérité actuelle sans corroboration actuelle |
| `existing_evidence` | Preuves historiques structurées | Activité actuelle |
| Analyse de sauvegarde mondiale | Lente world/classcontexte | Action du joueur, propriété, vol, duplication ou dommage |

Chaque source enregistre availability/readability, le nombre de fichiers, les références à la source, la portée actuelle ou historique et un `does_not_prove` explicite. déclaration.

<a id="source-states"></a>
## États de la source

| État | Signification de l'opérateur |
|---|---|
| `available` | La source était lisible et des preuves ont été collectées. |
| `expected_empty` | La source était lisible et n'avait légitimement aucun enregistrement correspondant. |
| `partial` | Certaines preuves ont été collectées ; la couverture est incomplète. |
| `deferred` | Le travail limité a été intentionnellement reporté. |
| `unavailable` | La source n'est pas présente dans cet environnement. |
| `malformed` | La source existe mais ne peut pas être analysée en toute sécurité. |
| `permission_denied` | Le chien de garde n'a pas d'autorisation de lecture. |
| `error` | La collecte a échoué pour un autre enregistrement. raison. |

Le vide attendu est une observation valide. Elles ne doivent jamais être transformées en un acteur, une affaire, un incident ou une accusation fabriqué de toutes pièces.

<a id="current-versus-historical-evidence"></a>
## Preuves actuelles par rapport aux preuves historiques

Les preuves actuelles appartiennent à la fenêtre de collecte active ou à l'époque du serveur. Les preuves historiques proviennent de journaux, de cas, de rapports, d'enregistrements de preuves, de sauvegardes ou de références antérieurs.

Les preuves historiques peuvent fournir un contexte. Il ne peut pas combler silencieusement une lacune dans les données actuelles. Les rapports doivent étiqueter les deux champs d'application et citer leurs sources séparément.

<a id="corroboration-rule"></a>
## Règle de corroboration

Il s'agit d'un contexte utile mais ne constitue pas une preuve directe en soi :

- noms d'affichage ou similitude de nom ;
- coïncidence temporelle ;
- déconnexion ou reconnexion ;
- un crash ou une rafale d'avertissement ;
- jetons de classe, de chemin, d'acteur, de carte ou de nombre d'objets ;
- appartenance à un cas automatiquement regroupé ;
- rapports antérieurs sans confirmation de la source actuelle.

Ne revendiquez pas de culpabilité, d'intention, de tricherie, de propriété, de vol, de duplication, de dommage direct, d'utilisation directe de conteneurs, d'action d'inventaire directe, de coordonnées exactes en direct, de ping en direct ou de comportement au niveau de la mémoire sans preuve qui expose directement le fait.

<a id="truthful-report-language"></a>
## Langage de rapport véridique

Utiliser :

```text
Observed: the account was active in the recorded crash window.
Interpretation: repeated overlap warrants operator review.
Unknown: the cause of the crash.
Does not prove: that the account caused the crash.
Next action: compare the cited current session and lifecycle records.
```

Éviter :

```text
The player crashed the server.
The player stole or duplicated items.
The world token proves who used the object.
```

<a id="report-reading-order"></a>
## Ordre de lecture des rapports

Chaque rapport destiné au public doit expliquer :

1. Le sens simple.
2. Pourquoi c'est important.
3. Preuve technique et références sources.
4. Action suivante.
5. Limites, inconnues et affirmations non prouvées.

<a id="related-docs"></a>
## Documents associés

- [`OUTPUT_SCHEMA_REFERENCE.md`](R%C3%89F%C3%89RENCE_DU_SCH%C3%89MA_DE_SORTIE.md)
- [`PLAYER_REVIEW_WORKFLOW.md`](FLUX_DE_TRAVAIL_DE_R%C3%89VISION_DU_LECTEUR.md)
- [`BAN_ID_MAPPING.md`](MAPPAGE_DES_IDENTIFIANTS_D_INTERDICTION.md)
- [`DETECTION_SIGNALS.md`](SIGNAUX_DE_D%C3%89TECTION.md)
