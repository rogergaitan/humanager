# == Schema Information
#
# Table name: ledger_accounts
#
#  id         :integer          not null, primary key
#  iaccount   :string(255)
#  naccount   :string(255)
#  ifather    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class LedgerAccount < ActiveRecord::Base
  has_many :other_salaries
  has_many :credit_benefits, class_name: "WorkBenefit", foreign_key: "credit_account"
  has_many :debit_benefits, class_name: "WorkBenefit", foreign_key: "debit_account"
  has_many :deductions

  attr_accessible :iaccount, :ifather, :naccount, :account_type, :cost_center,
    :foreign_currency, :request_entity 
  
  scope :debit_accounts, 
  	where("iaccount LIKE :prefix1 or iaccount LIKE :prefix2 or iaccount LIKE :prefix3", 
    prefix1: "5%", prefix2: "6%", prefix3: "7%").select("id, iaccount, naccount, ifather")
  scope :credit_accounts, 
  	where("iaccount LIKE :prefix1", prefix1: "2%").select("id, iaccount, naccount, ifather")

  validates :naccount, :iaccount, :account_type, :presence => true
  validates :iaccount, :uniqueness => true

end
