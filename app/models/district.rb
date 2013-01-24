# == Schema Information
#
# Table name: districts
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  canton_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  province_id :integer
#

class District < ActiveRecord::Base
  belongs_to :province
  belongs_to :canton
  has_many :addresses, :dependent => :destroy
  attr_accessible :name, :canton_id, :province_id

  def self.fetch
		Rails.cache.fetch("District.all"){ find(:all, :select =>['id','name', 'canton_id']) } 
	end

	def self.clean_cache
		Rails.cache.delete("District.all")
	end

end
