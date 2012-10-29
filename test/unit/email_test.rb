# == Schema Information
#
# Table name: emails
#
#  id         :integer          not null, primary key
#  entity_id  :integer
#  email      :string(255)
#  typeemail  :enum([:personal,
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class EmailTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
