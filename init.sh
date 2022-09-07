#!/bin/bash

# Credit for a lot of this goes to https://www.lotharschulz.info/2021/05/11/macos-setup-automation-with-homebrew/

set -euo pipefail

# from ez.pz
function brew_check() {
    if ! which brew >/dev/null; then
        read -n 1 -r -p "You will also need brew. Install brew? [y/n] "
        echo
        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
            /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        else
            echo "Go to https://brew.sh/ to see installation instructions."
            exit 1
        fi
    fi
}
if [ "${BASH_VERSION%%.*}" -lt "4" ]; then
    if [ -n "${RECURSION-}" ]; then
        echo "Unable to correctly restart script with newer bash version."
        exit 1
    fi
    read -n 1 -r -p "You need a minimum bash version of 4.0! Install a newer version? [y/n] "
    echo
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        brew_check
        brew install bash
        hash -r
        export RECURSION="yep"
        exec /usr/bin/env bash $0
    else
        echo "Use \"brew install bash\" to install a newer version."
        exit 1
    fi
fi



# Install XCode
if ! which xcode-select >/dev/null; then
    xcode-select --install
fi

# Set SUDO User to Current User
SUDO_USER=$(whoami)

# Install Homebrew
if test ! "$(which brew)"; then
    /bin/bash -c \
"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

brew upgrade

# CLI Tools
PROD=$(softwareupdate -l | grep "\*.*Command Line" | head -n 1 | awk -F"*" '{print $2}' | sed -e 's/^ *//' | tr -d '\n') || true

if [[ -n "$PROD" ]]; then
  softwareupdate -i "$PROD" --verbose
fi

PACKAGES=(
    gettext
    zsh
)

echo "Installing packages..."
brew install "${PACKAGES[@]}"

CASKS=(
    firefox
    google-chrome
    iterm2
    slack
    visual-studio-code
    zoom
)

echo "Installing cask apps (Firefox, Google Chrome, iTerm2, Slack, Visual Studio Code, Zoom)..."
sudo -u $SUDO_USER brew install --cask "${CASKS[@]}"

cd ~/
git clone https://github.com/nvm-sh/nvm.git .nvm
. ./nvm.sh

cat <<EOF >> ~/.zshrc
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
EOF

source "~/.zshrc"

nvm install 14 # CURRENT NODE VERSION 14 SUPPORTED BY SHSP

# Rancher Desktop
## Download
curl -O ~/Downloads/RancherDesktop.dmg https://github.com/rancher-sandbox/rancher-desktop/releases/download/v1.4.1/Rancher.Desktop-1.4.1.aarch64.dmg
## Mount the .dmg image
sudo hdiutil attach ~/Downloads/RancherDesktop.dmg
## Install the application
cp -R /Volumes/RancherDesktop/RancherDesktop.app /Applications
diskutil unmount /Volumes/RancherDesktop
open /Applications/RancherDesktop.app

}