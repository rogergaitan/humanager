class Purchase < ActiveRecord::Base

	##ASSOCIATIONS
  belongs_to :vendor
  has_many :purchase_items, :dependent => :destroy
  has_many :purchase_payment_options, :dependent => :destroy

  #ATTRIBUTES
  attr_accessor :vendor_name
  attr_accessible :completed, :currency, :dai_tax, :document_number, :isc_tax,
    :purchase_type, :purchase_date, :subtotal, :taxes, :total, :vendor_id, 
    :purchase_items_attributes, :vendor_name, :purchase_payment_options_attributes

  accepts_nested_attributes_for :purchase_payment_options,    
    :allow_destroy => true, 
    :reject_if => proc { |a| a[:amount].blank? }


  accepts_nested_attributes_for :purchase_items, 
    :allow_destroy => true,
    :reject_if => proc { |attributes| attributes[:product_id].blank? }


  #VALIDATIONS
  validates :vendor_id, :document_number, :purchase_date, :vendor_name, 
  	:presence => true

  validate :quantity_amount, :on => :create

  def self.get_vendor(id = nil)
    @vendor = Vendor.joins(:entity).select("name, surname").find(id) unless id.nil?
    @vendor.nil? ? "" : "#{@vendor.name} #{@vendor.surname}"
  end

  def self.search(search)
    where("document_number like '%#{search}%'") if search and search.length >= 3
  end
  private
  def quantity_amount
    self.errors.add(:total, "Total debe ser igual a la suma de los metods de pago")  if !(self.total == purchase_payment_options.map(&:amount).sum)
    #self.total == purchase_payment_options.map(&:amount).sum
  end

end
