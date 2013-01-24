class Employee < ActiveRecord::Base
  attr_accessible :gender, :birthday, :marital_status, :ccss_calculated, :join_date,
    :number_of_dependents, :seller, :social_insurance, :spouse,
    :wage_payment, :entity_attributes, :department_id,
    :occupation_id, :payment_frequency_id,
    :means_of_payment_id, :photo_attributes, :position_id, :employee_id, :is_superior

  has_one :department
  belongs_to :entity, :dependent => :destroy
  belongs_to :department
  belongs_to :occupation
  belongs_to :payment_frequency
  belongs_to :means_of_payment
  belongs_to :position
  has_one :photo, :dependent => :destroy
  has_many :employee_benefits, :dependent => :destroy
  has_many :work_benefits, :through => :employee_benefits
  has_many :employees
  has_many :deduction_employees, :dependent => :destroy
  has_many :deductions, :through => :deduction_employees

  #association with other_salaries through other_salary_employees
  has_many :other_salary_employees, :dependent => :destroy
  has_many :other_salaries, :through => :other_salary_employees

  has_many :payroll_employees, :dependent => :destroy
  has_many :payroll_logs, :through => :payroll_employees
  belongs_to :employees

  has_many :payroll_employees
  has_many :payroll_logs, :through => :payroll_employees

  accepts_nested_attributes_for :entity, :allow_destroy => true
  accepts_nested_attributes_for :photo, :allow_destroy => true

  scope :order_employees, joins(:entity).order('surname ASC')

  scope :superior, where("is_superior = ?", 1)

  before_save :update_superior

  def update_superior
    if self.employee_id
      s = Employee.find(self.employee_id)
      s.update_attributes(:is_superior => 1)
    end
  end


  def full_name
    "#{entity.name} #{entity.surname}"
  end
end
