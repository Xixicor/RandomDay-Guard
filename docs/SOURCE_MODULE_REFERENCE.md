# Source module reference

This page maps every source, configuration, data, compatibility-loader, and
runtime-placeholder class admitted by the release allowlist. The machine
index is [`TRACEABILITY_INDEX.json`](TRACEABILITY_INDEX.json); this page is the
readable canonical explanation. Each generated machine row names a distinct
path/class, purpose, owning source block, public settings, side effects,
operator-visible states, failures, recovery, and canonical document.

## Packaged file map

| Path | Responsibility | Entry point or caller | Inputs | Outputs and side effects | Failure behavior | User editable |
|---|---|---|---|---|---|---|
| `LICENSE` | Project license shipped at the archive root. | Installer, redistributor, and operator. | Reviewed repository license text. | States the terms that apply to the package; no runtime mutation. | Omission makes the release package legally incomplete and blocks the allowlist. | No. |
| `NOTICE.md` | Project notices shipped at the archive root. | Installer and operator. | Reviewed project notices. | Preserves required attribution and project context; no runtime mutation. | Omission makes the release package incomplete and blocks the allowlist. | No. |
| `THIRD_PARTY_NOTICES.md` | Third-party notices shipped at the archive root. | Installer and redistributor. | Reviewed third-party attribution text. | Preserves dependency attribution; no runtime mutation. | Omission makes the release package incomplete and blocks the allowlist. | No. |
| `RandomDayGuard/enabled.txt` | UE4SS mod enablement flag. | UE4SS mod loader. | `1` or `0` as supported by UE4SS. | Enables or disables loading; writes no runtime evidence. | A disabled or malformed flag prevents normal startup proof. | Yes, during install. |
| `RandomDayGuard/config.lua` | Complete public settings table. | `Scripts/main.lua` at startup. | Fields catalogued in [`CONFIG_FIELD_CATALOG.md`](CONFIG_FIELD_CATALOG.md). | Controls discovery, budgets, reports, review gates, and optional local markers. | Lua/load/default drift blocks validation or makes startup fail closed. | Yes; keep a backup. |
| `RandomDayGuard/SavedRoot.txt` | Optional explicit Saved-root override. | Saved-root resolver in `main.lua`. | One generic filesystem path to `AbioticFactor/Saved`. | Selects the root used for logs, saves, PlayerData filenames, and `Admin.ini`. | Missing is allowed; unsafe, wrong, or unreadable paths remain unproven. | Yes; never place credentials here. |
| `RandomDayGuard/BUILD_MARKER.txt` | Human-readable package identity. | Installer, validator, and operator. | Release version rendered by the builder. | No runtime mutation. | Version mismatch blocks packaging. | No. |
| `RandomDayGuard/MANIFEST.json` | Machine-readable package identity and layout metadata. | Validator, builder, and support tooling. | Release version rendered by the builder. | No runtime mutation. | JSON or version mismatch blocks packaging. | No. |
| `RandomDayGuard/README.txt` | Installed English quick reference. | Operator. | Packaged paths and safe defaults. | No runtime mutation. | Stale paths or safety wording fail documentation parity. | No. |
| `RandomDayGuard/Scripts/main.lua` | UE4SS entry, evidence collection, state ownership, bounded scheduling, optional enforcement, and output writers. | UE4SS. | Config, Saved-root sources, current runtime state, dictionaries, and the reporting module. | Writes the runtime classes in [`OUTPUT_SCHEMA_REFERENCE.md`](OUTPUT_SCHEMA_REFERENCE.md); an approved enforcement path may back up and update `Admin.ini`. | Startup/poll/write failures produce explicit error state and never prove route completion. | No. |
| `RandomDayGuard/Scripts/public_pipeline.lua` | Source accounting, current-cycle lineage, report translation, route proof, durable public history, and optional local outbox. | `main.lua` report worker. | Read-only state/context callbacks and retained local evidence. | Writes report JSON/TXT pairs, source/history accounting, route proof, durable account history, and notification status/envelopes. | Missing lineage, required source, paired write, or route-proof write forces `missing` and blocks queueing. | No. |
| `RandomDayGuard/data/detection_events.json` | Public event vocabulary and explanations. | `main.lua` event normalization/reporting. | Valid JSON dictionary. | Labels evidence; does not create observations. | Missing/malformed data blocks repository validation. | No. |
| `RandomDayGuard/data/warning_types.json` | Warning-type vocabulary and review meaning. | Warning normalization/reporting. | Valid JSON dictionary. | Labels warning evidence. | Missing/malformed data blocks repository validation. | No. |
| `RandomDayGuard/data/object_categories.json` | Object/class category vocabulary. | Scan and object-registry reporting. | Valid JSON dictionary. | Labels extracted class context. | Missing/malformed data blocks repository validation. | No. |
| `RandomDayGuard/runtime/**/.gitkeep` | Empty install-layout placeholders only. | Package extraction. | Empty bytes. | Creates writable directory structure; no evidence is bundled. | Any non-placeholder runtime member blocks the exact allowlist. | No. |

## UE4SS loader and watchdog

`Scripts/main.lua` owns the independent watchdog's startup, Saved-root discovery, the current log tail,
server epochs and sessions, bounded polling and scanning, object/world context,
review scoring, `Admin.ini` safety gates, legacy operational outputs, and the
separate report-worker handoff. It must keep live polling bounded while slow
historical work resumes independently. A heartbeat, startup marker, or
increasing `poll_id` proves only that component; route completion requires the
same current boot, epoch, poll, source freshness, report pair, and route proof.

The source and package have one authority: `RandomDayGuard/Scripts/main.lua`.
A lowercase `scripts/` copy is not part of the source tree or release. Keeping one
canonical spelling prevents case-collision failures when the package is extracted
on Windows or Linux.

## Public reporting module

`Scripts/public_pipeline.lua` receives callbacks instead of host credentials
or provider adapters. It inventories eight source classes, records terminal
and incomplete states, keeps current players separate from retained history,
translates each route in the order `Observed`, `Interpretation`, `Unknown`,
`Does not prove`, `Next action`, and `Source references`, then writes route
proof. The optional notification mode writes a local JSON envelope only; it
never claims delivery or bundles a delivery endpoint/bridge.

The executable fixture in `tests/lua/public_pipeline_runtime_test.lua` loads
this shipped module with Lua, proves full and expected-empty routes, proves a
missing-current-source cycle fails closed, and proves incomplete routes do not
enter the outbox.

## Configuration and data

[`CONFIG_FIELD_CATALOG.md`](CONFIG_FIELD_CATALOG.md) and
[`TRACEABILITY_INDEX.json`](TRACEABILITY_INDEX.json) are generated by
`tools/generate_documentation_audit.py` from a non-executing structural parse
of `config.lua`, the package allowlist, and source-discovered output classes.
Exact generated content and one-to-one coverage are validated. The three JSON
dictionaries are labels and mappings, not evidence sources. An operator may
edit config, Saved-root selection, and enablement; source, dictionaries,
manifests, and packaged readmes are release-owned.

## Package layout

The builder admits only the three root legal files, the `RandomDayGuard/`
paths above, and empty runtime placeholders. It
orders members bytewise, fixes ZIP metadata, packages the canonical loader once,
scans every member for private material, records a
SHA-256 for every member, binds names and bytes into one content digest, and
builds twice. Tests reject every case-fold collision and prove normal extraction
produces exactly one physical file per archive entry.

The public repository keeps only the current release folder. The builder checks
that its ZIP, checksum, notes, version markers, and source tree agree.

## Code comment contract

Runtime comments are concise maintainer contracts, not a second manual. Each
shipped runtime module must place one canonical link in its opening comment
block:

```lua
-- Documentation: docs/SOURCE_MODULE_REFERENCE.md#ue4ss-loader-and-watchdog
```

Non-obvious state, scheduling, write/readback/rollback, source-discovery,
translation, evidence, output-schema, route-cadence, and redaction blocks use
focused comments with these labels where applicable:

```lua
-- Public contract: <invariant or consequence>
-- Evidence boundary: <what the input cannot prove>
-- Failure behavior: <how the block fails closed or recovers>
-- Documentation: docs/<canonical-file>.md#<existing-anchor>
```

The main loader also has one focused owner comment for config loading, Saved
discovery, atomic replacement, enforcement, and scheduling. These comments
state control-flow and failure boundaries; they do not change runtime behavior.

The validator requires a module-level `Documentation:` link for each runtime
module, resolves every comment path and anchor, requires focused contract and
failure comments in both runtime modules, and compares the same canonical links
with `TRACEABILITY_INDEX.json`. A comment is traceability, not runtime proof.

## Contributor change checklist

1. Update one owning module and its focused fixture.
2. Update the canonical config, schema, output, evidence, or lifecycle section.
3. Run `python -B tools/generate_documentation_audit.py --write` after a config,
   packaged path, generated output class, owner, or recovery contract changes.
4. Run `python -B tools/generate_documentation_audit.py --check`, focused unit
   tests, the real Lua fixture where Lua is available, the full validator, two
   independent deterministic builds, and `git diff --check`.
5. Review the generated ZIP member list, checksum, and private-material scan
   before creating the release.
