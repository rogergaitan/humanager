class PayrollType < ActiveRecord::Base
  attr_accessible :description, :payroll_type, :state, :cod_doc_payroll_support,
    :mask_doc_payroll_support, :cod_doc_accounting_support_mov, :mask_doc_accounting_support_mov,
    :ledger_account_id, :company_id, :calendar_color, :payer_employee_id, :allow_register_from_app
  
  # Validations
  validates :description, :presence => true
  validates_uniqueness_of :description, :case_sensitive => false, :scope => [:description, :company_id]
  validates_length_of :description, :maximum => 30, :message => "maximo 30 caracteres"
  validates :description, :format => { :with => /^[A-Za-z0-9- ]+$/i }
  
  validates :cod_doc_accounting_support_mov, :cod_doc_payroll_support, :mask_doc_payroll_support, 
            :mask_doc_accounting_support_mov, :payroll_type, :calendar_color, :ledger_account_id, presence: true

  belongs_to :company, :primary_key => "code"
  belongs_to :ledger_account
  belongs_to :payer_employee, class_name: 'Employee'

  has_many :companies
  has_many :employees
  has_many :payrolls
  
  has_many :payroll_type_benefits, :dependent => :restrict
  has_many :work_benefits, :through => :payroll_type_benefits
  
  has_many :payroll_type_deductions, :dependent => :restrict
  has_many :deductions, :through => :payroll_type_deductions
  
  has_many :payroll_type_other_payments, :dependent => :restrict
  has_many :other_payments, :through => :payroll_type_other_payments
  
  scope :tipo_planilla,->(company_id){select(['id','description','payroll_type']).where(:state => 1, company_id: company_id ).order('payroll_type')}
  
  def self.validate_description_uniqueness(id, description, company_id)
    
    payroll_type = PayrollType.new() if id.empty?
    payroll_type = PayrollType.find(id) unless id.empty?

    payroll_type.description = description
    payroll_type.company_id = company_id
    
    payroll_type.valid?
    status = 404 if (payroll_type.errors[:description].any?)? 404:200
  end
  
end
