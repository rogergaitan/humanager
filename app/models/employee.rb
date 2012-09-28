class Employee < ActiveRecord::Base
  belongs_to :person
  belongs_to :department
  belongs_to :occupation
  belongs_to :role
  belongs_to :payment_method
  belongs_to :payment_frequency
  belongs_to :means_of_payment
  attr_accessible :ccss_calculated, :department_id, 
          :join_date, :means_of_payment_id, 
          :number_of_dependents, :occupation_id, :payment_frequency_id, 
          :payment_method_id, :person_id, :role_id, :social_insurance, 
          :spouse, :wage_payment
end
