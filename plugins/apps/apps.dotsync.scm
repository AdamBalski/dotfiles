; General applications and command-line tools.

(brew-cask
  (name "mactex-no-gui")
  (cask "mactex-no-gui"))

(brew-cask
  (name "pinta")
  (cask "pinta"))

(brew-package
  (name "autossh"))

(brew-command
  (name "ssh")
  (package "openssh")
  (command "ssh"))

(brew-package
  (name "jq"))

(brew-package
  (name "sshuttle"))

(brew-package
  (name "sponge"))

(brew-command
  (name "npm")
  (package "node")
  (command "npm"))

(brew-package
  (name "node"))

(brew-command
  (name "npx")
  (package "node")
  (command "npx"))

(brew-command
  (name "python3")
  (package "python@3.14")
  (command "python3"))

(brew-package
  (name "openvpn"))

(brew-package
  (name "mpv"))

(brew-package
  (name "plantuml"))

(brew-package
  (name "tree"))
