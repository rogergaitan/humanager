# == Schema Information
#
# Table name: payrolls
#
#  id              :integer          not null, primary key
#  payroll_type_id :integer
#  start_date      :date
#  end_date        :date
#  payment_date    :date
#  state           :boolean          default(TRUE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Payroll < ActiveRecord::Base

  attr_accessible :end_date, :payment_date, :payroll_type_id, :start_date, :state
  belongs_to :payroll_type
  has_many :deduction_payrolls, :dependent => :destroy
  has_many :deductions, :through => :deduction_payrolls
  validates :payroll_type_id, :presence => true
  validates :start_date, :presence => true
  validates :end_date, :presence => true
  validates :payment_date, :presence => true

  has_one :payroll_log, :dependent => :destroy
  
  accepts_nested_attributes_for :payroll_log

  has_many :payroll_logs

  scope :activas, where(state: true)
  scope :inactivas, where(state: false)
  #consulta todas las planillas para un tipo de planilla especifico especifico
  #scope :tipo_planilla, lambda {|type_payroll| joins(:payroll_type).where("payroll_type = ?", type_payroll).
  #	select(['payroll_type', 'description']) }

end
