<a id="source-module-reference"></a>
# Référence du module source

> **Source canonique en anglais:** [SOURCE_MODULE_REFERENCE.md](../../SOURCE_MODULE_REFERENCE.md). Cette documentation localisée conserve les commandes, chemins, clés, valeurs d'état, hachages et noms de fichiers exacts. Si la formulation technique diffère, utilisez la source anglaise.


Cette page mappe chaque source, configuration, données, chargeur de compatibilité et espace réservé d'exécution. classe admise par la liste d'autorisation de sortie. L'index de la machine est [`TRACEABILITY_INDEX.json`](../../TRACEABILITY_INDEX.json) ; cette page est l'explication canonique lisible. Chaque ligne de machine générée nomme un path/class distinct, un objectif, un bloc source propriétaire, des paramètres publics, des effets secondaires, des états visibles par l'opérateur, des pannes, une récupération et un document canonique.

<a id="packaged-file-map"></a>
## Carte de fichiers packagée

| Chemin | Responsabilité | Point d'entrée ou appelant | Entrées | Sorties et effets secondaires | Comportement en cas d'échec | Modifiable par l'utilisateur |
|---|---|---|---|---|---|---|
| `LICENSE` | Licence de projet expédiée à la racine de l'archive. | Installateur, redistributeur et opérateur. | Dépôt révisé texte de licence. | Indique les conditions qui s'appliquent au package ; aucune mutation d'exécution. | L'omission rend le package de version légalement incomplet et bloque la liste verte. | Non. |
| `NOTICE.md` | Avis de projet envoyés à la racine de l'archive. | Installateur et opérateur. | Avis de projet examinés. | Préserve l'attribution requise et le contexte du projet ; aucune mutation d'exécution. | L'omission rend le package de version incomplet et bloque la liste verte. | Non. |
| `THIRD_PARTY_NOTICES.md` | Avis de tiers envoyés à la racine de l'archive. | Installateur et redistributeur. | Texte d'attribution tiers révisé. | Préserve la dépendance. attribution ; aucune mutation d'exécution. | L'omission rend le package de version incomplet et bloque la liste verte. | Non. |
| `RandomDayGuard/enabled.txt` | UE4SS indicateur d'activation du mod. | UE4SS chargeur de mod. | `1` ou `0` tel que pris en charge par UE4SS. | Active ou désactive le chargement ; n'écrit aucune preuve d'exécution. | Un indicateur désactivé ou mal formé empêche la preuve de démarrage normal. | Oui, pendant l'installation. |
| `RandomDayGuard/config.lua` | Tableau complet des paramètres publics. | `Scripts/main.lua` au démarrage. | Champs catalogués dans [`CONFIG_FIELD_CATALOG.md`](CATALOGUE_DE_CHAMPS_DE_CONFIGURATION.md). | Contrôle la découverte, les budgets, les rapports, les portes de révision et les marqueurs locaux facultatifs. | Lua/load/default la dérive bloque la validation ou ferme l'échec du démarrage. | Oui ; conserver une sauvegarde. |
| `RandomDayGuard/SavedRoot.txt` | Remplacement explicite facultatif de la racine enregistrée. | Résolveur de racine enregistrée dans `main.lua`. | Un chemin de système de fichiers générique vers `AbioticFactor/Saved`. | Sélectionne la racine utilisée pour les journaux, enregistre, PlayerData les noms de fichiers et `Admin.ini`. | Les informations manquantes sont autorisées ; les chemins dangereux, erronés ou illisibles n'ont pas été prouvés. | Oui ; ne placez jamais les informations d'identification ici. |
| `RandomDayGuard/BUILD_MARKER.txt` | Identité du package lisible par l'homme. | Installateur, validateur et opérateur. | Version de version rendue par le constructeur. | Aucune mutation d'exécution. | L'incompatibilité de version bloque l'empaquetage. | Non. |
| `RandomDayGuard/MANIFEST.json` | Métadonnées d'identité et de présentation du package lisibles par machine. | Validateur, générateur et outils de support. | Version de version rendue par le constructeur. | Aucune mutation d'exécution. | JSON ou les erreurs de version bloquent l'empaquetage. | Non. |
| `RandomDayGuard/README.txt` | Référence rapide en anglais installée. | Opérateur. | Chemins packagés et valeurs par défaut sûres. | Aucune mutation d'exécution. | Les chemins obsolètes ou les formulations de sécurité échouent à la parité de la documentation. | Non. |
| `RandomDayGuard/Scripts/main.lua` | UE4SS l'entrée, la collecte de preuves, la propriété de l'État, la planification limitée, l'application facultative et les rédacteurs de sortie. | UE4SS. | Configuration, Sources racine enregistrées, état d'exécution actuel, dictionnaires et module de reporting. | Écrit les classes d'exécution dans [`OUTPUT_SCHEMA_REFERENCE.md`](R%C3%89F%C3%89RENCE_DU_SCH%C3%89MA_DE_SORTIE.md) ; un chemin d'application approuvé peut sauvegarder et mettre à jour `Admin.ini`. | Startup/poll/write les échecs produisent un état d'erreur explicite et ne prouvent jamais l'achèvement de l'itinéraire. | Non. |
| `RandomDayGuard/Scripts/public_pipeline.lua` | Comptabilité source, lignée du cycle actuel, traduction des rapports, preuve d'itinéraire, historique public durable et boîte d'envoi locale facultative. | `main.lua` générateur de rapports. | Rappels en lecture seule state/context et preuves locales conservées. | Écrit des paires de rapport JSON/TXT, source/history comptabilité, preuve de routage, historique de compte durable et notification status/envelopes. | Lignée manquante, source requise, écriture couplée ou force d'écriture à l'épreuve du routage `missing` et blocage de la file d'attente. | Non. |
| `RandomDayGuard/data/detection_events.json` | Vocabulaire et explications des événements publics. | `main.lua` événement normalization/reporting. | Dictionnaire JSON valide. | Preuve des étiquettes ; ne crée pas d'observations. | Missing/malformed validation du référentiel de blocs de données. | Non. |
| `RandomDayGuard/data/warning_types.json` | Vocabulaire de type avertissement et signification de la révision. | Avertissement normalization/reporting. | Dictionnaire JSON valide. | Étiquettes de preuve d'avertissement. | Missing/malformed validation du référentiel de blocs de données. | Non. |
| `RandomDayGuard/data/object_categories.json` | Object/class vocabulaire de catégorie. | Analyse et registre d'objets. reporting. | Dictionnaire JSON valide. | Contexte de classe extrait des étiquettes. | Missing/malformed validation du référentiel de blocs de données. | Non. |
| `RandomDayGuard/runtime/**/.gitkeep` | Espaces réservés vides pour la mise en page d'installation uniquement. | Extraction de package. | Octets vides. | Crée une structure de répertoires inscriptible ; aucune preuve n'est regroupée. | Tout membre d'exécution non réservé bloque la liste autorisée exacte. | Non. |

<a id="ue4ss-loader-and-watchdog"></a>
## UE4SS chargeur et chien de garde

`Scripts/main.lua` sont propriétaires du démarrage du chien de garde indépendant, de la découverte de la racine enregistrée, de la queue du journal actuel, des époques et des sessions du serveur, de l'interrogation et de l'analyse limitées, object/world du contexte, de la notation des avis, `Admin.ini` barrières de sécurité, sorties opérationnelles héritées et transfert séparé entre les opérateurs de rapports. Il doit limiter les sondages en direct pendant que le lent travail historique reprend de manière indépendante. Un battement de cœur, un marqueur de démarrage ou un `poll_id` croissant prouve uniquement ce composant ; L'achèvement de la route nécessite les mêmes démarrage, époque, sondage, fraîcheur de la source, paire de rapports et preuve de route.

La source et le package ont une seule autorité : `RandomDayGuard/Scripts/main.lua`. Une copie `scripts/` minuscule ne fait pas partie de l'arborescence source ou de la version. Le fait de conserver une orthographe canonique évite les échecs de collision lorsque le package est extrait sous Windows ou Linux.

<a id="public-reporting-module"></a>
## Le module de reporting public

`Scripts/public_pipeline.lua` reçoit des rappels au lieu des informations d'identification de l'hôte ou des adaptateurs de fournisseur. Il inventorie huit classes sources, enregistre les états terminaux et incomplets, sépare les joueurs actuels de l'historique conservé, traduit chaque itinéraire dans l'ordre `Observed`, `Interpretation`, `Unknown`, `Does not prove`, `Next action` et `Source references`, puis écrit la preuve d'itinéraire. Le mode de notification facultatif écrit uniquement une enveloppe JSON locale ; il ne revendique jamais la livraison ni ne regroupe une livraison endpoint/bridge.

L'exécutable dans `tests/lua/public_pipeline_runtime_test.lua` charge ce module livré avec Lua, prouve les routes pleines et vides attendues, prouve qu'un cycle de source de courant manquant échoue et prouve que les routes incomplètes n'entrent pas dans la boîte d'envoi.

<a id="configuration-and-data"></a>
## Configuration et données

[`CONFIG_FIELD_CATALOG.md`](CATALOGUE_DE_CHAMPS_DE_CONFIGURATION.md) et [`TRACEABILITY_INDEX.json`](../../TRACEABILITY_INDEX.json) sont générés par `tools/generate_documentation_audit.py` à partir d'une analyse structurelle non exécutable de `config.lua`, la liste verte du package et les classes de sortie découvertes par la source. Le contenu généré exactement et la couverture individuelle sont validés. Les trois JSON dictionnaires sont des étiquettes et des mappages, et non des sources de preuves. Un opérateur peut modifier la configuration, la sélection de racine enregistrée et l'activation ; la source, les dictionnaires, les manifestes et les fichiers readme packagés appartiennent à la version.

<a id="package-layout"></a>
## Disposition du package

Le constructeur n'admet que les trois fichiers légaux racine, le `RandomDayGuard/` chemins ci-dessus et espaces réservés d'exécution vides. Il classe les membres par octet, corrige ZIP métadonnées, emballe le chargeur canonique une fois, analyse chaque membre à la recherche de matériel privé, enregistre un SHA-256 pour chaque membre, lie les noms et les octets dans un seul résumé de contenu et construit deux fois. Les tests rejettent chaque collision de cas et prouvent que l'extraction normale produit exactement un fichier physique par entrée d'archive.

Le référentiel public conserve uniquement le dossier de version actuel. Le constructeur vérifie que son ZIP, sa somme de contrôle, ses notes, ses marqueurs de version et son arborescence source sont conformes.

<a id="code-comment-contract"></a>
## Contrat de commentaire de code

Les commentaires d'exécution sont des contrats concis du responsable, pas un deuxième manuel. Chaque module d'exécution fourni doit placer un lien canonique dans son bloc de commentaire d'ouverture :

```lua
-- Documentation: docs/SOURCE_MODULE_REFERENCE.md#ue4ss-loader-and-watchdog
```

Les blocs d'état non évident, de planification, write/readback/rollback, de découverte de source, de traduction, de preuve, de schéma de sortie, de cadence de route et de rédaction utilisent des commentaires ciblés avec ces étiquettes le cas échéant :

```lua
-- Public contract: <invariant or consequence>
-- Evidence boundary: <what the input cannot prove>
-- Failure behavior: <how the block fails closed or recovers>
-- Documentation: docs/<canonical-file>.md#<existing-anchor>
```

Le chargeur principal a également un commentaire de propriétaire ciblé pour le chargement de la configuration, Découverte enregistrée, remplacement atomique, application et planification. Ces commentaires indiquent les limites du flux de contrôle et des défaillances ; ils ne modifient pas le comportement d'exécution.

Le validateur nécessite un lien `Documentation:` au niveau du module pour chaque module d'exécution, résout chaque chemin de commentaire et ancre, nécessite des commentaires ciblés sur les contrats et les échecs dans les deux modules d'exécution et compare les mêmes liens canoniques avec `TRACEABILITY_INDEX.json`. Un commentaire est une traçabilité, pas une preuve d'exécution.

<a id="contributor-change-checklist"></a>
## Liste de contrôle des modifications des contributeurs

1. Mettez à jour un module propriétaire et son appareil ciblé.
2. Mettez à jour la section canonique de configuration, de schéma, de sortie, de preuve ou de cycle de vie.
3. Exécuter `python -B tools/generate_documentation_audit.py --write` après une configuration, un chemin empaqueté, une classe de sortie générée, un propriétaire ou un contrat de récupération.
4. Exécuter `python -B tools/generate_documentation_audit.py --check`, des tests unitaires ciblés, le véritable appareil Lua où Lua est disponible, le validateur complet, deux versions déterministes indépendantes et `git diff --check`.
5. Examinez la liste des membres ZIP générée, la somme de contrôle et l'analyse du matériel privé avant de créer la version.
