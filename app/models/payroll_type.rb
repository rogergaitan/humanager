class PayrollType < ActiveRecord::Base
  attr_accessible :description, :payroll_type, :state, :cod_doc_payroll_support,
  		:mask_doc_payroll_support, :cod_doc_accounting_support_mov, :mask_doc_accounting_support_mov,
  		:ledger_account_id, :company_id, :calendar_color, :allow_register_from_app
  
  validates :description, :presence => true, :uniqueness => true
  validates_length_of :description, :maximum => 30, :message => "maximo 30 caracteres"

  belongs_to :company
  has_many :companies

  has_many :employees
  has_many :payroll_type_benefits, :dependent => :destroy
  has_many :work_benefit, :through => :payroll_type_benefits

  belongs_to :ledger_account
  
  scope :tipo_planilla,->(company_id){select(['id','description','payroll_type']).where(:state => 1, company_id: company_id ).order('payroll_type')}
  #scope :tipo_planilla, lambda {|type_payroll| where("payroll_type = ?", type_payroll).
  #select(['id', 'payroll_type', 'description']) }
end
