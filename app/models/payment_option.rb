class PaymentOption < ActiveRecord::Base
	##RELATIONS
	belongs_to :purchase
	#has_many :purchase_payment_options

	##ATTRIBUTES  
  attr_accessible :name, :related_account, :require_transaction, :use_expenses, :use_incomes

  ##VALIDATIONS
  validates :name, :related_account, :presence => true

  def self.fetch
  	where :use_expenses => true, :require_transaction => true
  end

end
