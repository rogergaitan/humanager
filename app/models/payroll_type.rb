class PayrollType < ActiveRecord::Base
  attr_accessible :description, :payroll_type
  validates :description, :presence => true, :uniqueness => true

  has_many :employees
  
  scope :tipo_planilla, select(['id','description','payroll_type']).order('payroll_type')
  #scope :tipo_planilla, lambda {|type_payroll| where("payroll_type = ?", type_payroll).
  #select(['id', 'payroll_type', 'description']) }
end
