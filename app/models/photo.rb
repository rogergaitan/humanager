class Photo < ActiveRecord::Base
  belongs_to :employee
  attr_accessible :url
end
