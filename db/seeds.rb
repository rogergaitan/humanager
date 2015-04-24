# -*- encoding : utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create! :username => 'admin', :name => 'Admin User', :email => 'admin@dotcreek.com', :password => 'password', :password_confirmation => 'password'
user.toggle!(:admin)
puts 'New user created: ' << user.name