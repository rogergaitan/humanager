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

class ProductPricing < ActiveRecord::Base
  attr_accessible :category, :product_id, :sell_price, :price_type, :utility

  validates :category, :product_id, :sell_price, :price_type, :utility,
  		:presence => true
end
