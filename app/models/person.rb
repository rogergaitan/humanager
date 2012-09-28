class Person < ActiveRecord::Base
	attr_accessible :birthday, :first_surname, :id_person, :name, :second_surname, :tipoid, 
					:gender, :marital_status, :employee_attributes
	has_one :employee, :dependent => :destroy
	accepts_nested_attributes_for :employee
end
