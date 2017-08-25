class Deduction < ActiveRecord::Base

  attr_accessible :payroll_ids, :amount_exhaust, :calculation_type, #:calculation
        :ledger_account_id, :deduction_type, :description,
        :payroll_type_ids, :current_balance, :state, :is_beneficiary, :beneficiary_id, :individual, 
        :deduction_employees_attributes, :custom_calculation, :employee_ids, :company_id, :creditor_id,
        :deduction_currency_id, :amount_exhaust_currency_id, :deduction_value, :pay_to_employee, :active,
        :maximum_deduction, :maximum_deduction_currency_id

  attr_accessor :employee_ids, :active

  belongs_to :creditor
  
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

  validates :description, presence: true,  length: { maximum: 30 }
  
  validates_numericality_of :deduction_value, greater_than: 0, allow_nil: true
  validates_numericality_of :amount_exhaust, greater_than: 0, allow_nil: true
  
  def self.get_list_to_general_payment(payroll_ids, limit)
    listId = DeductionPayment.joins(:deduction_employee)
        .select('DISTINCT deduction_employees.deduction_id')
        .where('deduction_payments.payroll_id in (?)', payroll_ids)
        .map(&:deduction_id)

    orderByDeductionType = "CASE deduction_type WHEN 'constant' THEN 1 WHEN 'unique' THEN 2 WHEN 'amount_to_exhaust' THEN 3 END";
    list_deductions = Deduction.where('id in (?)', listId)
                      .order("state desc, #{orderByDeductionType}")
                      .limit(limit)
                      .map(&:id)

  end
  
  def active
    if self.state == :active
      1
    else
      0
    end  
  end
  
end
