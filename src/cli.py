from __future__ import annotations

import sys

from .errors import DotsyncError
from .paths import PLUGINS_ROOT, STATE_ROOT
from .plugin import Plugin, discover_plugins, parse_selector
from .syncables.base import Status


def usage() -> str:
    return f"""dotsync

Usage:
  dotsync help
  dotsync ls
  dotsync <syncable> <op> [--force]

Syncables:
  .                         Entire device: every enabled plugin
  ./<plugin>                One plugin
  ./<plugin>/<syncable>     One syncable inside a plugin

Ops:
  ls                        List plugins and whether they are enabled
  status                    Show state/config/device drift
  apply                     Apply config DTO to the device
  apply --force             Apply even when device drift is detected
  on                        Force-apply a plugin, then enable it
  off                       Disable a plugin

State:
  {STATE_ROOT}

Plugin files:
  {PLUGINS_ROOT}/<plugin>/*.dotsync.scm
"""


def print_statuses(statuses: list[Status]) -> int:
    exit_code = 0
    for status in statuses:
        print("\n".join(status.lines))
        if not status.ok:
            exit_code = 1
    return exit_code


def device_status(plugins: dict[str, Plugin]) -> int:
    statuses: list[Status] = []
    for item in plugins.values():
        statuses.extend(item.status(include_disabled=False))
    return print_statuses(statuses)


def device_apply(plugins: dict[str, Plugin], force: bool) -> int:
    lines: list[str] = []
    for item in plugins.values():
        lines.extend(item.apply(force))
    print("\n".join(lines))
    return 0


def list_plugins() -> int:
    for plugin in discover_plugins().values():
        state = "on " if plugin.enabled() else "off"
        print(f"{state} {plugin.selector}")
    return 0


def run(selector: str, op: str, force: bool) -> int:
    plugins = discover_plugins()
    target_kind, plugin, syncable = parse_selector(selector, plugins)

    if op in ("on", "off"):
        if target_kind != "plugin" or plugin is None:
            raise DotsyncError(f"{op}: only plugins can be turned on or off")
        if op == "on":
            print("\n".join(plugin.turn_on()))
        else:
            print("\n".join(plugin.set_enabled(False)))
        return 0

    if op == "status":
        if target_kind == "device":
            return device_status(plugins)
        if target_kind == "plugin" and plugin is not None:
            return print_statuses(plugin.status(include_disabled=True))
        if target_kind == "syncable" and syncable is not None:
            return print_statuses([syncable.status()])

    if op == "apply":
        if target_kind == "device":
            return device_apply(plugins, force)
        if target_kind == "plugin" and plugin is not None:
            print("\n".join(plugin.apply(force)))
            return 0
        if target_kind == "syncable" and syncable is not None:
            print("\n".join(syncable.apply(force)))
            return 0

    raise DotsyncError(f"{op}: unknown op")


def main(argv: list[str] | None = None) -> int:
    if argv is None:
        argv = sys.argv[1:]
    if not argv or argv == ["help"] or argv == ["--help"] or argv == ["-h"]:
        print(usage())
        return 0
    if argv == ["ls"]:
        return list_plugins()

    force = False
    clean_args = []
    for arg in argv:
        if arg == "--force":
            force = True
        else:
            clean_args.append(arg)

    if len(clean_args) != 2:
        raise DotsyncError("expected: dotsync <syncable> <op> [--force]")
    return run(clean_args[0], clean_args[1], force)


def entrypoint() -> None:
    try:
        raise SystemExit(main())
    except DotsyncError as e:
        print(f"dotsync: {e}", file=sys.stderr)
        raise SystemExit(2)
