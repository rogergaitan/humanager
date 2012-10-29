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

require 'test_helper'

class BankAccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
