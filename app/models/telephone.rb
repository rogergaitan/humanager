class Telephone < ActiveRecord::Base
  belongs_to :entity
  attr_accessible :telephone, :typephone
end
