# == Schema Information
#
# Table name: emails
#
#  id         :integer          not null, primary key
#  email_type :string(255)
#  email      :string(255)
#  entity_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class EmailTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
