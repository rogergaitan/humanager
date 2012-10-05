class Phone < ActiveRecord::Base
  belongs_to :entity
  attr_accessible :phone, :phone_type
end
