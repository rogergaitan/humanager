class OtherPaymentEmployee < ActiveRecord::Base
  
  belongs_to :other_payment
  belongs_to :employee

  has_many :other_payment_payments, :dependent => :destroy
  attr_accessible :other_payment_id, :employee_id, :state, :calculation
  
end
