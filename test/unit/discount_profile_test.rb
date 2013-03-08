# == Schema Information
#
# Table name: discount_profiles
#
#  id          :integer          not null, primary key
#  description :string(255)
#  category    :enum([:a, :b, :c
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class DiscountProfileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
