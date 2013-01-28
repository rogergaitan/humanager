class DiscountProfile < ActiveRecord::Base
  
  has_many :discount_profile_items, :dependent => :destroy

  attr_accessible :description, :category, :discount_profile_items_attributes

  accepts_nested_attributes_for :discount_profile_items, 
  :allow_destroy => true,
  :reject_if => proc { |attributes| attributes[:item_id].blank? }

  validates :description, :category, :presence => true

  def self.items_name(profile)
  	profile.discount_profile_items.each do |item|
  		#if item[:item_type] == 'product'
  		#item[:name] = item[:item_type].capitalize.camelize.constantize.find(item[:item_id]).select('name')
  		#Rails.logger.debug " type = #{item[:item_type].to_s}" 
  		#a = "#{item[:item_type]}".capitalize.camelize.constantize.select('name').find(item[:item_id])
  		#item[:name] = a.name
  		item[:name] = "#{item[:item_type]}".capitalize.camelize.constantize.select('name').find(item[:item_id]).name
  		#tambien funciona el de abajo
  		#item[:name] = eval("#{item[:item_type]}".capitalize).select('name').find(item[:item_id]).name
  		#end
  	end

  end
end
