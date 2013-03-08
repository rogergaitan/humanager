# == Schema Information
#
# Table name: type_of_personnel_actions
#
#  id          :integer          not null, primary key
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class TypeOfPersonnelAction < ActiveRecord::Base
  has_many :personalized_fields
  has_many :fields_personnel_actions, :through => :personalized_fields

  attr_accessible :description, :fields_personnel_action_ids
end
