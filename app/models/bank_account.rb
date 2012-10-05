class BankAccount < ActiveRecord::Base
  belongs_to :entity
  attr_accessible :account_title, :bank, :bank_account, :sinpe
end
