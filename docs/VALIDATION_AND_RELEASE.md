# Validation and Release

This guide explains how to validate RandomDayGuard and build the release ZIP.

---

## Version Consistency

All of these must agree:

```text
VERSION
RandomDayGuard/config.lua
RandomDayGuard/BUILD_MARKER.txt
RandomDayGuard/MANIFEST.json
RandomDayGuard/Scripts/main.lua
RandomDayGuard/scripts/main.lua
releases/v0.4.11-alpha/RELEASE_NOTES.md
```

Expected:

```text
v0.4.11-alpha
```

---

## Lua Parse Checks

Run:

```powershell
C:\Users\User 774XxoE7\AppData\Local\Programs\Lua\bin\luac.exe -p RandomDayGuard\Scripts\main.lua
C:\Users\User 774XxoE7\AppData\Local\Programs\Lua\bin\luac.exe -p RandomDayGuard\scripts\main.lua
```

Both must pass.

---

## Repository Validation

Run:

```powershell
python tools\validate_repo.py
```

This should fail if:

```text
versions disagree
README sections are missing
unsafe Admin.ini examples exist
private names/IDs are present
runtime artifacts are packaged
Scripts/main.lua and scripts/main.lua differ
unsupported claims appear in docs
```

---

## Build Release ZIP

Run:

```powershell
python tools\build_release_zip.py
```

Expected output:

```text
releases/v0.4.11-alpha/RandomDayGuard_v0.4.11-alpha.zip
releases/v0.4.11-alpha/CHECKSUMS.sha256
```

---

## Validate Again

Run:

```powershell
python tools\validate_repo.py
```

Validation after build is required because release files and checksums may change.

---

## Inspect ZIP

Check that the ZIP contains:

```text
RandomDayGuard/enabled.txt
RandomDayGuard/config.lua
RandomDayGuard/SavedRoot.txt
RandomDayGuard/BUILD_MARKER.txt
RandomDayGuard/MANIFEST.json
RandomDayGuard/README.txt
RandomDayGuard/Scripts/main.lua
RandomDayGuard/scripts/main.lua
RandomDayGuard/data/detection_events.json
RandomDayGuard/data/warning_types.json
RandomDayGuard/data/object_categories.json
RandomDayGuard/runtime/**/.gitkeep
```

Check that the ZIP does not contain:

```text
runtime/generated json/jsonl/tsv/txt files
server logs
Admin.ini from a real server
PlayerData
world saves
private evidence
old release folders
```

---

## Git Checks

Before commit:

```powershell
git status
git diff --stat
```

Commit message example:

```text
Update operator documentation and validation
```

---

## GitHub Actions Failure Checklist

If GitHub validation fails:

1. Read the exact validator message.
2. Fix the named README/doc/code issue.
3. Run local validation.
4. Rebuild if release assets changed.
5. Validate again.
6. Push.

Common failures:

| Failure | Fix |
|---|---|
| Missing README section | Add exact required heading. |
| Unsafe BannedPlayer example | Use only `BannedPlayer=<ID>`, no suffix/name. |
| Version mismatch | Update all version markers. |
| Runtime artifact in ZIP | Fix build exclusions. |
| Private name hit | Replace with placeholders. |
| Script path missing | Ensure both Scripts and scripts exist. |

---

## Release Checklist

- [ ] `luac -p` passes for both script paths.
- [ ] `python tools/validate_repo.py` passes.
- [ ] `python tools/build_release_zip.py` passes.
- [ ] Post-build validation passes.
- [ ] ZIP has both Lua entrypoints.
- [ ] ZIP has runtime `.gitkeep` placeholders only.
- [ ] ZIP has no generated runtime files.
- [ ] Checksum updated.
- [ ] README and docs match current behavior.
- [ ] No private data is included.
- [ ] GitHub Actions passes.
