# == Schema Information
#
# Table name: sublines
#
#  id          :integer          not null, primary key
#  code        :string(255)
#  description :string(255)
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Subline < ActiveRecord::Base

	has_many :products

  attr_accessible :code, :description, :name

	validates :code, 
					:length => { :within => 1..10 },
					:uniqueness => { :case_sensitive => false }

	validates :code, :name,
						:presence => true		

  ##GENERAL SEARCH
    def self.search(search)
    	where("name like '%#{search}%'") if search.length >= 3
    end

	def self.fetch
		Rails.cache.fetch("Subline.all"){ find(:all, :select =>['id','name']).to_json } 
	end

	def self.clean_cache
		Rails.cache.delete("Subline.all")
	end

end
