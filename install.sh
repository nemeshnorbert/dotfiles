#!/bin/bash

# Uncomment for debugging
# set -o pipefail -eux

DOTS_ROOT=$(dirname "$0")

############################################# VS CODE ##############################################

VS_CODE_BIN=$(command -v code)
if [[ -z $VS_CODE_BIN ]]; then
    # Installing VSCode. Requires `sudo`
    # Code is taken from https://code.visualstudio.com/docs/setup/linux
    echo "Installing VS Code"
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > "$DOTS_ROOT/packages.microsoft.gpg"
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt-get install apt-transport-https
    sudo apt-get update
    sudo apt-get install code

    echo "Installing VS code extenstions:"
    VS_CODE_EXTENSIONS="$DOTS_ROOT/vscode/extensions.txt"
    cat "$VS_CODE_EXTENSIONS"
    xargs -n 1 code --install-extension --force < "$VS_CODE_EXTENSIONS"

    VS_CODE_SETTINGS="$HOME/.config/Code/User/settings.json"
    if [[ ! -L "$VS_CODE_SETTINGS" ]]; then
        echo "Setting up $VS_CODE_SETTINGS"
        ln -s "$DOTS_ROOT/vscode/settings.json" "$VS_CODE_SETTINGS"
    else
        echo "Link $VS_CODE_SETTINGS already exists!"
    fi

    rm "$DOTS_ROOT/packages.microsoft.gpg"
else
    echo "VS Code is already installed"
fi

# ############################################# BASH #################################################

BASHRC="$HOME/.bashrc"
if [[ ! -L "$BASHRC" ]]; then
    echo "Setting up $BASHRC"
    ln -s "$DOTS_ROOT/.bashrc" "$BASHRC"
else
    echo "Link $BASHRC already exists!"
fi

BASH_PROFILE="$HOME/.bash_profile"
if [[ ! -L "$BASH_PROFILE" ]]; then
    echo "Setting up $BASH_PROFILE"
    ln -s "$DOTS_ROOT/.bash_profile" "$BASH_PROFILE"
else
    echo "Link $BASH_PROFILE already exists!"
fi

# ############################################# VIM ##################################################

VIM_BIN=$(command -v vim)
if [[ -z "$VIM_BIN" ]]; then
    echo "Installing vim"
    # sudo apt-get install -y vim build-essential cmake python-dev
    VIMRC="$HOME/.vimrc"
    if [[ ! -L "$VIMRC" ]]; then
        echo "Setting up $VIMRC"
        ln -s "$DOTS_ROOT/.vimrc" "$VIMRC"
    else
        echo "Link $VIMRC already exists!"
    fi
    VIM_DIR="$HOME/.vim"
    if [[ ! -L "$VIM_DIR" ]]; then
        echo "Setting up $VIM_DIR"
        ln -s "$DOTS_ROOT/.vim" "$VIM_DIR"
    else
        echo "Directory $VIM_DIR already exists"
    fi
    echo "Installing vim plugins"
    vim +'PlugInstall --sync' +qa

    echo "Installing YouCompleteme vim plugin"
    bash "$DOTS_ROOT/.vim/bundle/YouCompleteMe/install.py"
else
    echo "Vim already installed!"
fi

# ############################################# GIT ##################################################

GITCONFIG="$HOME/.gitconfig"
if [[ ! -L "$GITCONFIG" ]]; then
    echo "Setting up $GITCONFIG"
    ln -s "$DOTS_ROOT/.gitconfig" "$GITCONFIG"
else
    echo "Link $GITCONFIG already exists!"
fi

# ############################################# TMUX #################################################

TMUXCONFIG="$HOME/.tmux.conf"
if [[ ! -L "$TMUXCONFIG" ]]; then
    echo "Setting up $TMUXCONFIG"
    ln -s "$DOTS_ROOT/.tmux.conf" "$TMUXCONFIG"
else
    echo "Link $TMUXCONFIG already exists!"
fi

# ########################################### JUPYTER ################################################

JUPYTER="$HOME/.jupyter"
if [[ ! -L "$JUPYTER" ]]; then
    echo "Setting up $JUPYTER"
    ln -s "$DOTS_ROOT/.jupyter" "$JUPYTER"
else
    echo "Link $JUPYTER already exists"
fi

# ########################################### DOCKER #################################################

DOCKER_BASH_HISTORY="$HOME/.docker_bash_history"
if [[ ! -L "$DOCKER_BASH_HISTORY" ]]; then
    echo "Setting up $DOCKER_BASH_HISTORY"
    touch "$DOTS_ROOT/.docker/.bash_history"
    ln -s "$DOTS_ROOT/.docker/.bash_history" "$DOCKER_BASH_HISTORY"
else
    echo "Link $DOCKER_BASH_HISTORY already exists!"
fi

DOCKER_D="$HOME/d"
if [[ ! -L "$DOCKER_D" ]]; then
    echo "Setting up $DOCKER_D"
    ln -s "$DOTS_ROOT/.docker/d" "$DOCKER_D"
else
    echo "Link $DOCKER_D already exists!"
fi
