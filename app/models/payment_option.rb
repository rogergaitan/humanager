class PaymentOption < ActiveRecord::Base
	##ATTRIBUTES  
  attr_accessible :name, :related_account, :require_transaction, :use_expenses, :use_incomes

  ##VALIDATIONS
  validates :name, :related_account, :presence => true

end
