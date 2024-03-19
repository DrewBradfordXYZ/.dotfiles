# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# source ~/.zsh_profile

bindkey '^y' autosuggest-accept

export XDG_CONFIG_HOME=$HOME/.config

source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

#export PATH="$HOME/.config":$PATH

export SCRIPTS="$HOME/.local/bin"
export PATH="$SCRIPTS":$PATH
# Neovim version manager
export BOB_INSTALL="$HOME/.local/share/bob/nvim-bin"
export PATH="$BOB_INSTALL":$PATH

# Go command
export GO_CMD="/usr/local/go/bin"
export PATH=$PATH:"$GO_CMD" # go
# Go path
export GO_PATH="$HOME/go/bin"
export PATH=$PATH:"$GOPATH" 

# Node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export GIT_EDITOR="nvim"

bindkey -s ^f "tmux-sessionizer\n"
bindkey -s ^g "fzf-dotfiles\n"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source ~/powerlevel10k/powerlevel10k.zsh-theme
