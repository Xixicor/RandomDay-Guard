<a id="security-policy"></a>
# Politique de sécurité

> **Source canonique en anglais:** [SECURITY.md](../../../SECURITY.md). Cette documentation localisée conserve les commandes, chemins, clés, valeurs d'état, hachages et noms de fichiers exacts. Si la formulation technique diffère, utilisez la source anglaise.


<a id="report-a-vulnerability-privately"></a>
## Signaler une vulnérabilité en privé

Utilisez [GitHub rapport de vulnérabilité privé](https://github.com/Xixicor/RandomDay-Guard/security/advisories/new) pour envoyer un rapport confidentiel au propriétaire du référentiel. Si ce formulaire n'est pas disponible, utilisez le [profil public GitHub du propriétaire](https://github.com/Xixicor) pour demander un canal de contact privé sans inclure les détails de la vulnérabilité.

N'ouvrez pas de problème public contenant des étapes d'exploitation, des informations d'identification, des chemins de serveur privé, des identifiants de joueur, `Admin.ini`, des données enregistrées, des URL de webhook ou des fichiers de preuves en direct.

<a id="include-useful-evidence"></a>
## Incluez des preuves utiles

Fournissez :

- la version ou la validation RandomDayGuard concernée ;
- le composant concerné et le comportement sûr attendu ;
- étapes minimales de reproduction à l'aide de luminaires nettoyés ;
- l'impact observé et s'il est reproductible ; et
- toute atténuation proposée qui n'expose pas de données privées.

N'envoyez pas de vrais secrets. Remplacez les chemins privés, les identifiants de compte, les noms d'hôte et les jetons par des espaces réservés clairs tout en préservant la structure nécessaire pour reproduire le problème.

<a id="expect-review-first-handling"></a>
## Attendez-vous à un traitement en premier lieu

Un rapport est une preuve de l'examen du responsable, et non de l'autorisation d'accéder à un serveur, de tester une cible active, de publier les détails de l'exploit ou d'affaiblir les valeurs par défaut fermées en cas d'échec. Le propriétaire validera la portée et coordonnera toute divulgation via le rapport privé.
