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

class PayrollHistory < ActiveRecord::Base
  belongs_to :task
  belongs_to :centro_de_costo
  belongs_to :payroll_log
  attr_accessible :time_worked, :task_id, :centro_de_costo_id, :payment_type, :payroll_log_id
end
