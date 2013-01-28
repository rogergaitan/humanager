# == Schema Information
#
# Table name: payment_options
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  related_account     :string(255)
#  use_expenses        :boolean
#  use_incomes         :boolean
#  require_transaction :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'test_helper'

class PaymentOptionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
