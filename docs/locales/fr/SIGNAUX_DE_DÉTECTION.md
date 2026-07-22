<a id="detection-signals"></a>
# Signaux de détection

> **Source canonique en anglais:** [DETECTION_SIGNALS.md](../../DETECTION_SIGNALS.md). Cette documentation localisée conserve les commandes, chemins, clés, valeurs d'état, hachages et noms de fichiers exacts. Si la formulation technique diffère, utilisez la source anglaise.


Les signaux sont des entrées de révision, pas des accusations automatiques.

<a id="signal-table"></a>
## Tableau des signaux

| Signal | Signification | Plus fort lorsque... | Pas assez seul |
|---|---|---|---|
| Identité de connexion | Mappe le nom sur l'ID du compte | ConnectID est présent | Ban |
| Congé propre | Fermeture normale de la session | Rejoindre et quitter le match | Suspicion |
| Reconnexion rapide | Churn/probingcontexte | Se répète rapidement | Ban |
| Déconnexion incorrecte | La session ne s'est pas fermée proprement | Plans répétés ou chevauchements | Ban |
| Chevauchement de crash | Compte actif proche du crash | Le même compte se répète | Ban |
| Retour après crash | Le compte est renvoyé après le redémarrage | Répétition à travers les époques | Ban par un événement |
| Salut d'avertissement | Fenêtre d'avertissement du serveur | Les sessions mappées se chevauchent | Ban d'un coup |
| Touche de sauvegarde de l'acteur | Contexte de sauvegarde mondiale | Corrélation avec sessions | Preuve de use/theft |
| Delta d'objet | World/class Modification | Corrélation avec sessions | Interdiction du décompte seul |
| Cas de raid | Cluster multi-comptes | Répétitions de comptes centraux | Bannir en masse tous les comptes |

<a id="login-identity"></a>
## Identité de connexion

Meilleure source :

```text
Login request
Name=
ConnectID=
UniqueId=
```

Utilisez-le pour cartographier :

```text
display/log name -> account_id -> ban_id
```

<a id="rapid-reconnect"></a>
## Reconnexion rapide

Modèle :

```text
join -> leave -> join -> leave -> join
```

Utiliser pour l'examen en cas de répétition.

Sécurité :

```text
churn_alone_never_bans = true
```

<a id="crash-overlap-and-post-crash-return"></a>
## Chevauchement des crashs et retour après un crash

Modèle :

```text
account active before crash
server restarts
same account returns quickly
```

Utiliser pour l'examen en cas de répétition époques.

Sécurité :

```text
single_crash_never_bans = true
```

<a id="warning-bursts"></a>
## Salves d'avertissement

Exemples :

```text
ActorChannelFailure
DeployableSaveWarning
UpdateActorToWorldSave
ServerMove warnings
```

Utiliser comme contexte jusqu'à ce qu'il soit lié aux sessions et aux seuils mappés.

<a id="actor-save-touch"></a>
## Touche de sauvegarde de l'acteur

Signification :

```text
The server evidence referenced a class or actor.
```

Cela ne signifie rien :

```text
A player opened it.
A player stole from it.
A player duplicated through it.
A player damaged it.
```

<a id="raid-cases"></a>
## Cas de raid

Un cas de raid regroupe les comptes par timing et fenêtres partagées.

Règle :

```text
Do not auto-ban every account in a raid case.
Each account needs account-specific evidence.
```

<a id="related-docs"></a>
## Documents associés

* [`BAD_ACTOR_PATTERNS_AND_RESILIENCE.md`](MOD%C3%88LES_D_ACTEURS_MALVEILLANTS_ET_R%C3%89SILIENCE.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](FLUX_DE_TRAVAIL_DE_R%C3%89VISION_DU_LECTEUR.md)
