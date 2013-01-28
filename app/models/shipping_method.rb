# == Schema Information
#
# Table name: shipping_methods
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class ShippingMethod < ActiveRecord::Base

	##ATTRIBUTES
  attr_accessible :description, :name

  ##VALIDATIONS
  validates :name, :presence => true

  def self.fetch_all
		Rails.cache.fetch("ShippingMethod.all"){ all } 
	end

	def self.clean_cache
		Rails.cache.delete("ShippingMethod.all")
	end
end
