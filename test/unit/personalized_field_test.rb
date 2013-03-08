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

require 'test_helper'

class PersonalizedFieldTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
