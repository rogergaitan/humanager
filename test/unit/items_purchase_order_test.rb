# == Schema Information
#
# Table name: items_purchase_orders
#
#  id                :integer          not null, primary key
#  purchase_order_id :integer
#  product           :string(255)
#  description       :string(255)
#  quantity          :integer
#  cost_unit         :float
#  cost_total        :float
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  warehouse_id      :integer
#  discount          :decimal(17, 2)
#

require 'test_helper'

class ItemsPurchaseOrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
