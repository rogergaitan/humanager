# == Schema Information
#
# Table name: products
#
#  id           :integer          not null, primary key
#  code         :string(255)
#  line_id      :integer
#  subline_id   :integer
#  category_id  :integer
#  part_number  :string(255)
#  name         :string(255)
#  make         :string(255)
#  model        :string(255)
#  year         :string(255)
#  version      :string(255)
#  max_discount :integer
#  address      :string(255)
#  max_cant     :integer
#  min_cant     :integer
#  cost         :float
#  bar_code     :string(255)
#  market_price :integer
#  status       :enum([:active, :
#  stock        :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
