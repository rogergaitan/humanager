class District < ActiveRecord::Base
  belongs_to :canton
  attr_accessible :district
end
