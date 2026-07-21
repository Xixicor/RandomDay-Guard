#!/usr/bin/env python3
"""Build or verify the deterministic RandomDayGuard release package."""

from __future__ import annotations

import argparse
import hashlib
import io
import json
from pathlib import Path, PurePosixPath
import re
import zipfile


ROOT = Path(__file__).resolve().parents[1]
MOD = ROOT / "RandomDayGuard"
VERSION = (ROOT / "VERSION").read_text(encoding="utf-8").strip()
RELEASE_DIR = ROOT / "releases" / VERSION
ASSET = f"RandomDayGuard_{VERSION}.zip"
ZIP_TIME = (1980, 1, 1, 0, 0, 0)
LEGAL = ("LICENSE", "NOTICE.md", "THIRD_PARTY_NOTICES.md")
PRIVATE_PATTERNS = {
    "delivery_url": re.compile(rb"https?://[^\s\"'<>]+/(?:api/)?webhooks?/", re.I),
    "private_key": re.compile(rb"-----BEGIN (?:OPENSSH |RSA |EC )?PRIVATE KEY-----"),
    "credential": re.compile(rb"(?:password|api[_-]?key|access[_-]?token|client[_-]?secret)\s*[:=]\s*[\"'][^\"']{8,}[\"']", re.I),
    "private_path": re.compile(rb"(?:[A-Z]:[/\\]Users[/\\][^/\\\r\n]+|/(?:home|root)/[^/\r\n]+)", re.I),
}


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def validate_name(name: str) -> None:
    path = PurePosixPath(name)
    if path.is_absolute() or ".." in path.parts or "\\" in name:
        raise SystemExit(f"unsafe package member: {name}")
    if {part.casefold() for part in path.parts} & {"private", "__pycache__", ".git", ".tmp", "server_reports"}:
        raise SystemExit(f"private/generated package member: {name}")


def source_members() -> dict[str, bytes]:
    payload = {name: (ROOT / name).read_bytes() for name in LEGAL}
    for path in sorted(MOD.rglob("*")):
        if not path.is_file():
            continue
        relative = path.relative_to(MOD).as_posix()
        if relative.startswith("runtime/") and path.name != ".gitkeep":
            continue
        if relative == "runtime/.gitkeep" or not relative.startswith("runtime/") or path.name == ".gitkeep":
            payload[f"RandomDayGuard/{relative}"] = path.read_bytes()
    required = {
        "RandomDayGuard/enabled.txt", "RandomDayGuard/config.lua",
        "RandomDayGuard/Scripts/main.lua", "RandomDayGuard/Scripts/public_pipeline.lua",
        "RandomDayGuard/MANIFEST.json", "RandomDayGuard/BUILD_MARKER.txt",
    }
    if not required.issubset(payload):
        raise SystemExit("RandomDayGuard package is missing required files")
    if "RandomDayGuard/scripts/main.lua" in payload:
        raise SystemExit("lowercase duplicate loader is forbidden")
    folded: dict[str, str] = {}
    for name, data in payload.items():
        validate_name(name)
        prior = folded.setdefault(name.casefold(), name)
        if prior != name:
            raise SystemExit(f"case-colliding package members: {prior}, {name}")
        for label, pattern in PRIVATE_PATTERNS.items():
            if pattern.search(data):
                raise SystemExit(f"private material in {name}: {label}")
    manifest = json.loads(payload["RandomDayGuard/MANIFEST.json"])
    if manifest.get("version") != VERSION:
        raise SystemExit("MANIFEST.json version does not match VERSION")
    if VERSION.encode() not in payload["RandomDayGuard/BUILD_MARKER.txt"]:
        raise SystemExit("BUILD_MARKER.txt version does not match VERSION")
    return payload


def zip_bytes(payload: dict[str, bytes]) -> bytes:
    output = io.BytesIO()
    with zipfile.ZipFile(output, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
        for name in sorted(payload):
            info = zipfile.ZipInfo(name, ZIP_TIME)
            info.create_system = 3
            info.external_attr = 0o100644 << 16
            info.compress_type = zipfile.ZIP_DEFLATED
            archive.writestr(info, payload[name], compress_type=zipfile.ZIP_DEFLATED, compresslevel=9)
    return output.getvalue()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    data = zip_bytes(source_members())
    checksum = f"{sha256(data)}  {ASSET}\n".encode("utf-8")
    with zipfile.ZipFile(io.BytesIO(data), "r") as archive:
        names = archive.namelist()
        if names != sorted(names) or len(names) != len(set(item.casefold() for item in names)):
            raise SystemExit("release ZIP order or case identity is invalid")
    if args.check:
        actual_dirs = sorted(path.name for path in (ROOT / "releases").iterdir() if path.is_dir())
        if actual_dirs != [VERSION]:
            raise SystemExit(f"release directory set is not current-only: {actual_dirs}")
        if not (RELEASE_DIR / ASSET).is_file() or (RELEASE_DIR / ASSET).read_bytes() != data:
            raise SystemExit("release ZIP differs from deterministic build")
        if (RELEASE_DIR / "CHECKSUMS.sha256").read_bytes() != checksum:
            raise SystemExit("CHECKSUMS.sha256 differs from release ZIP")
        print(f"RandomDayGuard {VERSION} release check passed")
        return 0
    RELEASE_DIR.mkdir(parents=True, exist_ok=True)
    for path in RELEASE_DIR.iterdir():
        if path.is_file() and path.name != "RELEASE_NOTES.md":
            path.unlink()
    (RELEASE_DIR / ASSET).write_bytes(data)
    (RELEASE_DIR / "CHECKSUMS.sha256").write_bytes(checksum)
    print(RELEASE_DIR / ASSET)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
