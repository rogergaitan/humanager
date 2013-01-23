# == Schema Information
#
# Table name: kardexes
#
#  id           :integer          not null, primary key
#  company_id   :integer
#  mov_date     :date
#  mov_id       :integer
#  mov_type     :enum([:input, :o
#  doc_type     :string(255)
#  doc_number   :string(255)
#  entity_id    :integer
#  current_user :string(255)
#  code         :string(255)
#  cost_unit    :string(255)
#  discount     :string(255)
#  tax          :string(255)
#  cost_total   :string(255)
#  price_list   :string(255)
#  quantity     :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class KardexTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
