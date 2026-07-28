# Run the following commands in the current folder as needed
stow --no-folding kitty

stow --no-folding nvim

stow tig


# Oh My Bash
https://github.com/ohmybash/oh-my-bash
The installed bashrc script is to be renamed to ~/.oh-my-bash

Add the following to the .bashrc
```
# OhMyBash
. ~/dotfiles/.bashrc_omb
```


# Agents
Different agent requires different file extension. remember to change the extension when creating
the symlink
- Claude uses .md
- Cursor uses .mdc
