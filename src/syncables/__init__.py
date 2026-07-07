from __future__ import annotations

from pathlib import Path
from typing import Any, Callable

from ..errors import DotsyncError
from .base import Syncable
from .files import DirSyncable, FileSyncable, FontFileSyncable
from .homebrew import BrewCaskSyncable, BrewCommandSyncable, BrewPackageSyncable, HomebrewSyncable


SyncableFactory = Callable[[str, Path, list[Any], Path], Syncable]
SYNCABLE_TYPES: dict[str, SyncableFactory] = {}


def register_syncable_type(kind: str) -> Callable[[type[Syncable]], type[Syncable]]:
    def decorate(cls: type[Syncable]) -> type[Syncable]:
        factory = getattr(cls, "from_form", None)
        if factory is None:
            raise DotsyncError(f"{cls.__name__}: missing from_form")
        SYNCABLE_TYPES[kind] = factory
        return cls

    return decorate


register_syncable_type("file")(FileSyncable)
register_syncable_type("dir")(DirSyncable)
register_syncable_type("homebrew")(HomebrewSyncable)
register_syncable_type("brew-package")(BrewPackageSyncable)
register_syncable_type("brew-cask")(BrewCaskSyncable)
register_syncable_type("brew-command")(BrewCommandSyncable)
register_syncable_type("font-file")(FontFileSyncable)
