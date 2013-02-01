class PurchaseOrderPayment < ActiveRecord::Base
  #belongs_to :payment_option
  #belongs_to :payment_type
  belongs_to :purchase_order
  attr_accessible :amount, :number, :payment_option_id, :payment_type_id, 
  	:purchase_order_id

  validates :amount, :number, :payment_option_id, :payment_type_id, 
  	:presence => true
  validates :amount, 
  	:numericality => { :greater_than => 0 }
end
