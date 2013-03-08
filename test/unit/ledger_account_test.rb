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

require 'test_helper'

class LedgerAccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
