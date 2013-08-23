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
  					:occupation_id, :payment_frequency_id, :means_of_payment_id, 
            :photo_attributes, :position_id, :employee_id, :is_superior,
            :payment_unit_id, :price_defined_work, :payroll_type_default_id,
            :number_employee
  
  validates_uniqueness_of :number_employee

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

  def self.payment_types_report_data(employees, payroll_ids, tasks, order)
  
    data = {}
    infoData = []
    result = []
    set_total

    # ORDER BY EMPLOYEE
    ###################################################
    if order == "employee"

      Employee.find(employees).each do |employee|

        data['nombre'] = employee.entity.name + ' ' + employee.entity.surname

        Task.find(tasks).each do |task|

          info = get_info(payroll_ids, task.id, employee.id, task.ntask)

          if !info.empty?
            infoData << info
            info = {}
          end
        end # End each Task

        if !infoData.empty?
          infoData << @total
          set_total
          data['info'] = infoData
          result << data
          data = {}
          infoData = []
        end
      end # End each Employee
    end # End if order

    # ORDER BY TASK
    ###################################################
    if order == "task"

      Task.find(tasks).each do |task|
        
        data['nombre'] = task.ntask

        Employee.find(employees).each do |employee|

          name_employee = employee.entity.name + ' ' + employee.entity.surname

          info = get_info(payroll_ids, task.id, employee.id, name_employee)
          
          if !info.empty?
            infoData << info
            info = {}
          end
        end # End each Employee

        if !infoData.empty?
          infoData << @total
          set_total
          data['info'] = infoData
          result << data
          data = {}
          infoData = []
        end
      end # End each Tasks
    end # End if order

    result
  end

  def self.get_info(payroll_ids, task_id, employee_id, name)

    totalTasks = 0
    info = {
            'nombre' => '',
            'total_unid_ord' => 0,
            'valor_total_ord' => 0,
            'total_unid_extra' => 0,
            'valor_total_extra' => 0,
            'total_unid_doble' => 0,
            'valor_total_doble' => 0,
            'total' => 0
          }

    data = PayrollHistory.joins(:payroll_employees)
                        .where(:payroll_log_id => payroll_ids, :task_id => task_id, payroll_employees: {employee_id: employee_id})

      if !data.empty?

        data.each do |detail|

          time_worked = detail.time_worked
          total = detail.total
          totalTasks += total
          info['nombre'] = name
          
          case detail.payment_type.to_s
            when CONSTANTS[:PAYMENT][0]['name'] # Ordinario
              info['total_unid_ord'] += time_worked.to_i
              info['valor_total_ord'] += total
              @total['total_unid_ord'] += time_worked.to_i
              @total['valor_total_ord'] += total
              
            when CONSTANTS[:PAYMENT][1]['name'] # Extra
              info['total_unid_extra'] += time_worked.to_i
              info['valor_total_extra'] += total
              @total['total_unid_extra'] += time_worked.to_i
              @total['valor_total_extra'] += total

            when CONSTANTS[:PAYMENT][2]['name'] # Doble
              info['total_unid_doble'] += time_worked.to_i
              info['valor_total_doble'] += total
              @total['total_unid_doble'] += time_worked.to_i
              @total['valor_total_doble'] += total
          end # End case
        end # End data each

        info['total'] = totalTasks
        @total['total'] += totalTasks
      else # Else Emply
        info = {}
      end # End Emply
      info
  end

  def self.set_total
    @total = {
            'nombre' => 'Total',
            'total_unid_ord' => 0,
            'valor_total_ord' => 0,
            'total_unid_extra' => 0,
            'valor_total_extra' => 0,
            'total_unid_doble' => 0,
            'valor_total_doble' => 0,
            'total' => 0
          }
  end

end