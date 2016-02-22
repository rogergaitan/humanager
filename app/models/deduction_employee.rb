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

end
