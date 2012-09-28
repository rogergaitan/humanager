# -*- encoding : utf-8 -*-
class Person < ActiveRecord::Base
	attr_accessible :birthday, :first_surname, :id_person, :name, :second_surname, :tipoid, 
					:gender, :marital_status, :employee_attributes, :fb_person
	has_one :employee, :dependent => :destroy
	accepts_nested_attributes_for :employee
end
