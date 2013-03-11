# == Schema Information
#
# Table name: quotations
#
#  id              :integer          not null, primary key
#  document_number :string(255)
#  customer_id     :integer
#  currency        :string(255)
#  document_date   :date
#  valid_to        :date
#  payment_term    :string(255)
#  sub_total_free  :float
#  sub_total_taxed :float
#  tax_total       :float
#  discount_total  :float
#  total           :float
#  notes           :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

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

  def self.quotations_all(page, per_page = nil)
    includes(:customer => :entity).paginate(:page => page, :per_page => per_page)
  end

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

  def self.date_range(date, page, per_page = nil)
    rev = date.split('/')
    par = rev[2] + '/' + rev[1] + '/' + rev[0]
    includes(:customer => :entity)
    .where("document_date <= ?", "#{par}").paginate(:page => page, :per_page => per_page)
  end
end
