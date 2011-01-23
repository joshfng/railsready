#!/bin/bash
#
# Author: Josh Frye <joshfng@gmail.com>
# Licence: MIT
#
# Contributions from: Wayne E. Seguin <wayneeseguin@gmail.com>
#

ruby_version="1.9.2"
ruby_version_string="1.9.2p136"
ruby_source_url="ftp://ftp.ruby-lang.org//pub/ruby/1.9/ruby-1.9.2-p136.tar.gz"
ruby_source_tar_name="ruby-1.9.2-p136.tar.gz"
ruby_source_dir_name="ruby-1.9.2-p136"
script_runner=$(whoami)

control_c()
{
  echo -en "\n\n*** Exiting ***\n\n"
  exit 1
}
 
# trap keyboard interrupt (control-c)
trap control_c SIGINT

shopt -s extglob
set -e

# Check if the user has sudo privileges.
sudo -v >/dev/null 2>&1 || { echo $script_runner has no sudo privileges ; exit 1; }

echo -e "\n\n"
echo "#################################"
echo "########## Rails Ready ##########"
echo "#################################"

echo -e "\n\n"
echo "!!! This script will update your system! Run on a fresh install only !!!"
echo "run tail -f ~/railsready/install.log in a new terminal to watch the install"

echo -e "\n"
echo "What this script gets you:"
echo " * An updated system"
echo " * Ruby $ruby_version_string"
echo " * Imagemagick"
echo " * libs needed to run Rails (sqlite, mysql, etc)"
echo " * Bundler, Passenger, and Rails gems"
echo " * Git"

echo -e "\nThis script is always changing."
echo "Make sure you got it from https://github.com/joshfng/railsready"

# Ask if you want to build Ruby or install RVM
echo -e "\n"
echo "Build Ruby or install RVM?"
echo "=> 1. Build from souce"
echo "=> 2. Install RVM"
echo -n "Select your Ruby type [1 or 2]? "
read whichRuby

if [ $whichRuby -eq 1 ] ; then
  echo -e "\n\n!!! Set to build Ruby from source and install system wide !!! \n"
elif [ $whichRuby -eq 2 ] ; then
  echo -e "\n\n!!! Set to install RVM for user: $script_runner !!! \n"
else
  echo -e "\n\n!!! Must choose to build Ruby or install RVM, exiting !!!"
  exit 1
fi

echo -e "\n=> Creating install dir..."
cd && mkdir -p railsready/src && cd railsready && touch install.log
echo "==> done..."

# Update the system before going any further
echo -e "\n=> Updating system (this may take awhile)..."
sudo apt-get update >> ~/railsready/install.log 2>> ~/railsready/install.log \
 && sudo apt-get -y upgrade >> ~/railsready/install.log 2>> ~/railsready/install.log
echo "==> done..."

# Install build tools
echo -e "\n=> Installing build tools..."
sudo apt-get -y install \
    wget curl build-essential \
    bison openssl zlib1g \
    libxslt1.1 libssl-dev libxslt1-dev \
    libxml2 libffi-dev libyaml-dev \
    libxslt-dev autoconf libc6-dev \
    libreadline6-dev zlib1g-dev >> ~/railsready/install.log 2>> ~/railsready/install.log
echo "==> done..."

echo -e "\n=> Installing libs needed for sqlite and mysql..."
sudo apt-get -y install libsqlite3-0 sqlite3 libsqlite3-dev libmysqlclient16-dev libmysqlclient16 >> ~/railsready/install.log 2>> ~/railsready/install.log
echo "==> done..."

# Install imagemagick
echo -e "\n=> Installing imagemagick (this may take awhile)..."
sudo apt-get -y install imagemagick libmagick9-dev >> ~/railsready/install.log 2>> ~/railsready/install.log
echo "==> done..."

# Install git-core
echo -e "\n=> Installing git..."
sudo apt-get -y install git-core >> ~/railsready/install.log 2>> ~/railsready/install.log
echo "==> done..."

if [ $whichRuby -eq 1 ] ; then
  # Install Ruby
  echo -e "\n=> Downloading Ruby $ruby_version_string \n"
  cd src && wget $ruby_source_url
  echo -e "\n==> done..."
  echo -e "\n=> Extracting Ruby $ruby_version_string"
  tar -xzf $ruby_source_tar_name >> ~/railsready/install.log 2>> ~/railsready/install.log
  echo "==> done..."
  echo -e "\n=> Building Ruby $ruby_version_string (this will take awhile)..."
  cd  $ruby_source_dir_name && ./configure --prefix=/usr/local >> ~/railsready/install.log 2>> ~/railsready/install.log \
   && make >> ~/railsready/install.log 2>> ~/railsready/install.log \
    && sudo make install >> ~/railsready/install.log 2>> ~/railsready/install.log
  echo "==> done..."
elif [ $whichRuby -eq 2 ] ; then
  #thanks wayneeseguin :)
  echo -e "\n=> Installing RVM the Ruby enVironment Manager http://rvm.beginrescueend.com/rvm/install/ \n"
  curl -O -L http://rvm.beginrescueend.com/releases/rvm-install-head
  chmod +x rvm-install-head
  "$PWD/rvm-install-head" >> ~/railsready/install.log 2>> ~/railsready/install.log
  [[ -f rvm-install-head ]] && rm -f rvm-install-head
  echo -e "\n=> Setting up RVM to load with new shells..."
  echo  '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  # Load RVM into a shell session *as a function*' >> "$HOME/.bashrc"
  echo "==>done..."
  echo "=> Loading RVM..."
  #if RVM is installed as user root it goes to /usr/local/rvm/ not ~/.rvm
  if [ $script_runner != "root" ] ; then
    source ~/.rvm/scripts/rvm
    source ~/.bashrc
  fi
  echo "==> done..."
  echo -e "\n=> Installing $ruby_version_string (this will take awhile)..."
  echo -e "=> More information about installing rubies can be found at http://rvm.beginrescueend.com/rubies/installing/ \n"
  rvm install $ruby_version >> ~/railsready/install.log 2>> ~/railsready/install.log
  echo -e "\n==> done..."
  echo -e "\n=> Using 1.9.2 and setting it as default for new shells..."
  echo "=> More information about Rubies can be found at http://rvm.beginrescueend.com/rubies/default/"
  rvm --default use $ruby_version >> ~/railsready/install.log 2>> ~/railsready/install.log
  echo "==> done..."
else
  echo "How did you even get here?"
  exit 1
fi

# Reload bash
echo -e "\n=> Reloading bashrc so ruby and rubygems are available..."
source ~/.bashrc
echo "==> done..."

echo -e "\n=> Installing Bundler, Passenger and Rails.."
if [ $whichRuby -eq 1 ] ; then
  sudo gem install bundler passenger rails --no-ri --no-rdoc >> ~/railsready/install.log 2>> ~/railsready/install.log
elif [ $whichRuby -eq 2 ] ; then
  gem install bundler passenger rails --no-ri --no-rdoc >> ~/railsready/install.log 2>> ~/railsready/install.log
fi
echo "==> done..."

echo -e "\n#################################"
echo    "### Installation is complete! ###"
echo -e "#################################\n"

echo -e "\n !!! logout and back in to access Ruby or run source ~/.bashrc !!!\n"

echo -e "\n Thanks!\n-Josh\n"
