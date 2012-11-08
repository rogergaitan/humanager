class OtherSalary < ActiveRecord::Base
	belongs_to :ledger_account
  attr_accessible :code, :description, :ledger_account_id
end
