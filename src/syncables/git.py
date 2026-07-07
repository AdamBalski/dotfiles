from __future__ import annotations

import subprocess
from pathlib import Path
from typing import Any

from ..errors import DotsyncError
from ..parser import Symbol, as_string, form_options, resolve_path
from .base import Syncable


def run_git(args: list[str], action: str) -> str:
    result = subprocess.run(["git", *args], text=True, capture_output=True)
    if result.returncode == 0:
        return result.stdout.strip()

    details = []
    if result.stdout.strip():
        details.append(result.stdout.strip())
    if result.stderr.strip():
        details.append(result.stderr.strip())
    suffix = ""
    if details:
        suffix = ":\n" + "\n".join(details)
    raise DotsyncError(f"{action} failed with exit code {result.returncode}{suffix}")


def git_output(args: list[str]) -> str | None:
    try:
        result = subprocess.run(["git", *args], text=True, capture_output=True)
    except FileNotFoundError:
        return None
    if result.returncode != 0:
        return None
    return result.stdout.strip()


class GitRepoSyncable(Syncable):
    kind = "git-repo"

    def __init__(self, plugin_name: str, plugin_dir: Path, name: str, repo: str, target: Path, branch: str) -> None:
        super().__init__(plugin_name, plugin_dir, name)
        self.repo = repo
        self.target = target
        self.branch = branch

    @classmethod
    def from_form(cls, plugin_name: str, plugin_dir: Path, form: list[Any], file_name: Path) -> "GitRepoSyncable":
        opts = form_options(form, file_name)
        for required in ("name", "repo", "target"):
            if required not in opts:
                raise DotsyncError(f"{file_name}: git-repo syncable requires ({required} ...)")
        name = as_string(opts["name"], file_name, "name")
        repo = as_string(opts["repo"], file_name, "repo")
        target = resolve_path(plugin_dir, as_string(opts["target"], file_name, "target"))
        branch = as_string(opts.get("branch", Symbol("master")), file_name, "branch")
        return cls(plugin_name, plugin_dir, name, repo, target, branch)

    def config_dto(self) -> dict[str, Any]:
        return {
            "kind": self.kind,
            "target": str(self.target),
            "exists": True,
            "repo": self.repo,
            "branch": self.branch,
        }

    def device_dto(self) -> dict[str, Any]:
        if not self.target.exists():
            return {
                "kind": self.kind,
                "target": str(self.target),
                "exists": False,
            }
        if not (self.target / ".git").exists():
            return {
                "kind": self.kind,
                "target": str(self.target),
                "exists": True,
                "git": False,
            }
        repo = git_output(["-C", str(self.target), "remote", "get-url", "origin"])
        branch = git_output(["-C", str(self.target), "branch", "--show-current"])
        return {
            "kind": self.kind,
            "target": str(self.target),
            "exists": True,
            "repo": repo,
            "branch": branch,
        }

    def apply_config(self) -> None:
        if git_output(["--version"]) is None:
            raise DotsyncError(f"{self.selector}: git is required")

        if not self.target.exists():
            self.target.parent.mkdir(parents=True, exist_ok=True)
            run_git(
                ["clone", "--branch", self.branch, "--depth", "1", self.repo, str(self.target)],
                f"git clone {self.repo}",
            )
            return

        if not (self.target / ".git").exists():
            raise DotsyncError(f"{self.selector}: {self.target} exists but is not a git checkout")

        current_repo = git_output(["-C", str(self.target), "remote", "get-url", "origin"])
        if current_repo != self.repo:
            raise DotsyncError(
                f"{self.selector}: {self.target} has remote {current_repo!r}, expected {self.repo!r}"
            )

        current_branch = git_output(["-C", str(self.target), "branch", "--show-current"])
        if current_branch != self.branch:
            run_git(["-C", str(self.target), "checkout", self.branch], f"git checkout {self.branch}")
