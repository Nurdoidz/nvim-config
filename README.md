# nvim-config

This repository holds my dotfiles (confguration) for [Neovim](https://neovim.io/), based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). Neovim is a modal editor based on Vim and allows Lua language support for plugins and configuration.

## Installation

### Windows

First:

- **Optional**: Download and install [Windows Terminal](https://github.com/microsoft/terminal/releases). Windows Terminal is a modern terminal application with support for shells like [PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows), [WSL](https://learn.microsoft.com/en-us/windows/wsl/install), and Command Prompt.
- Set a user-scoped environment variable called `home` to your user home directory (default: `C:\Users\username`). [PowerToys](https://learn.microsoft.com/en-us/windows/powertoys/) is a convenient tool to set environment variables.
- Restart your computer.

**Optional**: Create a symlink from `$env:localappdata\nvim` to another directory (e.g. a directory that holds git repositories) by executing the following command in PowerShell:

```powershell
# Create a symlink for Neovim’s config directory to keep git-tracked files in one location
New-Item -Path $env:localappdata\nvim -ItemType SymbolicLink -Value 'C:\Dev\nvim-config.git'
```

Execute the following commands in PowerShell to install Neovim and dependencies:

```powershell
irm get.scoop.sh | iex # install scoop package manager
git clone git@github.com:nurdoidz/nvim-config.git $env:localappdata\nvim
scoop install neovim
scoop install zig # Neovim dependency
scoop install ripgrep # dependency for some Neovim plugins
scoop install 7zip # dependency for some Neovim plugins
```

Execute the following command in PowerShell to allow unsigned scripts to be executed. This allows Tabnine to build its binaries:

```
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine
```

Finally, launch Neovim either from the start menu or from a shell to install plugins and initialize the dotfiles.

### Mint/Ubuntu

Execute the following commands in terminal (<kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>T</kbd>):

```bash
sudo apt update # update package manager
sudo apt install ripgrep # dependency for some Neovim plugins
sudo apt install unzip # dependency for some Neovim plugins
sudo apt install build-essential # dependency for some Neovim plugins
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage # download app image
./nvim.appimage --appimage-extract # extract app image
sudo mv squashfs-root / # move extracted app image
sudo ln -s /squashfs-root/AppRun /usr/bin/nvim # create symbolic link for Neovim
rm -rf ./nvim.appimage # remove downloaded app image
```

### Windows Subsystem for Linux (WSL)

Download and install [Windows Terminal](https://github.com/microsoft/terminal/releases). Windows Terminal is a modern terminal application with support for shells like [PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows), [WSL](https://learn.microsoft.com/en-us/windows/wsl/install), and Command Prompt.

Install WSL by executing the following command in PowerShell:

```powershell
wsl --install
```

Launch Ubuntu in Windows Terminal and complete Ubuntu’s setup by setting a username and password.

Finally, follow the instructions for Mint/Ubuntu.

## Additional Configuration

### Use Neovim to edit commit messages

This shell script adds Neovim as the global default editor for commit messages and starts it in insert mode:

```bash
git config --global core.editor "nvim -c 'startinsert'"
```
