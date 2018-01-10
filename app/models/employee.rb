require 'concerns/encodable'
require 'concerns/currency_converter'

class Employee < ActiveRecord::Base
  include Encodable
  include CurrencyConverter
  
  attr_accessible :gender, :birthday, :marital_status, :join_date, 
                  :number_of_dependents, :seller, :social_insurance, :spouse, 
                  :wage_payment, :entity_attributes, :department_id, 
                  :occupation_id, :payment_frequency_id, :means_of_payment_id, 
                  :photo_attributes, :position_id, :employee_id, :is_superior,
                  :payment_unit_id, :price_defined_work, :payroll_type_id,
                  :number_employee, :account_bncr, :currency_id

  has_one :department
  belongs_to :entity, :dependent => :destroy
  belongs_to :department
  belongs_to :occupation
  belongs_to :payment_frequency
  belongs_to :means_of_payment
  belongs_to :position
  belongs_to :payment_unit
  has_many :payer_employee, :class_name => 'Employee', :foreign_key => 'id'
  belongs_to :currency
  has_one :photo, :dependent => :destroy
  has_many :employee_benefits, :dependent => :destroy
  has_many :work_benefits, :through => :employee_benefits
  
  has_many :employees
  belongs_to :employees

  has_many :deduction_employees, :dependent => :destroy
  has_many :deductions, :through => :deduction_employees

  # association with other_salaries through other_salary_employees
  # has_many :other_salary_employees, :dependent => :destroy
  # has_many :other_salaries, :through => :other_salary_employees

  #association with other_salaries through other_payment_employees
  has_many :other_payment_employees, :dependent => :destroy
  has_many :other_salaries, :through => :other_payment_employees
  
  has_many :payroll_employees, :dependent => :destroy
  has_many :payroll_histories, :through => :payroll_employees

  accepts_nested_attributes_for :entity, :allow_destroy => true
  accepts_nested_attributes_for :photo, :allow_destroy => true
  
  scope :order_employees, joins(:entity).order('surname ASC')
  
  scope :superior, where("is_superior = ?", 1)
  
  validates_numericality_of :account_bncr, :social_insurance, only_integer: true, on: :update, message: "solo permite numeros"
  
  validates_length_of :account_bncr, in: 6..20, too_short: "Debe tener minimo 6 numeros", 
    too_long: "Debe tener maximo 20 numeros", on: :update
  validates_length_of :social_insurance, in: 6..20, too_short: "Debe tener minimo 6 numeros", 
    too_long: "Debe tener maximo 20 numeros", on: :update
    
  validates_uniqueness_of :number_employee, :account_bncr, :social_insurance, :allow_nil => true
  
  validates :join_date, presence: true, on: :update
  validate :join_date_cannot_be_in_future, on: :update
  
  before_save :update_superior
  
  def join_date_cannot_be_in_future
    if join_date &&  join_date > Date.today()
      errors.add :join_date, "Fecha de ingreso no puede ser despues de la fecha actual"
    end
  end
  
  def update_superior
    if self.employee_id
      s = Employee.find(self.employee_id)
      s.update_column(:is_superior, 1)
    end    
  end
  
  def self.validate_social_insurance_uniqueness(id, social_insurance)
    employee = Employee.new() if id.empty?
    employee = Employee.find(id) unless id.empty?

    employee.social_insurance = social_insurance

    employee.valid?
    status = (employee.errors[:social_insurance].any?)? 404:200
  end

  def self.validate_account_bncr_uniqueness(id, account_bncr)
    employee = Employee.new() if id.empty?
    employee = Employee.find(id) unless id.empty?

    employee.account_bncr = account_bncr
    
    employee.valid?
    
    status = (employee.errors[:account_bncr].any?)? 404:200
  end

  def full_name
    "#{entity.name} #{entity.surname}"
  end

  def self.all_payment_unit
    @payment_unit = PaymentUnit.all
  end

  def self.all_payroll_type(company_id)
    @payroll_type = PayrollType.where(company_id: company_id)
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

  def self.payment_types_report_data(employees, payroll_ids, task_ids, order, cc_ids, report_currency)
  
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
          info = get_info_by_employee_no_order(payroll_ids, task_ids, employee_id, cc_ids, "no_order", report_currency)
                    
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
          info['info'] = get_info_by_employee_no_order(payroll_ids, task_ids, employee.id, cc_ids, "employee", report_currency)
                    
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
          info['unidad'] = "#{task.nunidad}"
          set_total('cc')
          info['info'] = get_info_by_task_cc(payroll_ids, task.id, employees, cc_ids, "task", report_currency)

          unless info['info'].empty?
            info['info'] << @total
            data << info
            info = {}
          end

        end # End each Task
        result = data

      ##### ORDER BY CENTRO DE COSTO #####
      when "centro_costo"

        CostsCenter.find(cc_ids).each do |cc|

          info['nombre'] = "#{cc.name_cc}"
          set_total('task')
          info['info'] = get_info_by_task_cc(payroll_ids, task_ids, employees, cc.id, "centro_costo", report_currency)

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

  def self.get_info_by_employee_no_order(payroll_ids, task_ids, employee_id, cc_ids, type, report_currency)

    data = []; infoData = [];
    info = {}

    PayrollHistory.joins(:payroll_employees)
                  .where(:payroll_log_id => payroll_ids, :task_id => task_ids, :costs_center_id => cc_ids, payroll_employees: {employee_id: employee_id})
                  .each do |ph|

      obj = {}
      obj['tarea'] = ph.task.ntask
      obj['unidad'] = ph.task.nunidad
      obj['cc'] = ph.costs_center.name_cc

      if data.include?(obj)
        index = data.index(obj)

        if ph.payment_type.payment_type.to_s == PaymentType::PAYMENT_ORDINARY
          infoData[index]['total_unid_ord'] += ph.time_worked.to_f
          infoData[index]['valor_total_ord'] += check_currency(ph.payroll_currency_type, report_currency, ph.total, ph.exchange_rate)
          @total['total_unid_ord'] += ph.time_worked.to_f
          @total['valor_total_ord'] += check_currency(ph.payroll_currency_type, report_currency, ph.total, ph.exchange_rate)
        end
        
        if ph.payment_type.payment_type.to_s == PaymentType::PAYMENT_EXTRA
          infoData[index]['total_unid_extra'] += ph.time_worked.to_f
          infoData[index]['valor_total_extra'] += check_currency(ph.payroll_currency_type, report_currency, ph.total, ph.exchange_rate)
          @total['total_unid_extra'] += ph.time_worked.to_f
          @total['valor_total_extra'] += check_currency(ph.payroll_currency_type, report_currency, ph.total, ph.exchange_rate)
        end

        if ph.payment_type.payment_type.to_s == PaymentType::PAYMENT_DOBLE
          infoData[index]['total_unid_doble'] += ph.time_worked.to_f
          infoData[index]['valor_total_doble'] += check_currency(ph.payroll_currency_type, report_currency, ph.total, ph.exchange_rate)
          @total['total_unid_doble'] += ph.time_worked.to_f
          @total['valor_total_doble'] += check_currency(ph.payroll_currency_type, report_currency, ph.total, ph.exchange_rate)
        end

        infoData[index]['total'] += check_currency(ph.payroll_currency_type, report_currency, ph.total, ph.exchange_rate)
        @total['total'] += check_currency(ph.payroll_currency_type, report_currency, ph.total, ph.exchange_rate)

      else
        
        if type == "employee"
          info['nombre'] = ph.task.ntask
        else
          em = Employee.find(employee_id)
          info['nombre'] = "#{em.entity.name} #{em.entity.surname}"
          info['tarea'] = ph.task.ntask
        end

        info['unidad'] = ph.task.nunidad
        info['cc'] = ph.costs_center.name_cc
        info['total_unid_ord'] = 0
        info['valor_total_ord'] = 0
        info['total_unid_extra'] = 0
        info['valor_total_extra'] = 0
        info['total_unid_doble'] = 0
        info['valor_total_doble'] = 0
        info['total'] = 0

        if ph.payment_type.payment_type.to_s == PaymentType::PAYMENT_ORDINARY
          info['total_unid_ord'] = ph.time_worked.to_f
          info['valor_total_ord'] = check_currency(ph.payroll_currency_type, report_currency, ph.total, ph.exchange_rate)
          @total['total_unid_ord'] += ph.time_worked.to_f
          @total['valor_total_ord'] += check_currency(ph.payroll_currency_type, report_currency, ph.total, ph.exchange_rate)
        end
        
        if ph.payment_type.payment_type.to_s == PaymentType::PAYMENT_EXTRA
          info['total_unid_extra'] = ph.time_worked.to_f
          info['valor_total_extra'] = check_currency(ph.payroll_currency_type, report_currency, ph.total, ph.exchange_rate)
          @total['total_unid_extra'] += ph.time_worked.to_f
          @total['valor_total_extra'] += check_currency(ph.payroll_currency_type, report_currency, ph.total, ph.exchange_rate)
        end

        if ph.payment_type.payment_type.to_s == PaymentType::PAYMENT_DOBLE
          info['total_unid_doble'] = ph.time_worked.to_f
          info['valor_total_doble'] = check_currency(ph.payroll_currency_type, report_currency, ph.total, ph.exchange_rate)
          @total['total_unid_doble'] += ph.time_worked.to_f
          @total['valor_total_doble'] += check_currency(ph.payroll_currency_type, report_currency, ph.total, ph.exchange_rate)
        end

        info['total'] = check_currency(ph.payroll_currency_type, report_currency, ph.total, ph.exchange_rate)
        @total['total'] += check_currency(ph.payroll_currency_type, report_currency, ph.total, ph.exchange_rate)

        data << obj
        infoData << info
        info = {}
      end # End data.include?(obj)
    end # End PayrollHistory.joins
    infoData
  end

  def self.get_info_by_task_cc(payroll_ids, task_id, employee_ids, cc_ids, type, report_currency)

    data = []; infoData = [];
    info = {}

    PayrollHistory.joins(:payroll_employees)
                  .where(:payroll_log_id => payroll_ids, :task_id => task_id, :costs_center_id => cc_ids, payroll_employees: {employee_id: employee_ids})
                  .each do |ph|

      ph.payroll_employees.each do |pe|
       
        obj = {}
        obj['employee'] = pe.employee_id
        obj['cc'] = ph.costs_center.name_cc
        
        if type == "task"
          obj['task'] = task_id
        end

        if type == "centro_costo"
          obj['task'] = ph.task.ntask
          obj['unidad'] = ph.task.nunidad
        end

        if data.include?(obj)
          index = data.index(obj)
          
          if ph.payment_type.payment_type.to_s == PaymentType::PAYMENT_ORDINARY
            infoData[index]['total_unid_ord'] += ph.time_worked.to_f
            infoData[index]['valor_total_ord'] += check_currency(ph.payroll_currency_type, report_currency, ph.total, ph.exchange_rate)
            @total['total_unid_ord'] += ph.time_worked.to_f
            @total['valor_total_ord'] += check_currency(ph.payroll_currency_type, report_currency, ph.total, ph.exchange_rate)
          end
          
          if ph.payment_type.payment_type.to_s == PaymentType::PAYMENT_EXTRA
            infoData[index]['total_unid_extra'] += ph.time_worked.to_f
            infoData[index]['valor_total_extra'] += check_currency(ph.payroll_currency_type, report_currency, ph.total, ph.exchange_rate)
            @total['total_unid_extra'] += ph.time_worked.to_f
            @total['valor_total_extra'] += check_currency(ph.payroll_currency_type, report_currency, ph.total, ph.exchange_rate)
          end

          if ph.payment_type.payment_type.to_s == PaymentType::PAYMENT_DOBLE
            infoData[index]['total_unid_doble'] += ph.time_worked.to_f
            infoData[index]['valor_total_doble'] += check_currency(ph.payroll_currency_type, report_currency, ph.total, ph.exchange_rate)
            @total['total_unid_doble'] += ph.time_worked.to_f
            @total['valor_total_doble'] += check_currency(ph.payroll_currency_type, report_currency, ph.total, ph.exchange_rate)
          end
          infoData[index]['total'] += check_currency(ph.payroll_currency_type, report_currency, ph.total, ph.exchange_rate)
          @total['total'] += check_currency(ph.payroll_currency_type, report_currency, ph.total, ph.exchange_rate)
        else

          info['nombre'] = "#{pe.employee.entity.name} #{pe.employee.entity.surname}"
          
          if type == "task"
              info['cc'] = ph.costs_center.name_cc
          end

          if type == "centro_costo"
            info['task'] = ph.task.ntask
            info['unidad'] = ph.task.nunidad
          end
          
          info['total_unid_ord'] = 0
          info['valor_total_ord'] = 0
          info['total_unid_extra'] = 0
          info['valor_total_extra'] = 0
          info['total_unid_doble'] = 0
          info['valor_total_doble'] = 0
          info['total'] = 0
          
          if ph.payment_type.payment_type.to_s == PaymentType::PAYMENT_ORDINARY
            info['total_unid_ord'] = ph.time_worked.to_f
            info['valor_total_ord'] = check_currency(ph.payroll_currency_type, report_currency, ph.total, ph.exchange_rate)
            @total['total_unid_ord'] += ph.time_worked.to_f
            @total['valor_total_ord'] += check_currency(ph.payroll_currency_type, report_currency, ph.total, ph.exchange_rate)
          end
          
          if ph.payment_type.payment_type.to_s == PaymentType::PAYMENT_EXTRA
            info['total_unid_extra'] = ph.time_worked.to_f
            info['valor_total_extra'] = check_currency(ph.payroll_currency_type, report_currency, ph.total, ph.exchange_rate)
            @total['total_unid_extra'] += ph.time_worked.to_f
            @total['valor_total_extra'] += check_currency(ph.payroll_currency_type, report_currency, ph.total, ph.exchange_rate)
          end

          if ph.payment_type.payment_type.to_s == PaymentType::PAYMENT_DOBLE
            info['total_unid_doble'] = ph.time_worked.to_f
            info['valor_total_doble'] = check_currency(ph.payroll_currency_type, report_currency, ph.total, ph.exchange_rate)
            @total['total_unid_doble'] += ph.time_worked.to_f
            @total['valor_total_doble'] += check_currency(ph.payroll_currency_type, report_currency, ph.total, ph.exchange_rate)
          end

          info['total'] = check_currency(ph.payroll_currency_type, report_currency, ph.total, ph.exchange_rate)
          @total['total'] += check_currency(ph.payroll_currency_type, report_currency, ph.total, ph.exchange_rate)

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
    @result = Entity.joins(:employee).where(:employees => { :id => search_id })
                    .select('employees.id, entities.name, entities.surname, employees.number_employee').limit(1)
    @result[0]
  end

  def self.search_employee_by_code(search_code)
    @result = Entity.joins(:employee).where(:employees => { :number_employee => search_code })
                    .select('employees.id, entities.name, entities.surname, employees.number_employee').limit(1)
    @result[0]
  end

  def self.search_employee_by_name(search_name)
    @result = Entity.joins(:employee).where('CONCAT(entities.surname, " " ,entities.name) like ?', "%#{search_name}%")
                    .select('employees.id, entities.name, entities.surname, employees.number_employee').limit(1)
    @result[0]
  end
  
  def self.sync_fb
    abanits = Abanit.includes(:abamunicipios, :abanitsddirecciones)
                       .where("bempleado = ?", 'T').find(:all, :select => ['init', 'ntercero', 'napellido', 
                                                                              'fnacimiento', 'isexo', 'zfoto'])
    created_records = 0
    updated_records = 0
    sync_data = {}
    
    abanits.each do |employee|
      full_name =firebird_encoding  employee.ntercero
      last_name = firebird_encoding employee.napellido
      gender = employee.isexo
      birthday = employee.fnacimiento
      country = employee.abamunicipios.try :nnombre
      department = employee.abamunicipios.try :idep
      municipality = employee.abamunicipios.try :imun
      address = employee.abanitsddirecciones.try :tdireccion
      photo = employee.zfoto
      
      if last_name.empty?
        last_name = 'nr'
      end
      
      if Entity.where("entityid = ?", employee.init).empty?

        new_employee = Employee.new(:gender => gender, :birthday => birthday)
        entity = new_employee.build_entity(:name => full_name, 
                                           :surname => last_name,
                                           :entityid => employee.init)
        
        entity.telephones.build
        entity.emails.build
        entity.build_address(department: department, municipality: municipality,
                             country: country, address: address)

        new_employee.build_photo
    
        if photo
          #create temporary file from blob field and upload it
          photo_file = Tempfile.new ["", ".jpg"]
          begin
            photo_file.write photo
            photo_file.rewind
            new_employee.photo.photo = photo_file 
          ensure
            photo_file.close
            photo_file.unlink
          end
        end
        
        if new_employee.save
          created_records += 1
        else
          new_employee.errors.each do |error|
            Rails.logger.error "Error creando empleado: #{employee.init}, #{error}"
          end
        end
      else
        entity = Entity.find_by_entityid(employee.init)
        
        entity.name = full_name 
        entity.surname = last_name
        entity.employee.gender = gender
        entity.employee.birthday = birthday
        entity.address_attributes = { address: address, department: department, 
                                     municipality: municipality, country: country }
        
        if entity.save
          updated_records += 1
        end
      end
    end
      sync_data[:notice] = ["#{I18n.t('helpers.titles.sync').capitalize}: #{created_records} 
                            #{I18n.t('helpers.titles.tasksfb_update')}: #{updated_records}"]
  end

  def self.custom_employees
    employees = {}
    Employee.order_employees.each do |e|
      employees[e.id] = {
        id: e.id,
        number_employee: e.number_employee,
        full_name: "#{e.entity.surname} #{e.entity.name}",
        department_id: e.department_id,
        employee_id: e.employee_id
      }
    end
    employees
  end

end
