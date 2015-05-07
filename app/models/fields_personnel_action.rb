class FieldsPersonnelAction < ActiveRecord::Base
  has_many :personalized_fields
  has_many :type_of_personnel_actions, :through => :personalized_fields

  attr_accessible :field_type, :name
end
