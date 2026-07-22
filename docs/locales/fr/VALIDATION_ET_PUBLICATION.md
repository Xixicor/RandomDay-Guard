<a id="validation-and-release"></a>
# Validation et publication

> **Source canonique en anglais:** [VALIDATION_AND_RELEASE.md](../../VALIDATION_AND_RELEASE.md). Cette documentation localisée conserve les commandes, chemins, clés, valeurs d'état, hachages et noms de fichiers exacts. Si la formulation technique diffère, utilisez la source anglaise.


Cette page est destinée aux contributeurs et aux responsables de la version. Les opérateurs de serveur n'ont pas besoin d'exécuter ces commandes pour installer RandomDayGuard.

<a id="user-visible-proof"></a>
## Visible par l'utilisateur preuve

Une version est compréhensible lorsqu'un nouvel opérateur peut l'installer, trouver le premier rapport d'état du serveur, distinguer les cinq routes de rapport et suivre une action claire à partir d'un exemple concret. Les tâches de lecture ne doivent pas nécessiter de connaissances sur Git, PowerShell, Python ou sur la somme de contrôle.

<a id="contributor-checks"></a>
## Vérifications des contributeurs

```powershell
python -B tools/validate_repo.py
python -B tools/test_public_pipeline.py
python -B -m unittest discover tests
```

Quand `luac` est disponible :

```powershell
luac -p RandomDayGuard/Scripts/main.lua
luac -p RandomDayGuard/Scripts/public_pipeline.lua
```

Les tests des appareils Lua couvrent le chargeur, le planificateur, les itinéraires de rapport et la transaction d'écriture facultative Admin.ini. Les appareils d'application utilisent uniquement des fichiers temporaires et vérifient l'identité, le rejet du compte de confiance, les seuils, la sauvegarde, le refus de modification simultanée, la relecture et la restauration.

<a id="package-proof"></a>
## Preuve du package

```powershell
python -B tools/build_release_zip.py --check
git diff --check
```

- Tous. les marqueurs de version correspondent `VERSION`.
- Seule la version actuelle existe sous `releases/`.
- Le ZIP contient les `RandomDayGuard/Scripts/main.lua` et aucun chargeur de variantes de casse en minuscules.
- La sortie d'exécution, la configuration privée, les informations d'identification, les chemins locaux, les caches et les artefacts de test sont exclus.
- La configuration publique reste en révision uniquement avec l'application désactivée.
- Les cinq exemples de rapports travaillés restent cohérents avec la propriété de la route et le dispositif de test de version.
- ZIP canoniques qui sont déterministes et correspondent `CHECKSUMS.sha256`.
- Tous les liens de documentation locale et 27 pages d'entrée de paramètres régionaux sont validés.

<a id="avoid-validation-environment-pitfalls"></a>
## Évitez les pièges de l'environnement de validation

- Exécutez des vérifications d'écriture de référentiel en série pour éviter les conflits de fichiers temporaires.
- Sous Windows, inspectez les noms de membres archivés ou l'orthographe des chemins énumérés plutôt qu'une recherche de fichier insensible à la casse lors de la recherche de doublons. chargeurs.
- Une commande `luac` manquante ou un runtime Lua est une fonctionnalité indisponible, pas une syntaxe réussie ou un test d'exécution.
- Un appareil ne prouve que ses entrées modélisées. Cela ne prouve pas qu'un serveur en direct a produit un rapport actuel.
- Enregistrez les délais d'attente des commandes et les sorties partielles au lieu de supposer qu'elles sont terminées.

<a id="repair-failed-repository-validation"></a>
## Réparez l'échec de la validation du référentiel

Commencez par le premier chemin ou contrat signalé. Corrigez cet élément, réexécutez le test restreint, puis réexécutez la matrice complète. Ne cachez pas une fonctionnalité manquante en supprimant le test qui l'exige.

<a id="known-limits-and-release-decision"></a>
## Limites connues et décision de publication

Les vérifications locales prouvent les contrats relatifs aux sources, aux appareils, aux packages et à la documentation. Une installation de serveur spécifique, une fenêtre de stabilité de longue durée ou un affichage client nécessite un résultat d'intégration distinct. Enregistrez ce résultat avec sa construction, sa configuration, sa durée et la sortie observée avant de faire la réclamation correspondante.
