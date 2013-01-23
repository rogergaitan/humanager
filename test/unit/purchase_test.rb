# == Schema Information
#
# Table name: purchases
#
#  id              :integer          not null, primary key
#  document_number :string(255)
#  vendor_id       :integer
#  purchase_date   :date
#  completed       :boolean
#  currency        :string(255)
#  subtotal        :float
#  taxes           :float
#  total           :float
#  purchase_type   :enum([:local, :i
#  dai_tax         :string(255)
#  isc_tax         :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class PurchaseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
