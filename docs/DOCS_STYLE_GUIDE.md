# Docs style guide

Use this guide when adding or editing RandomDayGuard docs.

## Goal

Docs should be fast to browse and practical to use.

Each page should answer:

```text
What is this?
When do I use it?
What do I open?
What should I expect?
What can go wrong?
Where do I go next?
```

## Page template

Use this structure for most pages:

```markdown
# Topic name

One or two sentences explaining the task.

## At a glance
A short table.

## Quick path
Numbered steps.

## Files to check
A short code block or table.

## Expected result
What success looks like.

## Problems to avoid
Short list.

## Related docs
Links to 2-4 nearby docs.
```

## Writing rules

| Rule | Reason |
|---|---|
| Use short sections | Makes GitHub browsing easier |
| Use tables for choices | Faster scanning |
| Use numbered lists for procedures | Clear order |
| Use code blocks for paths and commands | Easy copy/paste |
| Put warnings near the relevant step | Avoids defensive walls |
| Link instead of repeating | Keeps docs maintainable |
| Use placeholders | Avoids private data leaks |

## Preferred wording

Use direct operator language:

```text
Open this file.
Check this field.
Zip this folder.
Keep this disabled until verified.
```

Avoid vague language:

```text
It may be desirable to consider reviewing...
```

## Evidence language

Use:

```text
context
review signal
mapped account
clean ban ID
source file
```

Avoid unsupported claims unless evidence directly proves them.

## File/path style

Use code formatting:

```text
runtime/current/poll_status.json
Admin.ini
BannedPlayer=<ID>
```

## Private data rule

Never include:

```text
real server names
real world names
real private account IDs
real private label
raw player records
```

Use placeholders:

```text
<server>
<WorldName>
<AccountID>
<BanID>
<PlayerName>
```

