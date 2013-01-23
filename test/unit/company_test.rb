# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  surname    :string(255)
#  company_id :string(255)
#  telephone  :string(255)
#  address    :string(255)
#  email      :string(255)
#  web_site   :string(255)
#  default    :boolean
#  logo       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
