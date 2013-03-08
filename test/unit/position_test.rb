# == Schema Information
#
# Table name: positions
#
#  id          :integer          not null, primary key
#  position    :string(255)
#  description :string(255)
#  codigo_ins  :string(255)
#  codigo_ccss :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class PositionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
