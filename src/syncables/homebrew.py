from __future__ import annotations

import os
import shutil
import subprocess
from pathlib import Path
from typing import Any

from ..errors import DotsyncError
from ..parser import Symbol, as_string, form_options, optional_bool, optional_strings
from .base import Syncable


_BREW_ITEMS_CACHE: dict[str, set[str]] = {}


def brew_env() -> dict[str, str]:
    env = os.environ.copy()
    env["HOMEBREW_NO_AUTO_UPDATE"] = "1"
    return env


def run_command(args: list[str], action: str) -> None:
    result = subprocess.run(args, text=True, capture_output=True, env=brew_env())
    if result.returncode == 0:
        return

    details = []
    if result.stdout.strip():
        details.append(result.stdout.strip())
    if result.stderr.strip():
        details.append(result.stderr.strip())
    suffix = ""
    if details:
        suffix = ":\n" + "\n".join(details)
    raise DotsyncError(f"{action} failed with exit code {result.returncode}{suffix}")


def find_brew() -> Path | None:
    candidates = [
        shutil.which("brew"),
        "/opt/homebrew/bin/brew",
        "/usr/local/bin/brew",
        str(Path.home() / ".linuxbrew" / "bin" / "brew"),
        "/home/linuxbrew/.linuxbrew/bin/brew",
    ]
    for candidate in candidates:
        if candidate and Path(candidate).is_file():
            return Path(candidate)
    return None


def install_homebrew() -> None:
    env = brew_env()
    env["NONINTERACTIVE"] = "1"
    script = (
        'NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL '
        'https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    )
    result = subprocess.run(["/bin/bash", "-c", script], text=True, capture_output=True, env=env)
    if result.returncode != 0:
        details = []
        if result.stdout.strip():
            details.append(result.stdout.strip())
        if result.stderr.strip():
            details.append(result.stderr.strip())
        suffix = ""
        if details:
            suffix = ":\n" + "\n".join(details)
        raise DotsyncError(f"homebrew install failed with exit code {result.returncode}{suffix}")


def ensure_brew() -> Path:
    brew = find_brew()
    if brew is not None:
        return brew
    install_homebrew()
    brew = find_brew()
    if brew is None:
        raise DotsyncError("homebrew install completed, but brew was not found on PATH or standard locations")
    return brew


def invalidate_brew_cache() -> None:
    _BREW_ITEMS_CACHE.clear()


def brew_items(list_flag: str) -> set[str]:
    if list_flag in _BREW_ITEMS_CACHE:
        return _BREW_ITEMS_CACHE[list_flag]
    brew = find_brew()
    if brew is None:
        return set()
    result = subprocess.run(
        [str(brew), "list", list_flag],
        text=True,
        capture_output=True,
        env=brew_env(),
    )
    if result.returncode != 0:
        return set()
    items = set(result.stdout.split())
    _BREW_ITEMS_CACHE[list_flag] = items
    return items


def brew_item_installed(list_flag: str, name: str) -> bool:
    return name in brew_items(list_flag)


class HomebrewSyncable(Syncable):
    kind = "homebrew"

    def __init__(self, plugin_name: str, plugin_dir: Path, name: str, installed: bool) -> None:
        super().__init__(plugin_name, plugin_dir, name)
        self.installed = installed

    @classmethod
    def from_form(cls, plugin_name: str, plugin_dir: Path, form: list[Any], file_name: Path) -> "HomebrewSyncable":
        opts = form_options(form, file_name)
        name = as_string(opts.get("name", Symbol("homebrew")), file_name, "name")
        installed = optional_bool(opts, file_name, "installed", True)
        return cls(plugin_name, plugin_dir, name, installed)

    def config_dto(self) -> dict[str, Any]:
        return {
            "kind": self.kind,
            "name": self.name,
            "installed": self.installed,
        }

    def device_dto(self) -> dict[str, Any]:
        return {
            "kind": self.kind,
            "name": self.name,
            "installed": find_brew() is not None,
        }

    def apply_config(self) -> None:
        if self.installed:
            ensure_brew()
            return
        brew = find_brew()
        if brew is not None:
            raise DotsyncError(f"{self.selector}: uninstalling Homebrew is intentionally unsupported")


class BrewPackageSyncable(Syncable):
    kind = "brew-package"
    list_flag = "--formula"
    install_args: tuple[str, ...] = ()
    uninstall_args: tuple[str, ...] = ()
    package_option = "package"

    def __init__(self, plugin_name: str, plugin_dir: Path, name: str, package: str, installed: bool) -> None:
        super().__init__(plugin_name, plugin_dir, name)
        self.package = package
        self.installed = installed

    @classmethod
    def from_form(cls, plugin_name: str, plugin_dir: Path, form: list[Any], file_name: Path) -> "BrewPackageSyncable":
        opts = form_options(form, file_name)
        if "name" not in opts:
            raise DotsyncError(f"{file_name}: {cls.kind} syncable requires (name ...)")
        name = as_string(opts["name"], file_name, "name")
        package = as_string(opts.get(cls.package_option, Symbol(name)), file_name, cls.package_option)
        installed = optional_bool(opts, file_name, "installed", True)
        return cls(plugin_name, plugin_dir, name, package, installed)

    def config_dto(self) -> dict[str, Any]:
        return {
            "kind": self.kind,
            "name": self.package,
            "installed": self.installed,
        }

    def device_dto(self) -> dict[str, Any]:
        return {
            "kind": self.kind,
            "name": self.package,
            "installed": brew_item_installed(self.list_flag, self.package),
        }

    def apply_config(self) -> None:
        brew = ensure_brew()
        installed = brew_item_installed(self.list_flag, self.package)
        if self.installed and not installed:
            run_command([str(brew), "install", *self.install_args, self.package], f"brew install {self.package}")
            invalidate_brew_cache()
        elif not self.installed and installed:
            run_command(
                [str(brew), "uninstall", *self.uninstall_args, self.package],
                f"brew uninstall {self.package}",
            )
            invalidate_brew_cache()


class BrewCaskSyncable(BrewPackageSyncable):
    kind = "brew-cask"
    list_flag = "--cask"
    install_args = ("--cask",)
    uninstall_args = ("--cask",)
    package_option = "cask"


class BrewCommandSyncable(Syncable):
    kind = "brew-command"

    def __init__(
        self,
        plugin_name: str,
        plugin_dir: Path,
        name: str,
        packages: list[str],
        command: str,
        probe_args: list[str],
        installed: bool,
        removable: bool,
    ) -> None:
        super().__init__(plugin_name, plugin_dir, name)
        self.packages = packages
        self.command = command
        self.probe_args = probe_args
        self.installed = installed
        self.removable = removable

    @classmethod
    def from_form(cls, plugin_name: str, plugin_dir: Path, form: list[Any], file_name: Path) -> "BrewCommandSyncable":
        opts = form_options(form, file_name)
        if "name" not in opts:
            raise DotsyncError(f"{file_name}: {cls.kind} syncable requires (name ...)")
        name = as_string(opts["name"], file_name, "name")
        if "packages" in opts:
            packages = optional_strings(opts, file_name, "packages")
        else:
            packages = [as_string(opts.get("package", Symbol(name)), file_name, "package")]
        command = as_string(opts.get("command", Symbol(name)), file_name, "command")
        probe_args = optional_strings(opts, file_name, "probe")
        installed = optional_bool(opts, file_name, "installed", True)
        removable = optional_bool(opts, file_name, "removable", True)
        return cls(plugin_name, plugin_dir, name, packages, command, probe_args, installed, removable)

    def _installed(self) -> bool:
        if self.probe_args:
            try:
                result = subprocess.run(
                    [self.command, *self.probe_args],
                    text=True,
                    capture_output=True,
                    env=brew_env(),
                )
            except FileNotFoundError:
                return False
            return result.returncode == 0
        return shutil.which(self.command) is not None

    def config_dto(self) -> dict[str, Any]:
        dto = {
            "kind": self.kind,
            "name": self.name,
            "packages": self.packages,
            "command": self.command,
            "installed": self.installed,
            "removable": self.removable,
        }
        if self.probe_args:
            dto["probe"] = [self.command, *self.probe_args]
        return dto

    def device_dto(self) -> dict[str, Any]:
        dto = {
            "kind": self.kind,
            "name": self.name,
            "packages": self.packages,
            "command": self.command,
            "installed": self._installed(),
            "removable": self.removable,
        }
        if self.probe_args:
            dto["probe"] = [self.command, *self.probe_args]
        return dto

    def apply_config(self) -> None:
        installed = self._installed()
        if self.installed and not installed:
            brew = ensure_brew()
            for package in self.packages:
                run_command([str(brew), "install", package], f"brew install {package}")
            invalidate_brew_cache()
        elif not self.installed and installed:
            if not self.removable:
                raise DotsyncError(f"{self.selector}: removing {', '.join(self.packages)} is intentionally unsupported")
            brew = ensure_brew()
            for package in reversed(self.packages):
                run_command([str(brew), "uninstall", package], f"brew uninstall {package}")
            invalidate_brew_cache()
