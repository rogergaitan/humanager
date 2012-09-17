# == Schema Information
#
# Table name: sublines
#
#  id          :integer          not null, primary key
#  code        :string(255)
#  description :string(255)
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class SublineTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
