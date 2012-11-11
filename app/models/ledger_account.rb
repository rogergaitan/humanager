class LedgerAccount < ActiveRecord::Base
  has_many :other_salaries
  has_many :work_benefits, :class_name => "work_benefit"
  has_many :benefits, :class_name => "work_benefit"
  attr_accessible :iaccount, :ifather, :naccount
end
