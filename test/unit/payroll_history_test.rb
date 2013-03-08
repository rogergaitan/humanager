# == Schema Information
#
# Table name: payroll_histories
#
#  id                 :integer          not null, primary key
#  task_id            :integer
#  time_worked        :string(255)
#  centro_de_costo_id :integer
#  payment_type       :enum([:Ordinario
#  payroll_log_id     :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'test_helper'

class PayrollHistoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
