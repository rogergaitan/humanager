class PurchaseItem < ActiveRecord::Base
  
  belongs_to :purchase
  belongs_to :product
  
  attr_accessor :product_code
  attr_accessible :cost_total, :cost_unit, :description, :quantity, :product_id,
  	:warehouse_id, :discount

  validates :product_id, :cost_total, :cost_unit, :description, :quantity, 
  	:warehouse_id, :presence => true 
  validates :cost_unit, :cost_total, :quantity, :numericality => { :greater_than => 0 }
  validates :discount, :numericality => { :greater_than_or_equal_to => 0, :less_than => 100 }

end
