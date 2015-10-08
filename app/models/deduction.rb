class Deduction < ActiveRecord::Base

  attr_accessible :payroll_ids, :amount_exhaust, :calculation_type, #:calculation
        :ledger_account_id, :deduction_type, :description,
        :payroll_type_ids, :current_balance, :state, :is_beneficiary, :beneficiary_id, :individual, 
        :deduction_employees_attributes, :custom_calculation, :employee_ids, :company_id

  attr_accessor :custom_calculation, :employee_ids

  belongs_to :company
  has_many :companies

  has_many :payroll_type_deductions, :dependent => :destroy
  has_many :payroll_type, :through => :payroll_type_deductions
  
  has_many :deduction_employees, :dependent => :destroy
  has_many :employees, :through => :deduction_employees
  accepts_nested_attributes_for :deduction_employees, :allow_destroy => true
  accepts_nested_attributes_for :employees, :allow_destroy => true

  has_many :deduction_payrolls, :dependent => :destroy
  has_many :payrolls, :through => :deduction_payrolls

  belongs_to :ledger_account

  # validates :calculation, :presence => true


  def self.get_list_to_general_payment
      
    deductions = Deduction.where('state = ?', CONSTANTS[:PAYROLLS_STATES]['ACTIVE'])
    list_deductions = []

    if deductions.count > 4
      
      deductions = Deduction.where('state = ? and deduction_type = ?', CONSTANTS[:PAYROLLS_STATES]['ACTIVE'], CONSTANTS[:DEDUCTION]['CONSTANTE']).limit(4)
      
      deductions.each do |d|
        list_deductions.push d.id
      end # End each deductions

      unless deductions.count == 4
        num_limit = 4 - deductions.count
        deductions = Deduction.where('state = ? and id NOT IN (?)', CONSTANTS[:PAYROLLS_STATES]['ACTIVE'], list_deductions).limit(num_limit)
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