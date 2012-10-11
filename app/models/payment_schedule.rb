class PaymentSchedule < ActiveRecord::Base
  attr_accessible :code, :description, :end_date, :initial_date
end
