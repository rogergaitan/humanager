class Deduction < ActiveRecord::Base
  attr_accessible :payroll_ids, :amount_exhaust, :calculation, :calculation_type, 
  			:ledger_account_id, :deduction_type, :description, :employee_ids, 
  			:payroll_type_ids, :current_balance, :state, :is_beneficiary, :beneficiary_id

  has_many :payroll_type_deductions, :dependent => :destroy
  has_many :payroll_type, :through => :payroll_type_deductions

  has_many :deduction_payrolls, :dependent => :destroy
  has_many :deduction_employees, :dependent => :destroy
  has_many :payrolls, :through => :deduction_payrolls
  has_many :employees, :through => :deduction_employees
  belongs_to :ledger_account

  validates :calculation, :presence => true


  def self.get_list_to_general_payment
      
    deductions = Deduction.where('state = ?', 1)
    list_deductions = []

    if deductions.count > 4
      
      deductions = Deduction.where('state = ? and deduction_type = ?', 1, CONSTANTS[:DEDUCTION][0]['name']).limit(4)
      
      deductions.each do |d|
        list_deductions.push d.id
      end # End each deductions

      unless deductions.count == 4
        num_limit = 4 - deductions.count
        deductions = Deduction.where('state = ? and id NOT IN (?)', 1, list_deductions).limit(num_limit)
        deductions.each do |d|
          list_deductions.push d.id
        end # End each deductions
      end

    else 
      deductions.each do |d|
        list_deductions.push d.id
      end # End each deductions
    end # End if
    list_deductions
  end

end