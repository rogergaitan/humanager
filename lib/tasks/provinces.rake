# -*- coding: utf-8 -*-
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }]) ,'Pococí','Siquirres','Talamanca','Matina','Guácimo'

provinces = ['Guanacaste', 'Heredia']
limon_cantons = ["Limón"]

namespace :setup do
	task :provinces => :environment do

		provinces.each do |create|
			Province.create([{name:create}]) if !Province.find_by_name(create)
			#puts create
		end
	end

	task :cantons => :environment do
		limon_cantons.each do |create|
			c = Canton.create([{canton:create}]) if !Canton.find_by_canton(create)
			if c.save
				puts create ' saved'
			else
				puts create ' did not saved'
			end
		end	
	end
end
