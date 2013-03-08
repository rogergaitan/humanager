# == Schema Information
#
# Table name: personalized_fields
#
#  id                          :integer          not null, primary key
#  type_of_personnel_action_id :integer
#  fields_personnel_action_id  :integer
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#

class PersonalizedField < ActiveRecord::Base
  belongs_to :type_of_personnel_action
  belongs_to :fields_personnel_action
  
  attr_accessible :type_of_personnel_action_id, :fields_personnel_actions_id
end
