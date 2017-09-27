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
  
  belongs_to :deduction_currency, :class_name => "Currency"

  validates :description, presence: true,  length: { maximum: 30 }
  
  validates_numericality_of :deduction_value, greater_than: 0, less_than_or_equal_to: 100, 
    message: "debe ser mayor que cero o menor o igual a 100", if: Proc.new { |d| d.calculation_type == :percentage && d.individual == false} 
  
  validates_numericality_of :deduction_value, greater_than: 0, 
      message: "debe ser mayor que cero",  if: Proc.new {|d| d.calculation_type == :fixed && d.individual == false }
  
  validates_numericality_of :amount_exhaust, greater_than: 0,
      message: "debe ser mayor que cero", if: Proc.new { |d|  d.deduction_type == :amount_to_exhaust && d.individual == false}
  
  before_save :save_state
  before_save :add_deduction_currency_id
  
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
  
  def active?
    if self.state == :active
      true
    else
      false
    end
  end
  
  def self.search(deduction_type, calculation_type, state, company, page)
    query = Deduction.includes :deduction_currency
    query = query.where company_id: company
    query = query.where deduction_type: deduction_type unless deduction_type.empty?
    query = query.where calculation_type: calculation_type unless calculation_type.empty?
    query = query.where state: state unless state.empty?
    
    query.paginate page: page, per_page: 15
  end
  
  private
  
    #deduction_currency_id must be same as amount_exhaust_currency_id
    def add_deduction_currency_id
      if self.calculation_type == :fixed && self.deduction_type == :amount_to_exhaust
        self.deduction_currency_id = self.amount_exhaust_currency_id
      end
    end
    
    def save_state
      if active
        self.state = :active
      else
        self.state = :completed
      end
    end
  
end
