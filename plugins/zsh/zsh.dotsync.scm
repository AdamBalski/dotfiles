; Generic zsh config. Work-specific shell additions live outside the repo at
; ~/work/work.zshrc are sourced conditionally by this file.
(git-repo
  (name "oh-my-zsh")
  (repo "https://github.com/ohmyzsh/ohmyzsh.git")
  (target "~/.oh-my-zsh")
  (branch "master"))

(file
  (name "config")
  (source "zshrc")
  (target "~/.zshrc"))
