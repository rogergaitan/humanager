# == Schema Information
#
# Table name: work_benefits
#
#  id                 :integer          not null, primary key
#  description        :string(255)
#  employee_id        :integer
#  frequency          :string(255)
#  calculation_method :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class WorkBenefit < ActiveRecord::Base
  attr_accessible :credit_account, :debit_account, :description, :percentage, :employee_ids
  
  has_many :employee_benefits, :dependent => :destroy
  has_many :employees, :through => :employee_benefits
  belongs_to :debit, class_name: 'LedgerAccount', foreign_key: "debit_account"
  belongs_to :credit, class_name: 'LedgerAccount', foreign_key: "credit_account"
end
