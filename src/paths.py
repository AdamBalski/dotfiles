from __future__ import annotations

import os
from pathlib import Path


REPO_UUID = "9708c2b7-c09d-4c51-b165-631c1d47a9d0"
REPO_ROOT = Path(__file__).resolve().parents[1]
PLUGINS_ROOT = REPO_ROOT / "plugins"
STATE_ROOT = (
    Path(os.environ.get("XDG_STATE_HOME", Path.home() / ".local" / "state"))
    / f"dotsync-{REPO_UUID}"
)
