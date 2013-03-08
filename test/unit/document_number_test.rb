# == Schema Information
#
# Table name: document_numbers
#
#  id                   :integer          not null, primary key
#  company_id           :integer
#  description          :string(255)
#  document_type        :enum([:purchase,
#  number_type          :enum([:auto_incr
#  start_number         :integer
#  mask                 :string(255)
#  terminal_restriction :boolean
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

require 'test_helper'

class DocumentNumberTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
