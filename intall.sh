#!/bin/bash

DOTS_ROOT="$HOME/Documents/Programming/Settings/dotfiltes"

# Install VS Code

VS_CODE_ENTRIES=$(dpkg -l | grep ii | awk '{print $2}' | egrep '^code$')

if [[ -z $VS_CODE_ENTRIES ]]; then
    # Install VSCode. Requires `sudo`
    # Code is taken from https://code.visualstudio.com/docs/setup/linux
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt-get install apt-transport-https
    sudo apt-get update
    sudo apt-get install code
fi

cat $DOTS_ROOT/vscode/extensions.txt | xargs -n 1 code --install-extension --force

ln -s $DOTS_ROOT/vscode/settings.json $HOME/.config/Code/User/settings.json

rm packages.microsoft.gpg

# Setup links

ln -s $DOTS_ROOT/.bashrc ~/.bashrc

ln -s $DOTS_ROOT/.bash_profile ~/.bash_profile

ln -s $DOTS_ROOT/.vimrc ~/.vimrc

ln -s $DOTS_ROOT/.vim ~/.vim

ln -s $DOTS_ROOT/.gitconfig ~/.gitconfig

ln -s $DOTS_ROOT/.tmux.conf ~/.tmux.conf

ln -s $DOTS_ROOT/.jupyter ~/.jupyter

ln -s $DOTS_ROOT/.docker/.bash_history ~/.docker_bash_history

ln -s $DOTS_ROOT/.docker/.bash_history ~/.docker_bash_history

ln -s $DOTS_ROOT/.docker/d ~/d
