#!/usr/bin/env bash
set -euo pipefail

repo_url="${DOTSYNC_REPO_URL:-https://github.com/AdamBalski/dotfiles.git}"
install_dir="${DOTSYNC_INSTALL_DIR:-$HOME/dotfiles}"
bin_dir="${DOTSYNC_BIN_DIR:-$HOME/.local/bin}"
branch="${DOTSYNC_BRANCH:-master}"

if ! command -v git >/dev/null 2>&1; then
  echo "dotsync install: git is required" >&2
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "dotsync install: python3 is required" >&2
  exit 1
fi

if [ -d "$install_dir/.git" ]; then
  git -C "$install_dir" fetch origin "$branch"
  git -C "$install_dir" checkout "$branch"
  git -C "$install_dir" pull --ff-only origin "$branch"
elif [ -e "$install_dir" ]; then
  echo "dotsync install: $install_dir exists and is not a git checkout" >&2
  exit 1
else
  git clone --branch "$branch" "$repo_url" "$install_dir"
fi

chmod +x "$install_dir/dotsync"
mkdir -p "$bin_dir"

target="$bin_dir/dotsync"
if [ -e "$target" ] && [ ! -L "$target" ]; then
  echo "dotsync install: $target exists and is not a symlink" >&2
  exit 1
fi

ln -sfn "$install_dir/dotsync" "$target"

echo "dotsync installed at $target"
echo "Run: dotsync help"
