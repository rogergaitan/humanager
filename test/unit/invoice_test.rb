# == Schema Information
#
# Table name: invoices
#
#  id              :integer          not null, primary key
#  document_number :string(255)
#  document_date   :date
#  customer_id     :integer
#  currency        :string(255)
#  price_list      :string(255)
#  payment_term    :string(255)
#  due_date        :date
#  quotation_id    :integer
#  closed          :boolean
#  sub_total_free  :float
#  sub_total_taxed :float
#  discount_total  :float
#  tax_total       :float
#  total           :float
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
