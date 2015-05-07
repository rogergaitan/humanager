class Company < ActiveRecord::Base
  attr_accessible :code, :name, :label_reports_1, :label_reports_2, :label_reports_3

  has_many :payroll

end
