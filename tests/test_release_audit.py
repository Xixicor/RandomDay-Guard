import importlib.util
import io
from pathlib import Path
import unittest
import zipfile

ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("release_builder", ROOT / "tools/build_release_zip.py")
BUILDER = importlib.util.module_from_spec(SPEC); SPEC.loader.exec_module(BUILDER)

class ReleaseBuilderTests(unittest.TestCase):
    def test_package_is_deterministic_and_canonical(self):
        first = BUILDER.zip_bytes(BUILDER.source_members())
        second = BUILDER.zip_bytes(BUILDER.source_members())
        self.assertEqual(first, second)
        with zipfile.ZipFile(io.BytesIO(first)) as archive:
            names = archive.namelist()
            self.assertIn("RandomDayGuard/Scripts/main.lua", names)
            self.assertNotIn("RandomDayGuard/scripts/main.lua", names)
            self.assertEqual(len(names), len(set(name.casefold() for name in names)))

    def test_only_current_release_and_mexican_label(self):
        self.assertEqual([BUILDER.VERSION], sorted(path.name for path in (ROOT / "releases").iterdir() if path.is_dir()))
        self.assertIn("Mexican (MX)", (ROOT / "docs/locales/README.md").read_text(encoding="utf-8"))
        self.assertIn("Mexican (MX)", (ROOT / "docs/locales/es-MX/README.md").read_text(encoding="utf-8"))

if __name__ == "__main__": unittest.main()
