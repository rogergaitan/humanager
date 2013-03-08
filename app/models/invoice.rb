class Invoice < ActiveRecord::Base
  belongs_to :customer
  has_one :quotation
  has_many :invoice_items, :dependent => :destroy
  
  attr_accessor :customer_name, :default_company, :current_user
  attr_accessible :closed, :currency, :discount_total, :document_date, 
  	:document_number, :due_date, :payment_term, :price_list, :sub_total_free, 
  	:sub_total_taxed, :tax_total, :total, :customer_id, :customer_name, 
  	:invoice_items_attributes, :quotation_id, :customer_name, :default_company,
    :current_user

  accepts_nested_attributes_for :invoice_items,
    :allow_destroy => true,
    :reject_if => proc { |attributes| attributes[:product_id].blank? }

  validates :customer_name,  :presence => true
  validates :invoice_items, :presence => true
  
  #validates :total, :numericality => {:greater_than => 0}
  
  before_create :next_number, :if => proc { |a| a[:document_number].blank? }
  after_create :create_kardex, :increment_document_number
  after_update :update_kardex

  def self.invoices_all(page, per_page = nil)
    includes(:customer => :entity)
    .paginate(:page => page, :per_page => per_page)#.order("document_date DESC")
  end

  def next_number
    self.document_number = DocumentNumber.next_number(CONSTANTS[:invoice])
  end

  def increment_document_number
    DocumentNumber.increment_document_number(CONSTANTS[:invoice])
  end

  def self.customer_name(invoice)
    @customer = Customer.includes(:entity).find(invoice.customer_id) if invoice
    invoice.customer_name = "#{@customer.entity.name} #{@customer.entity.surname}"
  end


  def self.search(search, page, per_page = nil)
    joins(:customer => :entity)
    .where("entities.name like ? or invoices.document_number like ?", "%#{search}%", "%#{search}%")
    .paginate(:page => page, :per_page => 5)#.order("document_date DESC")
  end

  def current_info
    current_info = {
      :default_company => self.default_company.to_i,
      :current_user    => self.current_user,
      :doc_type        => Invoice.model_name.downcase,
      :mov_type        => CONSTANTS[:output],
      :mov_date        => self.document_date,
      :entity_id       => self.customer_id
    }
  end
  
  def create_kardex
    Kardex.create_kardex(self, self.invoice_items, current_info)
  end

  def update_kardex
    Kardex.update_kardex(self, self.invoice_items, current_info)
  end

end
