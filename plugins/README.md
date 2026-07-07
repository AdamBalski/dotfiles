# dotsync plugin layout

Plugins are flat directories under `plugins/<name>/`.
Each plugin contains one or more `*.dotsync.scm` files and any source files needed by those syncables.

Use plugin names for user-facing areas, not implementation mechanisms:

- `apps`: general apps and command-line tools.
- `brew`: Homebrew itself.
- `fonts`: direct font installs.
- `git`: global git config, global excludes, and git-related CLI packages.
- `iterm`: iTerm2 cask and plist preferences.
- `jetbrains`: portable IntelliJ IDEA settings, excluding caches and workspace state.
- `nvim`: Neovim formula plus portable Lua config files.
- `tmux`: tmux formula and `~/.tmux.conf`.
- `zsh`: `~/.zshrc`, with work-specific config sourced from `~/work/work.zshrc`.

Prefer ordering dependency syncables before dependent config inside the same plugin.
For example, install an app or package before syncing files that the app consumes.
Use `font-file` for direct font installs; it copies the font and touches the Fonts directory
when the file changes so macOS font services notice the update.
