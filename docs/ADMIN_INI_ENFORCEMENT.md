# Admin.ini enforcement

RandomDayGuard does not change the server ban list in its default setup. It only
creates reports for an admin to review. This page explains the optional
automatic ban-list update for admins who deliberately enable it.

## What Guard checks before changing the ban list

Guard adds a ban only when every answer below is **yes**:

1. Did current evidence identify one specific account with sufficient confidence?
2. Is the account neither a moderator nor an account the admin marked as trusted?
3. Is the account not already on the ban list?
4. Did the account reach the configured automatic-action score?
5. Can Guard read the current `Admin.ini` and save an identical backup?
6. Did `Admin.ini` stay unchanged while Guard prepared the update?
7. After saving, does the complete file exactly match the intended result?

If any answer is **no**, or cannot be checked, Guard leaves `Admin.ini` unchanged
and records the reason in its reports. If saving begins but the final check
fails, Guard restores the verified backup.

## File format

`Admin.ini` must receive clean ban lines only:

```ini
BannedPlayer=<ID>
```

- No names.
- No comments.
- No reasons.
- No suffixes.

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

The runtime accepts either a fully numeric ID or the complete documented
`<digits>_+_|<non-space token>` connection form and derives the numeric ban ID
from it. Arbitrary numeric prefixes with an unknown suffix are rejected; they
are not truncated into a ban ID.

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

## Exact settings Guard checks

These settings implement the checks described above. Every listed condition must be true:

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

If any condition is false or cannot be checked, Guard leaves the ban list unchanged and records what stopped it.

## Transaction safety

The sole `Admin.ini` mutation path performs these steps in order:

1. Read and structurally validate the authoritative bytes.
2. Derive moderator, trusted, and existing-ban state from that same snapshot.
3. Write a unique backup under `runtime/backups/` and verify it byte for byte.
4. Re-read `Admin.ini` immediately before replacement and reject any external change.
5. Write the candidate through the configured controlled replacement path.
6. Require the complete readback bytes to equal the complete candidate bytes.
7. On readback failure, restore the verified backup only while the current file
   is still the exact candidate written by Guard. If another writer changed it,
   Guard refuses rollback rather than overwrite unknown external bytes.

Duplicate IDs are idempotent: no second line and no second backup are written.
Backup names include a timestamp, source-byte fingerprint, and clean ID so
separate attempts cannot share the old one-second filename.

## Local regression proof

`tests/lua/enforcement_runtime_test.lua` boots the shipped loader once and then
executes its real local `append_ban()` closure against isolated synthetic files
below the repository `.tmp/` directory. It covers insertion, duplicate
idempotency, moderator/trusted rejection, weak and malformed identity rejection,
byte-exact backup verification, concurrent modification rejection, successful
rollback after failed readback, and refusal to overwrite a post-write external
change. Its filesystem wrappers reject any mutation outside the fixture root;
no real server path or real `Admin.ini` is used.

Run it through `python tools/test_public_pipeline.py`. A fixture pass proves the
local transaction behavior only. It does not enable enforcement, authorize a
production write, or prove host-specific permissions.

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
