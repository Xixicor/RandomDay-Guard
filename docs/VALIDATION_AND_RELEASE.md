# Validation and release

This page is for contributors and release maintainers. Server operators do not
need to run these commands to install RandomDayGuard.

## User-visible proof

A release is understandable when a new operator can install it, find the first
server-status report, distinguish the five report routes, and follow one clear
action from a worked example. Reader tasks must not require Git, PowerShell,
Python, or checksum knowledge.

## Contributor checks

```powershell
python -B tools/validate_repo.py
python -B tools/test_public_pipeline.py
python -B -m unittest discover tests
```

When `luac` is available:

```powershell
luac -p RandomDayGuard/Scripts/main.lua
luac -p RandomDayGuard/Scripts/public_pipeline.lua
```

The Lua fixture tests cover the loader, scheduler, report routes, and optional
Admin.ini write transaction. Enforcement fixtures use temporary files only and
verify identity, trusted-account rejection, thresholds, backup,
concurrent-change refusal, readback, and rollback.

## Package proof

```powershell
python -B tools/build_release_zip.py --check
git diff --check
```

- All version markers match `VERSION`.
- Only the current version exists under `releases/`.
- The ZIP contains the canonical `RandomDayGuard/Scripts/main.lua` path and no
  lowercase case-variant loader.
- Runtime output, private configuration, credentials, local paths, caches, and
  test artifacts are excluded.
- The public configuration remains review-only with enforcement disabled.
- The five worked report examples remain consistent with route ownership and
  the release test fixture.
- ZIP bytes are deterministic and match `CHECKSUMS.sha256`.
- All local documentation links and 27 locale entry pages validate.

## Avoid validation environment pitfalls

- Run repository-writing checks serially to avoid temporary-file contention.
- On Windows, inspect archived member names or enumerated path spelling rather
  than a case-insensitive file lookup when checking for duplicate loaders.
- A missing `luac` command or Lua runtime is an unavailable capability, not a
  passing syntax or runtime test.
- A fixture proves only its modeled inputs. It does not prove a live server
  produced a current report.
- Record command timeouts and partial output instead of assuming completion.

## Repair failed repository validation

Start with the first reported path or contract. Correct that item, rerun the
narrow test, then rerun the complete matrix. Do not hide a missing capability by
removing the test that requires it.

## Known limits and release decision

Local checks prove source, fixture, package, and documentation contracts. A
specific server installation, long-running stability window, or client display
requires a separate integration result. Record that result with its build,
configuration, duration, and observed output before making the matching claim.
