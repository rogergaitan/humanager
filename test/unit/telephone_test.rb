# == Schema Information
#
# Table name: telephones
#
#  id         :integer          not null, primary key
#  entity_id  :integer
#  telephone  :string(255)
#  typephone  :enum([:personal,
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class TelephoneTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
