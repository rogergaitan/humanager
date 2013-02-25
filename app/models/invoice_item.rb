class InvoiceItem < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :warehouse
  belongs_to :product
  attr_accessible :available_quantity, :code, :description, :discount, 
    :ordered_quantity, :quantity, :tax, :cost_total, :cost_unit, :product_id, 
    :warehouse_id

  validates :code, :description, :cost_unit, :cost_total, :product_id, 
    :ordered_quantity, :quantity,
  	  :presence => true

  validates :cost_total, :cost_unit, :ordered_quantity, :quantity,
  	:numericality => {:greater_than => 0}

  validates :discount, 
  	:numericality => { :greater_than => 0, :less_than => 100 },
  	:allow_blank => true

  after_destroy :destroy_kardex

  def destroy_kardex
    @kardex = Kardex.where(:mov_id => self.invoice_id, :code => self.product_id)
    @kardex.each { |item| Kardex.destroy(item.id) if item }
  end

end