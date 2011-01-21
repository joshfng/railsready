#Rails Ready
##Get a full Ruby on Rails stack up in one line :)

##Run this on a fresh install. Tested on Ubuntu server 10.04 lts

##To run:
  * sudo apt-get -y install curl && curl https://github.com/joshfng/railsready/raw/master/railsready.sh >> railsready.sh && chmod a+x railsready.sh && ./railsready.sh
  * If you want to watch the magic happen run "tail -f ~/railsready/install.log"

##What this gives you:

  * An updated system
  * Ruby 1.9.2p136 (installed to /usr/local/bin/ruby)
  * Imagemagick
  * libs needed to run Rails (sqlite, mysql, etc)
  * Bundler, Passenger, and Rails gems
  * Git

Just install a NGINX or Apache, run passenger-install-nginx-module or passenger-install-apache-module, upload your app, point your vhost config to your apps public dir and go!

Please note: If you are running on a super slow connection your sudo session may timeout and you'll have to enter your password again. If you're running this on an EC2 or RS instance it shouldn't be problem.

This method may not be ideal for everyone. Some people may prefer to use RVM. I use RVM in development but in production I only need 1.9.2 and gems are local to the app user thanks to bundler. Building from source (for me) is better since my servers are only running one app each and I know exactly what they need to run.

I use this to setup VMs all the time but I'm sure this script can be improved. It's meant to serve as quick start to get all the dependencies, Ruby, and Rails on a system with no interaction. Basically it's just running all the apt-get commands for you (aside from building Ruby). I'll update the commands and ruby versions as they change.
