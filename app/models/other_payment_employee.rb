class OtherPaymentEmployee < ActiveRecord::Base
  
  belongs_to :other_payment
  belongs_to :employee

  before_destroy :check_employees_attributes

  has_many :other_payment_payments, :dependent => :destroy
  attr_accessible :other_payment_id, :employee_id, :completed, :calculation

  def check_employees_attributes
  	if self.marked_for_destruction?
	  	if self.other_payment_payments.present?
	  		self.completed = true
	  		self.save
	  		return false
	  	end
  	end
  end
  
end
