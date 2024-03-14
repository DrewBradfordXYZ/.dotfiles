# 9.dotfiles

## Installation

### Install 'stow' for (Pop!_OS/Ubuntu)
```bash
sudo apt update
sudo apt install stow
```
### Download this repository.
```bash
# NOTE: Create the .dotfiles directory in your $HOME directory. 
# 'echo $HOME' to find the home path.
# 'home/user/.dotfiles' is what we are looking for. 'user' is your username.
# Putting this in your home directory is important because
#  'stow' symlinks files to a target-directory.
# When you put .dotfiles in your home directory
#  the home directory becomes the target-directory.
cd ~
git clone git@github.com:DrewBradfordXYZ/dotfiles.git .dotfiles
```

### Run 'stow' to symlink dotfiles onto your machine.
```bash
# Enter the .dotfiles directory
cd ~/.dotfiles

# NOTE: The first set of subdirectories in ~/.dotfiles are *special* for 'stow'. 
# 'stow' calles these special subdirectories *packages*.
# Each of these packages imitate the home directory structure.
# Packages can be thought of as a named-proxy instance of the home directory
#  that hold the dotfiles for a specific application or configuration.
# For example: nvim/.config/nvim will symlink to $HOME/.config/nvim.
# The nvim/ package is a proxy for $HOME/ in this case.

# Run 'stow' on these package subdirectories to 
#  symlink their file structure and dotfiles to the
#  appropriate place in the target home directory.
# Remember, this works because we placed .dotfile 
#  in the home directory when we cloned the repo. 

# You can copy each package one at a time as you work through the setup process.
# While in the ~/.dotfiles directory, run stow to symlink the desired packages.
stow zsh
stow wezterm
stow git 
stow nvim
stow scripts #Note: The gd script helps navigates this .dotfiles directory. (fzf required)
# ...more

# Tip: stow all subdirectory packages at once
stow */
```
Stow commands
```bash
stow <packagename> # activates symlink
stow -n <packagename> # trial runs or simulates symlink generation
stow -D <packagename> # delete stowed package
stow -R <packagename> # restows package
```

### Install fzf: A command-line fuzzy finder. 
```bash

# Well stdfoo... Double check the intall instructions. I may have missed something.
# Maybe using the package manager wasn't a good idea. Not sure.
#  ¯\_(ツ)_/¯
# Later, I found out I had to source files in .zshrc to get completion and keybindings to work.
# Note to future self:: Fzf and Bash and std commands is something I need to dig into. 
# I wish it was more friendly. Chatgpt struggled to help me with this.

# Check .zshrc for updates:
# source /usr/share/doc/fzf/examples/key-bindings.zsh
# source /usr/share/doc/fzf/examples/completion.zsh

# 'fd' makes 'fzf' much better. 'fd' happened to already be installed with cargo. 
# Add cargo/bin to the path if it is not there already.

# Check .zshrc for updates:
# export PATH="$PATH:/usr/lib/cargo/bin"
# export FZF_DEFAULT_COMMAND="fd --type f"

fzf keybindings:

# I found it difficult to remamp these keybindings. I wishy changeum, maybe learn one day.

CTRL-t	Fuzzy find all files and subdirectories of the working directory, and output the selection to STDOUT.
ALT-c	Fuzzy find all subdirectories of the working directory, and run the command “cd” with the output as argument.
CTRL-r	Fuzzy find through your shell history, and output the selection to STDOUT.

gd  # This is a bash script I wrote to help navigate this .dotfile repository. 
    # It uses fzf to navigate.
    # The bash file is located in the scripts package for stow.
    # Check that the scripts package is 'stow'ed
    # Check that $HOME/.config/scripts is in the $PATH.
    # Why?: I found stow pakages annoying to move around and 'cd' into 
    #  because they have a nested dir structure inorder to imitate the home directory.

```


