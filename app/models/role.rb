class Role < ActiveRecord::Base
  belongs_to :department
  attr_accessible :description, :role, :department_id
end
