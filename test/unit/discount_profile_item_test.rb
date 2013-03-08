# == Schema Information
#
# Table name: discount_profile_items
#
#  id                  :integer          not null, primary key
#  discount_profile_id :integer
#  item_type           :enum([:product,
#  item_id             :integer
#  discount            :float
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'test_helper'

class DiscountProfileItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
