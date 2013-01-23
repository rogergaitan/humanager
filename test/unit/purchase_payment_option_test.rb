# == Schema Information
#
# Table name: purchase_payment_options
#
#  id                :integer          not null, primary key
#  payment_option_id :integer
#  payment_type_id   :integer
#  purchase_id       :integer
#  number            :string(255)
#  amount            :float
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'test_helper'

class PurchasePaymentOptionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
