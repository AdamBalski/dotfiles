; tmux package and configuration.
(brew-package
  (name "package")
  (package "tmux"))

(file
  (name "config")
  (source "tmux.conf")
  (target "~/.tmux.conf"))
