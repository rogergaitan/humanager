# == Schema Information
#
# Table name: vendors
#
#  id           :integer          not null, primary key
#  credit_limit :string(255)
#  entity_id    :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class VendorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
