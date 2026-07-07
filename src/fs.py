from __future__ import annotations

import os
import shutil
import stat
import tempfile
from pathlib import Path


def atomic_copy_file(source: Path, target: Path) -> None:
    target.parent.mkdir(parents=True, exist_ok=True)
    source_mode = stat.S_IMODE(source.stat().st_mode)
    with source.open("rb") as src:
        fd, tmp_name = tempfile.mkstemp(prefix=f".{target.name}.", dir=str(target.parent))
        tmp = Path(tmp_name)
        try:
            with os.fdopen(fd, "wb") as dst:
                shutil.copyfileobj(src, dst)
            os.chmod(tmp, source_mode)
            os.replace(tmp, target)
        except Exception:
            try:
                tmp.unlink()
            except FileNotFoundError:
                pass
            raise
