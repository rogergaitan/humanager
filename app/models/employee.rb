class Employee < ActiveRecord::Base
  belongs_to :person
  belongs_to :department
  belongs_to :occupation
  belongs_to :role
  belongs_to :payment_method
  belongs_to :payment_frequency
  belongs_to :means_of_payment
  attr_accessible :ccss_calculated, :join_date, :number_of_dependens, :social_insurance, :spouse, :wage_payment
end
