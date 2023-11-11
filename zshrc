# Path to your oh-my-zsh installation.
export ZSH="/home/$USER/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"


# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)


# Homebrew's completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
  compinit
fi

source $ZSH/oh-my-zsh.sh

### Tmux
#export ZSH_TMUX_AUTOSTART=true


### History
HISTSIZE=10000
SAVEHIST=10000

### Aliases
# check for files without javadoc in a java project
alias javadocs-check="grep -Rc "/\*\*" src/main/java | grep:0"

# pygmentize
alias ccat="pygmentize -g -O style='native'"

# ls
alias l="ls -lA"
alias la="ls -A"
alias ll="ls -l"

# Python
alias pyt="python3"
alias py="python3"
alias p="python3"

# Git
alias gits="git status"
alias gita="git add"
alias gitaa="git add ."
alias gitl="git --no-pager log --oneline -n 20"   
alias gitm="git merge"
alias gitch="git checkout"
alias gitb="git branch"
alias gitf="git fetch"
alias gitpu="git push"
alias gitp="git pull"
alias gitc="git commit"
alias gitcm="git commit -m"
alias gitd="git diff"
alias gitbl="git blame"

# Vim
alias vim="nvim"
alias vi="nvim"

# Doesn't match any category
alias \:q="exit"
alias processes="ps -aux | grep"
alias sizeof="du -ha --max-depth=0"

# Taurus(FIIS faculty's server (AGH UST))  healthcheck
alias taurus-check="nmap -p 22 taurus.fis.agh.edu.pl"


### Filetype(suffix) aliases

alias -s pdf=xreader
alias -s {jpg,jpeg,png,ico}=pix
alias -s {md,properties}=vim
alias -s {odt,docx,doc}=libreoffice
alias -s {tex,latex,md,xml,html,css,js,py,java}=vim


### Exports

# $PATH           #### MY BINS ########
brewpath=/home/linuxbrew/.linuxbrew/bin
userbins=/home/$user/.apps/bin:/home/$user/bin
export PATH=$PATH:$brewpath:$userbins
