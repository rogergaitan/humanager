# == Schema Information
#
# Table name: roles
#
#  id            :integer          not null, primary key
#  role          :string(255)
#  description   :string(255)
#  department_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
