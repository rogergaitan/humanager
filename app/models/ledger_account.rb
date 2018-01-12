require 'concerns/encodable'

class LedgerAccount < ActiveRecord::Base
  include Encodable

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

  # Sync ledger accounts
  def self.sync_fb
    
    created_records = 0
    updated_records = 0
    accounts_fb = {}
    cntpuc = Cntpuc.where("bvisible = ?", 'T').find(:all, :select => ['icuenta', 'ncuenta', 'ipadre'])

    cntpuc.each do |account|
      if LedgerAccount.where("iaccount = ?", account.icuenta).empty?
        new_account = LedgerAccount.new(:iaccount => account.icuenta,
                                        :naccount => firebird_encoding(account.ncuenta),
                                        :ifather => account.ipadre)
        if new_account.save
          created_records += 1
        else
          @new_task.er.each do |error|
            Rails.logger.error "Error Creating account: #{account.icuenta}, Description: #{error}"
          end
        end
      else
        # UPDATE
        update_cntpuc = LedgerAccount.find_by_iaccount(account.icuenta)
        params = {
          :naccount => firebird_encoding(account.ncuenta),
          :ifather => account.ipadre
        }
        updated_records += 1 if update_cntpuc.update_attributes(params)
      end 
      accounts_fb[:notice] = ["#{I18n.t('helpers.titles.tasksfb').capitalize}: #{created_records} 
                               #{I18n.t('helpers.titles.tasksfb_update')}: #{updated_records}"]
    end

    return accounts_fb
  end
  
end
