class DeductionEmployee < ActiveRecord::Base

  belongs_to :deduction
  belongs_to :employee

  before_destroy :check_employees_attributes

  has_many :deduction_payments, :dependent => :destroy
  attr_accessible :deduction_id, :employee_id, :completed, :calculation

  #validates :calculation, :presence => true

	def check_employees_attributes
		if self.marked_for_destruction?
			if self.deduction_payments.present?
				self.completed = true
				self.save
				return false
			end
		end
	end
  
  def calculation_value
    deduction.individual? ? calculation : deduction.deduction_value
  end
  
  def maximum_deduction_currency
    deduction.maximum_deduction_currency.currency_type
  end
  
  def maximum_deduction_value
    deduction.maximum_deduction  
  end
  
  def deduction_currency
    deduction.deduction_currency.currency_type
  end
  
  def amount_exhaust_value
    deduction.amount_exhaust
  end
  
  def amount_exhaust_currency
   deduction.amount_exhaust_currency.currency_type  
  end
  
  def last_payment
    deduction_payments.last.current_balance
  end

end
