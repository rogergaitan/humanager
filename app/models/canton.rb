# == Schema Information
#
# Table name: cantons
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  province_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Canton < ActiveRecord::Base
  belongs_to :province
  has_many :districts
  has_many :addresses
  attr_accessible :name, :province_id

  def self.fetch
		Rails.cache.fetch("Canton.all"){ find(:all, :select =>['id','name', 'province_id']) } 
	end

	def self.clean_cache
		Rails.cache.delete("Canton.all")
	end

end
