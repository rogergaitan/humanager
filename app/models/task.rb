# == Schema Information
#
# Table name: tasks
#
#  id         :integer          not null, primary key
#  iactivity  :string(255)
#  itask      :string(255)
#  ntask      :string(255)
#  iaccount   :string(255)
#  mlaborcost :decimal(18, 4)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Task < ActiveRecord::Base

	has_many :payroll_logs

 	attr_accessible  :iaccount, :iactivity, :itask, :mlaborcost, :ntask
end
