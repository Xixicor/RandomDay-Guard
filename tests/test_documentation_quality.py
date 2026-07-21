from __future__ import annotations

from pathlib import Path
import re
import unittest
import zipfile


ROOT = Path(__file__).resolve().parents[1]
LOCALES = {
    "ar", "binary", "bn", "bo", "de", "el", "es-MX", "fa", "fr", "hi",
    "hu", "hy", "id", "ja", "ka", "ko", "la", "mn", "pt-BR", "ru",
    "sw", "ta", "th", "tr", "ur", "vi", "zh-CN",
}
LINK_RE = re.compile(r"(?<!!)\[[^\]]+\]\(([^)]+)\)")


class DocumentationQualityTests(unittest.TestCase):
    def test_language_library_uses_the_approved_anchor_set(self) -> None:
        locale_root = ROOT / "docs/locales"
        self.assertEqual(LOCALES, {path.name for path in locale_root.iterdir() if path.is_dir()})
        index = (locale_root / "README.md").read_text(encoding="utf-8")
        mexican = (locale_root / "es-MX/README.md").read_text(encoding="utf-8")
        self.assertIn("Mexican (MX)", index)
        self.assertIn("# RandomDayGuard - Mexican (MX)", mexican)
        for rejected in ("Mexican Spanish", "Spanish (Mexico)", "Español de México"):
            self.assertNotIn(rejected, index + mexican)
        for peninsular in ("ordenador", "fichero", "ficheros", "vosotros"):
            self.assertNotRegex(mexican.casefold(), rf"\b{peninsular}\b")
        for code in LOCALES:
            self.assertTrue((locale_root / code / "README.md").is_file(), code)
            self.assertIn(f"({code}/README.md)", index)

    def test_binary_page_contains_no_normal_language_preface(self) -> None:
        text = (ROOT / "docs/locales/binary/README.md").read_text(encoding="utf-8")
        self.assertGreaterEqual(len(text.splitlines()), 30)
        self.assertIn("01010010 01100001 01101110 01100100 01101111 01101101 01000100 01100001 01111001 01000111 01110101 01100001 01110010 01100100", text)
        for prose in ("This technical rendering", "Open ", "Read ", "Public defaults", "Use "):
            self.assertNotIn(prose, text)

    def test_landing_page_explains_five_distinct_reports(self) -> None:
        text = (ROOT / "README.md").read_text(encoding="utf-8")
        for route in ("**Server status**", "**Daily rollup**", "**Player activity**", "**Case review**", "**Critical Guard**"):
            self.assertIn(route, text)
        self.assertIn("does not merely say that files exist", text)
        compact = " ".join(text.split()).casefold()
        for supported in ("latest completed cycle", "same-day joins and leaves", "source gaps"):
            self.assertIn(supported, compact)
        for unsupported in ("online for 22 hours 41 minutes", "restart count, latest backup"):
            self.assertNotIn(unsupported, compact)

    def test_worked_examples_contain_values_actions_and_empty_behavior(self) -> None:
        text = (ROOT / "docs/REPORT_EXAMPLES.md").read_text(encoding="utf-8")
        for heading in ("## Server status", "## Daily rollup", "## Player activity", "## Case review", "## Critical Guard"):
            self.assertIn(heading, text)
        for value in (
            "3 minutes, 12 seconds", "312 of 355", "23 successful",
            "76561198000000400", "90 - High priority", "Report Writing Stopped",
        ):
            self.assertIn(value, text)
        for superseded in ("monitoring cycle: 42", "account 400", "EV-1042"):
            self.assertNotIn(superseded, text)
        self.assertGreaterEqual(text.count("**Action:**"), 4)
        self.assertIn("**Recommended action:**", text)
        self.assertIn("A quiet period does not create a player message", text)
        self.assertIn("A quiet route records a direct result", text)

    def test_current_and_historical_paths_reach_every_locale(self) -> None:
        for code in LOCALES:
            text = (ROOT / "docs/locales" / code / "README.md").read_text(encoding="utf-8")
            for marker in ("runtime/current/report_worker_status.json", "scan_cursor", "last_progress_ts"):
                self.assertIn(marker, text, f"{code}: {marker}")

    def test_report_examples_identify_sample_derived_provenance(self) -> None:
        text = (ROOT / "docs/REPORT_EXAMPLES.md").read_text(encoding="utf-8")
        self.assertIn("sample data included with the release", text)
        self.assertIn("names and account numbers are invented", text)
        self.assertNotIn("fictional review copy", text.casefold())

    def test_documentation_home_links_every_canonical_page(self) -> None:
        home = (ROOT / "docs/README.md").read_text(encoding="utf-8")
        self.assertIn("## New to RandomDayGuard", home)
        for page in sorted((ROOT / "docs").glob("*.md")):
            if page.name != "README.md":
                self.assertIn(f"({page.name})", home, page.name)

    def test_all_local_markdown_links_resolve(self) -> None:
        for source in ROOT.rglob("*.md"):
            if any(part in {".git", ".tmp"} for part in source.parts):
                continue
            for target in LINK_RE.findall(source.read_text(encoding="utf-8")):
                path_text = target.split("#", 1)[0].replace("%20", " ")
                if not path_text or path_text.startswith(("http://", "https://", "mailto:")):
                    continue
                self.assertTrue((source.parent / path_text).resolve().exists(), f"{source.relative_to(ROOT)} -> {target}")

    def test_reader_pages_exclude_private_workflow_and_transport_details(self) -> None:
        forbidden = (
            "prepared public candidate", "owner approval", "publication packet",
            "preservation ledger", "storefront draft", "hostinger", "discord",
            "webhook", "private-material scan",
        )
        for path in (ROOT / "README.md", ROOT / "INSTALL.md", ROOT / "CHANGELOG.md", ROOT / "RandomDayGuard/README.txt", ROOT / "docs/README.md"):
            text = path.read_text(encoding="utf-8").casefold()
            for phrase in forbidden:
                self.assertNotIn(phrase, text, path.name)

    def test_install_and_release_are_current_and_case_safe(self) -> None:
        install = (ROOT / "INSTALL.md").read_text(encoding="utf-8")
        for expected in ("The **Mods folder** is the `ue4ss/Mods/` directory", "one `Mods/RandomDayGuard/` folder", "`RandomDayGuard : 1`", "## Disable or remove RandomDayGuard"):
            self.assertIn(expected, install)
        for maintainer_detail in ("contains 34 files", "must not include", "Get-FileHash"):
            self.assertNotIn(maintainer_detail, install)
        version = (ROOT / "VERSION").read_text(encoding="utf-8").strip()
        self.assertEqual([version], sorted(path.name for path in (ROOT / "releases").iterdir() if path.is_dir()))
        archive_path = ROOT / "releases" / version / f"RandomDayGuard_{version}.zip"
        with zipfile.ZipFile(archive_path) as archive:
            names = archive.namelist()
            self.assertIn("RandomDayGuard/Scripts/main.lua", names)
            self.assertNotIn("RandomDayGuard/scripts/main.lua", names)
            self.assertEqual(len(names), len({name.casefold() for name in names}))

    def test_public_defaults_remain_review_only(self) -> None:
        config = (ROOT / "RandomDayGuard/config.lua").read_text(encoding="utf-8")
        for setting in ("review_only_mode = true", "auto_ban = false", "write_admin_ini = false"):
            self.assertIn(setting, config)

    def test_beginner_guides_do_not_require_maintainer_tools(self) -> None:
        for path in (ROOT / "README.md", ROOT / "INSTALL.md", ROOT / "docs/START_HERE.md", ROOT / "docs/REPORT_EXAMPLES.md"):
            text = path.read_text(encoding="utf-8")
            for detail in ("Get-FileHash", "CHECKSUMS.sha256", "git diff", "unittest discover"):
                self.assertNotIn(detail, text, path.name)

    def test_legal_and_source_references_remain_present(self) -> None:
        text = (ROOT / "docs/SOURCE_MODULE_REFERENCE.md").read_text(encoding="utf-8")
        for legal in ("`LICENSE`", "`NOTICE.md`", "`THIRD_PARTY_NOTICES.md`"):
            self.assertIn(legal, text)


if __name__ == "__main__":
    unittest.main()
