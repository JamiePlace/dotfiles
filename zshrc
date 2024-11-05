# If you come from bash you might have to change your $PATH.
BREW=/home/linuxbrew/.linuxbrew/bin/brew
if [ -x "$BREW" -a -z "$HOMEBREW_PREFIX" ]; then
  PREV_PATH=$PATH
  # brew needs tools like dirname and readlink
  PATH=/usr/bin:$HOME/.cargo/bin
  # this sets PATH, HOMEBREW_PREFIX, HOMEBREW_CELLAR, HOMEBREW_REPOSITORY
  eval "$($BREW shellenv)"
  export PATH=$PREV_PATH${PATH+:$PATH}
fi

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export PTPYTHON_CONFIG_HOME="$HOME/.config/ptpython/"

source $ZSH/oh-my-zsh.sh
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="prompt pure"
#autoload -U promptinit; promptinit
#prompt pure

plugins=(git)


# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# environment variables
export AWS_DEFAULT_PROFILE="thq-llm-dev"
export APPLE_SSH_ADD_BEHAVIOR="macos"




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
alias fvim="fzf | xargs -I{} nvim ./{}"
alias pre="git add . && git commit -m 'pre-commit formatting'"
alias fzg="$HOME/.config/tools/fzgrep.sh"
alias gc="git commit"
alias ga="git add ."

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


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# if on windows then do other stuff
if [[ $(uname) != "Darwin" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    source <(fzf --zsh)
    eval "$(ssh-agent -s)"
fi
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"


# set ssh keys
ssh-add -K $HOME/.ssh/id_ed25519 > /dev/null 2>&1
ssh-add -K $HOME/.ssh/id_rsa > /dev/null 2>&1
ssh-add -K $HOME/.ssh/gitkraken_rsa > /dev/null 2>&1

. "$HOME/.cargo/env"
