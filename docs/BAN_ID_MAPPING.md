# Ban ID Mapping

Display name is not a ban ID.

Primary mapping source:

```text
LogNet: Login request: ?Name=<PlayerName>?ConnectID=<BanID>_+_|<Suffix> UniqueId=<Platform>:<Value>
```

RandomDayGuard preserves:

- display name as context
- raw `ConnectID`
- `UniqueId`
- clean ban ID extracted from the leading numeric prefix

For Admin.ini, use only:

```ini
BannedPlayer=<BanID>
```

Do not paste suffixes, names, reasons, URLs, or inline comments into `Admin.ini`.

PlayerData filenames can confirm an ID exists in a world save, but they usually do not prove a display name. Host panels, activity feeds, and container logs are timing/name context only, not ban-ID authority.

Existing moderators and bans must be preserved. Trusted IDs belong in private server config, not public defaults.
