class District < ActiveRecord::Base
  attr_accessible :canton_id, :district

	belongs_to :canton #UN DISTRITO SOLO PUEDE TENER UN CANTON

  validates :district, :presence => true,
  			:uniqueness => { :case_sensitive => false }
end
