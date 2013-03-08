# == Schema Information
#
# Table name: deductions
#
#  id                :integer          not null, primary key
#  description       :string(255)
#  deduction_type    :enum([:Constante
#  amount_exhaust    :integer
#  calculation_type  :enum([:porcentua
#  calculation       :decimal(18, 4)
#  ledger_account_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  state             :boolean          default(TRUE)
#

require 'test_helper'

class DeductionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
