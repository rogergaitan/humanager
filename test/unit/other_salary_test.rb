# == Schema Information
#
# Table name: other_salaries
#
#  id                :integer          not null, primary key
#  description       :string(255)
#  ledger_account_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  amount            :decimal(18, 2)
#  state             :boolean          default(TRUE)
#

require 'test_helper'

class OtherSalaryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
