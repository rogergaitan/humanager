# == Schema Information
#
# Table name: product_applications
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  product_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class ProductApplicationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
