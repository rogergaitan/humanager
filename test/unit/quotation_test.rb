# == Schema Information
#
# Table name: quotations
#
#  id              :integer          not null, primary key
#  document_number :string(255)
#  customer_id     :integer
#  currency        :string(255)
#  document_date   :date
#  valid_to        :date
#  payment_term    :string(255)
#  sub_total_free  :float
#  sub_total_taxed :float
#  tax_total       :float
#  discount_total  :float
#  total           :float
#  notes           :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class QuotationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
