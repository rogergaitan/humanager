class Canton < ActiveRecord::Base
  belongs_to :province
  attr_accessible :canton, :province_id
end
