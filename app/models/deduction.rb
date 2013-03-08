# == Schema Information
#
# Table name: deductions
#
#  id                :integer          not null, primary key
#  description       :string(255)
#  deduction_type    :enum([:Constante
#  amount_exhaust    :integer
#  calculation_type  :enum([:porcentua
#  calculation       :decimal(18, 4)
#  ledger_account_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  state             :boolean          default(TRUE)
#

class Deduction < ActiveRecord::Base
  attr_accessible :payroll_ids, :amount_exhaust, :calculation, :calculation_type, :ledger_account_id, :deduction_type, :description, :employee_ids, :current_balance
  has_many :deduction_payrolls, :dependent => :destroy
  has_many :deduction_employees, :dependent => :destroy
  has_many :payrolls, :through => :deduction_payrolls
  has_many :employees, :through => :deduction_employees
  belongs_to :ledger_account

 	validates :calculation, :presence => true
end
