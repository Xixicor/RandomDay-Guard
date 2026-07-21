from __future__ import annotations

import importlib.util
import sys
import unittest
from pathlib import Path
from unittest import mock


ROOT = Path(__file__).resolve().parents[1]


def load_pipeline_tool():
    name = "test_public_pipeline_tool_under_test"
    spec = importlib.util.spec_from_file_location(name, ROOT / "tools" / "test_public_pipeline.py")
    if spec is None or spec.loader is None:
        raise RuntimeError("cannot load tools/test_public_pipeline.py")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


pipeline_tool = load_pipeline_tool()


class LuaToolDiscoveryTests(unittest.TestCase):
    def test_inaccessible_optional_windows_lua_path_is_skipped(self) -> None:
        with (
            mock.patch.object(pipeline_tool.shutil, "which", return_value=None),
            mock.patch.dict(pipeline_tool.os.environ, {"LOCALAPPDATA": "X:/Portable/Lua/AppData/Local"}),
            mock.patch.object(pipeline_tool.Path, "is_file", side_effect=PermissionError("access denied")),
        ):
            self.assertIsNone(pipeline_tool.find_lua_tool(["lua"], "lua.exe"))


if __name__ == "__main__":
    unittest.main()
