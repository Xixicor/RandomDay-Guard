# Admin.ini Enforcement

This guide explains how RandomDayGuard should write bans safely.

Admin.ini is an enforcement target, not an evidence report.

---

## Core Rule

Admin.ini ban lines must be clean:

```ini
BannedPlayer=<ID>
```

No comments.  
No names.  
No reasons.  
No suffixes.

Reasons belong in:

```text
runtime/enforced.txt
runtime/enforced_bans.jsonl
runtime/evidence/
runtime/warnings/
```

---

## Display Name Is Not A Ban ID

Do not write:

```ini
BannedPlayer=ExamplePlayer
```

A display name from Discord, Hostinger activity, or chat presence is not enough.

Strongest source:

```text
Server log Login request line containing:
Name=
ConnectID=
UniqueId=
```

---

## Clean ID Extraction

If the server log shows:

```text
ConnectID=2535422284688820_+_|0002d07b...
```

Use only:

```ini
BannedPlayer=2535422284688820
```

Do not paste:

```text
_+_|0002d07b...
```

into Admin.ini.

---

## PlayerData Verification

A PlayerData file can confirm an ID exists:

```text
Player_2535422284688820.sav
```

But PlayerData alone often does not prove the display name.

Use PlayerData as:

```text
ID existence support
save-state context
restricted-area or world-context evidence if readable
```

Do not claim a display name from PlayerData unless another source maps it.

---

## Safe Defaults

Public defaults should be:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
require_clean_ban_id = true
preserve_existing_bans = true
preserve_moderators = true
```

This means:

```text
Evidence is collected.
Recommendations can be produced.
Admin.ini is not modified until explicitly enabled.
```

---

## Enforcement Gates

RandomDayGuard should write Admin.ini only when all required gates pass:

```text
review_only_mode == false
auto_ban == true
write_admin_ini == true
ban_id is clean numeric
identity is mapped
threshold is met
account-specific evidence exists
ID is not trusted
ID is not moderator
existing bans are preserved
moderators are preserved
```

If any gate fails, write evidence only.

---

## Admin.ini Structure

Recommended structure:

```ini
[Moderators]
Moderator=<trusted_id>

[BannedPlayers]
BannedPlayer=<ban_id>
```

Rules:

```text
Keep one [Moderators] section.
Keep one [BannedPlayers] section.
Deduplicate IDs.
Do not remove old bans unless intentionally reviewing them.
Never add trusted/moderator IDs to bans.
```

---

## Backup Before Write

Before modifying Admin.ini, RandomDayGuard should create a backup.

Expected backup area:

```text
runtime/backups/
```

Expected evidence:

```text
runtime/enforced_bans.jsonl
runtime/enforced.txt
runtime/evidence/
```

If write fails, expected failure evidence may include:

```text
runtime/evidence/enforcement_failed_<timestamp>.json
```

---

## Manual Rollback

If a bad ban is written:

1. Stop the server.
2. Open the correct server Admin.ini.
3. Restore from the latest backup in `runtime/backups/`.
4. Remove the incorrect `BannedPlayer=<ID>` line if needed.
5. Start the server.
6. Reopen Admin.ini after restart to confirm it persisted.
7. Preserve `enforced_bans.jsonl` for audit.

---

## Enforcement Testing Before Live Use

Use review-only first:

```lua
review_only_mode = true
auto_ban = false
write_admin_ini = false
```

Then review:

```text
runtime/account_evidence.json
runtime/warnings/
runtime/evidence/
runtime/enforced_bans.jsonl
```

If recommendations are correct and trusted IDs are configured, then decide whether to enable writing.

---

## What Not To Ban From Alone

These are not enough by themselves:

```text
one crash
one warning burst
lag
high ping
object count alone
many deployed objects in normal context
display name only
PlayerData ID with no supporting reason
raid case membership without account-specific evidence
```

Ban eligibility requires repeated or account-specific configured evidence.
