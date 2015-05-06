### Humanager

## Setup


# Using Vagrant

- Install vagrant
- Clone the repository
- run vagrant up
- vagrant ssh
- cd /vagrant
- bundle install
- rake db:create
- rake db:migrate

there might be issues installing the rubyfb gem, so you will need to isntall the develop libs for firebird

* For Centos *

Download the latest atrpms-repo rpm from
http://dl.atrpms.net/el6-x86_64/atrpms/stable/

Install atrpms-repo rpm:
rpm -Uvh atrpms-repo*rpm

Install firebird-devel rpm package:
yum install firebird-devel

