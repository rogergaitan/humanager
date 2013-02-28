class Quotation < ActiveRecord::Base

  belongs_to :customer
  has_many :quotation_items, :dependent => :destroy

  attr_accessor :customer_name
  attr_accessible :currency, :discount_total, :document_date, :document_number,
    :notes, :payment_term, :sub_total_free, :sub_total_taxed, :tax_total,
    :total, :valid_to, :customer_id, :quotation_items_attributes, :customer_name

  accepts_nested_attributes_for :quotation_items,
    :allow_destroy => true,
    :reject_if => proc { |attributes| attributes[:product_id].blank? }

  validates :customer_name, :presence => true

  before_create :next_number, :if => proc { |a| a[:document_number].blank? }
  after_create :increment_document_number

  def next_number
    self.document_number = DocumentNumber.next_number(:quotation)
  end

  def increment_document_number
    DocumentNumber.increment_document_number(:quotation)
  end

  def self.customer_name(quotation)
    @customer = Customer.includes(:entity).find(quotation.customer_id) if quotation
    quotation.customer_name = "#{@customer.entity.name} #{@customer.entity.surname}"
  end

  def self.search(search)
    # @quotations = where(:document_number => number) unless number.nil?
    # @quotations = joins(:customer => :entity).where("entities.name like '%#{customer}%'") unless customer.nil?
    # # joins(:customer => :entity).where("entities.name like '%duo%' or quotations.document_number like '%145%'")
    # @quotations
    joins(:customer => :entity)
    .where("entities.name like ? or quotations.document_number like ?", "%#{search}%", "%#{search}%")
  end

end
