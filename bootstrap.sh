#!/usr/bin/env bash

echo "Starting installation"

# Check for Homebrew, install if not already installed
if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
brew update

# Install Bash 4
brew install bash

PACKAGES=(
    cmake
    imagemagick@6
    ghostscript
    xpdf
)

echo "Installing packages..."
brew install ${PACKAGES[@]}
brew link imagemagick@6 --force

echo "Cleaning up..."
brew cleanup

curl -L get.rvm.io | bash -s stable # Install RVM
# Load RVM into a shell session as a function
if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
  # First try to load from a user install
  source "$HOME/.rvm/scripts/rvm"
elif [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then
  # Then try to load from a root install
  source "/usr/local/rvm/scripts/rvm"
else
  printf "ERROR: An RVM installation was not found.\n"
fi

source ~/.bash_profile
source ~/.profile

rvm install 2.3.1
rvm --default use 2.3.1
rvm use 2.3.1@global

echo "Installing Ruby gems"
sudo gem install bundler

echo "Installation complete"
