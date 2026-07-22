<a id="status-and-error-reference"></a>
# Référence sur l'état et les erreurs

> **Source canonique en anglais:** [STATUS_AND_ERROR_REFERENCE.md](../../STATUS_AND_ERROR_REFERENCE.md). Cette documentation localisée conserve les commandes, chemins, clés, valeurs d'état, hachages et noms de fichiers exacts. Si la formulation technique diffère, utilisez la source anglaise.


Utilisez cette référence après qu'un symptôme a été classé dans [Dépannage](D%C3%89PANNAGE.md). Lisez le fichier d'état structuré nommé par l'erreur. Des codes distincts représentent des états distincts en matière de sécurité et de cycle de vie ; ne les réduisez pas dans un résultat générique "Échec de Guard".

<a id="route-and-source-states"></a>
## États d'itinéraire et de source

| Valeur | Signification | Réponse de l'opérateur |
|---|---|---|
| `full` | Le contrat d'itinéraire complété avec la preuve source du cycle en cours. | Lisez les limites de preuve de l'itinéraire ; aucune réparation n'est implicite. |
| `limited_expected_empty` | L'itinéraire terminé et l'activité manquante sont légitimes pour ce cycle. | Aucun événement synthétique player/case ne doit être créé. |
| `missing` | Une sortie, un champ de lignage ou une preuve de source requis est absent. | Inspectez la raison de l'itinéraire et l'état de la source nommée. |
| `available` | La source nommée était lisible et utilisable. | Non action. |
| `expected_empty` | La source a été vérifiée et ne comportait légitimement aucune ligne. | Aucune action à moins qu'une activité soit attendue de manière indépendante. |
| `partial` / `complete_with_gaps` | Des preuves utilisables existent, mais les classes sources nommées sont incomplètes. | Limiter les conclusions aux preuves collectées. |
| `deferred` | Un travail limité est prévu pour un travailleur ultérieur. opportunité. | Confirmez les progrès avant de modifier la configuration. |
| `unavailable` | L'environnement n'a pas fourni la source. | Enregistrez la limite ; corrigez uniquement un problème de chemin ou d'autorisation prouvé. |
| `malformed` | La source était lisible mais la validation structurelle a échoué. | Conservez-la et corrigez la source ; ne devinez pas. |
| `permission_denied` | La source existe mais n'a pas pu être lue. | Accordez uniquement l'autorisation de lecture étroite requise. |
| `error` | La collecte a échoué pour la raison enregistrée. | Conservez l'erreur et diagnostiquez cette étape. |

<a id="playerdata-and-inventory-codes"></a>
## PlayerData et les codes d'inventaire

| Code | Signification | Réponse sécurisée |
|---|---|---|
| `saved_root_unavailable` | Aucune racine enregistrée vérifiée n'était disponible pour le pipeline public. | Corrigez `SavedRoot.txt` et revérifiez la sonde de chemin. |
| `unsafe_playerdata_root` | PlayerData découverte résolue en dehors du Racine enregistrée délimitée. | Corrigez le chemin ; n'affaiblissez jamais la limite. |
| `playerdata_discovery_not_run` | Le travailleur de découverte limitée n'a pas encore été exécuté. | Vérifiez la progression du planificateur et du travailleur. |
| `playerdata_discovery_read_failed:*` | Le résultat de la découverte n'a pas pu être lu. | Conservez les détails du suffixe et vérifiez la commande d'inventaire limité. |
| `inventory_command_open_failed` | Le processus d'inventaire n'a pas pu être démarré. | Vérifiez que le moteur d'exécution fournit le pont de commandes configuré. |
| `inventory_command_read_failed` | La sortie de l'inventaire a échoué lors de la lecture. | Conservez la sortie partielle et réexécutez-la uniquement une fois l'erreur sous-jacente corrigée. |
| `inventory_command_close_failed` | Inventaire terminé sans résultat de clôture fiable. | Traitez la source comme incomplet. |
| `identity_ledger_row_limit_exceeded` | La saisie d'identité durable a dépassé sa limite de sécurité publique. | Archiver et examiner le grand livre ; ne le tronquez pas silencieusement en preuve complète. |

<a id="adminini-enforcement-codes"></a>
## Admin.ini codes d'application

Tous les codes de cette section sont fermés en cas d'échec. Ils n'autorisent pas eux-mêmes une interdiction manuelle.

| Code | Signification | Réponse sécurisée |
|---|---|---|
| `admin_ini_write_disabled` / `admin_ini_disabled` | Les portes d'écriture de sécurité publique sont désactivées. | Prévu en opération de révision uniquement. |
| `admin_ini_backup_disabled` / `backup_safety_gate_disabled` | La politique de sauvegarde requise n'est pas active. | Garder les écritures désactivées. |
| `enforcement_disabled` / `ban_on_threshold_disabled` / `auto_ban_disabled` | Une porte d'application explicite est désactivé. | Attendu dans les valeurs par défaut de révision publique uniquement ; ne le réinterprètez pas comme un échec d'écriture. |
| `review_only_mode_enabled` | Le mode de révision uniquement bloque intentionnellement la mutation. | Réviser les preuves uniquement. |
| `duplicate_prevention_disabled` | La protection contre les doublons a été désactivée. | Conserver les écritures désactivées jusqu'à ce que la barrière de sécurité soit restaurée. |
| `readback_safety_gate_disabled` / `rollback_safety_gate_disabled` | La vérification après écriture ou la protection contre l'annulation ont été désactivées. | Garder les écritures désactivées ; ne contournez jamais ces portes. |
| `clean_id_safety_gate_disabled` / `account_specific_evidence_gate_disabled` | L'application de preuves propres ou spécifiques au compte a été désactivée. | Restaurez la porte avant tout test d'application. |
| `moderator_preservation_disabled` / `existing_ban_preservation_disabled` | La conservation des comptes protégés ou des interdictions existantes a été désactivée. | Garder les écritures désactivées. |
| `clean_numeric_identity_required` | L'ID proposé n'est pas le formulaire de connexion accepté complet ou un ID numérique propre. | Obtenir un mappage vérifié ; ne tronquez jamais un préfixe arbitraire. |
| `identity_strength_below_minimum` | La preuve d'identité est plus faible que le seuil configuré. | Réviser les preuves uniquement. |
| `playerdata_verification_required` | La configuration nécessite PlayerData une confirmation et le compte ne l'a pas. | Gardez le candidat en révision uniquement ; ne déduisez pas la propriété d'un nom de fichier. |
| `trusted_or_moderator_identity` | Le compte est protégé par l'état de confiance ou de modérateur. | Aucune écriture n'est autorisée. |
| `admin_ini_path_invalid` / `admin_ini_path_outside_saved_root` | Le chemin cible n'est pas valide ou échappe à la racine enregistrée. | Configuration correcte ; ne contournez jamais le garde de chemin. |
| `admin_ini_unavailable` | Aucun Admin.ini configuré lisible n'a été trouvé à l'intérieur de la racine enregistrée. | Corrigez le chemin délimité ou laissez l'application désactivée. |
| `admin_ini_read_failed` | Les octets faisant autorité n'ont pas pu être lus. | Arrêtez avant la mutation. |
| `admin_ini_parse_failed` | Admin.ini la validation a échoué sans un code structurel plus spécifique. | Conservez le fichier et inspectez sa structure de sections et de lignes. |
| `admin_ini_contains_nul` | Le fichier contient NUL octets et n'est pas accepté sous forme de texte. | Conservez le fichier et réparez-le en dehors de Guard. |
| `admin_ini_duplicate_banned_players_section` | Plusieurs `[BannedPlayers]` sections existent. | Fusionner les sections manuellement à l'arrêt. |
| `admin_ini_banned_player_outside_section` | Une ligne d'interdiction apparaît à l'extérieur `[BannedPlayers]`. | Corrigez la disposition manuellement. |
| `admin_ini_invalid_banned_player_line` | Une ligne d'interdiction n'est pas exactement une ligne d'ID prise en charge propre. | Corrigez la ligne mal formée. |
| `admin_ini_backup_failed` | La sauvegarde unique n'a pas été écrite et relue à l'identique. | Aucune mutation n'est autorisée. |
| `admin_ini_external_change_detected` | Un autre rédacteur a modifié le fichier après l'instantané de Guard. | Conservez les octets externes et réessayez seulement après avoir coordonné les rédacteurs. |
| `atomic_rename_unavailable` | Un remplacement atomique a été demandé mais Lua ne l'a pas fourni `os.rename`. | Aucune écriture n'est fiable ; utilisez un moteur d'exécution pris en charge ou laissez l'application désactivée. |
| `admin_ini_write_failed` | Le remplacement contrôlé n'a pas été effectué. | Inspectez l'erreur de remplacement enregistrée et la sauvegarde. |
| `post_write_verification_failed` | Les octets de production n'étaient pas égaux au candidat. | Vérifiez `rollback_success` et `rollback_refused_external_change` avant toute action. |

<a id="startup-scheduler-and-backlog-states"></a>
## États de démarrage, de planification et de backlog

Ces valeurs constituent une preuve du cycle de vie et non une preuve de l'itinéraire. Lisez-les avec les fichiers actuels de sondage, de reporting et de route-proof.

| Valeur | Signification | Réponse sécurisée |
|---|---|---|
| `not_started` | L'étape de démarrage ou de planification nommée n'a pas commencé. | Pendant le lancement, attendez l'intervalle documenté ; inspectez ensuite la première phase inchangée. |
| `main_lua_loaded` / `starting` | Le chargeur canonique s'est exécuté et Guard est entré au démarrage. | Continuez avec les phases ultérieures ; cela seul ne constitue pas une préparation. |
| `saved_root_found` / `log_tail_initialized` / `epoch_started` | Initialisation de la source principale et de la continuité avancée. | Aucune action à moins que la phase suivante ne cesse d'avancer. |
| `admin_state_written` / `playerdata_index_written` | Les index limités initiaux ont été exportés. | Aucune action ; le transfert du planificateur doit encore suivre. |
| `watchdog_started` | Le chien de garde du rapport et du sondage a été enregistré. | Confirmez ensuite la progression du planificateur et du sondage. |
| `ready_degraded` / `scan_running` | La protection est en cours d'exécution alors que l'analyse historique limitée reste en attente. | Attention, pas d'échec ; vérifiez l'avancement des compteurs de progression. |
| `ready` | Le démarrage et l'analyse limitée en cours ont atteint l'état prêt. | Vérifiez la preuve d'itinéraire séparément. |
| `scan_failed` / `error` | Le démarrage ou l'analyse s'est terminé avec une erreur enregistrée. | Conservez l'erreur nommée ou le fichier d'état et diagnostiquez cette étape. |
| `running` | Le planificateur possède de futures opportunités de sondage. | Confirmez que `poll_id` et `poll_completed_count` avance. |
| `manual_only` | La programmation en boucle n'était pas disponible ; seul le travail explicite peut s'exécuter. | Traitez l'opération sans surveillance comme indisponible. |
| `stopped` | L'opération du planificateur s'est terminée. | Inspectez les preuves d'arrêt et d'erreur précédentes avant le redémarrage. |
| `active_log_caught_up` | Aucun retard de journal actif non lu ne subsiste. | L'analyse historique peut continuez. |
| `active_log_unavailable_nonblocking` | Le journal actif était absent, mais le démarrage est resté non bloquant. | Enregistrez la limite de source et vérifiez les autres sources. |
| `active_log_read_failed` | Le journal actif existait mais n'a pas pu être lu. | Conservez l'erreur et corrigez uniquement le chemin prouvé ou le problème d'autorisation. |
| `budget_exhausted` / `active_log_has_unread_bytes` | La passe finale limitée s'est arrêtée avec le retard restant. | Confirmez que les sondages ultérieurs réduisent les non lus. nombre. |
| `offset_commit_failed_after_events_applied` | Les événements ont été traités mais la persistance du décalage de journal durable a échoué. | L'application est différée ; réparez le stockage décalé avant de compter sur un autre cycle. |

<a id="scheduler-report-and-notification-codes"></a>
## Codes de planification, de rapport et de notification

| Code ou état | Signification | Réponse sécurisée |
|---|---|---|
| `poll already in flight` | Un deuxième rappel est arrivé alors que le sondage en cours possédait le cycle de vie. | Confirmez les avancées du sondage existant ; n'ajoutez pas un autre propriétaire de boucle. |
| `no_log_files_found` | Aucun journal actif ou de sauvegarde configuré n'a été découvert. | Vérifiez la configuration racine et source enregistrée. |
| `current_poll_error` | Le cycle actuel a enregistré un échec de source d'interrogation. | Lecture `runtime/current/poll_error.json`. |
| `cadence_deferred` | Le répartiteur d'achèvement n'est pas encore dû. | Attendu jusqu'à la prochaine opportunité limitée. |
| `reports_disabled` | La génération de rapports publics est désactivée. | Activer uniquement si les rapports sont souhaités. |
| `local_outbox_write_failed` | Une enveloppe locale traduite n'a pas pu être écrite. | Réparez le répertoire de sortie du runtime ; il ne s'agit pas d'une erreur de transport de notification. |
| `source_accounting_disabled` | La preuve d'itinéraire ne peut pas revendiquer une couverture complète de la source. | Activez la comptabilité source ou acceptez explicitement la preuve manquante. |
| `route_disabled` | L'itinéraire est intentionnellement désactivé. | Aucune livraison n'est attendue pour cette route. |
| `poll_owner_between_polls` | Le générateur de rapports est mis en file d'attente pour l'intervalle appartenant au planificateur entre les sondages. | Attendu uniquement pendant que les horodatages et les curseurs continuent d'avancer. |
| `unsafe_shell_path` | Un inventaire limité ou un chemin d'accès au shell a échoué à la validation sécurisée de la plate-forme. | Corrigez le chemin ; ne jamais affaiblir les devis ou la validation du chemin. |

<a id="related-procedures"></a>
## Procédures associées

- [Dépannage](D%C3%89PANNAGE.md) pour la classification et la réparation des symptômes.
- [Validation et révision des versions](VALIDATION_ET_PUBLICATION.md) pour les pannes de luminaires et de packages.
- [Référence du schéma de sortie](R%C3%89F%C3%89RENCE_DU_SCH%C3%89MA_DE_SORTIE.md) pour les contrats de terrain complets.
