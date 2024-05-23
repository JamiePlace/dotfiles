# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
# Path to xdg_config_home
#export XDG_CONFIG_HOME="$Home/.config/"
export PTPYTHON_CONFIG_HOME="$HOME/.config/ptpython/"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="prompt pure"
autoload -U promptinit; promptinit
prompt pure

plugins=(git)

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# environment variables
export AWS_DEFAULT_PROFILE="thq-llm-dev"
export APPLE_SSH_ADD_BEHAVIOR="macos"


# set ssh keys
ssh-add -K ~/.ssh/id_ed25519 > /dev/null 2>&1
ssh-add -K ~/.ssh/id_rsa > /dev/null 2>&1


# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias r="radian"

alias activate="source .venv/bin/activate"
alias python="python3"
alias pip="pip3"
alias cd="z"
alias ls="eza"
alias csv="csvlens"
alias light="lua $HOME/.config/tools/light_mode.lua"
alias gclean="git branch -v | grep '\[gone\]' | awk '{print $1}'|xargs -I{} git branch -D {}"
#alias ptpython="ptpython --config-file $PTPYTHON_CONFIG_HOME"

eval "$(zoxide init zsh)"
# lazy git alias
alias lg="lazygit"
# fuzzy finding change dir
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# yazi
ya() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

