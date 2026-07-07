# dotsync

`dotsync` manages this dotfiles checkout through small plugins. Each plugin is a set of
syncables that can report drift, apply repo config to the device, and record applied state in:

```sh
~/.local/state/dotsync-9708c2b7-c09d-4c51-b165-631c1d47a9d0
```

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/AdamBalski/dotfiles/master/install.sh | bash -s --
```

The installer clones or fast-forwards the repo at `$HOME/dotfiles`, then symlinks
`$HOME/.local/bin/dotsync` to the checkout. It does not apply any config.

Overrides:

```sh
curl -fsSL https://raw.githubusercontent.com/AdamBalski/dotfiles/master/install.sh \
  | env DOTSYNC_INSTALL_DIR="$HOME/.dotfiles" DOTSYNC_BIN_DIR="$HOME/bin" bash -s --
```

## Usage

```sh
dotsync help
dotsync ls
dotsync . status
dotsync ./nvim status
dotsync ./nvim apply
dotsync ./nvim apply --force
dotsync ./nvim on
dotsync ./nvim off
```

Selectors:

- `.`: all enabled plugins
- `./<plugin>`: one plugin
- `./<plugin>/<syncable>`: one syncable inside a plugin

`apply` blocks if the device differs from the last applied state. Use `apply --force`
to overwrite the device with the repo config. `on` force-applies the plugin first, then
marks it enabled.
