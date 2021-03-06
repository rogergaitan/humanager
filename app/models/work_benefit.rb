class WorkBenefit < ActiveRecord::Base
  attr_accessible :credit_account, :debit_account, :name, :percentage, :employee_ids,
                  :payroll_type_ids, :is_beneficiary, :beneficiary_id, :costs_center_id,
                  :company_id, :name, :state, :calculation_type, :work_benefits_value,
                  :currency_id, :active, :provisioning,:individual, :currency, 
                  :employee_benefits_attributes, :creditor_id, :pay_to_employee, :payroll_id

  attr_accessor :active

  # Constants
  STATE_ACTIVE = 'active'.freeze
  STATE_COMPLETED = 'completed'.freeze
  CALCULATION_TYPE_FIXED = 'fixed'.freeze
  CALCULATION_TYPE_PERCENTAGE = 'percentage'.freeze
  
  belongs_to :company
  has_many :companies
  has_many :payroll_type_benefits, :dependent => :destroy
  has_many :payroll_type, :through => :payroll_type_benefits, :validate => false
  has_many :employee_benefits, :dependent => :destroy
  has_many :employees, :through => :employee_benefits, :validate => false
  has_many :work_benefits_payments
  
  belongs_to :payroll
  belongs_to :costs_center , class_name: 'CostsCenter', foreign_key: "costs_center_id"
  belongs_to :debit, class_name: 'LedgerAccount', foreign_key: "debit_account"
  belongs_to :credit, class_name: 'LedgerAccount', foreign_key: "credit_account"
  belongs_to :currency

  # Validations
  validates_uniqueness_of :name, :case_sensitive => false,
      :scope => [:name, :company_id], message: "El nombre ya existe"
  
  validates :name, :format => { :with => /^[A-Za-z0-9- ]+$/i }
  
  accepts_nested_attributes_for :employee_benefits, :allow_destroy => true
  
  before_save :save_state

  def self.search_cost_center(search_cost_center_name, company_id, page, per_page = nil)
    @cost_center = CostsCenter.where("costs_centers.name_cc like '%#{search_cost_center_name}%' and company_id = '#{company_id}'")
                              .paginate(:page => page, :per_page => 5)
  end
  
  def self.search(calculation_type, state, company, page)
    query = WorkBenefit.includes :currency
    query = query.where company_id: company
    query = query.where calculation_type: calculation_type unless calculation_type.empty?
    query = query.where state: state unless  state.empty?
    
    query.paginate page: page, per_page: 15
  end
  
  def active?
    self.state == :active
  end

  def self.validate_name_uniqueness(id, name, company_id)
    work_benefit = WorkBenefit.new() if id.empty?
    work_benefit = WorkBenefit.find(id) unless id.empty?

    work_benefit.name = name
    work_benefit.company_id = company_id
    
    work_benefit.valid?
    status = (work_benefit.errors[:name].any?)? 404:200
  end
  
  private
  
  def save_state
    self.state = :active if active
    self.state = :completed unless active
  end

end
