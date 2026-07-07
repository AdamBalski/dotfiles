; Global Git configuration and tools referenced by that config.
(brew-package
  (name "package")
  (package "git"))

(brew-package
  (name "delta")
  (package "git-delta"))

(brew-package
  (name "lfs")
  (package "git-lfs"))

(file
  (name "config")
  (source "gitconfig")
  (target "~/.gitconfig"))

(file
  (name "ignore")
  (source "ignore")
  (target "~/.config/git/ignore"))
