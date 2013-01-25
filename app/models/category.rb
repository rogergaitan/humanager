# == Schema Information
#
# Table name: categories
#
#  id          :integer          not null, primary key
#  code        :string(255)
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Category < ActiveRecord::Base
  
  attr_accessible :code, :description, :name
  
  validates :code,
  	:length => { :within => 4..10 },
  	:uniqueness => { :case_sensitive => false }

	validates :code, :name, :presence => true

	def self.fetch
		Rails.cache.fetch("Category.all"){ find(:all, :select =>['id','name']).to_json }
	end

	def self.clean_cache
		Rails.cache.delete("Category.all")
	end

end
