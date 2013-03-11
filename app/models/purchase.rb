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

  belongs_to :vendor
  has_many :purchase_items, :dependent => :destroy
  has_many :purchase_payment_options, :dependent => :destroy

  attr_accessor :vendor_name
  attr_accessor :default_company
  attr_accessor :current_user
  
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

  validates :vendor_id, :document_number, :purchase_date, :vendor_name,
    :presence => true

  validate :quantity_amount, :on => :create
  

  #after_destroy :destroy_kardex TRIGGERED ON DESTROY purchase_item
  after_create  :create_kardex, :increment_document_number
  after_update  :update_kardex
  before_validation :next_number, :if => proc { |a| a[:document_number].blank? }

  def self.purchase_all(page, per_page = nil)
    includes(:vendor).paginate(:page => page, :per_page => per_page)
  end

  def self.get_vendor(id = nil)
    @vendor = Vendor.joins(:entity).select("name, surname").find(id) unless id.nil?
    @vendor.nil? ? "" : "#{@vendor.name} #{@vendor.surname}"
  end

  def self.vendor_name(purchase)
    @vendor = Vendor.includes(:entity).find(purchase.vendor_id) if purchase
    purchase.vendor_name = "#{@vendor.entity.name} #{@vendor.entity.surname}"
  end

  def self.search(search)
    where("document_number like '%#{search}%'") if search and search.length >= 3
  end

  private

  def quantity_amount
    errors.add :total, "Total debe ser igual a la suma de los metods de pago" unless (self.total == purchase_payment_options.map(&:amount).sum)
  end

  def current_info
    current_info = {
      :default_company => self.default_company.to_i,
      :current_user    => self.current_user,
      :doc_type        => Purchase.model_name.downcase,
      :mov_type        => "input",
      :mov_date       => self.purchase_date,
      :entity_id      => self.vendor_id
    }
  end
  
  def create_kardex
    Kardex.create_kardex(self, self.purchase_items, current_info)
  end

  def update_kardex
    Kardex.update_kardex(self, self.purchase_items, current_info)
  end

  def next_number
    self.document_number = DocumentNumber.next_number(:purchase)  
  end

  def increment_document_number
    DocumentNumber.increment_document_number(:purchase)
  end
  def self.date_range(date, page, per_page = nil)
    rev = date.split('/')
    par = rev[2] + '/' + rev[1] + '/' + rev[0]
    includes(:vendor).where("purchase_date <= ?", "#{par}").paginate(:page => page, :per_page => per_page)
  end
end
