# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# source zsh plugins
source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# source fzf keybindings
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

# Neovim alias
alias nv="nvim"

# Ctrl-y accepts zsh autosuggestions
bindkey '^y' autosuggest-accept
# Ctrl-f opens sessions in tmux
bindkey -s ^f "tmux-sessionizer\n"
# Ctrl-g select stow .dotfile directories
bindkey -s ^g "fzf-dotfiles\n"

# Nano is another planet
export GIT_EDITOR="nvim"
# Scripts
export SCRIPTS="$HOME/.local/bin"
export PATH="$SCRIPTS":$PATH
# Rust binaries, e.g. fd
export RUST_BIN="usr/lib/cargo/bin"
export PATH=$PATH:"$RUST_BIN"
# Neovim version manager
export NVIM_INSTALL="$HOME/.local/share/bob/nvim-bin"
export PATH="$NVIM_INSTALL":$PATH
# Go command
export GO_CMD="/usr/local/go/bin"
export PATH=$PATH:"$GO_CMD" # go
# Go path
export GO_PATH="$HOME/go/bin"
export PATH=$PATH:"$GO_PATH"

# Node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source ~/powerlevel10k/powerlevel10k.zsh-theme
