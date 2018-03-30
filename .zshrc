[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ ' && return

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit -i

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="robbyrussell"
# ZSH_THEME="geometry"
# ZSH_THEME="spaceship"
# ZSH_THEME="muse"
ZSH_THEME="bira"
# bira refined
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

DISABLE_UPDATE_PROMPT=true

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="dd/mm/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git npm node osx zsh-syntax-highlighting)

# User configuration

export PATH="/usr/local/mysql/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin"
# export MANPATH="/usr/local/man:$MANPATH"
export GOPATH="$HOME/go"
export PATH="$HOME/bin:$HOME/.local/bin:$PATH:$GOROOT/bin:$GOPATH/bin"

xset r rate 200 35
source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

export EDITOR='emacs -q'

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias ttop='top -s1 -o cpu -R -F'
alias ll='ls -lah'
alias lock='gnome-screensaver-command -l'
alias pd='printDir'
alias less='less -Nij5'
alias dud='du -hd 1'

findContent() {
    echo $1
    find . -type f -not -path "*/.git/*" -not -path "*/node_modules/*" -not -path "*/build/*" -exec grep --color -nH -e $1 {} +
}
alias ff=findContent

pushd()
{
  if [ $# -eq 0 ]; then
    DIR="${HOME}"
  else
    DIR="$1"
  fi

  builtin pushd "${DIR}" > /dev/null
  echo -n "DIRSTACK: "
  dirs
}

pushd_builtin()
{
  builtin pushd > /dev/null
  echo -n "DIRSTACK: "
  dirs
}

popd()
{
  builtin popd > /dev/null
  echo -n "DIRSTACK: "
  dirs
}

alias cd='pushd'
alias b='popd'
alias flip='pushd_builtin'

alias gspa='git stash && git pull && git stash apply'


# Change the keyboard layout and reload xmodmap
kmap() {
    setxkbmap -layout $1 && xmodmap ~/.Xmodmap
}

# Change the keyboard layout and reload xmodmap (planck)
kmapp() {
    setxkbmap -layout $1 && xmodmap ~/.Xmodmap-empty
}

docker_bp () {
    echo $1
    docker build -t briteback/$1 . --squash && docker push briteback/$1
}
alias dockerbp='docker_bp'

# This will clear the dir stack
alias cl='dirs -c'

#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "~/.gvm/bin/gvm-init.sh" ]] && source "~/.gvm/bin/gvm-init.sh"
###-begin-pm2-completion-###
### credits to npm for the completion file model
#
# Installation: pm2 completion >> ~/.bashrc  (or ~/.zshrc)
#

COMP_WORDBREAKS=${COMP_WORDBREAKS/=/}
COMP_WORDBREAKS=${COMP_WORDBREAKS/@/}
export COMP_WORDBREAKS

if type complete &>/dev/null; then
  _pm2_completion () {
    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$COMP_CWORD" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           pm2 completion -- "${COMP_WORDS[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
  }
  complete -o default -F _pm2_completion pm2
elif type compctl &>/dev/null; then
  _pm2_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       pm2 completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _pm2_completion + -f + pm2
fi
###-end-pm2-completion-###
