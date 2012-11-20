class Deduction < ActiveRecord::Base
	belongs_to :ledger_account
  attr_accessible :amount_exhaust, :calculation, :calculation_type, :ledger_account_id, :deduction_type, :description
end
