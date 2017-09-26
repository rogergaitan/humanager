class WorkBenefit < ActiveRecord::Base
  attr_accessible :credit_account, :debit_account, :description, :percentage, :employee_ids,
    :payroll_type_ids, :is_beneficiary, :beneficiary_id, :costs_center_id, :company_id, :name, :state, 
    :calculation_type, :work_benefits_value, :work_benefits_type

  belongs_to :company
  has_many :companies
  
  has_many :payroll_type_benefits, :dependent => :destroy
  has_many :payroll_type, :through => :payroll_type_benefits
  has_many :employee_benefits, :dependent => :destroy
  has_many :employees, :through => :employee_benefits
  has_many :work_benefits_payments
  
  belongs_to :costs_center , class_name: 'CostsCenter', foreign_key: "costs_center_id"
  belongs_to :debit, class_name: 'LedgerAccount', foreign_key: "debit_account"
  belongs_to :credit, class_name: 'LedgerAccount', foreign_key: "credit_account"

  def self.search_cost_center(search_cost_center_name, company_id, page, per_page = nil)
    @cost_center = CostsCenter.where("costs_centers.name_cc like '%#{search_cost_center_name}%' and company_id = '#{company_id}'")
    .paginate(:page => page, :per_page => 5)
  end

end
