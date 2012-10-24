# == Schema Information
#
# Table name: entities
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  surname    :string(255)
#  entityid   :string(255)
#  typeid     :enum([:nacional,
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class EntityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
