<a id="player-review-workflow"></a>
# Flux de travail d'évaluation des joueurs

> **Source canonique en anglais:** [PLAYER_REVIEW_WORKFLOW.md](../../PLAYER_REVIEW_WORKFLOW.md). Cette documentation localisée conserve les commandes, chemins, clés, valeurs d'état, hachages et noms de fichiers exacts. Si la formulation technique diffère, utilisez la source anglaise.


Utilisez cette page pour un joueur, un compte ou un cas. L'objectif est une décision de révision reproductible, et non une accusation automatisée.

<a id="quick-path"></a>
## Chemin rapide

1. Ouvert `runtime/final_logs/player_activity_latest.json`.
2. Confirmez l'état de l'itinéraire dans `runtime/final_logs/route_proof.json`.
3. Identifiez les observations actuelles et celles historiques.
4. Vérifiez l'identité citée et les références de la source de session.
5. Examen `case_review_latest.json` lorsqu'un cas corrélé existe.
6. Enregistrez les inconnues et `does_not_prove` avant de choisir une action.
7. Laissez l'application désactivée à moins que la séparation ne soit les portes d'application ont fait leurs preuves.

<a id="1-confirm-route-proof"></a>
## 1. Confirmer la preuve de l'itinéraire

Interpréter l'itinéraire du joueur comme :

| Statut | Action |
|---|---|
| `full` | Continuer, tout en vérifiant les limites des sources. |
| `limited_expected_empty` | Continuer uniquement avec les sujets réellement présents ; n'inventez pas de joueur ou de cas manquant. |
| `missing` | Arrêtez la décision du joueur et dépannez l'itinéraire. |

Un planificateur sain ne remplace pas la preuve d'itinéraire.

<a id="2-establish-identity"></a>
## 2. Établir l'identité

Préférez un identifiant de compte propre corroboré par des preuves d'identité exposées par le serveur et, le cas échéant, PlayerData les noms de fichiers. Conservez la référence source brute.

Ne pas imposer :

- un nom d'affichage seul ;
- un nom vu dans un panneau de notification ou d'hébergement ;
- similitude temporelle ;
- une identité non mappée ou à faible confiance ;
- un rapport historique sans corroboration actuelle.

<a id="3-separate-current-from-historical"></a>
## 3. Séparez les données actuelles des données historiques.

Les preuves actuelles décrivent la fenêtre de reporting active ou l'époque du serveur. Les preuves historiques peuvent expliquer une tendance, mais elles ne peuvent pas combler silencieusement les lacunes de la fenêtre actuelle.

Enregistrez les deux étendues indépendamment :

```text
Current observations:
Current source references:
Historical context:
Historical source references:
```

<a id="4-review-observations-and-interpretation"></a>
## 4. Examinez les observations et l'interprétation

Lisez distinctement ces sections du rapport :

```text
observed
interpretation
unknown
does_not_prove
next_action
source_references
```

Rouvrez les preuves structurées citées pour toute décision importante. Une traduction est une navigation et une explication, pas une nouvelle preuve.

<a id="5-calibrate-the-decision"></a>
## 5. Calibrer la décision

| Décision | À utiliser lorsque |
|---|---|
| `INFO` | Observation normale ou à faible contexte. |
| `WATCH` | Un signal faible ou incomplet mérite d'être surveillé. |
| `REVIEW` | Les preuves corrélées nécessitent le jugement de l'administrateur. |
| `BAN-ELIGIBLE` | L'identité propre et les seuils de preuves configurés sont respectés ; les portes d'écriture s'appliquent toujours. |
| `AUTO-BANNED` | L'application a été explicitement activée et la sauvegarde, l'écriture, la relecture et l'audit ont tous réussi. |

Aucune étiquette de décision ne prouve la culpabilité ou l'intention.

<a id="6-apply-the-evidence-boundary"></a>
## 6. Appliquez la limite des preuves

Plantages, reconnexions, avertissements, object/class jetons et le regroupement de cas peut prendre en charge l'examen. À eux seuls, ils ne prouvent pas la tricherie, le vol, la duplication, la propriété, les dommages directs ou la causalité de l'incident.

Si l'identité, l'analyse, la sauvegarde, l'écriture, la relecture ou la restauration sont faibles ou échouent, l'application doit échouer.

<a id="review-note-template"></a>
## Modèle de note de révision

```text
Review time:
Route proof status:
Coverage status:
Account ID:
Display name as observed:
Identity confidence and source:
Current observations:
Historical context:
Interpretation:
Unknown:
Does not prove:
Decision:
Next action:
Source references:
Operator:
```

<a id="related-docs"></a>
## Documents associés

- [`EVIDENCE_BOUNDARY.md`](LIMITE_DES_PREUVES.md)
- [`OUTPUT_SCHEMA_REFERENCE.md`](R%C3%89F%C3%89RENCE_DU_SCH%C3%89MA_DE_SORTIE.md)
- [`ADMIN_INI_ENFORCEMENT.md`](ADMINISTRATEUR_INI_ENFORCEMENT.md)
- [`DETECTION_SIGNALS.md`](SIGNAUX_DE_D%C3%89TECTION.md)
