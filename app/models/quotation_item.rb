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
