from __future__ import annotations

from pathlib import Path
from typing import Any

from .errors import DotsyncError


class Symbol(str):
    pass


class QuotedString(str):
    pass


def tokenize(source: str, file_name: Path) -> list[Any]:
    tokens: list[Any] = []
    i = 0

    while i < len(source):
        ch = source[i]
        if ch.isspace():
            i += 1
            continue
        if ch == ";":
            while i < len(source) and source[i] != "\n":
                i += 1
            continue
        if ch in "()":
            tokens.append(ch)
            i += 1
            continue
        if ch == '"':
            i += 1
            value: list[str] = []
            while i < len(source):
                ch = source[i]
                if ch == '"':
                    i += 1
                    tokens.append(QuotedString("".join(value)))
                    break
                if ch == "\\":
                    i += 1
                    if i >= len(source):
                        raise DotsyncError(f"{file_name}: unterminated string escape")
                    escapes = {"n": "\n", "t": "\t", "r": "\r", '"': '"', "\\": "\\"}
                    value.append(escapes.get(source[i], source[i]))
                    i += 1
                    continue
                value.append(ch)
                i += 1
            else:
                raise DotsyncError(f"{file_name}: unterminated string")
            continue

        start = i
        while i < len(source) and not source[i].isspace() and source[i] not in "();":
            i += 1
        tokens.append(Symbol(source[start:i]))

    return tokens


def parse_many(source: str, file_name: Path) -> list[Any]:
    tokens = tokenize(source, file_name)
    pos = 0

    def parse_one() -> Any:
        nonlocal pos
        if pos >= len(tokens):
            raise DotsyncError(f"{file_name}: unexpected end of input")
        token = tokens[pos]
        pos += 1
        if token == "(":
            values = []
            while pos < len(tokens) and tokens[pos] != ")":
                values.append(parse_one())
            if pos >= len(tokens):
                raise DotsyncError(f"{file_name}: missing ')'")
            pos += 1
            return values
        if token == ")":
            raise DotsyncError(f"{file_name}: unexpected ')'")
        return token

    forms = []
    while pos < len(tokens):
        forms.append(parse_one())
    return forms


def as_string(value: Any, file_name: Path, key: str) -> str:
    if isinstance(value, (Symbol, QuotedString)):
        return str(value)
    raise DotsyncError(f"{file_name}: {key} must be a string or symbol")


def form_options(form: list[Any], file_name: Path) -> dict[str, Any]:
    result: dict[str, Any] = {}
    for item in form[1:]:
        if not isinstance(item, list) or not item:
            raise DotsyncError(f"{file_name}: options must be lists")
        key = as_string(item[0], file_name, "option key")
        if len(item) == 2:
            result[key] = item[1]
        else:
            result[key] = item[1:]
    return result


def resolve_path(plugin_dir: Path, value: str) -> Path:
    if value.startswith("~"):
        return Path(value).expanduser()
    path = Path(value)
    if path.is_absolute():
        return path
    return plugin_dir / path


def as_bool(value: Any, file_name: Path, key: str) -> bool:
    text = as_string(value, file_name, key).lower()
    if text in ("true", "yes", "on", "1"):
        return True
    if text in ("false", "no", "off", "0"):
        return False
    raise DotsyncError(f"{file_name}: {key} must be true or false")


def optional_bool(opts: dict[str, Any], file_name: Path, key: str, default: bool) -> bool:
    if key not in opts:
        return default
    return as_bool(opts[key], file_name, key)


def optional_strings(opts: dict[str, Any], file_name: Path, key: str) -> list[str]:
    if key not in opts:
        return []
    value = opts[key]
    if isinstance(value, list):
        return [as_string(item, file_name, key) for item in value]
    return [as_string(value, file_name, key)]
