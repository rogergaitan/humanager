class Department < ActiveRecord::Base
  belongs_to :employee
  attr_accessible :name
end
