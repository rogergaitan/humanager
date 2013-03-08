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

class QuotationItem < ActiveRecord::Base
  
  ###ASSOCIATIONS
  belongs_to :quotation
  has_one :product
  belongs_to :warehouse

  ###ATTRIBUTES
  attr_accessible :code, :description, :discount, :quantity, :tax, :total, 
  	:unit_price, :warehouse_id, :product_id

  ###VALIDATIONS
  validates :product_id, :code, :description, :total, :quantity, :unit_price,
  	:presence => true

  validates :quantity, :total, :unit_price,
  	:numericality => {:greater_than => 0}

  validates :discount, 
  	:numericality => { :greater_than => 0, :less_than => 100 },
  	:allow_blank => true

end
