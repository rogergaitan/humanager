class Task < ActiveRecord::Base

	has_many :payroll_logs

 	attr_accessible  :iaccount, :iactivity, :itask, :mlaborcost, :ntask
end
