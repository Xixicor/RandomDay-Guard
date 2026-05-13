# Validation and release

Use this page before committing or publishing a release ZIP.

## Version target

Expected version:

```text
v0.4.11-alpha
```

Check:

```text
VERSION
RandomDayGuard/config.lua
RandomDayGuard/BUILD_MARKER.txt
RandomDayGuard/MANIFEST.json
RandomDayGuard/Scripts/main.lua
RandomDayGuard/scripts/main.lua
releases/v0.4.11-alpha/RELEASE_NOTES.md
```

## Lua parse check

```powershell
C:\Users\User 774XxoE7\AppData\Local\Programs\Lua\bin\luac.exe -p RandomDayGuard\Scripts\main.lua
C:\Users\User 774XxoE7\AppData\Local\Programs\Lua\bin\luac.exe -p RandomDayGuard\scripts\main.lua
```

Both must pass.

## Validate repo

```powershell
python tools\validate_repo.py
```

## Build release

```powershell
python tools\build_release_zip.py
```

Expected:

```text
releases/v0.4.11-alpha/RandomDayGuard_v0.4.11-alpha.zip
releases/v0.4.11-alpha/CHECKSUMS.sha256
```

## Validate again

```powershell
python tools\validate_repo.py
```

## Inspect ZIP

Required:

```text
RandomDayGuard/enabled.txt
RandomDayGuard/config.lua
RandomDayGuard/SavedRoot.txt
RandomDayGuard/Scripts/main.lua
RandomDayGuard/scripts/main.lua
RandomDayGuard/data/*.json
RandomDayGuard/runtime/**/.gitkeep
```

Must not include:

```text
generated runtime files
forensic_days/YYYY-MM-DD/*
final_logs/YYYY-MM-DD/*
Admin.ini from a real server
server logs
PlayerData
world saves
private evidence
```

## Common validation failures

| Failure | Fix |
|---|---|
| Version mismatch | Update all markers |
| Scripts mismatch | Copy canonical script to both paths |
| Unsafe ban example | Use only `BannedPlayer=<ID>` |
| Runtime artifact packaged | Fix build exclusions |
| Docs claim unsupported feature | Adjust docs or implement behavior |

## Final release checklist

- [ ] Lua parse passes for both script paths.
- [ ] Validator passes before build.
- [ ] Build script succeeds.
- [ ] Validator passes after build.
- [ ] ZIP contains both script paths.
- [ ] ZIP excludes generated runtime data.
- [ ] Checksum is updated.
- [ ] No private IDs or names are present.
- [ ] GitHub Actions passes.

## Related docs

* [`DOCS_STYLE_GUIDE.md`](DOCS_STYLE_GUIDE.md)
* [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md)
