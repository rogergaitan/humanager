class Province < ActiveRecord::Base
  attr_accessible :province
  
  has_many :canton, :dependent => :destroy #UNA PROVINCIA PUEDE TENER MUCHOS CANTONES

  validates :province, :presence => true,
  			:uniqueness => { :case_sensitive => false }
end
