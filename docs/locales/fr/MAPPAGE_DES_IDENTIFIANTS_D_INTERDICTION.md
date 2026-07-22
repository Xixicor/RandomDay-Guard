<a id="ban-id-mapping"></a>
# Mappage des ID d'interdiction

> **Source canonique en anglais:** [BAN_ID_MAPPING.md](../../BAN_ID_MAPPING.md). Cette documentation localisée conserve les commandes, chemins, clés, valeurs d'état, hachages et noms de fichiers exacts. Si la formulation technique diffère, utilisez la source anglaise.


Utilisez cette page lors de la conversion d'un nom de joueur en une ligne d'interdiction sécurisée `Admin.ini`.

<a id="core-rule"></a>
## Règle de base

Un nom d'affichage n'est pas un identifiant d'interdiction.

`Admin.ini` utilise :

```ini
BannedPlayer=<raw numeric player ID>
```

<a id="evidence-hierarchy"></a>
## Hiérarchie des preuves

| Classement | Source | Utilisation |
|---:|---|---|
| 1 | Journal du serveur `Login request` | Meilleur mappage nom-ID |
| 2 | `Player_<ID>.sav` | Confirme que l'ID existe |
| 3 | Existant `Admin.ini` | Existant bans/moderators |
| 4 | Notification externe ou activité du panneau d'hébergement | Time/name contexte uniquement ; pas de preuve d'identification |
| 5 | UE4SS focus/player lignes | Presence/context uniquement |
| 6 | Journaux du cycle de vie du système ou du conteneur | Contexte du cycle de vie de l'hôte uniquement ; pas de preuve d'identité |

<a id="extract-the-clean-id"></a>
## Extraire l'ID propre

Exemple brut :

```text
ConnectID=2535422284688820_+_|0002d07b...
```

Nettoyer `Admin.ini` valeur :

```ini
BannedPlayer=2535422284688820
```

Ne pas coller `_+_|...`.

<a id="verify-with-playerdata"></a>
## Vérifiez avec PlayerData

Vérifier :

```text
Saved/SaveGames/Server/Worlds/<WorldName>/PlayerData/Player_<ID>.sav
```

Signification :

```text
The ID exists in the world save.
```

Limitation :

```text
PlayerData may not prove the display name unless another source maps it.
```

<a id="when-not-to-ban"></a>
## Quand ne pas interdire

Ne pas attribuer d'ID d'interdiction lorsque :

```text
the name only appears in an external notification
the name only appears in hosting-panel activity
UE4SS shows a name but no ConnectID
only system lifecycle or container logs exist
the ID is trusted or moderator
```

<a id="evidence-table-template"></a>
## Modèle de tableau de preuves

```text
display_name:
server_time:
log_file:
line_number:
log_name:
connect_id_raw:
ban_id:
unique_id:
playerdata_file:
decision:
notes:
```

<a id="related-docs"></a>
## Documents associés

* [`ADMIN_INI_ENFORCEMENT.md`](ADMINISTRATEUR_INI_ENFORCEMENT.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](FLUX_DE_TRAVAIL_DE_R%C3%89VISION_DU_LECTEUR.md)
