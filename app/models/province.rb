# == Schema Information
#
# Table name: provinces
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Province < ActiveRecord::Base
  has_many :addresses, :dependent => :destroy
  has_many :cantons, :dependent => :destroy
  has_many :districts, :dependent => :destroy

  attr_accessible :name
  validates :name, :presence => true
    def self.fetch
		Rails.cache.fetch("Province.all"){ find(:all, :select =>['id','name']) } 
	end

	def self.clean_cache
		Rails.cache.delete("Province.all")
	end
end
