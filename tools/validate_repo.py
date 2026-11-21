from __future__ import annotations

import argparse
import ast
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys
import urllib.parse

ROOT = Path(__file__).resolve().parents[1]
MOD = ROOT / "RandomDayGuard"
CANDIDATE_DIRECT_PATHS = (
    "enabled.txt", "config.lua", "SavedRoot.txt", "BUILD_MARKER.txt",
    "README.txt", "MANIFEST.json", "Scripts/public_pipeline.lua",
    "data/detection_events.json", "data/warning_types.json",
    "data/object_categories.json",
)
EXPECTED_LOCALES = {"ar", "binary", "bn", "bo", "de", "el", "es-MX", "fa", "fr", "hi", "hu", "hy", "id", "ja", "ka", "ko", "la", "mn", "pt-BR", "ru", "sw", "ta", "th", "tr", "ur", "vi", "zh-CN"}
EXPECTED_ENTRIES = {
    'ar': 'اقرأني.md',
    'binary': '01010010_01000101_01000001_01000100_01001101_01000101.md',
    'bn': 'আমাকে-পড়ুন.md',
    'bo': 'ཀློག་རོགས།.md',
    'de': 'LIES_MICH.md',
    'el': 'ΔΙΑΒΑΣΕ_ΜΕ.md',
    'es-MX': 'LÉEME.md',
    'fa': 'مرا_بخوان.md',
    'fr': 'LISEZ_MOI.md',
    'hi': 'मुझे-पढ़ें.md',
    'hu': 'OLVASS_EL.md',
    'hy': 'ԿԱՐԴԱ_ԻՆՁ.md',
    'id': 'BACA_SAYA.md',
    'ja': 'お読みください.md',
    'ka': 'წამიკითხე.md',
    'ko': '읽어주세요.md',
    'la': 'LEGE_ME.md',
    'mn': 'НАМАЙГ_УНШ.md',
    'pt-BR': 'LEIA-ME.md',
    'ru': 'ПРОЧТИ_МЕНЯ.md',
    'sw': 'NISOME.md',
    'ta': 'என்னைப்_படியுங்கள்.md',
    'th': 'โปรดอ่าน.md',
    'tr': 'BENİ_OKU.md',
    'ur': 'مجھے_پڑھیں.md',
    'vi': 'ĐỌC_TÔI.md',
    'zh-CN': '请读我.md',
}
LINK = re.compile(r"(?<!!)\[[^\]]+\]\(([^)]+)\)")
LEAK_PATTERNS = {
    "delivery_url": re.compile(r"https?://[^\s\"'<>]+/(?:api/)?webhooks?/", re.I),
    "private_key": re.compile(r"-----BEGIN (?:OPENSSH |RSA |EC )?PRIVATE KEY-----"),
    "credential": re.compile(r"(?:password|api[_-]?key|access[_-]?token|client[_-]?secret)\s*[:=]\s*[\"'][^\"']{8,}[\"']", re.I),
    "private_path": re.compile(r"(?:[A-Z]:[/\\]Users[/\\][^/\\\r\n]+|/(?:home|root)/[^/\r\n]+)", re.I),
}

def text(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="replace")


def add(errors: list[str], message: str) -> None:
    errors.append(message)


def parse_config_table(source: str) -> tuple[dict[str, object], list[object]]:
    """Parse the pure-data Lua table used by config.lua without executing it."""
    token_pattern = re.compile(
        r"\s+|--[^\r\n]*|\"(?:\\.|[^\"\\])*\"|'(?:\\.|[^'\\])*'|"
        r"[A-Za-z_][A-Za-z0-9_]*|-?[0-9]+(?:\.[0-9]+)?|[{}\[\]=,]"
    )
    tokens: list[str] = []
    position = 0
    while position < len(source):
        match = token_pattern.match(source, position)
        if match is None:
            raise ValueError(f"unsupported config.lua token near offset {position}")
        token = match.group(0)
        position = match.end()
        if token.isspace() or token.startswith("--"):
            continue
        tokens.append(token)

    index = 0

    def peek(offset: int = 0) -> str | None:
        target = index + offset
        return tokens[target] if target < len(tokens) else None

    def take(expected: str | None = None) -> str:
        nonlocal index
        if index >= len(tokens):
            raise ValueError("unexpected end of config.lua")
        token = tokens[index]
        if expected is not None and token != expected:
            raise ValueError(f"expected {expected!r}, got {token!r}")
        index += 1
        return token

    def scalar(token: str) -> object:
        if token in {"true", "false"}:
            return token == "true"
        if token == "nil":
            return None
        if token.startswith(('"', "'")):
            return ast.literal_eval(token)
        if re.fullmatch(r"-?[0-9]+", token):
            return int(token)
        if re.fullmatch(r"-?[0-9]+\.[0-9]+", token):
            return float(token)
        return token

    def parse_value() -> object:
        if peek() == "{":
            return parse_table()
        return scalar(take())

    def parse_table() -> tuple[dict[str, object], list[object]]:
        fields: dict[str, object] = {}
        items: list[object] = []
        take("{")
        while peek() not in {"}", None}:
            if peek() == "[":
                take("[")
                key = str(parse_value())
                take("]")
                take("=")
                fields[key] = parse_value()
            elif re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", peek() or "") and peek(1) == "=":
                key = take()
                take("=")
                fields[key] = parse_value()
            else:
                items.append(parse_value())
            if peek() == ",":
                take(",")
        take("}")
        return fields, items

    while peek() is not None and peek() != "return":
        take()
    take("return")
    parsed = parse_table()
    if index != len(tokens):
        raise ValueError("unexpected trailing config.lua tokens")
    return parsed


def config_field_paths(source: str) -> set[str]:
    fields: set[str] = set()

    def walk(table: tuple[dict[str, object], list[object]], prefix: str) -> None:
        for key, value in table[0].items():
            path = f"{prefix}.{key}"
            if isinstance(value, tuple) and len(value) == 2 and isinstance(value[0], dict) and isinstance(value[1], list):
                if value[0]:
                    walk(value, path)
                else:
                    fields.add(path)
            else:
                fields.add(path)

    walk(parse_config_table(source), "config")
    return fields


def generated_output_paths() -> set[str]:
    source_paths = [
        MOD / "Scripts" / "main.lua",
        MOD / "Scripts" / "public_pipeline.lua",
        MOD / "config.lua",
    ]
    raw: set[str] = set()
    for source_path in source_paths:
        for value in re.findall(r'["\'](runtime/[^"\']+)["\']', text(source_path)):
            raw.update(part for part in value.split(";") if part.startswith("runtime/"))

    directories = {
        "runtime/backups", "runtime/baselines", "runtime/current", "runtime/days",
        "runtime/epochs", "runtime/evidence", "runtime/final_logs",
        "runtime/forensic_days", "runtime/logs", "runtime/notifications",
        "runtime/notifications/pending", "runtime/raid_cases", "runtime/sessions",
        "runtime/warnings", "runtime/weeks", "runtime/world_state",
        "runtime/world_state/boot", "runtime/world_state/current",
        "runtime/world_state/sessions",
    }
    replacements = {
        "runtime/backups/Admin_": "runtime/backups/Admin_*.ini",
        "runtime/evidence/enforcement_failed_": "runtime/evidence/enforcement_failed_*",
        "runtime/warnings/warning_": "runtime/warnings/warning_*",
        "runtime/warnings/warning_<period>.txt": "runtime/warnings/warning_*.txt",
        "runtime/world_state/boot/world_state_boot_": "runtime/world_state/boot/world_state_boot_*.json",
    }
    outputs: set[str] = set()
    for value in raw:
        value = value.rstrip("/")
        outputs.add(value + "/**" if value in directories else replacements.get(value, value))
    for route in ("server_status", "daily_rollup", "player_activity", "case_review", "critical_guard"):
        outputs.add(f"runtime/final_logs/{route}_latest.json")
        outputs.add(f"runtime/final_logs/{route}_latest.txt")
    outputs.update({
        "runtime/notifications/pending/*_latest.json",
        "runtime/forensic_days/YYYY-MM-DD/**",
        "runtime/final_logs/YYYY-MM-DD/**",
    })
    return outputs


def local_links() -> list[str]:
    errors = []
    for source in ROOT.rglob("*.md"):
        if any(part in {".git", ".tmp"} for part in source.parts):
            continue
        text = source.read_text(encoding="utf-8")
        for raw in LINK.findall(text):
            target = raw.strip().split("#", 1)[0]
            if not target or target.startswith(("http://", "https://", "mailto:", "#")):
                continue
            path = (source.parent / urllib.parse.unquote(target)).resolve()
            if not path.exists():
                errors.append(f"broken link: {source.relative_to(ROOT).as_posix()} -> {raw}")
    return errors

def locale_errors() -> list[str]:
    root = ROOT / "docs/locales"
    errors = []
    codes = {path.name for path in root.iterdir() if path.is_dir()}
    if codes != EXPECTED_LOCALES:
        errors.append(f"locale set mismatch: {sorted(codes)}")
    if list(root.rglob("README.md")):
        errors.append("localized entry pages must use native-language filenames, not README.md")

    manifest_path = root / "manifest.json"
    try:
        manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    except (OSError, ValueError) as exc:
        return errors + [f"invalid locale manifest: {exc}"]

    locales = manifest.get("locales", {})
    if set(locales) != EXPECTED_LOCALES:
        errors.append(f"manifest locale set mismatch: {sorted(locales)}")
        return errors
    if manifest.get("schema_version") != 1 or manifest.get("canonical_language") != "en":
        errors.append("locale manifest header is invalid")
    if manifest.get("locale_count") != len(EXPECTED_LOCALES):
        errors.append("locale manifest count is invalid")
    if manifest.get("source_document_count") != 33:
        errors.append("locale source-document count is invalid")

    canonical_sources = {"README.md"}
    canonical_sources.update(path.name for path in ROOT.glob("*.md") if path.name != "README.md")
    canonical_sources.update(
        path.relative_to(ROOT).as_posix()
        for path in (ROOT / "docs").rglob("*.md")
        if "locales" not in path.relative_to(ROOT / "docs").parts
    )
    if len(canonical_sources) != 33:
        errors.append(f"canonical source-document count changed: {len(canonical_sources)}")

    index = (root / "LANGUAGES.md").read_text(encoding="utf-8")
    expected_localized = set()
    for code in sorted(EXPECTED_LOCALES):
        locale = locales[code]
        expected_entry = f"docs/locales/{code}/{EXPECTED_ENTRIES[code]}"
        if locale.get("entry") != expected_entry:
            errors.append(f"{code} native entry mismatch: {locale.get('entry')}")
        encoded_entry = urllib.parse.quote(EXPECTED_ENTRIES[code], safe="/@:+#._-~")
        if f"({code}/{encoded_entry})" not in index:
            errors.append(f"language index does not link {code} native entry")
        documents = locale.get("documents", [])
        if len(documents) != 33:
            errors.append(f"{code} document count is {len(documents)}")
            continue
        if {record.get("source") for record in documents} != canonical_sources:
            errors.append(f"{code} source coverage differs from the canonical library")
        for record in documents:
            source_rel = record.get("source", "")
            localized_rel = record.get("localized", "")
            source_path = ROOT / source_rel
            localized_path = ROOT / localized_rel
            expected_localized.add(localized_rel)
            if not source_path.is_file() or not localized_path.is_file():
                errors.append(f"{code} missing mapped document: {source_rel} -> {localized_rel}")
                continue
            source_hash = hashlib.sha256(source_path.read_bytes()).hexdigest()
            localized_hash = hashlib.sha256(localized_path.read_bytes()).hexdigest()
            if record.get("source_sha256") != source_hash or record.get("localized_sha256") != localized_hash:
                errors.append(f"{code} stale manifest hash: {source_rel}")
            localized_text = localized_path.read_text(encoding="utf-8")
            if "ZXQ" in localized_text or "data-codex" in localized_text:
                errors.append(f"{code} internal translation marker remains: {localized_rel}")

    actual_localized = {
        path.relative_to(ROOT).as_posix()
        for path in root.rglob("*.md")
        if path.name != "LANGUAGES.md"
    }
    if actual_localized != expected_localized:
        errors.append("localized Markdown files differ from manifest coverage")
    relative_files = [path.relative_to(ROOT).as_posix() for path in root.rglob("*") if path.is_file()]
    if len(relative_files) != len({path.casefold() for path in relative_files}):
        errors.append("localized library contains a case-insensitive path collision")
    if any(len(path) > 220 for path in relative_files):
        errors.append("localized library contains an overlong relative path")

    mexican_path = ROOT / locales["es-MX"]["entry"]
    mexican = mexican_path.read_text(encoding="utf-8")
    if "Mexican (MX)" not in index or "Mexican (MX)" not in mexican:
        errors.append("es-MX must use the reader-facing label Mexican (MX)")
    for forbidden in ("Mexican Spanish", "Spanish (Mexico)", "Español de México"):
        if forbidden in index or forbidden in mexican:
            errors.append(f"obsolete es-MX label remains: {forbidden}")
    return errors

def leak_scan_errors() -> list[str]:
    errors = []
    suffixes = {".md", ".txt", ".json", ".lua", ".py", ".yml", ".yaml"}
    for path in ROOT.rglob("*"):
        if not path.is_file() or path.suffix.lower() not in suffixes:
            continue
        if any(part in {".git", ".tmp", "releases"} for part in path.parts):
            continue
        text = path.read_text(encoding="utf-8", errors="replace")
        for pattern in LEAK_PATTERNS.values():
            if pattern.search(text):
                errors.append(f"sensitive pattern found: {path.relative_to(ROOT).as_posix()}")
                break
    return errors

def run_release_check() -> list[str]:
    result = subprocess.run([sys.executable, "-B", "tools/build_release_zip.py", "--check"], cwd=ROOT, text=True, capture_output=True)
    return [] if result.returncode == 0 else ["release check failed: " + (result.stdout + result.stderr).strip()]

def product_errors() -> list[str]:
    errors = []
    version = (ROOT / "VERSION").read_text(encoding="utf-8").strip()
    manifest = json.loads((ROOT / "RandomDayGuard/MANIFEST.json").read_text(encoding="utf-8"))
    if manifest.get("version") != version:
        errors.append("RandomDayGuard manifest version differs from VERSION")
    marker = (ROOT / "RandomDayGuard/BUILD_MARKER.txt").read_text(encoding="utf-8")
    if version not in marker:
        errors.append("RandomDayGuard build marker differs from VERSION")
    files = {path.relative_to(ROOT).as_posix() for path in ROOT.rglob("*") if path.is_file()}
    if "RandomDayGuard/Scripts/main.lua" not in files or "RandomDayGuard/scripts/main.lua" in files:
        errors.append("RandomDayGuard canonical loader layout is invalid")
    releases = sorted(path.name for path in (ROOT / "releases").iterdir() if path.is_dir())
    if releases != [version]:
        errors.append(f"release directories must contain only {version}: {releases}")
    for relative in ("README_ES.md", "RandomDayGuard/README_ES.txt", "docs/publication", "docs/HOSTINGER_AMP_INSTALL.md"):
        if (ROOT / relative).exists():
            errors.append(f"obsolete or provider-specific path remains: {relative}")
    config = (ROOT / "RandomDayGuard/config.lua").read_text(encoding="utf-8")
    for required in ("review_only_mode = true", "auto_ban = false", "write_admin_ini = false"):
        if required not in config:
            errors.append(f"safe public default missing: {required}")
    return errors

def validate_scheduler_offset_contract(main: str, errors: list[str]) -> None:
    def block(start: str, end: str) -> str:
        if start not in main:
            return ""
        value = main.split(start, 1)[1]
        return value.split(end, 1)[0] if end in value else value

    write_offsets_block = block("local function write_offsets", "local continuity_event")
    registry_block = block("local function update_log_registry", "local function write_poll_status")
    tail_block = block("local function tail_logs", "local function startup_scan")
    poll_block = block("local function poll_once", "local function safe_poll_once")
    safe_poll_block = block("local function safe_poll_once", "local function run_public_report_opportunity")
    schedule_block = block("local function schedule_next_poll", "local function stop_poll_loop")

    if 'while state.scheduler_status == "running" do' not in schedule_block:
        errors.append("LoopAsync poll scheduler is not the live-proven stay-alive owner model")
    if "schedule_next_poll()" in schedule_block:
        errors.append("LoopAsync poll callback recursively requeues schedule_next_poll")
    poll_at = schedule_block.find('safe_poll_once("loop")')
    report_at = schedule_block.find('run_public_report_opportunity("poll_owner_between_polls")')
    sleep_at = schedule_block.find("scheduler_sleep_ms(interval)")
    if not (0 <= poll_at < report_at < sleep_at) or "return true" not in schedule_block:
        errors.append("LoopAsync poll owner does not run one report opportunity between polls and stop with return true")
    if "refresh_public_pipeline(" in safe_poll_block:
        errors.append("safe_poll_once runs the public report pipeline inline")
    if "write_offsets(" in tail_block or 'write_json(runtime_path("runtime/log_registry.json")' in tail_block:
        errors.append("tail_logs persists offsets or registry before parsed events are applied")
    if "update_log_registry(false)" not in tail_block or "persist_registry" not in registry_block:
        errors.append("tail_logs does not keep log registry persistence tentative")
    if "pending_recent_event_keys" not in tail_block:
        errors.append("tail_logs commits dedupe keys before parsed events are applied")
    if "return write_tsv" not in write_offsets_block:
        errors.append("write_offsets does not propagate durable write failure")
    apply_at = poll_block.find("for _,ev in ipairs(evs) do apply_event(ev) end")
    registry_at = poll_block.find('write_json(runtime_path("runtime/log_registry.json"), state.log_registry)')
    offsets_at = poll_block.find("write_offsets(tail_meta.offsets)")
    if not (0 <= apply_at < registry_at < offsets_at):
        errors.append("poll_once does not commit registry and offsets after every parsed event is applied")
    for term in ("registry_ok", "offsets_ok", "offset_commit_failed_after_events_applied", "offset_commit_failed"):
        if term not in poll_block:
            errors.append(f"poll_once cursor commit contract missing: {term}")
    if "if tail_meta.offset_commit_failed ~= true then" not in poll_block or "evaluate_enforcement()" not in poll_block:
        errors.append("poll_once does not fail closed before enforcement when cursor commit fails")

def main() -> int:
    parser = argparse.ArgumentParser(); parser.add_argument("--lua-command"); parser.add_argument("--require-lua", action="store_true"); args = parser.parse_args()
    errors = product_errors() + locale_errors() + local_links() + leak_scan_errors() + run_release_check()
    validate_scheduler_offset_contract((ROOT / "RandomDayGuard/Scripts/main.lua").read_text(encoding="utf-8"), errors)
    if args.require_lua and not args.lua_command:
        errors.append("--require-lua needs --lua-command")
    if args.lua_command:
        for relative in ("RandomDayGuard/Scripts/main.lua", "RandomDayGuard/Scripts/public_pipeline.lua"):
            result = subprocess.run([args.lua_command, "-p", relative], cwd=ROOT, text=True, capture_output=True)
            if result.returncode != 0: errors.append(f"Lua syntax failed: {relative}: {result.stderr.strip()}")
    if errors:
        print("VALIDATION FAILED")
        for error in errors: print("- " + error)
        return 1
    print("RandomDayGuard repository validation passed")
    return 0

if __name__ == "__main__": raise SystemExit(main())
