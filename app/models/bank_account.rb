# == Schema Information
#
# Table name: bank_accounts
#
#  id            :integer          not null, primary key
#  bank          :string(255)
#  bank_account  :string(255)
#  sinpe         :string(255)
#  account_title :string(255)
#  entity_id     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class BankAccount < ActiveRecord::Base
  belongs_to :entity
  attr_accessible :account_title, :bank, :bank_account, :sinpe

  ## VALIDATIONS
  #validates :bank_account, :presence => true
end
