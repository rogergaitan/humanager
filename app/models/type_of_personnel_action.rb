class TypeOfPersonnelAction < ActiveRecord::Base
  has_many :personalized_fields
  has_many :fields_personnel_actions, :through => :personalized_fields

  attr_accessible :description, :fields_personnel_action_ids
end
