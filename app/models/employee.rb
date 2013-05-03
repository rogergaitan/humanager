# == Schema Information
# 
# Table name: employees
# 
#  id                   :integer          not null, primary key
#  entity_id            :integer
#  gender               :enum([:male, :fe
#  birthday             :date
#  marital_status       :enum([:single, :
#  number_of_dependents :integer
#  spouse               :string(255)
#  join_date            :date
#  social_insurance     :string(255)
#  ccss_calculated      :boolean
#  department_id        :integer
#  occupation_id        :integer
#  role_id              :integer
#  seller               :boolean
#  payment_frequency_id :integer
#  means_of_payment_id  :integer
#  wage_payment         :decimal(12, 2)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null


class Employee < ActiveRecord::Base
  attr_accessible :gender, :birthday, :marital_status, :join_date, 
  					:number_of_dependents, :seller, :social_insurance, :spouse, 
  					:wage_payment, :entity_attributes, :department_id, 
  					:occupation_id, :payment_frequency_id,
  					:means_of_payment_id, :photo_attributes, :position_id, :employee_id, :is_superior,
            :payment_unit_id, :price_defined_work, :payroll_type_default_id
            
  has_one :department
  belongs_to :entity, :dependent => :destroy
  belongs_to :department
  belongs_to :occupation
  belongs_to :payment_frequency
  belongs_to :means_of_payment
  belongs_to :position
  belongs_to :payment_unit
  belongs_to :payroll_type
  has_one :photo, :dependent => :destroy
  has_many :employee_benefits, :dependent => :destroy
  has_many :work_benefits, :through => :employee_benefits
  has_many :employees
  has_many :deduction_employees, :dependent => :destroy
  has_many :deductions, :through => :deduction_employees

  #association with other_salaries through other_salary_employees
  has_many :other_salary_employees, :dependent => :destroy
  has_many :other_salaries, :through => :other_salary_employees

  belongs_to :employees
  
  has_many :payroll_employees, :dependent => :destroy
  has_many :payroll_histories, :through => :payroll_employees

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

  def self.all_payment_unit
    @payment_unit = PaymentUnit.all
  end

  def self.all_payroll_type
    @payroll_type = PayrollType.all
  end
  
  def self.all_departments
    @departments = Department.all
  end

  def self.search(search_id, search_name, search_surname, search_department, search_entities, page, per_page = nil)
    query = ""
    params = []
    params.push(" entities.entityid like '%#{search_id}%' ") unless search_id.empty?
    params.push(" entities.name like '%#{search_name}%' ") unless search_name.empty?
    params.push(" entities.surname like '%#{search_surname}%' ") unless search_surname.empty?
    params.push(" employees.department_id = '#{search_department}' ") unless search_department.empty?
    params.push(" employees.employee_id = '#{search_entities}' ") unless search_entities.empty?
    query = build_query(params)
    
    Employee.joins(:entity).where(query).paginate(:page => page, :per_page => 15)
  end

  def self.build_query(data)
    query = ""
    if data
      data.each_with_index do |q, i|
        if i < data.length - 1
          query += q + " AND "
        else
          query += q
        end
      end
    end
    query
  end

end