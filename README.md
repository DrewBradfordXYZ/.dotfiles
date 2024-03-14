# Dotfiles

## Installation

Install stow for (Pop!_OS/Ubuntu)
```bash
sudo apt update
sudo apt install stow
```
Download this repository
```bash
# NOTE: Create the .dotfiles directory in your HOME directory. This is important.
cd ~
git clone git@github.com:DrewBradfordXYZ/dotfiles.git .dotfiles
```

In the downloaded repository, run 'stow' to copy dotfile symlink's into your home directory.
```bash
cd ~/.dotfiles
# NOTE: First-order child directories are "special" in stow. 
# Each of them imitate the home directory.
# Run 'stow' on these directories to symlink their file structure to the home directory.

# You can copy them one at a time as you work through the setup process.
# While in the ~/.dotfiles directory, run stow to symlink the desired packages.
stow zsh
stow wezterm
stow git 
stow nvim
stow scripts #Note: The gd script helps navigates this .dotfiles directory. (fzf required)

# Optional: stow all subdirectories at once
stow */
```
Stow commands
```bash
stow <packagename> # activates symlink
stow -n <packagename> # trial runs or simulates symlink generation. Effective for checking for errors
stow -D <packagename> # delete stowed package
stow -R <packagename> # restows package
```

Install FZF. 
```bash
#fzf is required for the gd script that helps navigate this repository to work.

# Double check the intall instructions... I may have missed something.
# Later, I found out: I had to source files in .zshrc to get completion and keybindings to work.
# See .zshrc.
# source /usr/share/doc/fzf/examples/key-bindings.zsh # ctrl-t, ctrl-r, alt-c
# source /usr/share/doc/fzf/examples/completion.zsh # Context aware auto-completion: nvim **<tab>

# fd makes fzf much better. fd was already installed with cargo. I only needed to add it to my path.
# See .zshrc
# export PATH="$PATH:/usr/lib/cargo/bin"
# export FZF_DEFAULT_COMMAND="fd --type f" # fd ignores directories like .git and uses .gitignore

```


