from __future__ import annotations

import json
from dataclasses import dataclass
from pathlib import Path

from .errors import DotsyncError
from .parser import as_string, form_options, optional_bool, parse_many
from .paths import PLUGINS_ROOT, STATE_ROOT
from .syncables import SYNCABLE_TYPES
from .syncables.base import Status, Syncable


def plugin_state_path() -> Path:
    return STATE_ROOT / "plugins.json"


def load_plugin_state() -> dict[str, bool]:
    try:
        with plugin_state_path().open("r", encoding="utf-8") as f:
            raw = json.load(f)
    except FileNotFoundError:
        return {}
    if not isinstance(raw, dict):
        raise DotsyncError(f"{plugin_state_path()}: expected object")
    return {str(k): bool(v) for k, v in raw.items()}


def save_plugin_state(state: dict[str, bool]) -> None:
    plugin_state_path().parent.mkdir(parents=True, exist_ok=True)
    with plugin_state_path().open("w", encoding="utf-8") as f:
        json.dump(state, f, indent=2, sort_keys=True)
        f.write("\n")


@dataclass
class Plugin:
    name: str
    path: Path
    syncables: dict[str, Syncable]
    default_enabled: bool = True

    @property
    def selector(self) -> str:
        return f"./{self.name}"

    def enabled(self) -> bool:
        return load_plugin_state().get(self.name, self.default_enabled)

    def set_enabled(self, value: bool) -> list[str]:
        state = load_plugin_state()
        state[self.name] = value
        save_plugin_state(state)
        return [f"{self.selector}: {'on' if value else 'off'}"]

    def status(self, include_disabled: bool = True) -> list[Status]:
        if not self.enabled() and not include_disabled:
            return [Status(self.selector, True, [f"{self.selector}: off (skipped)"])]
        header = Status(self.selector, True, [f"{self.selector}: {'on' if self.enabled() else 'off'}"])
        return [header] + [syncable.status() for syncable in self.syncables.values()]

    def apply(self, force: bool, include_disabled: bool = False) -> list[str]:
        if not self.enabled() and not include_disabled:
            return [f"{self.selector}: off (skipped)"]
        lines = []
        for syncable in self.syncables.values():
            lines.extend(syncable.apply(force))
        return lines

    def turn_on(self) -> list[str]:
        lines = self.apply(force=True, include_disabled=True)
        lines.extend(self.set_enabled(True))
        return lines


def load_plugin(plugin_dir: Path) -> Plugin:
    name = plugin_dir.name
    syncables: dict[str, Syncable] = {}
    default_enabled = True
    for scm_file in sorted(plugin_dir.glob("*.dotsync.scm")):
        for form in parse_many(scm_file.read_text(encoding="utf-8"), scm_file):
            if not isinstance(form, list) or not form:
                raise DotsyncError(f"{scm_file}: top-level forms must be lists")
            kind = as_string(form[0], scm_file, "syncable kind")
            if kind == "plugin":
                opts = form_options(form, scm_file)
                default_enabled = optional_bool(opts, scm_file, "default-enabled", default_enabled)
                continue
            factory = SYNCABLE_TYPES.get(kind)
            if factory is None:
                raise DotsyncError(f"{scm_file}: unknown syncable kind {kind!r}")
            syncable = factory(name, plugin_dir, form, scm_file)
            if syncable.name in syncables:
                raise DotsyncError(f"{scm_file}: duplicate syncable {syncable.name!r}")
            syncables[syncable.name] = syncable
    return Plugin(name=name, path=plugin_dir, syncables=syncables, default_enabled=default_enabled)


def discover_plugins() -> dict[str, Plugin]:
    if not PLUGINS_ROOT.exists():
        return {}
    plugins = {}
    for plugin_dir in sorted(p for p in PLUGINS_ROOT.iterdir() if p.is_dir()):
        plugins[plugin_dir.name] = load_plugin(plugin_dir)
    return plugins


def parse_selector(selector: str, plugins: dict[str, Plugin]) -> tuple[str, Plugin | None, Syncable | None]:
    if selector == ".":
        return ("device", None, None)
    if not selector.startswith("./"):
        raise DotsyncError(f"{selector}: syncable must be '.', './plugin', or './plugin/syncable'")
    parts = [part for part in selector[2:].split("/") if part]
    if len(parts) not in (1, 2):
        raise DotsyncError(f"{selector}: syncable must be '.', './plugin', or './plugin/syncable'")
    plugin = plugins.get(parts[0])
    if plugin is None:
        raise DotsyncError(f"{selector}: unknown plugin")
    if len(parts) == 1:
        return ("plugin", plugin, None)
    syncable = plugin.syncables.get(parts[1])
    if syncable is None:
        raise DotsyncError(f"{selector}: unknown plugin syncable")
    return ("syncable", plugin, syncable)
