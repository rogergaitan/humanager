class DetailPersonnelAction < ActiveRecord::Base
  belongs_to :type_of_personnel_action
  belongs_to :fields_personnel_action
  attr_accessible :value
end
