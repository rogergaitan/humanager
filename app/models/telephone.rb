class Telephone < ActiveRecord::Base
  belongs_to :person
  attr_accessible :telephone
end
