; Neovim package and portable config files.
(brew-package
  (name "package")
  (package "neovim"))

(brew-package
  (name "bash-language-server"))

(file
  (name "init")
  (source "config/init.lua")
  (target "~/.config/nvim/init.lua"))

(file
  (name "plugins")
  (source "config/lua/plugins.lua")
  (target "~/.config/nvim/lua/plugins.lua"))
