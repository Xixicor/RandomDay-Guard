#!/usr/bin/env python3
from __future__ import annotations

import hashlib
import json
import zipfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
MOD = ROOT / "RandomDayGuard"
VERSION = (ROOT / "VERSION").read_text(encoding="utf-8").strip()
OUT_DIR = ROOT / "releases" / VERSION
ZIP_PATH = OUT_DIR / f"RandomDayGuard_{VERSION}.zip"

REQUIRED_FILES = [
    "enabled.txt",
    "config.lua",
    "SavedRoot.txt",
    "BUILD_MARKER.txt",
    "README.txt",
    "MANIFEST.json",
    "Scripts/main.lua",
    "scripts/main.lua",
    "data/detection_events.json",
    "data/warning_types.json",
    "data/object_categories.json",
]

RUNTIME_KEEP_DIRS = [
    "runtime",
    "runtime/backups",
    "runtime/baselines",
    "runtime/current",
    "runtime/days",
    "runtime/forensic_days",
    "runtime/final_logs",
    "runtime/evidence",
    "runtime/epochs",
    "runtime/logs",
    "runtime/raid_cases",
    "runtime/sessions",
    "runtime/warnings",
    "runtime/world_state",
    "runtime/world_state/boot",
    "runtime/world_state/current",
    "runtime/world_state/sessions",
]


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def check_inputs() -> None:
    if VERSION != "v0.4.11-alpha":
        raise SystemExit("This clean public baseline builder only builds v0.4.11-alpha")
    missing = [rel for rel in REQUIRED_FILES if not (MOD / rel).exists()]
    if missing:
        raise SystemExit("Missing release inputs: " + ", ".join(missing))
    if (MOD / "Scripts/main.lua").read_bytes() != (MOD / "scripts/main.lua").read_bytes():
        raise SystemExit("Scripts/main.lua and scripts/main.lua differ")
    manifest = json.loads((MOD / "MANIFEST.json").read_text(encoding="utf-8"))
    if manifest.get("version") != VERSION:
        raise SystemExit("MANIFEST.json version does not match VERSION")
    if VERSION not in (MOD / "BUILD_MARKER.txt").read_text(encoding="utf-8"):
        raise SystemExit("BUILD_MARKER.txt does not contain VERSION")


def add_file(zf: zipfile.ZipFile, src: Path, arcname: str) -> None:
    info = zipfile.ZipInfo(arcname)
    info.external_attr = 0o644 << 16
    zf.writestr(info, src.read_bytes(), compress_type=zipfile.ZIP_DEFLATED)


def build() -> None:
    check_inputs()
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    if ZIP_PATH.exists():
        ZIP_PATH.unlink()
    with zipfile.ZipFile(ZIP_PATH, "w") as zf:
        for rel in REQUIRED_FILES:
            add_file(zf, MOD / rel, f"RandomDayGuard/{rel}")
        for rel in RUNTIME_KEEP_DIRS:
            zf.writestr(f"RandomDayGuard/{rel}/.gitkeep", "")

    (OUT_DIR / "CHECKSUMS.sha256").write_text(f"{sha256(ZIP_PATH)}  {ZIP_PATH.name}\n", encoding="utf-8")
    (OUT_DIR / "RELEASE_NOTES.md").write_text(
        f"""# RandomDayGuard {VERSION} - Initial Clean Public Baseline

RandomDayGuard is a separately installable guard addon for RandomDay Mod dedicated servers. It watches the Abiotic Factor dedicated-server evidence layer through UE4SS Lua, AMP/Hostinger/Wine-compatible paths, and Saved-folder/log-derived evidence.

## Included

- Standalone UE4SS Lua entrypoints at `RandomDayGuard/Scripts/main.lua` and `RandomDayGuard/scripts/main.lua`
- Immediate live-defense layer from server logs before baseline completion
- Bounded baseline scan layer with progress, checkpoint, partial, manifest, and completed baseline outputs
- Review-first defaults: `auto_ban=false`, `write_admin_ini=false`, and `review_only_mode=true`
- Clean Admin.ini output only when explicitly enabled: `BannedPlayer=<ID>`
- Session evidence, crash/restart context, log continuity, object registry, world-state files, warning reports, raid context, and AMP restart marker support

## Evidence Boundary

RandomDayGuard uses Saved-folder and log-derived evidence only. It does not claim live object damage, container use, item duplication, exact player coordinates, live ping, object ownership, memory inspection, or client anti-cheat behavior unless those facts are visible in readable server evidence.
""",
        encoding="utf-8",
    )
    print(ZIP_PATH)


if __name__ == "__main__":
    build()
