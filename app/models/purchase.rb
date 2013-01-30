# == Schema Information
#
# Table name: purchases
#
#  id              :integer          not null, primary key
#  document_number :string(255)
#  vendor_id       :integer
#  purchase_date   :date
#  completed       :boolean
#  currency        :string(255)
#  subtotal        :float
#  taxes           :float
#  total           :float
#  purchase_type   :enum([:local, :i
#  dai_tax         :string(255)
#  isc_tax         :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Purchase < ActiveRecord::Base

  ##ASSOCIATIONS
  belongs_to :vendor
  has_many :purchase_items, :dependent => :destroy
  has_many :purchase_payment_options, :dependent => :destroy

  #ATTRIBUTES
  attr_accessor :vendor_name
  attr_accessor :default_company
  attr_accessor :current_user
  
  ##ATTRIBUTES ACCESIBLES
  attr_accessible :completed, :currency, :dai_tax, :document_number, :isc_tax,
    :purchase_type, :purchase_date, :subtotal, :taxes, :total, :vendor_id,
    :purchase_items_attributes, :vendor_name, :purchase_payment_options_attributes,
    :default_company, :current_user

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

  ##CALLBACKS
  #after_destroy :destroy_kardex TRIGGERED ON DESTROY purchase_item
  after_create  :create_kardex
  after_update  :update_kardex

  def self.get_vendor(id = nil)
    @vendor = Vendor.joins(:entity).select("name, surname").find(id) unless id.nil?
    @vendor.nil? ? "" : "#{@vendor.name} #{@vendor.surname}"
  end

  def self.search(search)
    where("document_number like '%#{search}%'") if search and search.length >= 3
  end

  private

  def quantity_amount
    errors.add :total, "Total debe ser igual a la suma de los metods de pago"  if !(self.total == purchase_payment_options.map(&:amount).sum)
  end

  def current_info
    current_info = {
      :default_company => self.default_company.to_i,
      :current_user    => self.current_user,
      :doc_type        => Purchase.model_name.downcase,
      :mov_type        => "input"
    }
  end
  
  def create_kardex
    Kardex.create_kardex(self, self.purchase_items, current_info)
  end

  def update_kardex
    Kardex.update_kardex(self, self.purchase_items, current_info)
  end

end
