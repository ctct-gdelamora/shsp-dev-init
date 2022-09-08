#!/bin/bash

# Credit for a lot of this goes to https://www.lotharschulz.info/2021/05/11/macos-setup-automation-with-homebrew/

{
# unofficial bash strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail

# Install XCode
if ! which xcode-select >/dev/null; then
    xcode-select --install
else
    echo "Xcode-Select already installed. Skipping."
fi

# Install Homebrew
if ! which brew >/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
    source ~/.zshrc
else
    echo "Homebrew already installed. Updating..."
    brew update
    echo "Re-tapping homebrew/core."
    rm -rf "$(brew --repo homebrew/core)"
    brew tap homebrew/core
fi

# 
if ! which nvm >/dev/null; then
    echo "Node Version Manager not found. Installing."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    source ~/.zshrc
else
    echo "Node Version Manager already installed. Skipping."
fi

echo "Installing Node v14, current version supported."
nvm install 14

if ! which gettext >/dev/null; then
    echo "gettext not found. Installing."
    brew install gettext
fi

if ! which zsh >dev/null; then
    echo "zsh not found. Installing."
    brew install zsh
else
    echo "zsh already installed. Skipping."
fi

if  [[ -d "/Applications/Visual Studio Code.app" ]]; then 
    echo "Visual Studio Code already installed. Skipping."
else
    read -p "Visual Studio Code is the recommended IDE. Install? " yn
    select yn in "Yes" "No"; do
        case $yn in
            [Yy]* ) brew install --cask visual-studio-code; break;;
            [Nn]* ) exit;;
        esac
    done
fi

if  [[ -d "/Applications/Google Chrome.app" ]]; then 
    echo "Google Chrome already installed. Skipping."
else
    brew install --cask google-chrome
fi

if  [[ -d "/Applications/Zoom.app" ]]; then 
    echo "Zoom already installed. Skipping."
else
    brew install --cask zoom
fi

if  [[ -d "/Applications/Slack.app" ]]; then 
    echo "Slack already installed. Skipping."
else
    brew install --cask slack
fi

if  [[ -d "/Applications/iTerm.app" ]]; then 
    echo "iTerm already installed. Skipping."
else
    brew install --cask iterm2
fi

# Rancher Desktop
if ! mdfind -name 'Rancher Desktop.app'; then
    ## Download
    curl -O ~/Downloads/RancherDesktop.dmg https://github.com/rancher-sandbox/rancher-desktop/releases/download/v1.4.1/Rancher.Desktop-1.4.1.aarch64.dmg
    ## Mount the .dmg image
    sudo hdiutil attach ~/Downloads/RancherDesktop.dmg
    ## Install the application
    cp -R /Volumes/RancherDesktop/RancherDesktop.app /Applications
    diskutil unmount /Volumes/RancherDesktop
    open /Applications/RancherDesktop.app
else
    echo "Rancher Desktop already installed. Continuing..."
fi
}