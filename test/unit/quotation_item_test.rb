# == Schema Information
#
# Table name: quotation_items
#
#  id           :integer          not null, primary key
#  quotation_id :integer
#  product_id   :integer
#  code         :string(255)
#  description  :string(255)
#  quantity     :float
#  unit_price   :float
#  discount     :float
#  tax          :float
#  total        :float
#  warehouse_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class QuotationItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
