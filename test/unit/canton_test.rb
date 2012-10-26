# == Schema Information
#
# Table name: cantons
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  province_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class CantonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
