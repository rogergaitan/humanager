# == Schema Information
#
# Table name: purchase_order_payments
#
#  id                :integer          not null, primary key
#  payment_option_id :integer
#  payment_type_id   :integer
#  purchase_order_id :integer
#  number            :string(255)
#  amount            :float
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

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
