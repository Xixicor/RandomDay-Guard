<a id="contributing"></a>
# Contribution

> **Source canonique en anglais:** [CONTRIBUTING.md](../../../CONTRIBUTING.md). Cette documentation localisée conserve les commandes, chemins, clés, valeurs d'état, hachages et noms de fichiers exacts. Si la formulation technique diffère, utilisez la source anglaise.


RandomDayGuard accepte des améliorations ciblées et reproductibles des analyseurs, de la documentation, des tests et de la validation de sécurité publique. Limitez chaque modification au contrat de projet public et préservez le comportement de révision : Guard doit laisser `Admin.ini` inchangé lorsqu'un contrôle de sécurité requis ne peut pas être confirmé.

<a id="prepare-a-safe-workspace"></a>
## Préparez un espace de travail sécurisé

1. Forkez ou clonez le référentiel et créez une branche ciblée.
2. Installez un interpréteur Python 3 pris en charge. Installez un compilateur Lua lorsque vous modifiez Lua afin que `luac -p` puisse vérifier la syntaxe.
3. Lisez la [accueil de la documentation](DOCUMENTATION.md), [architecture](ARCHITECTURE.md) et [limite des preuves](LIMITE_DES_PREUVES.md) pour la zone que vous allez modifier.
4. Inspectez `git status` avant de modifier et préservez les travaux non liés.
5. Utilisez uniquement des luminaires synthétiques ou aseptisés.

Ne soumettez jamais de journaux de serveur privé, de dossiers enregistrés, d'identifiants de joueur, `Admin.ini`, de points de terminaison de notification privés, d'identifiants, de chemins privés, de sortie d'exécution ou de preuves en direct copiées.

<a id="make-a-focused-change"></a>
## Effectuez un changement ciblé

- Suivez la dénomination, le formatage, les contrôles de sécurité et la propriété du module existants.
- Conservez un propriétaire de documentation canonique pour chaque procédure ou fait exact.
- Mettez à jour la documentation utilisateur et les exemples lorsque le comportement ou la sortie publique change.
- Ajoutez un test de régression pour corriger un bug lorsque cela est possible.
- N'affaiblissez pas la confirmation de compte, la protection des comptes de confiance, la vérification des sauvegardes, la détection de modifications extérieures, la comparaison des fichiers enregistrés, la récupération ou les valeurs par défaut de révision uniquement. effectuez un test réussi.

<a id="run-the-relevant-checks"></a>
## Exécutez les vérifications appropriées

Pour les modifications de la documentation uniquement, exécutez :

```powershell
python -B tools\generate_documentation_audit.py --check
python -B -m unittest discover tests -p "test_documentation*.py"
git diff --check
```

Pour les modifications de source, de configuration, d'empaquetage ou de test, exécutez également les vérifications applicables depuis [Validation et révision des versions](VALIDATION_ET_PUBLICATION.md), y compris les vérifications de syntaxe Lua, la validation du référentiel, les tests de pipeline public et la suite complète de tests unitaires. Signalez chaque chèque ignoré ou indisponible ; ne le décrivez pas comme passé.

<a id="submit-the-change-for-review"></a>
## Soumettez la modification pour examen

Ouvrez une pull request ciblée uniquement après avoir examiné la différence complète. Incluez :

- le problème et le comportement prévu ;
- les fichiers exacts et les contrats publics ont été modifiés ;
- les commandes exécutées et leurs résultats ;
- l'impact sur la confidentialité, la compatibilité et l'application ; et
- limitations restantes ou travaux de suivi.

N'incluez pas les preuves d'exécution générées ou les archives de publication à moins que la modification ne les exige et ne les valide explicitement. Une contribution n'autorise pas une version, un déploiement, un test sur un serveur réel, une mesure d'application ou une publication sur un site tiers.

Signaler les vulnérabilités via [la voie de sécurité privée](S%C3%89CURIT%C3%89.md), pas un problème public ou une demande d'extraction ordinaire.
