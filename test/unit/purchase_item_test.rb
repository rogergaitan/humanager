# == Schema Information
#
# Table name: purchase_items
#
#  id           :integer          not null, primary key
#  purchase_id  :integer
#  product_id   :integer
#  description  :string(255)
#  quantity     :float
#  cost_unit    :float
#  cost_total   :float
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  warehouse_id :integer
#  discount     :decimal(17, 2)
#  tax          :float
#  code         :string(255)
#

require 'test_helper'

class PurchaseItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
