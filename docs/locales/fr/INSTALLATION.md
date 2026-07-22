<a id="install-randomdayguard"></a>
# Installer RandomDayGuard

> **Source canonique en anglais:** [INSTALL.md](../../../INSTALL.md). Cette documentation localisée conserve les commandes, chemins, clés, valeurs d'état, hachages et noms de fichiers exacts. Si la formulation technique diffère, utilisez la source anglaise.


Ce guide installe `v0.4.12-alpha` sur un serveur dédié à Abiotic Factor qui utilise déjà UE4SS. Le mod n'est pas lié à une société d'hébergement ou à un panneau de contrôle.

<a id="before-you-begin"></a>
## Avant de commencer

Vous avez besoin :

- accès pour arrêter et démarrer le serveur dédié ;
- le UE4SS `Mods` ;
- du serveur une copie du dossier RandomDayGuard actuel si vous effectuez une mise à jour ;
- une sauvegarde des données du serveur que vous protégez normalement avant de changer de mod.

Le **Dossier Mods** est le `ue4ss/Mods/` le répertoire dans l'installation du serveur dédié. RandomDayGuard appartient directement à ce dossier.

<a id="new-installation"></a>
## Nouvelle installation

1. Arrêtez le serveur dédié.
2. Extraire le RandomDayGuard ZIP dans un nouveau dossier vide.
3. Copier l'extrait `RandomDayGuard` dossier dans le dossier UE4SS `Mods`. Le résultat devrait être un `Mods/RandomDayGuard/` du serveur, pas un deuxième RandomDayGuard dossier imbriqué à l'intérieur il.
4. Ouvert UE4SS `mods.txt` et activez :

   ```text
   RandomDayGuard : 1
   ```

5. Démarrez le serveur normalement.
6. Attendez que UE4SS et le serveur de jeu pour terminer en commençant, puis suivez [Lire le premier rapport](COMMENCER_ICI.md).

Ne copiez pas une nouvelle version sur une installation en cours d'exécution. Conservez la sauvegarde jusqu'à ce que l'installation mise à jour ait produit un rapport actuel sur l'état du serveur.

<a id="update-an-existing-installation"></a>
## Mettre à jour une installation existante

1. Arrêtez le serveur.
2. Copiez l'intégralité du dossier installé RandomDayGuard vers un emplacement de sauvegarde sûr.
3. Déplacez l'ancien dossier du programme hors de UE4SS `Mods` au lieu de superposer la nouvelle version.
4. Copiez le nouveau dossier RandomDayGuard dans `Mods`.
5. Restaurez uniquement votre configuration locale révisée et les preuves enregistrées. Si le guide de configuration répertorie de nouveaux champs, fusionnez-les dans la copie révisée au lieu de remplacer tous les paramètres aveuglément.
6. Confirmez que `RandomDayGuard : 1` reste activé.
7. Démarrez le serveur et lisez le rapport d'état actuel du serveur.

Cette mise à jour du dossier propre supprime également les fichiers obsolètes des anciennes versions sans demander à l'opérateur d'inspecter le programme. noms de fichiers.

<a id="help-guard-find-the-server-records"></a>
## Aidez Guard à trouver les enregistrements du serveur

Guard trouve normalement le répertoire Abiotic Factor `Saved` automatiquement. Si ce n'est pas le cas, placez le chemin complet de ce répertoire `Saved` dans `SavedRoot.txt` à l'intérieur du RandomDayGuard. Pointez sur `Saved`, et non sur un monde individuel en dessous.

Le premier rapport d'état du serveur indique si l'emplacement de l'enregistrement a été trouvé et quels groupes sources étaient disponibles. Utilisez [Dépannage](D%C3%89PANNAGE.md) lorsqu'il ne peut pas lire l'emplacement.

<a id="first-run-behavior"></a>
## Comportement de première exécution

L'installation par défaut surveille les enregistrements disponibles et rédige des rapports. Cela ne change pas `Admin.ini` et n'ajoute pas d'interdiction. Cela vous permet de confirmer la collecte, la traduction et la qualité du rapport avant de décider d'activer ou non une action facultative.

[Lire le premier rapport](COMMENCER_ICI.md)

<a id="disable-or-remove-randomdayguard"></a>
## Désactiver ou supprimer RandomDayGuard

1. Arrêtez le serveur.
2. Copiez le dossier complet RandomDayGuard dans une archive sécurisée.
3. Pour désactiver le mod, définissez `RandomDayGuard : 0` dans UE4SS `mods.txt`.
4. Pour le supprimer, déplacez le dossier complet RandomDayGuard hors de `Mods` après avoir confirmé que l'archive peut être ouverte.
5. Démarrez le serveur et confirmez que Guard ne démarre plus.

La désactivation ou la suppression de Guard arrête la collecte future. Il ne supprime pas les données de jeu, n'efface pas les rapports archivés et n'annule pas une action distincte de l'opérateur.

<a id="roll-back-an-update"></a>
## Annuler une mise à jour

Si la nouvelle installation ne se charge pas ou ne peut pas produire de rapport actuel :

1. Arrêtez le serveur.
2. Mettez de côté l'installation ayant échoué sans supprimer ses enregistrements.
3. Restaurez le dossier complet de pré-mise à jour RandomDayGuard.
4. Restaurez la configuration révisée et les preuves enregistrées à partir de la même sauvegarde.
5. Confirmez que le mod est activé et démarrez le serveur.
6. Lisez le rapport sur l'état du serveur restauré avant d'effectuer une autre modification.

<a id="more-help"></a>
## Plus d'aide

- [Lire le premier rapport](COMMENCER_ICI.md)
- [Manuel d'opérations](MANUEL_D_OP%C3%89RATIONS.md)
- [Dépannage](D%C3%89PANNAGE.md)
- [Profils de configuration](PROFILS_DE_CONFIGURATION.md)
- [Admin.ini application](ADMINISTRATEUR_INI_ENFORCEMENT.md)

Les responsables de la version peuvent trouver les contrôles de source, de package et de confidentialité dans [Validation et publication](VALIDATION_ET_PUBLICATION.md). Ils ne sont pas requis pour une installation ordinaire.
