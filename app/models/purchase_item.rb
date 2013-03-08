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

class PurchaseItem < ActiveRecord::Base
  
  belongs_to :purchase
  belongs_to :product
  
  attr_accessible :cost_total, :cost_unit, :description, :quantity, :product_id,
  	:warehouse_id, :discount, :purchase_id, :tax, :code

  validates :product_id, :cost_unit, :description, :quantity, :warehouse_id, :code, 
    :presence => true 
  
  validates :cost_unit, :cost_total, :quantity, 
    :numericality => { :greater_than => 0 }
  
  validates :discount, 
    :numericality => { :greater_than => 0, :less_than => 100 }, :allow_nil => true

  after_destroy :destroy_kardex

  def destroy_kardex
  	@kardex = Kardex.where(:mov_id => self.purchase_id, :code => self.product_id)
  	@kardex.each { |item| Kardex.destroy(item.id) if item }
  end
  

end
