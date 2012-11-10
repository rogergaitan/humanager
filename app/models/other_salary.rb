class OtherSalary < ActiveRecord::Base
	belongs_to :ledger_account
  attr_accessible :code, :description, :ledger_account_id

  validates :code, 
					:presence => true, 
					:length => { :within => 4..10 },
					:uniqueness => { :case_sensitive => false }

validates :description, 
					:presence => true	

validates :ledger_account_id, 
					:presence => true	
end
