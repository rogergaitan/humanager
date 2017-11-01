class OtherPayment < ActiveRecord::Base

  belongs_to :ledger_account
  belongs_to :costs_center

  attr_accessible :description, :deduction_type, :calculation_type, :amount, :state, :constitutes_salary, 
    :individual, :ledger_account_id, :payroll_type_ids, :costs_center_id, :other_payment_employees_attributes, 
    :custom_calculation, :payroll_ids, :employee_ids, :name, :active, :company_id, :other_payment_type, :currency_id

  before_update :check_is_salary

  attr_accessor :custom_calculation, :employee_ids, :active

  # Constants
  STATE_COMPLETED = 'completed'.freeze
  STATE_ACTIVE = 'active'.freeze
  DEDUCTION_TYPE_CONSTANT = 'constant'.freeze
  DEDUCTION_TYPE_UNIQUE = 'unique'.freeze
  CALCULATION_TYPE_FIXED = 'fixed'.freeze
  CALCULATION_TYPE_PERCENTAGE = 'percentage'.freeze

  # association other_payments with payrolls
  has_many :other_payment_payrolls, :dependent => :destroy
  has_many :payrolls, :through => :other_payment_payrolls
  accepts_nested_attributes_for :other_payment_payrolls
  accepts_nested_attributes_for :payrolls

  has_many :payroll_type_other_payment, :dependent => :destroy
  has_many :payroll_type, :through => :payroll_type_other_payment

  # association with other_payments through other_payment_employees
  has_many :other_payment_employees, :dependent => :destroy
  has_many :employees, :through => :other_payment_employees
  accepts_nested_attributes_for :other_payment_employees, :allow_destroy => true
  accepts_nested_attributes_for :employees, :allow_destroy => true
  belongs_to :currency
  belongs_to :company
  
  before_save :save_state

  def self.get_list_to_general_payment(payroll_ids, limit)

    listId = OtherPaymentPayment.joins(:other_payment_employee)
            .select('DISTINCT other_payment_employees.other_payment_id')
            .where('other_payment_payments.payroll_id in (?)', payroll_ids)
            .map(&:other_payment_id)
              
    orderByDeductionType = "CASE deduction_type WHEN 'constant' THEN 1 WHEN 'unique' THEN 2 WHEN 'amount_to_exhaust' THEN 3 END";
    list_other_payments = OtherPayment.where('id in (?) and constitutes_salary = ?', listId, false)
                        .order("state desc, #{orderByDeductionType}")
                        .limit(limit)
                        .map(&:id)
  end

  def check_is_salary
    if self.constitutes_salary_changed?      
      a = OtherPaymentPayment.joins(:other_payment_employee).select('count(*) as total')
        .where('other_payment_employees.other_payment_id = ?', self.id).first
      self.constitutes_salary = a.total == 0 ? self.constitutes_salary : self.constitutes_salary_was
    end  
  end
  
  def self.search(other_payment_type, calculation_type, state, company, page)
    query = OtherPayment.includes :currency
    query = query.where company_id: company
    query = query.where other_payment_type: other_payment_type unless other_payment_type.empty?
    query = query.where calculation_type: calculation_type unless calculation_type.empty?
    query = query.where state: state unless state.empty?
    query.paginate page: page, per_page: 15
  end
  
  def active?
    self.state == :active ? true : false
  end
  
  private
  
  def save_state
    self.state = :active if active
    self.state = :completed unless active
  end

end
