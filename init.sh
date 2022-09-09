#!/bin/bash

# Credit for a lot of this goes to https://www.lotharschulz.info/2021/05/11/macos-setup-automation-with-homebrew/
set -euo pipefail

{
# unofficial bash strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/

# Install XCode
if ! which xcode-select >/dev/null; then
    xcode-select --install
else
    echo "Xcode-Select already installed. Skipping."
    exit 0
fi

# Install Homebrew or re-tap homebrew/core if already installed.
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
    exit 0
fi

# Install NVM or skip
if ! which nvm >/dev/null; then
    echo "Node Version Manager not found. Installing."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    source ~/.zshrc
else
    echo "Node Version Manager already installed. Skipping."
    exit 0
fi

# Regardless of results above, install NVM 14
echo "Installing Node v14, current version supported."
nvm install 14

# Install gettext if not installed
if ! which gettext >/dev/null; then
    echo "gettext not found. Installing."
    brew install gettext
else
    echo "gettext already installed. Skipping."
    exit 0
fi

# Install zsh if not installed
if ! which zsh >/dev/null; then
    echo "zsh not found. Installing."
    brew install zsh
else
    echo "zsh already installed. Skipping."
    exit 0
fi

# Check if iTerm2 is installed
if [ ! -f "/Applications/iTerm 2.app" ]; then
    read -n 1 -r -p "iTerm2 is an optional install. Install? [Y/n]"
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        echo
        brew install --cask iterm2
    else
        echo
        echo "iTerm2 will not be installed. Skipping.";
    fi
fi

# REQUIRED: Check if Rancher Desktop is installed
if [ ! -f "/Applications/Rancher Desktop.app" ]; then
    echo "Rancher Desktop is a required M1 install. Downloading."
    ## Download
    curl -O ~/Downloads/RancherDesktop.dmg https://github.com/rancher-sandbox/rancher-desktop/releases/download/v1.4.1/Rancher.Desktop-1.4.1.aarch64.dmg
    ## Mount the .dmg image
    sudo hdiutil attach ~/Downloads/RancherDesktop.dmg
    ## Install the application
    cp -R /Volumes/RancherDesktop/RancherDesktop.app /Applications
    diskutil unmount /Volumes/RancherDesktop
    open /Applications/RancherDesktop.app
else
    echo "Rancher Desktop already installed. Skipping."
fi

# REQUIRED: Check if Slack is installed
if [ ! -f "/Applications/Slack.app" ]; then
    echo "Slack is required for intra-company communications. Downloading."
        brew install --cask slack
else
    echo "Slack already installed. Skipping."
fi

# Check if VS Code is installed
if [ ! -f "/Applications/Visual Studio Code.app" ]; then
    read -n 1 -r -p "Visual Studio Code is the recommended IDE. Install? [Y/n]"
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        echo
        brew install --cask visual-studio-code
    else
        echo
        echo "Visual Studio Code will not be installed. Skipping.";
    fi
fi

# Check if Chrome is installed
if [ ! -f "/Applications/Google Chrome.app" ]; then
    read -n 1 -r -p "Google Chrome is recommended for browser testing. Install? [Y/n]"
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        echo
        brew install --cask google-chrome
    else
        echo
        echo "Google Chrome will not be installed. Skipping.";
    fi
fi

# Check if Zoom is installed
if [ ! -f "/Applications/Zoom.app" ]; then
    read -n 1 -r -p "Zoom is required for video meetings. Install? [Y/n]"
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        echo
        brew install --cask zoom
    else
        echo
        echo "Zoom will not be installed. Skipping.";
    fi
fi

}