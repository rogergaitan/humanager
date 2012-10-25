# == Schema Information
#
# Table name: payment_schedules
#
#  id           :integer          not null, primary key
#  code         :string(255)
#  description  :string(255)
#  initial_date :date
#  end_date     :date
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  payment_date :date
#

class PaymentSchedule < ActiveRecord::Base
  attr_accessible :code, :description, :end_date, :initial_date, :payment_date
end
