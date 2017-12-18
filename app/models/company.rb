# == Schema Information
#
# Table name: companies
#
#  id              :integer          not null, primary key
#  code            :integer
#  name            :string(255)
#  label_reports_1 :text
#  label_reports_2 :text
#  label_reports_3 :text
#  inum            :integer          (Autoincrement number just to send data to Firebird)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Company < ActiveRecord::Base
  attr_accessible :code, :name, :label_reports_1, :label_reports_2, :label_reports_3, 
                  :inum, :page_footer

  has_many :payroll

  has_one :department
  belongs_to :department

  has_one :deduction
  belongs_to :deduction

  has_one :work_benefit
  belongs_to :work_benefit

  belongs_to :payroll_type
  has_many :payroll_type

  belongs_to :costs_center
  has_many :costs_center

end
