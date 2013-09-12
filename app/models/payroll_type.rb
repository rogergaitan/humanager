class PayrollType < ActiveRecord::Base
  attr_accessible :description, :payroll_type, :state
  validates :description, :presence => true, :uniqueness => true

  has_many :employees
  has_many :payroll_type_benefits, :dependent => :destroy # kalfaro
  has_many :work_benefit, :through => :payroll_type_benefits # kalfaro
  
  scope :tipo_planilla, select(['id','description','payroll_type']).where(:state => 1 ).order('payroll_type')
  #scope :tipo_planilla, lambda {|type_payroll| where("payroll_type = ?", type_payroll).
  #select(['id', 'payroll_type', 'description']) }
end
