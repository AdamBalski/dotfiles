from __future__ import annotations

import json
from dataclasses import dataclass
from pathlib import Path
from typing import Any

from ..dto import same_dto, unified
from ..errors import DotsyncError
from ..paths import STATE_ROOT


@dataclass(frozen=True)
class Status:
    path: str
    ok: bool
    lines: list[str]


class Syncable:
    kind = "syncable"

    def __init__(self, plugin_name: str, plugin_dir: Path, name: str) -> None:
        if "/" in name or not name:
            raise DotsyncError(f"{plugin_name}: invalid syncable name {name!r}")
        self.plugin_name = plugin_name
        self.plugin_dir = plugin_dir
        self.name = name

    @property
    def selector(self) -> str:
        return f"./{self.plugin_name}/{self.name}"

    @property
    def state_path(self) -> Path:
        return STATE_ROOT / "syncables" / self.plugin_name / f"{self.name}.json"

    def config_dto(self) -> dict[str, Any]:
        raise NotImplementedError

    def device_dto(self) -> dict[str, Any]:
        raise NotImplementedError

    def apply_config(self) -> None:
        raise NotImplementedError

    def load_state(self) -> dict[str, Any] | None:
        try:
            with self.state_path.open("r", encoding="utf-8") as f:
                return json.load(f)
        except FileNotFoundError:
            return None

    def save_state(self, dto: dict[str, Any]) -> None:
        self.state_path.parent.mkdir(parents=True, exist_ok=True)
        with self.state_path.open("w", encoding="utf-8") as f:
            json.dump(dto, f, indent=2, sort_keys=True)
            f.write("\n")

    def status(self) -> Status:
        config = self.config_dto()
        device = self.device_dto()
        state = self.load_state()
        lines = [f"{self.selector}: {self.kind}"]

        if same_dto(state, config) and same_dto(state, device):
            lines.append("  ok: state, config, and device match")
            return Status(self.selector, True, lines)

        ok = True
        if state is None:
            ok = False
            lines.append("  state: missing")
        if not same_dto(state, config):
            ok = False
            lines.append("  state != config")
            diff = unified("state", state, "config", config)
            if diff:
                lines.extend(f"    {line}" for line in diff.splitlines())
        if not same_dto(state, device):
            ok = False
            lines.append("  state != device")
            diff = unified("state", state, "device", device)
            if diff:
                lines.extend(f"    {line}" for line in diff.splitlines())
        if config != device:
            ok = False
            lines.append("  config != device")
            diff = unified("config", config, "device", device)
            if diff:
                lines.extend(f"    {line}" for line in diff.splitlines())
        return Status(self.selector, ok, lines)

    def apply(self, force: bool) -> list[str]:
        config = self.config_dto()
        device = self.device_dto()
        state = self.load_state()

        if state is None:
            if device.get("exists") and device != config and not force:
                raise DotsyncError(
                    f"{self.selector}: device has unmanaged state; use apply --force to overwrite"
                )
        elif device != state and not force:
            raise DotsyncError(
                f"{self.selector}: device differs from last applied state; use apply --force to overwrite"
            )

        self.apply_config()
        after = self.device_dto()
        if after != config:
            raise DotsyncError(f"{self.selector}: apply finished but device DTO still differs")
        self.save_state(after)
        return [f"{self.selector}: applied"]
