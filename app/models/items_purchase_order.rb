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
#  tax               :float
#

class ItemsPurchaseOrder < ActiveRecord::Base
  belongs_to :purchase_order
  attr_accessible :cost_total, :cost_unit, :description, :product, :quantity,
    :warehouse_id, :discount, :tax

  ##VALIDATIONS
  validates :cost_total, :cost_unit, :description, :product, :quantity,
    :warehouse_id,
    :presence => true

  validates :cost_unit, :cost_total, :quantity,
    :numericality => { :greater_than => 0 }

  validates :discount,
    :numericality => { :only_integer => true, :greater_than => 0, :less_than => 100 }, :allow_nil => true
  
end
