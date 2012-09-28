# -*- encoding : utf-8 -*-
class Employee < ActiveRecord::Base
	attr_accessible :ccss_calculated, :department_id, 
					:join_date, :means_of_payment_id, 
					:number_of_dependents, :occupation_id, :payment_frequency_id, 
					:payment_method_id, :person_id, :role_id, :social_insurance, 
					:spouse, :wage_payment
	belongs_to :person
end