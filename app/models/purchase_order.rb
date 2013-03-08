# == Schema Information
#
# Table name: purchase_orders
#
#  id              :integer          not null, primary key
#  vendor_id       :integer
#  reference_info  :string(255)
#  currency        :string(255)
#  observation     :text
#  subtotal        :float
#  taxes           :float
#  total           :float
#  delivery_date   :date
#  shipping_type   :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  document_date   :date
#  document_number :string(255)
#

class PurchaseOrder < ActiveRecord::Base

  ##ASSOCIATIONS
  belongs_to :vendor
  has_many :items_purchase_order, :dependent => :destroy
  has_many :purchase_order_payments, :dependent => :destroy

  ##ATTRIBUTES
  attr_accessor :vendor_name

  attr_accessible :vendor_id,:currency, :delivery_date, :observation,
    :reference_info,:shipping_type, :subtotal, :taxes, :total,
    :items_purchase_order_attributes,:vendor_attributes, :vendor_name, 
    :document_date, :purchase_order_payments_attributes, :document_number

  accepts_nested_attributes_for :items_purchase_order, :allow_destroy => true,
    :reject_if => proc { |attributes| attributes["product"].blank? }

  accepts_nested_attributes_for :purchase_order_payments, :allow_destroy => true,
    :reject_if => proc { |attributes| attributes[:number].blank? }

  accepts_nested_attributes_for :vendor, :allow_destroy => true

  validates :vendor_id, :delivery_date, :vendor_name, :document_date,
    :presence => true

  before_create :next_number, :if => proc { |a| a[:document_number].blank? }
  after_create :increment_document_number

  def self.get_vendor(purchase_order)
    @vendor = Entity.find(purchase_order.vendor_id)
    puts purchase_order.vendor_name
    purchase_order.vendor_name = "#{@vendor.name} #{@vendor.surname}"
  end

  def next_number
    self.document_number = DocumentNumber.next_number(:purchase_order)
  end

  def increment_document_number
    DocumentNumber.increment_document_number(:purchase_order)
  end
end
