# == Schema Information
#
# Table name: purchase_orders
#
#  id             :integer          not null, primary key
#  vendor_id      :integer
#  reference_info :string(255)
#  currency       :string(255)
#  observation    :text
#  subtotal       :float
#  taxes          :float
#  total          :float
#  delivery_date  :date
#  shipping_type  :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'test_helper'

class PurchaseOrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
