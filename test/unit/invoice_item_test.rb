# == Schema Information
#
# Table name: invoice_items
#
#  id                 :integer          not null, primary key
#  invoice_id         :integer
#  warehouse_id       :integer
#  code               :string(255)
#  description        :string(255)
#  ordered_quantity   :float
#  available_quantity :float
#  quantity           :float
#  cost_unit          :float
#  discount           :float
#  tax                :float
#  cost_total         :float
#  product_id         :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'test_helper'

class InvoiceItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
