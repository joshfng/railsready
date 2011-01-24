#Rails Ready
##Get a full Ruby on Rails stack up in one line :)

##Run this on a fresh install. Tested on Ubuntu server 10.04 lts

##To run:
  * `sudo wget --no-check-certificate https://github.com/joshfng/railsready/raw/master/railsready.sh && bash railsready.sh`
  * The script will ask if you want to build Ruby from source or install RVM
  * If you want to watch the magic happen run `tail -f ~/railsready/install.log`

##What this gives you:

  * An updated system
  * Ruby 1.9.2p136 (installed to /usr/local/bin/ruby) or RVM running 1.9.2p136
  * Imagemagick
  * libs needed to run Rails (sqlite, mysql, etc)
  * Bundler, Passenger, and Rails gems
  * Git

Just install either NGINX or Apache, run passenger-install-nginx-module or passenger-install-apache-module, upload your app, point your vhost config to your apps public dir and go!

Please note: If you are running on a super slow connection your sudo session may timeout and you'll have to enter your password again. If you're running this on an EC2 or RS instance it shouldn't be problem.

I use this to setup VMs all the time but I'm sure this script can be improved. It's meant to serve as a quick start to get all the dependencies, Ruby, and Rails on a system with no interaction. Basically it's just running all the apt-get commands for you (aside from building Ruby or installing RVM). I'll update the commands and ruby versions as they change.

If you use this and have any suggestions let me know joshfng@gmail.com
