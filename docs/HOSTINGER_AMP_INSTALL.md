# Hostinger and AMP Install

Use a stop, replace, verify, start workflow.

1. Stop the server.
2. Delete the old `RandomDayGuard` folder from `AbioticFactor/Binaries/Win64/ue4ss/Mods/`.
3. Extract `RandomDayGuard_v0.4.11-alpha.zip`.
4. Verify both script paths:

```sh
grep -n "local VERSION" RandomDayGuard/Scripts/main.lua
grep -n "local VERSION" RandomDayGuard/scripts/main.lua
cat RandomDayGuard/BUILD_MARKER.txt
```

5. Confirm `mods.txt` contains:

```text
RandomDayGuard : 1
```

6. Start the server.

If Saved root auto-detection fails, set `SavedRoot.txt` to the server `Saved/` folder, not the world folder.

After start, check `runtime/current/poll_status.json`. `poll_id` should increase and `poll_in_flight` should clear between polls.
