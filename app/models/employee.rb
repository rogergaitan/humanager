class Employee < ActiveRecord::Base
  belongs_to :entities
  attr_accessible :join_date, :entities_id
end
