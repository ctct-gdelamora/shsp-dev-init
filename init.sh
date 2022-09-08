#!/bin/bash

# Credit for a lot of this goes to https://www.lotharschulz.info/2021/05/11/macos-setup-automation-with-homebrew/

{
# unofficial bash strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail

# Commenting all this out since I know it works
# # Install XCode
# if ! which xcode-select >/dev/null; then
#     xcode-select --install
# else
#     echo "Xcode-Select already installed. Skipping."
# fi

# # Install Homebrew or re-tap homebrew/core if already installed.
# if ! which brew >/dev/null; then
#     echo "Installing Homebrew..."
#     /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
#     echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
#     source ~/.zshrc
# else
#     echo "Homebrew already installed. Updating..."
#     brew update
#     echo "Re-tapping homebrew/core."
#     rm -rf "$(brew --repo homebrew/core)"
#     brew tap homebrew/core
# fi

# # Install NVM or skip
# if ! which nvm >/dev/null; then
#     echo "Node Version Manager not found. Installing."
#     curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
#     source ~/.zshrc
# else
#     echo "Node Version Manager already installed. Skipping."
# fi

# # Regardless of results above, install NVM 14
# echo "Installing Node v14, current version supported."
# nvm install 14

# # Install gettext
# if ! which gettext >/dev/null; then
#     echo "gettext not found. Installing."
#     brew install gettext
# else
#     echo "gettext already installed. Skipping."
# fi

# if ! which zsh >/dev/null; then
#     echo "zsh not found. Installing."
#     brew install zsh
# else
#     echo "zsh already installed. Skipping."
# fi

if  [ ! -e "/Applications/Visual Studio Code.app" ]; then 
    echo "Visual Studio Code is the recommended IDE. Install?"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) brew install --cask visual-studio-code; break;;
            No ) exit;;
        esac
    done
else
    echo "Visual Studio Code already installed. Skipping."
fi

# if  [ -e "/Applications/Google Chrome.app" ]; then 
#     echo "Google Chrome already installed. Skipping."
# else
#     brew install --cask google-chrome
# fi

# if  [ -e "/Applications/Zoom.app" ]; then 
#     echo "Zoom already installed. Skipping."
# else
#     brew install --cask zoom
# fi

# if  [ -e "/Applications/Slack.app" ]; then 
#     echo "Slack already installed. Skipping."
# else
#     brew install --cask slack
# fi

# if  [ -e "/Applications/iTerm.app" ]; then 
#     echo "iTerm already installed. Skipping."
# else
#     brew install --cask iterm2
# fi

# # Rancher Desktop
# if ! mdfind -name 'Rancher Desktop.app'; then
#     ## Download
#     curl -O ~/Downloads/RancherDesktop.dmg https://github.com/rancher-sandbox/rancher-desktop/releases/download/v1.4.1/Rancher.Desktop-1.4.1.aarch64.dmg
#     ## Mount the .dmg image
#     sudo hdiutil attach ~/Downloads/RancherDesktop.dmg
#     ## Install the application
#     cp -R /Volumes/RancherDesktop/RancherDesktop.app /Applications
#     diskutil unmount /Volumes/RancherDesktop
#     open /Applications/RancherDesktop.app
# else
#     echo "Rancher Desktop already installed. Continuing..."
# fi
}