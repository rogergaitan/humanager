# == Schema Information
#
# Table name: purchase_orders
#
#  id             :integer          not null, primary key
#  vendor_id      :integer
#  reference_info :string(255)
#  currency       :string(255)
#  observation    :text
#  subtotal       :float
#  taxes          :float
#  total          :float
#  delivery_date  :date
#  shipping_type  :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class PurchaseOrder < ActiveRecord::Base
  belongs_to :vendor
  has_many :items_purchase_order, :dependent => :destroy
  attr_accessible :vendor_id,:currency, :delivery_date, :observation, :reference_info,
  				  :shipping_type, :subtotal, :taxes, :total, :items_purchase_order_attributes,:vendor_attributes
  accepts_nested_attributes_for :items_purchase_order, :allow_destroy => true
  accepts_nested_attributes_for :vendor, :allow_destroy => true
  
  def self.get_vendor(vendor_id = nil)
    unless vendor_id.nil?
      @vendor = Vendor.find(vendor_id)
      "#{@vendor.entity.name} #{@vendor.entity.surname}"
    else
      ""
    end
  end
end
