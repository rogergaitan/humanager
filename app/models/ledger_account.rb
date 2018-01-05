class LedgerAccount < ActiveRecord::Base
  has_many :other_salaries
  has_many :other_payments
  has_many :credit_benefits, class_name: "WorkBenefit", foreign_key: "credit_account"
  has_many :debit_benefits, class_name: "WorkBenefit", foreign_key: "debit_account"
  has_many :deductions
  has_many :payroll_types
  
  attr_accessible :iaccount, :ifather, :naccount
  
  scope :debit_accounts, where("iaccount LIKE :prefix1 or iaccount LIKE :prefix2 or iaccount LIKE :prefix3", 
    prefix1: "5%", prefix2: "6%", prefix3: "7%").select("id, iaccount, naccount, ifather")
  scope :credit_accounts, where("iaccount LIKE :prefix1", prefix1: "2%").select("id, iaccount, naccount, ifather")
  scope :bank_account, where("iaccount LIKE :prefix1 or iaccount LIKE :prefix2", prefix1: "1%", prefix2: "2%").select("id, iaccount, naccount, ifather")
  scope :children_credit_accounts, credit_accounts.where(children_count: 0).order(:iaccount)
  scope :children_debit_accounts, debit_accounts.where(children_count: 0).order(:iaccount)
  
  after_create :check_father
  
  def check_father
    father = LedgerAccount.find_by_iaccount self.ifather
    father.increment! :children_count if father
  end
  
end
