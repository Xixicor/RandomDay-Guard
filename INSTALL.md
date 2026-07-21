# Install RandomDayGuard

This guide installs `v0.4.12-alpha` on an Abiotic Factor dedicated server that
already uses UE4SS. The mod is not tied to one hosting company or control panel.

## Before you begin

You need:

- access to stop and start the dedicated server;
- the server's UE4SS `Mods` folder;
- a copy of the current RandomDayGuard folder if you are updating;
- a backup of the server data you normally protect before changing a mod.

The **Mods folder** is the `ue4ss/Mods/` directory inside the dedicated-server
installation. RandomDayGuard belongs directly inside that folder.

## New installation

1. Stop the dedicated server.
2. Extract the RandomDayGuard ZIP into a new empty folder.
3. Copy the extracted `RandomDayGuard` folder into the server's UE4SS `Mods`
   folder. The result should be one `Mods/RandomDayGuard/` folder, not a second
   RandomDayGuard folder nested inside it.
4. Open UE4SS `mods.txt` and enable:

   ```text
   RandomDayGuard : 1
   ```

5. Start the server normally.
6. Wait for UE4SS and the game server to finish starting, then follow
   [Read the first report](docs/START_HERE.md).

Do not copy a new release over a running installation. Keep the backup until
the updated installation has produced a current server-status report.

## Update an existing installation

1. Stop the server.
2. Copy the complete installed RandomDayGuard folder to a safe backup location.
3. Move the old program folder out of UE4SS `Mods` instead of layering the new
   release over it.
4. Copy the new RandomDayGuard folder into `Mods`.
5. Restore only your reviewed local configuration and saved evidence. If the
   configuration guide lists new fields, merge them into the reviewed copy
   instead of replacing all settings blindly.
6. Confirm `RandomDayGuard : 1` remains enabled.
7. Start the server and read the current server-status report.

This clean-folder update also removes obsolete files from older releases
without asking the operator to inspect program filenames.

## Help Guard find the server records

Guard normally finds the Abiotic Factor `Saved` directory automatically. If it
cannot, put the full path to that `Saved` directory in `SavedRoot.txt` inside
the RandomDayGuard folder. Point to `Saved`, not to one individual world below
it.

The first server-status report says whether the record location was found and
which source groups were available. Use
[Troubleshooting](docs/TROUBLESHOOTING.md) when it cannot read the location.

## First-run behavior

The default installation watches available records and writes reports. It does
not change `Admin.ini` or add a ban. This allows you to confirm collection,
translation, and report quality before deciding whether to enable any optional
action.

[Read the first report](docs/START_HERE.md)

## Disable or remove RandomDayGuard

1. Stop the server.
2. Copy the complete RandomDayGuard folder to a safe archive.
3. To disable the mod, set `RandomDayGuard : 0` in UE4SS `mods.txt`.
4. To remove it, move the complete RandomDayGuard folder out of `Mods` after
   confirming the archive can be opened.
5. Start the server and confirm Guard no longer starts.

Disabling or removing Guard stops future collection. It does not delete game
data, erase the archived reports, or reverse a separate operator action.

## Roll back an update

If the new installation does not load or cannot produce a current report:

1. Stop the server.
2. Move the unsuccessful installation aside without deleting its records.
3. Restore the complete pre-update RandomDayGuard folder.
4. Restore the reviewed configuration and saved evidence from the same backup.
5. Confirm the mod is enabled and start the server.
6. Read the restored server-status report before making another change.

## More help

- [Read the first report](docs/START_HERE.md)
- [Operations playbook](docs/OPERATIONS_PLAYBOOK.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)
- [Configuration profiles](docs/CONFIG_PROFILES.md)
- [Admin.ini enforcement](docs/ADMIN_INI_ENFORCEMENT.md)

Release maintainers can find source, package, and privacy checks in
[Validation and release](docs/VALIDATION_AND_RELEASE.md). They are not required
for an ordinary installation.
