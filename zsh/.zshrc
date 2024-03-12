# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
# plug "zap-zsh/zap-prompt"
plug "romkatv/powerlevel10k"
plug "zsh-users/zsh-syntax-highlighting"
plug "zap-zsh/vim"

# Load and initialise completion system
autoload -Uz compinit
compinit

# Neovim version manager
export PATH="$HOME/.local/share/bob/nvim-bin":$PATH

export PATH=$PATH:/usr/local/go/bin # go
export PATH=$PATH:/home/drew/go/bin # Needed to run 'godoc'. 'go install' puts binaries here. 

# 'git commit' opened nano in a neovim :term buffer, which was suprising.
export GIT_EDITOR="nvim"

# Accept zsh-autosuggestions
bindkey '^Y' autosuggest-accept

# # numbered workspaces for PopOS
# gsettings set org.gnome.mutter dynamic-workspaces false
# gsettings set org.gnome.desktop.wm.preferences num-workspaces 9
# for i in {1..9} 
# do
#   gsettings set "org.gnome.shell.keybindings" "switch-to-application-$i" "[]"
#   gsettings set "org.gnome.desktop.wm.keybindings" "switch-to-workspace-$i" "['<Super>${i}']"
#   gsettings set "org.gnome.desktop.wm.keybindings" "move-to-workspace-$i" "['<Super><Shift>${i}']"
# done

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
