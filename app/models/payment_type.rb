class PaymentType < ActiveRecord::Base
  
  #has_many :purchase_payment_options

  ##ATTRIBUTES
  attr_accessible :name

  ##VALIDATIONS
  validates :name, 
  	:presence => true, 
  	:uniqueness => { :case_sensitive => false }

end
