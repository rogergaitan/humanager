class OtherPayment < ActiveRecord::Base

  belongs_to :ledger_account
  belongs_to :costs_center

  attr_accessible :name, :description, :deduction_type, :calculation_type, :amount, :state,
                  :constitutes_salary, :individual, :ledger_account_id, :payroll_type_ids,
                  :costs_center_id, :other_payment_employees_attributes, :custom_calculation,
                  :payroll_ids, :employee_ids, :active, :company_id, :other_payment_type,
                  :currency_id

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
  has_many :payroll_type, :through => :payroll_type_other_payment, :validate => false

  # association with other_payments through other_payment_employees
  has_many :other_payment_employees, :dependent => :destroy
  has_many :employees, :through => :other_payment_employees
  accepts_nested_attributes_for :other_payment_employees, :allow_destroy => true
  accepts_nested_attributes_for :employees, :allow_destroy => true
  belongs_to :currency
  belongs_to :company

  # Validations
  
  validates :name, :format => { :with => /^[A-Za-z0-9- ]+$/i }

  validates_uniqueness_of :name, :case_sensitive => false,
      :scope => [:name, :company_id], message: "El nombre ya existe"
  
  before_save :save_state

  def self.get_list_to_general_payment(payroll_ids, limit)
    listId = OtherPaymentPayment.joins(:other_payment_employee)
      .select('DISTINCT other_payment_employees.other_payment_id')
      .where('other_payment_payments.payroll_id in (?)', payroll_ids)
      .map(&:other_payment_id)
              
    orderByDeductionType = "CASE other_payment_type WHEN 'constant' THEN 1 WHEN 'unique' THEN 2 WHEN 'amount_to_exhaust' THEN 3 END";
    list_other_payments = OtherPayment.where('id in (?) and constitutes_salary = ?', listId, false)
      .order("state desc, #{orderByDeductionType}")
      .limit(limit)
      .map(&:id)
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

  def self.validate_name_uniqueness(id, name, company_id)
    
    other_payment = OtherPayment.new() if id.empty?
    other_payment = OtherPayment.find(id) unless id.empty?

    other_payment.name = name
    other_payment.company_id = company_id
    
    other_payment.valid?
    status = (other_payment.errors[:name].any?)? 404:200
  end
  
  private
  
  def save_state
    self.state = :active if active
    self.state = :completed unless active
  end

end
