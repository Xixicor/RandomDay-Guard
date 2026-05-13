# Admin.ini enforcement

Use this page before allowing RandomDayGuard to write bans.

## Core rule

`Admin.ini` must receive clean ban lines only:

```ini
BannedPlayer=<ID>
```

No names.  
No comments.  
No reasons.  
No suffixes.

## Safe defaults

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
require_clean_ban_id = true
preserve_existing_bans = true
preserve_moderators = true
```

## Ban ID source

Best source:

```text
Login request
Name=<player>
ConnectID=<raw_id>
UniqueId=<platform_id>
```

If the raw connection ID contains a suffix, use only the clean leading numeric ID.

Correct:

```ini
BannedPlayer=2535422284688820
```

Wrong:

```ini
BannedPlayer=ExamplePlayer
```

Also wrong:

```text
BannedPlayer=<ID>
```

## Enforcement gates

All gates must pass:

```text
review_only_mode == false
auto_ban == true
write_admin_ini == true
ban_id is clean numeric
identity is mapped
not trusted
not moderator
threshold is met
account-specific evidence exists
```

If any gate fails, write evidence only.

## Files to check

```text
runtime/account_evidence.json
runtime/forensic_days/YYYY-MM-DD/ban_recommendations.tsv
runtime/final_logs/YYYY-MM-DD/final_forensic_log.txt
runtime/enforced_bans.jsonl
runtime/enforced.txt
runtime/ban_queue.json
```

## Rollback

1. Stop the server.
2. Restore the latest Admin.ini backup from `runtime/backups/`.
3. Remove the incorrect `BannedPlayer=<ID>` line if needed.
4. Start the server.
5. Reopen Admin.ini and confirm the line persisted or was removed.
6. Preserve `enforced_bans.jsonl` for audit.

## Related docs

* [`BAN_ID_MAPPING.md`](BAN_ID_MAPPING.md)
* [`PLAYER_REVIEW_WORKFLOW.md`](PLAYER_REVIEW_WORKFLOW.md)

