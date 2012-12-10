class OtherSalary < ActiveRecord::Base
	belongs_to :ledger_account
  	attr_accessible :description, :ledger_account_id

	validates :description, 
					:presence => true	

	validates :ledger_account_id, 
					:presence => true	
end
