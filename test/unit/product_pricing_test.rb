# == Schema Information
#
# Table name: product_pricings
#
#  id         :integer          not null, primary key
#  product_id :integer
#  utility    :float
#  type       :enum([:other, :c
#  category   :enum([:a, :b, :c
#  sell_price :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class ProductPricingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
