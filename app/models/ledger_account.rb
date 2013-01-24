class LedgerAccount < ActiveRecord::Base
  has_many :other_salaries
  has_many :credit_benefits, class_name: "WorkBenefit", foreign_key: "credit_account"
  has_many :debit_benefits, class_name: "WorkBenefit", foreign_key: "debit_account"
  attr_accessible :iaccount, :ifather, :naccount
  has_many :deductions
  
  scope :debit_accounts, where("iaccount LIKE :prefix1 or iaccount LIKE :prefix2 or iaccount LIKE :prefix3", 
                              prefix1: "5%", prefix2: "6%", prefix3: "7%").select("id, iaccount, naccount, ifather")
  scope :credit_accounts, where("iaccount LIKE :prefix1", prefix1: "2%").select("id, iaccount, naccount, ifather")
end
