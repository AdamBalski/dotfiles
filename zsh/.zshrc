# Path to your oh-my-zsh installation.
export ZSH="/home/adambalski/.oh-my-zsh"

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
plugins=(git tmux vi-mode)

source $ZSH/oh-my-zsh.sh

### Tmux
#export ZSH_TMUX_AUTOSTART=true


### History
HISTSIZE=10000
SAVEHIST=10000

### Aliases
# pygmentize
alias ccat="pygmentize -g -O style='native'"

# ls
alias l="ls -la"
alias la="ls -a"
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
alias gitcheck="git checkout"
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

# Docker
alias docker="sudo docker"

# Doesn't match any category
alias processes="ps -aux | grep"


### Filetype(suffix) aliases

alias -s pdf=xreader
alias -s {jpg,jpeg,png,ico}=pix
alias -s {md,properties}=vim
alias -s {odt,docx,doc}=libreoffice
alias -s {html,css,js,py,java}=vim


### Exports

# $JAVA_HOME
export JAVA_HOME=/home/adambalski/.jdks/openjdk-14.0.2

# $PATH           ########### APPS ########## #### MY BINS ######## #### JAVA ##### ###################### NODE #######################
export PATH=$PATH:/home/adambalski/.apps/bin/:/home/adambalski/bin/:$JAVA_HOME/bin/:/home/adambalski/.apps/node-v12.18.3-linux-x64/bin/
