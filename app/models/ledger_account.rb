class LedgerAccount < ActiveRecord::Base
  has_many :other_salaries
  attr_accessible :iaccount, :ifather, :naccount
end
