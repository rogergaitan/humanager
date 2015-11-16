#!/usr/bin/env bash

# install RVM with rails and ruby 2.1.1
gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
command curl -sSL https://rvm.io/mpapis.asc | gpg --import -
\curl -sSL https://get.rvm.io | bash -s stable --rails --ruby=2.1.1

# install mysql 5.5
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
apt-get install -y git mysql-server-5.5 mysql-client-5.5 mysql-common libmysqlclient-dev imagemagick libmagickwand-dev firebird2.5-dev nodejs firefox

#apt-get install ruby-dev
