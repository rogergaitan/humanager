class WorkBenefit < ActiveRecord::Base
  attr_accessible :credit_account, :debit_account, :description, :percentage, :employee_ids,
  			:payroll_type_ids, :is_beneficiary, :beneficiary_id, :centro_de_costo_id
  
  has_many :payroll_type_benefits, :dependent => :destroy
  has_many :payroll_type, :through => :payroll_type_benefits

  has_many :employee_benefits, :dependent => :destroy
  has_many :employees, :through => :employee_benefits
  has_many :work_benefits_payments
  belongs_to :centro_de_costos , class_name: 'CentroDeCosto', foreign_key: "centro_de_costo_id"
  belongs_to :debit, class_name: 'LedgerAccount', foreign_key: "debit_account"
  belongs_to :credit, class_name: 'LedgerAccount', foreign_key: "credit_account"

  def self.search_cost_center(search_cost_center_name, page, per_page = nil)
    @cost_center = CentroDeCosto.where(" centro_de_costos.nombre_cc like '%#{search_cost_center_name}%' " )
    .paginate(:page => page, :per_page => 5)
  end

end