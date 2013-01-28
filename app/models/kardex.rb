# == Schema Information
#
# Table name: kardexes
#
#  id           :integer          not null, primary key
#  company_id   :integer
#  mov_date     :date
#  mov_id       :integer
#  mov_type     :enum([:input, :o
#  doc_type     :string(255)
#  doc_number   :string(255)
#  entity_id    :integer
#  current_user :string(255)
#  code         :string(255)
#  cost_unit    :string(255)
#  discount     :string(255)
#  tax          :string(255)
#  cost_total   :string(255)
#  price_list   :string(255)
#  quantity     :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Kardex < ActiveRecord::Base
  belongs_to :company
  belongs_to :entity
  attr_accessible :code, :cost_total, :cost_unit, :current_user, :discount, :tax,
  	:doc_number, :doc_type, :mov_date, :mov_id, :mov_type, :price_list, 
  	:quantity, :company_id, :entity_id

  validates :code, :cost_total, :cost_unit, :current_user, :doc_number,
  	:doc_type, :mov_date, :mov_id, :mov_type, :quantity, :entity_id, :company_id,
   		:presence => true

  def self.create_kardex(kardex, items, info)
    items.each do |item|
      kardex_object = kardex_item(kardex, item, info)
      @kardex = Kardex.create(kardex_object) if kardex_object
    end
  end

  def self.update_kardex(kardex, items, info)
    items.each do |item|
      kardex_object = kardex_item(kardex, item, info)
      @kardex = Kardex.find_by_mov_id_and_code(kardex[:id], item[:product_id])
      @kardex ? @kardex.update_attributes(kardex_object) : Kardex.create(kardex_object)
    end
  end

  def self.kardex_item(kardex, item, info)
    kardex_object = {}
    kardex_object = {
			:company_id   => info[:default_company],
			:current_user => info[:current_user],
			:doc_type     => info[:doc_type],
      :mov_type     => info[:mov_type],
			:mov_date     => kardex[:purchase_date],
			:mov_id       => kardex[:id],
			:doc_number   => kardex[:document_number],
			:entity_id    => kardex[:vendor_id],
			:code         => item[:product_id],
			:cost_unit    => item[:cost_unit],
			:discount     => item[:discount],
			:tax          => item[:tax] ? item[:tax] : 0,
			:cost_total   => item[:cost_total],
			:price_list   => item[:price_list] ? item[:price_list] : 0,
			:quantity     => item[:quantity]
		}
    kardex_object
  end
end
