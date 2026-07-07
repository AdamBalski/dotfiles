; iTerm2 preferences plist.
; The source is kept next to this plugin config as a binary plist snapshot.
(brew-cask
  (name "app")
  (cask "iterm2"))

(macos-plist
  (name "preferences")
  (domain "com.googlecode.iterm2")
  (source "com.googlecode.iterm2.plist")
  (target "~/Library/Preferences/com.googlecode.iterm2.plist"))
