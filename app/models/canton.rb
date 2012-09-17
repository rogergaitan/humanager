class Canton < ActiveRecord::Base
  attr_accessible :canton, :province_id

  belongs_to :province #UN CANTON SOLO PUEDE PERTENECER A UNA PROVINCIA
  has_many :district, :dependent => :destroy #UN CANTON PUEDE TENER MUCHOS DISTRITOS 
  
   validates :canton, :presence => true,
  			:uniqueness => { :case_sensitive => false }
end
