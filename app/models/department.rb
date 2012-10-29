# == Schema Information
#
# Table name: departments
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  employee_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Department < ActiveRecord::Base
	belongs_to :employee
	has_many :employees
	has_many :roles, :dependent => :destroy
  attr_accessible :name, :employee_id
end
