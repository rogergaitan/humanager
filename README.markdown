# HuManager 

## Development Environment Setup

### Vagrant
- Download and install [vagrant](http://www.vagrantup.com/downloads)
- Clone the [repository](https://kalfaro@bitbucket.org/dotcreek/humanager.git)
- CD into the managerp and run `vagrant up`, this will download the Ubuntu Trusty base box and provision  the box from a shell script which is called `provisioning.sh` in the repository
- When finished you can just do `vagrant up` and that would start the vagrant box
	+ Port 8080 will be ported to 3000, so in your host machine you can see the app by accessing http://localhost:8080
	+ Your local code will be linked to the box in the folder called `/vagrant`
	+ MySQL 5.5 is installed and the default password is "root"
	+ The box's root password is "vagrant" in case you need it, the "vagrant" user is in the sudoer list
- Now you can ssh to the box by calling `vagrant ssh`

### Deploy the app
- Start up the vagrant box and ssh to it `vagrant up, vagrant ssh`
- Go to the shared folder `cd /vagrant`
- Run `bundle install`, this will take a while the first time
- Run any migration or create the database (if is the first time): `bundle exec rake db:create, bundle exec rake db:migrate`
- [*optional*] You may better take a database dump from a QA environment
- Now you can start the app running `rails s`
- You can see from your host the app by accessing [your localhost in port 8080](http://localhost:8080)

### Running the Cucumber tests
- `vagrant ssh`
- `cd /vagrant`
- Run an specific test: `bundle exec cucumber features/<feature_to_run>`
- Run all tests `bundle exec cucumber features`
- Run an specific scenario from a feature `bundle exec cucumber features/<feature>:XX` where XX is the line number where the scenario is defined

There might be issues installing the rubyfb gem, so you will need to isntall the develop libs for firebird

* For Centos *

Download the latest atrpms-repo rpm from
http://dl.atrpms.net/el6-x86_64/atrpms/stable/

Install atrpms-repo rpm:
rpm -Uvh atrpms-repo*rpm

Install firebird-devel rpm package:
yum install firebird-devel

