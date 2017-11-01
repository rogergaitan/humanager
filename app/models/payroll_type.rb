class PayrollType < ActiveRecord::Base
  attr_accessible :description, :payroll_type, :state, :cod_doc_payroll_support,
  		:mask_doc_payroll_support, :cod_doc_accounting_support_mov, :mask_doc_accounting_support_mov,
  		:ledger_account_id, :company_id, :calendar_color, :allow_register_from_app
  
  validates :description, :presence => true
  validates_uniqueness_of :description, :case_sensitive => false, :scope => :company_id
  validates_length_of :description, :maximum => 30, :message => "maximo 30 caracteres"
  
  validates :cod_doc_accounting_support_mov, :cod_doc_payroll_support, :mask_doc_payroll_support, 
    :mask_doc_accounting_support_mov, :payroll_type, :calendar_color, :ledger_account_id, presence: true

  belongs_to :company, :primary_key => "code"
  has_many :companies

  has_many :employees
  has_many :payroll_type_benefits, :dependent => :destroy
  has_many :work_benefit, :through => :payroll_type_benefits

  belongs_to :ledger_account
  
  scope :tipo_planilla,->(company_id){select(['id','description','payroll_type']).where(:state => 1, company_id: company_id ).order('payroll_type')}
  #scope :tipo_planilla, lambda {|type_payroll| where("payroll_type = ?", type_payroll).
  #select(['id', 'payroll_type', 'description']) }
  
  def self.validate_description_uniqueness(id, description, company_id)
    if id.empty?
      payroll_type = PayrollType.new :description => description, :company_id => company_id
    else
      payroll_type = PayrollType.find id
      payroll_type.description = description
    end
    
    payroll_type.valid?
    
    if payroll_type.errors[:description].any?
      status = 404
    else
      status = 200
    end      
    status
  end
  
end
