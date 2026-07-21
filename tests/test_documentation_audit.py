from __future__ import annotations

import json
import re
import unittest
from collections import Counter
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class DocumentationAuditTests(unittest.TestCase):
    def test_config_catalog_covers_all_public_fields(self) -> None:
        catalog = (ROOT / "docs/CONFIG_FIELD_CATALOG.md").read_text(encoding="utf-8")
        rows = [line for line in catalog.splitlines() if line.startswith("| `config.")]
        self.assertEqual(300, len(rows))
        meanings = []
        for row in rows:
            cells = [cell.strip() for cell in re.split(r"(?<!\\)\|", row)[1:-1]]
            self.assertEqual(8, len(cells), row)
            meanings.append(cells[3])
            for cell in (cells[3], cells[4], cells[5], cells[6], cells[7]):
                self.assertGreaterEqual(len(cell), 8, row)
        self.assertLessEqual(max(Counter(meanings).values()), 5)

    def test_traceability_index_is_unique_and_explained(self) -> None:
        payload = json.loads((ROOT / "docs/TRACEABILITY_INDEX.json").read_text(encoding="utf-8"))
        self.assertEqual("randomdayguard.traceability/v2", payload["schema"])
        paths = [entry["path"] for entry in payload["entries"]]
        self.assertEqual(len(paths), len(set(paths)))
        for entry in payload["entries"]:
            for field in ("purpose", "owning_source", "public_settings", "side_effects", "failure_modes", "recovery", "canonical_document"):
                self.assertTrue(entry[field], f"{entry['path']}: {field}")

    def test_canonical_loader_documents_source_ownership(self) -> None:
        canonical = ROOT / "RandomDayGuard/Scripts/main.lua"
        self.assertTrue(canonical.is_file())
        files = {path.relative_to(ROOT).as_posix() for path in ROOT.rglob("*") if path.is_file()}
        self.assertNotIn("RandomDayGuard/scripts/main.lua", files)
        source = canonical.read_text(encoding="utf-8")
        for owner in ("Config loading owner:", "Saved discovery owner:", "Atomic replacement owner:", "Enforcement owner:", "Scheduling owner:"):
            self.assertEqual(1, source.count(owner), owner)


if __name__ == "__main__":
    unittest.main()
