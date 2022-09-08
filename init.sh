#!/bin/bash

# Credit for a lot of this goes to https://www.lotharschulz.info/2021/05/11/macos-setup-automation-with-homebrew/

{
# unofficial bash strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail

# Install XCode
if ! which xcode-select >/dev/null; then
    xcode-select --install
else
    echo "Xcode-Select already installed. Moving on..."
fi

# Install Homebrew
if ! which brew >/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
fi

source /Users/"$(whoami)"/.zprofile

# sanity check, read brew version
brew -v

# CLI Tools
PROD=$(softwareupdate -l | grep "\*.*Command Line" | head -n 1 | awk -F"*" '{print $2}' | sed -e 's/^ *//' | tr -d '\n') || true

if [[ ! -z "$PROD" ]]; then
  softwareupdate -i "$PROD" --verbose
fi

PACKAGES=(
    zsh
    gettext
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

source /.zshrc

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