# == Schema Information
#
# Table name: taxes
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  percentage :float
#  cc_id      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class TaxisTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
