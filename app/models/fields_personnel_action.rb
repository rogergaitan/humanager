# == Schema Information
#
# Table name: fields_personnel_actions
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  field_type :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FieldsPersonnelAction < ActiveRecord::Base
  has_many :personalized_fields
  has_many :type_of_personnel_actions, :through => :personalized_fields

  attr_accessible :field_type, :name
end
