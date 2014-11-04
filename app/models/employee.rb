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
            :number_employee, :account_bncr
  
  validates_uniqueness_of :number_employee, :allow_nil => true

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
  
  validates :account_bncr, length: {is: 12}, allow_blank: true

  #association with other_salaries through other_salary_employees
  has_many :other_salary_employees, :dependent => :destroy
  has_many :other_salaries, :through => :other_salary_employees

  #association with other_salaries through other_payment_employees
  has_many :other_payment_employees, :dependent => :destroy
  has_many :other_salaries, :through => :other_payment_employees

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

  def self.payment_types_report_data(employees, payroll_ids, task_ids, order, cc_ids)
  
    data = []; infoData = [];
    info = {}
    
    # Get the payroll log ids
    payroll_log_ids = PayrollLog.where(:payroll_id => payroll_ids)

    case order
      
      ##### NOT ORDER #####
      when "no_order"
        totl = 0
        set_total('cc')

        employees.each do |employee_id|

          totl += 1
          info = get_info_by_employee_no_order(payroll_ids, task_ids, employee_id, cc_ids, "no_order")
                    
          unless info.empty?
            data << info
            info = {}
          end # End unless

          if totl == employees.length
            infoData << @total
            data << infoData
          end

        end # End each Employee
        result = data

      ##### ORDER BY EMPLOYEE #####
      when "employee"

        Employee.find(employees).each do |employee|

          info['nombre'] = "#{employee.entity.name} #{employee.entity.surname}"
          set_total('cc')
          info['info'] = get_info_by_employee_no_order(payroll_ids, task_ids, employee.id, cc_ids, "employee")
                    
          unless info['info'].empty?
            info['info'] << @total
            data << info
            info = {}
          end
        end # End each Employee
        result = data

      ##### ORDER BY TASK #####
      when "task"
        
        Task.find(task_ids).each do |task|

          info['nombre'] = "#{task.ntask}"
          set_total('cc')
          info['info'] = get_info_by_task_cc(payroll_ids, task.id, employees, cc_ids, "task")

          unless info['info'].empty?
            info['info'] << @total
            data << info
            info = {}
          end

        end # End each Task
        result = data

      ##### ORDER BY CENTRO DE COSTO #####
      when "centro_costo"

        CentroDeCosto.find(cc_ids).each do |cc|

          info['nombre'] = "#{cc.nombre_cc}"
          set_total('task')
          info['info'] = get_info_by_task_cc(payroll_ids, task_ids, employees, cc.id, "centro_costo")

          unless info['info'].empty?
            info['info'] << @total
            data << info
            info = {}
          end 
        end # End each cc_ids
        result = data
    end # End Case
    result
  end

  def self.get_info_by_employee_no_order(payroll_ids, task_ids, employee_id, cc_ids, type)

    data = []; infoData = [];
    info = {}

    PayrollHistory.joins(:payroll_employees)
                  .where(:payroll_log_id => payroll_ids, :task_id => task_ids, :centro_de_costo_id => cc_ids, payroll_employees: {employee_id: employee_id})
                  .each do |ph|

      obj = {}
      obj['tarea'] = ph.task.ntask
      obj['cc'] = ph.centro_de_costo.nombre_cc

      if data.include?(obj)
        index = data.index(obj)

        if ph.payment_type.to_s == CONSTANTS[:PAYMENT][0]['name'] # Ordinario
          infoData[index]['total_unid_ord'] += ph.time_worked.to_f
          infoData[index]['valor_total_ord'] += ph.total.to_f
          @total['total_unid_ord'] += ph.time_worked.to_f
          @total['valor_total_ord'] += ph.total.to_f
        end
        
        if ph.payment_type.to_s == CONSTANTS[:PAYMENT][1]['name'] # Extra
          infoData[index]['total_unid_extra'] += ph.time_worked.to_f
          infoData[index]['valor_total_extra'] += ph.total.to_f
          @total['total_unid_extra'] += ph.time_worked.to_f
          @total['valor_total_extra'] += ph.total.to_f
        end

        if ph.payment_type.to_s == CONSTANTS[:PAYMENT][2]['name'] # Doble
          infoData[index]['total_unid_doble'] += ph.time_worked.to_f
          infoData[index]['valor_total_doble'] += ph.total.to_f
          @total['total_unid_doble'] += ph.time_worked.to_f
          @total['valor_total_doble'] += ph.total.to_f
        end

        infoData[index]['total'] += ph.total.to_f
        @total['total'] += ph.total.to_f

      else
        
        if type == "employee"
          info['nombre'] = ph.task.ntask
        else
          em = Employee.find(employee_id)
          info['nombre'] = "#{em.entity.name} #{em.entity.surname}"
          info['tarea'] = ph.task.ntask
        end

        info['cc'] = ph.centro_de_costo.nombre_cc
        info['total_unid_ord'] = 0
        info['valor_total_ord'] = 0
        info['total_unid_extra'] = 0
        info['valor_total_extra'] = 0
        info['total_unid_doble'] = 0
        info['valor_total_doble'] = 0
        info['total'] = 0

        if ph.payment_type.to_s == CONSTANTS[:PAYMENT][0]['name'] # Ordinario
          info['total_unid_ord'] = ph.time_worked.to_f
          info['valor_total_ord'] = ph.total.to_f
          @total['total_unid_ord'] += ph.time_worked.to_f
          @total['valor_total_ord'] += ph.total.to_f
        end
        
        if ph.payment_type.to_s == CONSTANTS[:PAYMENT][1]['name'] # Extra
          info['total_unid_extra'] = ph.time_worked.to_f
          info['valor_total_extra'] = ph.total.to_f
          @total['total_unid_extra'] += ph.time_worked.to_f
          @total['valor_total_extra'] += ph.total.to_f
        end

        if ph.payment_type.to_s == CONSTANTS[:PAYMENT][2]['name'] # Doble
          info['total_unid_doble'] = ph.time_worked.to_f
          info['valor_total_doble'] = ph.total.to_f
          @total['total_unid_doble'] += ph.time_worked.to_f
          @total['valor_total_doble'] += ph.total.to_f
        end

        info['total'] = ph.total.to_f
        @total['total'] += ph.total.to_f

        data << obj
        infoData << info
        info = {}
      end # End data.include?(obj)
    end # End PayrollHistory.joins
    infoData
  end

  def self.get_info_by_task_cc(payroll_ids, task_id, employee_ids, cc_ids, type)

    data = []; infoData = [];
    info = {}

    PayrollHistory.joins(:payroll_employees)
                  .where(:payroll_log_id => payroll_ids, :task_id => task_id, :centro_de_costo_id => cc_ids, payroll_employees: {employee_id: employee_ids})
                  .each do |ph|

      ph.payroll_employees.each do |pe|

        obj = {}
        obj['employee'] = pe.employee_id
        obj['cc'] = ph.centro_de_costo.nombre_cc
        
        if type == "task"
          obj['task'] = task_id
        end

        if type == "centro_costo"
          obj['task'] = ph.task.ntask
        end

        if data.include?(obj)
          index = data.index(obj)
          
          if ph.payment_type.to_s == CONSTANTS[:PAYMENT][0]['name'] # Ordinario
            infoData[index]['total_unid_ord'] += ph.time_worked.to_f
            infoData[index]['valor_total_ord'] += ph.total.to_f
            @total['total_unid_ord'] += ph.time_worked.to_f
            @total['valor_total_ord'] += ph.total.to_f
          end
          
          if ph.payment_type.to_s == CONSTANTS[:PAYMENT][1]['name'] # Extra
            infoData[index]['total_unid_extra'] += ph.time_worked.to_f
            infoData[index]['valor_total_extra'] += ph.total.to_f
            @total['total_unid_extra'] += ph.time_worked.to_f
            @total['valor_total_extra'] += ph.total.to_f
          end

          if ph.payment_type.to_s == CONSTANTS[:PAYMENT][2]['name'] # Doble
            infoData[index]['total_unid_doble'] += ph.time_worked.to_f
            infoData[index]['valor_total_doble'] += ph.total.to_f
            @total['total_unid_doble'] += ph.time_worked.to_f
            @total['valor_total_doble'] += ph.total.to_f
          end
          infoData[index]['total'] += ph.total.to_f
          @total['total'] += ph.total.to_f
        else

          info['nombre'] = "#{pe.employee.entity.name} #{pe.employee.entity.surname}"
          
          if type == "task"
              info['cc'] = ph.centro_de_costo.nombre_cc
          end

          if type == "centro_costo"
            info['task'] = ph.task.ntask
          end
          
          info['total_unid_ord'] = 0
          info['valor_total_ord'] = 0
          info['total_unid_extra'] = 0
          info['valor_total_extra'] = 0
          info['total_unid_doble'] = 0
          info['valor_total_doble'] = 0
          info['total'] = 0
          
          if ph.payment_type.to_s == CONSTANTS[:PAYMENT][0]['name'] # Ordinario
            info['total_unid_ord'] = ph.time_worked.to_f
            info['valor_total_ord'] = ph.total.to_f
            @total['total_unid_ord'] += ph.time_worked.to_f
            @total['valor_total_ord'] += ph.total.to_f
          end
          
          if ph.payment_type.to_s == CONSTANTS[:PAYMENT][1]['name'] # Extra
            info['total_unid_extra'] = ph.time_worked.to_f
            info['valor_total_extra'] = ph.total.to_f
            @total['total_unid_extra'] += ph.time_worked.to_f
            @total['valor_total_extra'] += ph.total.to_f
          end

          if ph.payment_type.to_s == CONSTANTS[:PAYMENT][2]['name'] # Doble
            info['total_unid_doble'] = ph.time_worked.to_f
            info['valor_total_doble'] = ph.total.to_f
            @total['total_unid_doble'] += ph.time_worked.to_f
            @total['valor_total_doble'] += ph.total.to_f
          end

          info['total'] = ph.total.to_f
          @total['total'] += ph.total.to_f

          data << obj
          infoData << info
          info = {}
        end

      end # End each ph.payroll_employees
    end # End each PayrollHistory.joins
    infoData    
  end

  def self.set_total(data)
    
    @total = {
        "#{data}" => 'Total',
        'total_unid_ord' => 0,
        'valor_total_ord' => 0,
        'total_unid_extra' => 0,
        'valor_total_extra' => 0,
        'total_unid_doble' => 0,
        'valor_total_doble' => 0,
        'total' => 0
    }
  end

  # Check if some departments it's used in any record.
  # Check if some position it's used in any record.
  def self.check_if_exist_records(id, type)
    case type.to_s
        when "department"
          @total = Employee.where('department_id = ?', id).count
        when "position"
          @total = Employee.where('position_id = ?', id).count
        when "occupation"
          @total = Employee.where('occupation_id = ?', id).count
        when "means_of_payment"
          @total = Employee.where('means_of_payment_id = ?', id).count
        when "payment_frequency"
          @total = Employee.where('payment_frequency_id = ?', id).count
    end
  end

  def self.search_employee_by_id(search_id)
    @result = Entity.joins(:employee).where(:employees => { :id => search_id }).select('employees.id, entities.name, entities.surname, employees.number_employee').limit(1)
    @result[0]
  end

  def self.search_employee_by_code(search_code)
    @result = Entity.joins(:employee).where(:employees => { :number_employee => search_code }).select('employees.id, entities.name, entities.surname, employees.number_employee').limit(1)
    @result[0]
  end

   def self.search_employee_by_name(search_name)
    @result = Entity.joins(:employee).where('CONCAT(entities.surname, " " ,entities.name) like ?', "%#{search_name}%").select('employees.id, entities.name, entities.surname, employees.number_employee').limit(1)
    @result[0]
  end

end
