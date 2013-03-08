# == Schema Information
#
# Table name: photos
#
#  id          :integer          not null, primary key
#  employee_id :integer
#  name        :string(255)
#  photo       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
