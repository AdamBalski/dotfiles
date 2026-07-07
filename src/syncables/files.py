from __future__ import annotations

import os
import stat
from pathlib import Path
from typing import Any

from ..dto import file_dto, sha256_file
from ..errors import DotsyncError
from ..fs import atomic_copy_file
from ..parser import as_string, form_options, resolve_path
from .base import Syncable


class FileSyncable(Syncable):
    kind = "file"

    def __init__(self, plugin_name: str, plugin_dir: Path, name: str, source: Path, target: Path) -> None:
        super().__init__(plugin_name, plugin_dir, name)
        self.source = source
        self.target = target

    @classmethod
    def from_form(cls, plugin_name: str, plugin_dir: Path, form: list[Any], file_name: Path) -> "FileSyncable":
        opts = form_options(form, file_name)
        for required in ("name", "source", "target"):
            if required not in opts:
                raise DotsyncError(f"{file_name}: file syncable requires ({required} ...)")
        name = as_string(opts["name"], file_name, "name")
        source = resolve_path(plugin_dir, as_string(opts["source"], file_name, "source"))
        target = resolve_path(plugin_dir, as_string(opts["target"], file_name, "target"))
        return cls(plugin_name, plugin_dir, name, source, target)

    def config_dto(self) -> dict[str, Any]:
        return file_dto(self.target, self.source)

    def device_dto(self) -> dict[str, Any]:
        return file_dto(self.target, self.target)

    def apply_config(self) -> None:
        if not self.source.is_file():
            raise DotsyncError(f"{self.selector}: missing source file {self.source}")
        atomic_copy_file(self.source, self.target)


class DirSyncable(Syncable):
    kind = "dir"

    def __init__(self, plugin_name: str, plugin_dir: Path, name: str, source: Path, target: Path) -> None:
        super().__init__(plugin_name, plugin_dir, name)
        self.source = source
        self.target = target

    @classmethod
    def from_form(cls, plugin_name: str, plugin_dir: Path, form: list[Any], file_name: Path) -> "DirSyncable":
        opts = form_options(form, file_name)
        for required in ("name", "source", "target"):
            if required not in opts:
                raise DotsyncError(f"{file_name}: dir syncable requires ({required} ...)")
        name = as_string(opts["name"], file_name, "name")
        source = resolve_path(plugin_dir, as_string(opts["source"], file_name, "source"))
        target = resolve_path(plugin_dir, as_string(opts["target"], file_name, "target"))
        return cls(plugin_name, plugin_dir, name, source, target)

    def _manifest(self, path: Path) -> dict[str, Any]:
        if not path.exists():
            return {
                "kind": "dir",
                "target": str(self.target),
                "exists": False,
                "files": [],
            }
        if not path.is_dir():
            raise DotsyncError(f"{path}: expected a directory")
        files = []
        for file_path in sorted(p for p in path.rglob("*") if p.is_file()):
            rel = file_path.relative_to(path).as_posix()
            st = file_path.stat()
            files.append(
                {
                    "path": rel,
                    "sha256": sha256_file(file_path),
                    "size": st.st_size,
                    "mode": stat.S_IMODE(st.st_mode),
                }
            )
        return {
            "kind": "dir",
            "target": str(self.target),
            "exists": True,
            "files": files,
        }

    def config_dto(self) -> dict[str, Any]:
        return self._manifest(self.source)

    def device_dto(self) -> dict[str, Any]:
        return self._manifest(self.target)

    def apply_config(self) -> None:
        if not self.source.is_dir():
            raise DotsyncError(f"{self.selector}: missing source directory {self.source}")
        self.target.mkdir(parents=True, exist_ok=True)
        source_files = {p.relative_to(self.source) for p in self.source.rglob("*") if p.is_file()}
        target_files = {p.relative_to(self.target) for p in self.target.rglob("*") if p.is_file()}

        for rel in sorted(target_files - source_files, reverse=True):
            (self.target / rel).unlink()
        for rel in sorted(source_files):
            atomic_copy_file(self.source / rel, self.target / rel)


class FontFileSyncable(FileSyncable):
    kind = "font-file"

    def apply_config(self) -> None:
        before = self.device_dto()
        super().apply_config()
        after = self.device_dto()
        if before != after:
            self.target.parent.mkdir(parents=True, exist_ok=True)
            os.utime(self.target.parent, None)
