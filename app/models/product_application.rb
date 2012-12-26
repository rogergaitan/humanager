class ProductApplication < ActiveRecord::Base
  belongs_to :product
  attr_accessible :name, :product_id, :id
  validates :product_id, :name, :presence => true
end
