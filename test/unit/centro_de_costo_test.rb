# == Schema Information
#
# Table name: centro_de_costos
#
#  id            :integer          not null, primary key
#  iempresa      :string(255)
#  icentro_costo :string(255)
#  nombre_cc     :string(255)
#  icc_padre     :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class CentroDeCostoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
