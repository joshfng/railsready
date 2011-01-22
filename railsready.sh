#!/bin/bash
#
# Author: Josh Frye <joshfng>
# Licence: MIT
#
# Contributions from: Wayne E. Seguin <wayneeseguin@gmail.com>
#

shopt -s extglob
set -e

# Check if the user has sudo privileges.
sudo -v >/dev/null 2>&1 || { echo $(whoami) has no sudo privileges ; exit 1; }

# Ask if you want to build Ruby or install RVM
echo "Build Ruby or install RVM?"
echo "1. Build from souce"
echo "2. Install RVM"
echo -n "Select your Ruby type [1 or 2]? "
read whichRuby

if [ $whichRuby -eq 1 ] ; then
  echo "Will build Ruby from source and install system wide"
elif [ $whichRuby -eq 2 ] ; then
  echo "Will install RVM for this user"
else
  echo "Must choose to build Ruby or install RVM, exiting..."
  exit 1
fi

echo "Creating install dir..."
cd && mkdir -p railsready/src && cd railsready && touch install.log
echo "done.."

# Update the system before going any further
echo "Updating system..."
sudo apt-get update >> install.log && sudo apt-get -y upgrade >> install.log
echo "done.."

# Install build tools
echo "Installing build tools..."
sudo apt-get -y install \
    wget curl build-essential \
    bison openssl zlib1g \
    libxslt1.1 libssl-dev libxslt1-dev \
    libxml2 libffi-dev libyaml-dev \
    libxslt-dev autoconf libc6-dev \
    libreadline6-dev zlib1g-dev >> install.log
echo "done..."

echo "Installing libs needed for sqlite and mysql..."
sudo apt-get -y install libsqlite3-0 sqlite3 libsqlite3-dev libmysqlclient16-dev libmysqlclient16 >> install.log
echo "done..."

# Install imagemagick
echo "Installing imagemagick (this may take awhile)..."
sudo apt-get -y install imagemagick libmagick9-dev >> install.log
echo "done..."

# Install git-core
echo "Installing git..."
sudo apt-get -y install git-core >> install.log
echo "done..."

if [ $whichRuby -eq 1 ] ; then
  # Install Ruby
  echo "Downloading Ruby 1.9.2p136"
  cd src && wget ftp://ftp.ruby-lang.org//pub/ruby/1.9/ruby-1.9.2-p136.tar.gz
  echo "done..."
  echo "Extracting Ruby 1.9.2p136"
  tar -xzf ruby-1.9.2-p136.tar.gz >> ~/railsready/install.log
  echo "done..."
  echo "Building Ruby 1.9.2p136 (this may take awhile and build output may appear on screen)..."
  cd  ruby-1.9.2-p136 && ./configure --prefix=/usr/local >> ~/railsready/install.log && make >> ~/railsready/install.log && sudo make install >> ~/railsready/install.log
  echo "done..."
elif [ $whichRuby -eq 2 ] ; then
  #thanks wayneeseguin :)
  echo "Installing RVM the Ruby environment Manager http://rvm.beginrescueend.com/rvm/install/"
  curl -O -L http://rvm.beginrescueend.com/releases/rvm-install-head
  chmod +x rvm-install-head
  "$PWD/rvm-install-head" >> ~/railsready/install.log
  [[ -f rvm-install-head ]] && rm -f rvm-install-head
  echo "Setting up RVM to load with new shells."
  echo  '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  # Load RVM into a shell session *as a function*' >> "$HOME/.bashrc"
  echo "=> Loading RVM"
  source ~/.rvm/scripts/rvm
  source ~/.bashrc
  echo "Installing Ruby 1.9.2 (this will take awhile)"
  echo "More information about installing rubies can be found at http://rvm.beginrescueend.com/rubies/installing/"
  rvm install 1.9.2 >> ~/railsready/install.log
  echo "Using 1.9.2 and setting it as default for new shells"
  echo "More information about Rubies can be found at http://rvm.beginrescueend.com/rubies/default/"
  rvm --default use 1.9.2
else
  echo "How did you even get here?"
  exit 1
fi

# Reload bash
echo "Reloading bashrc so ruby and rubygems are available..."
source ~/.bashrc
echo "done..."

echo "Installing Bundler, Passenger and Rails.."
if [ $whichRuby -eq 1 ] ; then
  sudo gem install bundler passenger rails --no-ri --no-rdoc >> ~/railsready/install.log
elif [ $whichRuby -eq 2 ] ; then
  gem install bundler passenger rails --no-ri --no-rdoc >> ~/railsready/install.log
fi
echo "done..."

echo "Installation is complete!"

echo "run source ~/.bashrc or logout and back in to access Ruby"