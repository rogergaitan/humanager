class Quotation < ActiveRecord::Base
  ###ASSOCIATIONS
  belongs_to :customer
  has_many :quotation_items

  ##ATTRIBUTES
  attr_accessor :customer_name
  attr_accessible :currency, :discount_total, :document_date, :document_number,
    :notes, :payment_term, :sub_total_free, :sub_total_taxed, :tax_total,
    :total, :valid_to, :customer_id, :quotation_items_attributes, :customer_name

  accepts_nested_attributes_for :quotation_items,
    :allow_destroy => true,
    :reject_if => proc { |attributes| attributes[:product_id].blank? }

  ###VALIDATIONS
  validates :customer_name, :presence => true

  ###CALLBACKS
  before_create :next_number, :if => proc { |a| a[:document_number].blank? }

  after_create :increment_document_number

  def next_number
    self.document_number = CheckDocumentNumber.next_number(:quotation)
  end

  def increment_document_number
    DocumentNumber.increment_document_number(:quotation)
  end

  def self.customer_name(quotation)
    @customer = Customer.includes(:entity).find(quotation.customer_id) if quotation
    quotation.customer_name = "#{@customer.entity.name} #{@customer.entity.surname}"
  end

  def self.search(number = nil, customer = nil)
    @quotations = where(:document_number => number) if !number.nil?
    @quotations = joins(:customer => :entity).where("entities.name like '%#{customer}%'") if !customer.nil?
    @quotations
  end

end
