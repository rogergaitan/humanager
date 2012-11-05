# == Schema Information
#
# Table name: lines
#
#  id                :integer          not null, primary key
#  code              :string(255)
#  name              :string(255)
#  description       :string(255)
#  inventory         :integer
#  sale_cost         :integer
#  utility_adjusment :integer
#  lost_adjustment   :integer
#  income            :integer
#  sales_return      :integer
#  purchase_return   :integer
#  sale_tax          :integer
#  purchase_tax      :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'test_helper'

class LineTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
