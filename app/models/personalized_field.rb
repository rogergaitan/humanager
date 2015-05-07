class PersonalizedField < ActiveRecord::Base
  belongs_to :type_of_personnel_action
  belongs_to :fields_personnel_action
  
  attr_accessible :type_of_personnel_action_id, :fields_personnel_actions_id
end
