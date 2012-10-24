class Deduction < ActiveRecord::Base
  belongs_to :employee
  attr_accessible :calculation_method, :description, :frequency
end
