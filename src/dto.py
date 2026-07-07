from __future__ import annotations

import difflib
import hashlib
import json
import stat
from pathlib import Path
from typing import Any

from .errors import DotsyncError


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def file_dto(target: Path, content_path: Path) -> dict[str, Any]:
    if not content_path.exists():
        return {
            "kind": "file",
            "target": str(target),
            "exists": False,
        }
    if not content_path.is_file():
        raise DotsyncError(f"{content_path}: expected a regular file")
    st = content_path.stat()
    return {
        "kind": "file",
        "target": str(target),
        "exists": True,
        "sha256": sha256_file(content_path),
        "size": st.st_size,
        "mode": stat.S_IMODE(st.st_mode),
    }


def dto_text(dto: dict[str, Any] | None) -> list[str]:
    if dto is None:
        return ["<missing state>"]
    return json.dumps(dto, indent=2, sort_keys=True).splitlines()


def unified(label_a: str, dto_a: dict[str, Any] | None, label_b: str, dto_b: dict[str, Any]) -> str:
    lines = difflib.unified_diff(
        dto_text(dto_a),
        dto_text(dto_b),
        fromfile=label_a,
        tofile=label_b,
        lineterm="",
    )
    return "\n".join(lines)


def same_dto(a: dict[str, Any] | None, b: dict[str, Any]) -> bool:
    return a == b
