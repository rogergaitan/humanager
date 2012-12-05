class ItemsPurchaseOrder < ActiveRecord::Base
  belongs_to :purchase_order
  attr_accessible :cost_total, :cost_unit, :description, :product, :quantity, 
  	:warehouse_id, :discount
end
