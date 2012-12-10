class Payroll < ActiveRecord::Base
  attr_accessible :end_date, :payment_date, :payroll_type_id, :star_date, :state
  has_many :deduction_payrolls, :dependent => :destroy
  belongs_to :payroll_type
  has_many :deductions, :through => :deduction_payrolls
  validates :payroll_type_id, :presence => true
  validates :star_date, :presence => true
  validates :end_date, :presence => true
  validates :payment_date, :presence => true

  has_many :payroll_logs

  scope :activas, where(state: true)
  scope :inactivas, where(state: false)
  #consulta todas las planillas para un tipo de planilla especifico especifico
  #scope :tipo_planilla, lambda {|type_payroll| joins(:payroll_type).where("payroll_type = ?", type_payroll).
  #	select(['payroll_type', 'description']) }

end