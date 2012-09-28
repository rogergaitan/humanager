class PaymentSchedule < ActiveRecord::Base
  belongs_to :employee
  attr_accessible :description, :end_date, :initial_date
end
