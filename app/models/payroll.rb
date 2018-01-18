require 'concerns/currency_converter'

class Payroll < ActiveRecord::Base
  include CurrencyConverter

  attr_accessible :end_date, :payment_date, :payroll_type_id, :start_date, :state, :num_oper, :num_oper_2, :company_id, :currency_id
  belongs_to :payroll_type
  belongs_to :deduction_payment
  belongs_to :company
  belongs_to :currency
  has_many :deduction_payrolls, :dependent => :destroy
  has_many :deductions, :through => :deduction_payrolls

  # OTHER PAYMENTS
  has_many :other_payment_payrolls, :dependent => :destroy
  has_many :other_payments, :through => :other_payment_payrolls

  # Validations
  validates :payroll_type_id, :presence => true
  validates :start_date, :presence => true
  validates :end_date, :presence => true
  validates :payment_date, :presence => true
  validates :company_id, :presence => true

  has_one :payroll_log, :dependent => :destroy
  
  accepts_nested_attributes_for :payroll_log

  has_many :payroll_logs
  has_many :work_benefits_payments
  has_many :deduction_payment
  has_many :other_payment_payment

  scope :activas, ->(company_id){ where(state: true, company_id: company_id) }
  scope :inactivas, ->(company_id){ where(state: false, company_id: company_id) }

  # Constants
  PROCESS_ONE = 'ONE'.freeze
  PROCESS_TWO = 'TWO'.freeze
  PROCESS_THREE = 'THREE'.freeze
  PROCESS_FOUR = 'FOUR'.freeze
  
  # consulta todas las planillas para un tipo de planilla especifico especifico
  # scope :tipo_planilla, lambda {|type_payroll| joins(:payroll_type).where("payroll_type = ?", type_payroll).
  #	select(['payroll_type', 'description']) }

  # Close the payroll
  def self.close_payroll(payroll_id, exchange_rate)
    exchange_rate = exchange_rate.to_f
    payroll_log = PayrollLog.includes(payroll: :currency).find_by_payroll_id(payroll_id)
    payroll_currency = payroll_log.payroll.currency.currency_type
    currency_symbol = payroll_log.payroll.currency.symbol
    list_employees_salary = get_salary_empoyees(payroll_log, payroll_currency, exchange_rate)
    list_other_payments_constitute_salary = get_other_payment(list_employees_salary, payroll_log, payroll_currency, exchange_rate, true)
    list_employees_salary = sum_other_payments_salary(list_employees_salary, list_other_payments_constitute_salary)
    list_other_payments = get_other_payment(list_employees_salary, payroll_log, payroll_currency, exchange_rate, false)
    list_employees_deductions = get_deductions_employees(list_employees_salary, payroll_log, payroll_currency, exchange_rate)
    detail_report = check_salaries_deductions(list_employees_salary,list_employees_deductions)
    list_employees_work_benefits = get_work_benefits(list_employees_salary, payroll_log, payroll_currency, exchange_rate)
    sum_work_benefits_non_provisioned(list_employees_salary, list_employees_work_benefits)

    result = {}
    
    if detail_report.empty?
      salaries  = list_employees_salary.values.sum
      
      # Save information, close the payroll and close deductions
      ActiveRecord::Base.transaction do

        # Get date
        date = payroll_log.payroll.payment_date

        # Deductions
        save_deduction_payments(date, payroll_log.payroll, list_employees_deductions)
        
        # Work Benefits
        save_work_benefits_payments(date, payroll_log.payroll, list_employees_work_benefits)
        
        # Other Payments
        save_other_payment_payments(date, payroll_log.payroll, list_other_payments)
	save_other_payment_payments(date, payroll_log.payroll, list_other_payments_constitute_salary)
    
        payroll_log.update_attributes(:exchange_rate => exchange_rate)
        
        p = payroll_log.payroll
        p.update_attributes(:state => false)

        result['status'] = true
        result['data'] = true
      end
    else
      result['status'] = false
      result['currency_symbol'] = currency_symbol
      result['data'] = detail_report
    end
    result
  end

  # Get the salary of each employee
  def self.get_salary_empoyees(payroll_log, payroll_currency, exchange_rate)
    list_employees_salary = {}
    
    payroll_log.payroll_histories.includes(task: :currency).each do |h|
      h.payroll_employees.each do |e|
        task_currency = h.task.currency.currency_type
      
        if list_employees_salary.has_key?(e.employee_id)
          list_employees_salary[e.employee_id] += check_currency(payroll_currency, task_currency, h.total.to_f, exchange_rate)
        else
          list_employees_salary[e.employee_id] = check_currency(payroll_currency, task_currency, h.total.to_f, exchange_rate)
        end
      end
    end
    list_employees_salary
  end

  # Get Other Payments of each employee
  def self.get_other_payment(list_employees, payroll_log, payroll_currency, exchange_rate, constitutes_salary)

    other_payment_details = {}
    list_other_payments = []
    list_employee_other_payments = {}
    
    list_employees.each do |id, salary|
      OtherPaymentEmployee.joins(:other_payment)
                          .where(:employee_id => id,
                                 :other_payments => {:constitutes_salary => constitutes_salary}).each do |ope|
        if ope.other_payment.state.to_s == OtherPayment::STATE_ACTIVE and !ope.completed
                    
          other_payment_details['other_payment_employee_id'] = ope.id
          other_payment_details['other_payment_id'] = ope.other_payment.id
          other_payment_details['other_payment_name'] = ope.other_payment.name
          other_payment_details['payment'] = 0
          other_payment_details['constitutes_salary'] = ope.other_payment.constitutes_salary
          other_payment_details['state'] = true
          other_payment_details['state_other_payment_employee'] = true
          add = true
          calculation = ope.other_payment.individual? ? ope.calculation : ope.other_payment.amount
          other_currency = ope.other_payment.currency.currency_type

          case ope.other_payment.other_payment_type.to_s
            # Constante
            when OtherPayment::DEDUCTION_TYPE_CONSTANT
              if ope.other_payment.payroll_type_ids.include? payroll_log.payroll.payroll_type_id
                
                # porcentual
                if ope.other_payment.calculation_type.to_s == OtherPayment::CALCULATION_TYPE_PERCENTAGE
                  other_payment_details['payment'] = (salary.to_f*calculation.to_f/100)
                end

                # fija
                if ope.other_payment.calculation_type.to_s == OtherPayment::CALCULATION_TYPE_FIXED
                  other_payment_details['payment'] = check_currency(payroll_currency, other_currency, 
                                                                    calculation.to_f, exchange_rate)
                end
              else
                add = false
              end

            # Unica
            when OtherPayment::DEDUCTION_TYPE_UNIQUE

              if ope.other_payment.payroll_ids.include? payroll_log.payroll_id.to_i

                # porcentual
                if ope.other_payment.calculation_type.to_s == OtherPayment::CALCULATION_TYPE_PERCENTAGE
                  other_payment_details['payment'] = (salary.to_f*calculation.to_f/100)
                end

                # fija
                if ope.other_payment.calculation_type.to_s == OtherPayment::CALCULATION_TYPE_FIXED
                  other_payment_details['payment'] = check_currency(payroll_currency, other_currency,
                                                                    calculation.to_f, exchange_rate)
                                                                    
                end
                other_payment_details['state'] = false
                other_payment_details['state_other_payment_employee'] = false
              else
                add = false
              end
          end

          if add
            list_other_payments << other_payment_details
            list_employee_other_payments[id] = list_other_payments
          end
        end
        other_payment_details = {}
      end
      list_other_payments = []
    end

    list_employee_other_payments
  end

  # Sum other payments to the salary only if ("is_salary") 
  def self.sum_other_payments_salary(list_employees, list_other_payments)

    new_list_employee_salary = {}
    
    list_employees.each do |employee_id, salary|
      new_list_employee_salary[employee_id] = salary.to_f

      if list_other_payments.key?(employee_id)   
        list_other_payments[employee_id].each do |other_payment|
          if new_list_employee_salary.has_key?(employee_id)
            new_list_employee_salary[employee_id] += other_payment['payment'].to_f
          else              
            new_list_employee_salary[employee_id] = other_payment['payment'].to_f
          end
        end
      end
    end
    new_list_employee_salary
  end
  
  def self.sum_work_benefits_non_provisioned(list_employees, list_work_benefits)
    list_employees.each do |employee_id, salary|
      if list_work_benefits.has_key?(employee_id)
        list_work_benefits[employee_id].each do |work_benefit|
          unless work_benefit['provisioning']
            list_employees[employee_id] += work_benefit['payment'].to_f
          end
        end
      end
    end
  end

  # Get the deduction of each employee (Calculations)
  def self.get_deductions_employees(list_employees, payroll_log, payroll_currency, exchange_rate)
    
    keys = [
      Deduction::DEDUCTION_TYPE_CONSTANT,
      Deduction::DEDUCTION_TYPE_UNIQUE,
      Deduction::DEDUCTION_TYPE_EXHAUST
    ]
    
    keys = "'#{keys.join("','")}'"

    deduction_details = {}
    list_deductions = []
    list_employees_deductions = {}

    list_employees.each do |id, salary|
      DeductionEmployee.includes(deduction: :deduction_currency, employee: :entity)
                       .where(:employee_id => id)
                       .order("field(deductions.deduction_type, #{keys})")
                       .each do |de|
        
        if de.deduction.state.to_s == Deduction::STATE_ACTIVE and !de.completed
          deduction_details['deduction_employee_id'] = de.id
          deduction_details['deduction_id'] = de.deduction.id
          deduction_details['deduction_description'] = de.deduction.description
          deduction_details['employee_name'] = de.employee.entity.full_name
          deduction_details['previous_balance'] = 0
          deduction_details['payment'] = 0
          deduction_details['current_balance'] = 0
          deduction_details['state'] = true
          deduction_details['state_deduction_employee'] = true
          add = true
          
          case de.deduction.deduction_type.to_s
            # Constante
            when Deduction::DEDUCTION_TYPE_CONSTANT
              
              if de.deduction.payroll_type_ids.include? payroll_log.payroll.payroll_type_id

                # porcentual
                if de.deduction.calculation_type.to_s == Deduction::CALCULATION_TYPE_PERCENTAGE
                  percentage = (salary.to_f*de.calculation_value/100)
                  
                  deduction_value = check_currency(payroll_currency, de.maximum_deduction_currency,
                                                   percentage, exchange_rate)
                  
                  maximum_deduction = check_currency(payroll_currency, de.maximum_deduction_currency,
                                                     de.maximum_deduction_value, exchange_rate)
                  
                  deduction_amount = check_maximum_deduction(deduction_value, de.maximum_deduction_value)
                  deduction_details['payment'] = deduction_amount
                end

                # fija
                if de.deduction.calculation_type.to_s == Deduction::CALCULATION_TYPE_FIXED
                  deduction_details['payment'] = check_currency(payroll_currency, de.deduction_currency,
                                                                de.calculation_value, exchange_rate)
                end
              else
                add = false
              end

            # Unica
            when Deduction::DEDUCTION_TYPE_UNIQUE

              if de.deduction.payroll_ids.include? payroll_log.payroll_id.to_i

                # porcentual
                if de.deduction.calculation_type.to_s == Deduction::CALCULATION_TYPE_PERCENTAGE
                  percentage = (salary.to_f*de.calculation_value/100)
                  deduction_value = check_currency(payroll_currency, de.maximum_deduction_currency,
                                                   percentage, exchange_rate)
                  
                  maximum_deduction = check_currency(payroll_currency, de.maximum_deduction_currency,
                                                     de.maximum_deduction_value, exchange_rate)
                  
                  deduction_details['payment'] = check_maximum_deduction(deduction_value, de.maximum_deduction_value)
                end

                # fija
                if de.deduction.calculation_type.to_s == Deduction::CALCULATION_TYPE_FIXED
                  deduction_details['payment'] = check_currency(payroll_currency, de.deduction_currency,
                                                                de.calculation_value, exchange_rate)
                end

                deduction_details['state'] = false
                deduction_details['state_deduction_employee'] = false
              else
                add = false
              end

            # Monto_Agotar
            when Deduction::DEDUCTION_TYPE_EXHAUST
              if de.deduction.payroll_type_ids.include? payroll_log.payroll.payroll_type_id
                
                amount_exhaust = check_currency(payroll_currency, de.amount_exhaust_currency,
                                                de.amount_exhaust_value, exchange_rate)
                payment = 0
                
                if de.deduction.calculation_type.to_s == Deduction::CALCULATION_TYPE_FIXED
                  payment = check_currency(payroll_currency, de.deduction_currency,
                                           de.calculation_value, exchange_rate)
                end
                
                if de.deduction.calculation_type.to_s == Deduction::CALCULATION_TYPE_PERCENTAGE
                  percentage = (salary.to_f*de.calculation_value/100)
                  
                  deduction_value = check_currency(payroll_currency, de.maximum_deduction_currency,
                                                   percentage, exchange_rate)
                  
                  maximum_deduction = check_currency(payroll_currency, de.maximum_deduction_currency,
                                                     de.maximum_deduction_value, exchange_rate)
                  
                  payment = check_maximum_deduction(deduction_value, de.maximum_deduction_value)
                end
                
                if de.deduction_payments.blank?
                  deduction_details['previous_balance'] = amount_exhaust
                  deduction_details['current_balance'] = (amount_exhaust - de.calculation_value)
                  deduction_details['payment'] = payment
                else
                  current_balance = 0
                  
                  if de.deduction.calculation_type.to_s == Deduction::CALCULATION_TYPE_FIXED
                    current_balance = check_currency(payroll_type, de.deduction_currency_type, 
                                                     de.last_payment, exchange_rate)
                  end
                              
                  if de.deduction.calculation_type.to_s == Deduction::CALCULATION_TYPE_PERCENTAGE
                    current_balance = (salary.to_f*de.last_payment/100)
                  end
                  
                  deduction_details['current_balance'] = 0
                  deduction_details['payment'] = current_balance
                  deduction_details['previous_balance'] = current_balance

                  if current_balance >= payment
                    deduction_details['current_balance'] = (current_balance - payment)
                    deduction_details['payment'] = payment
                  end 

                  if deduction_details['current_balance'].to_f == 0
                    deduction_details['state_deduction_employee'] = false
                    deduction_details['state'] = false
                  end
                end
              else
                add = false
            end
          end
          
          unless deduction_details['payment'] <= salary.to_f
            if Deduction::DEDUCTION_TYPE_EXHAUST == de.deduction.deduction_type.to_s
              deduction_details['current_balance'] = current_balance
            end
          end
          
          list_deductions << deduction_details if add
          list_employees_deductions[id] = list_deductions if add
        end

        deduction_details = {}
      end

      list_deductions = []
    end
    
    list_employees_deductions
  end

  # Get the work benefits (Calculations)
  def self.get_work_benefits(list_employees, payroll_log, payroll_currency, exchange_rate)

    work_benefits_details = {}
    list_work_benefits = []
    list_employees_work_benefits = {}

    list_employees.each do |id, salary|
      EmployeeBenefit.includes(work_benefit: [:currency]).where(:employee_id => id).each do |eb|
        if eb.work_benefit.state.to_s == WorkBenefit::STATE_ACTIVE and !eb.completed
          if eb.work_benefit.payroll_type_ids.include? payroll_log.payroll.payroll_type_id
            
            calculation = eb.work_benefit.individual? ? eb.calculation : eb.work_benefit.work_benefits_value
            
            if eb.work_benefit.calculation_type.to_s == WorkBenefit::CALCULATION_TYPE_FIXED
              work_benefits_details['payment'] = check_currency(payroll_currency,
                                                                eb.work_benefit.currency.currency_type, 
                                                                calculation.to_f, exchange_rate)
            end
                  
            if eb.work_benefit.calculation_type.to_s == WorkBenefit::CALCULATION_TYPE_PERCENTAGE
              work_benefits_details['payment'] = (salary.to_f*calculation.to_f/100)
            end
          
            work_benefits_details['employee_benefits_id'] = eb.id
      	    work_benefits_details['provisioning'] = eb.work_benefit.provisioning
            list_work_benefits << work_benefits_details
          end
        end
        work_benefits_details = {}
      end

      list_employees_work_benefits[id] = list_work_benefits
      list_work_benefits = []
    end

    list_employees_work_benefits
  end

  # Check salaries between deductions
  def self.check_salaries_deductions(list_salaries, list_deductions)
    
    detail_report = {}
    total_salary = 0
    
    list_deductions.each do |id, details|
      total_salary = list_salaries[id]
      total_deductions = 0
      detail_employee = {}

      details.each do |detail|
        total_deductions += detail['payment']
        detail_employee['employee_name'] = detail['employee_name']
      end
      
      if total_salary < total_deductions
        detail_employee['total_salary'] = total_salary
        detail_employee['total_deductions'] = total_deductions
        detail_report[id] = detail_employee
      end
    end
    detail_report
  end

  # Save the deductions information
  def self.save_deduction_payments(date, payroll, list_employees_deductions)
    payments = 0

    list_employees_deductions.each do |id, deductions|
      deductions.each do |deduction|
        deduction_payment = DeductionPayment.new
        deduction_payment.deduction_employee_id = deduction['deduction_employee_id']
        deduction_payment.payment_date = date
        deduction_payment.previous_balance = deduction['previous_balance']
        deduction_payment.payment = deduction['payment']
        deduction_payment.current_balance = deduction['current_balance']
        deduction_payment.payroll = payroll
        deduction_payment.currency = payroll.currency
        deduction_payment.save
        payments += deduction['payment']

        if deduction['state'] == false
          d = Deduction.find(deduction['deduction_id'])
          d.update_column(:state, Deduction::STATE_COMPLETED)
        end

        if deduction['state_deduction_employee'] == false
          de = DeductionEmployee.find(deduction['deduction_employee_id'])
          de.update_attributes(:completed => true)
        end
      end
    end
    payments
  end

  # Save the work benefits
  def self.save_work_benefits_payments(date, payroll, list_employees_work_benefits)
    payments = 0
    
    list_employees_work_benefits.each do |id, work_benefits|
      work_benefits.each do |benefits|
        work_benefits_payments = WorkBenefitsPayment.new
        work_benefits_payments.employee_benefits_id = benefits['employee_benefits_id'].to_i
        work_benefits_payments.payroll = payroll
        work_benefits_payments.currency = payroll.currency
        work_benefits_payments.payment_date = date
	      work_benefits_payments.provisioning = benefits['provisioning']
        work_benefits_payments.payment = benefits['payment']
        work_benefits_payments.save
        payments += benefits['payment']
      end
    end
    payments
  end

  # Save the other payments
  def self.save_other_payment_payments(date, payroll, list_other_payments)
    
    list_other_payments.each do |id, other_payments|

      other_payments.each do |other_payment|

        other_payment_payments = OtherPaymentPayment.new
        other_payment_payments.other_payment_employee_id = other_payment['other_payment_employee_id']
        other_payment_payments.payroll = payroll
        other_payment_payments.currency = payroll.currency
        other_payment_payments.payment_date = date
        other_payment_payments.payment = other_payment['payment']
        other_payment_payments.is_salary = other_payment['constitutes_salary']
        other_payment_payments.save

        if other_payment['state'] == false
          op = OtherPayment.find(other_payment['other_payment_id'])
          op.update_column(:state, OtherPayment::STATE_COMPLETED)
        end

        if other_payment['state_other_payment_employee'] == false
          ope = OtherPaymentEmployee.find(other_payment['other_payment_employee_id'])
          ope.update_attributes(:completed => true)
        end
      end
    end
  end
  
  # Send the information to Firebird.
  def self.send_to_firebird(payroll_id, username)

    result = false
    num_oper = get_number_operation
    num_oper_2 = get_number_operation
    num_oper_3 = get_number_operation
    num_oper_4 = get_number_operation

    payroll = Payroll.find(payroll_id)

    # Part 1

    # Save into OPRMAEST
    r1 = save_in_oprmaest(num_oper, payroll, username, PROCESS_ONE)

    # Save into OPRPLA5_BASE
    r2 = save_in_oprpla5_base(num_oper, payroll)

    # Save into OPRPLA5_DETALLE
    r3 = save_in_oprpla5_detalle(num_oper, payroll)

    # Save into OPRFPAGO
    r4 = save_in_oprfpago(num_oper, payroll)
    
    # Part 2

    # Save into OPRMAEST
    r5 = save_in_oprmaest(num_oper_2, payroll, username, PROCESS_TWO)

    # Save into OPRMOV1_BASE
    r6 = save_in_oprmov1_base(num_oper_2, payroll)

    # Save into OPRMOV1_DETALLE - Other Payments
    r7 = save_in_oprmov1_details_other_payments(num_oper_2, payroll)

    # Part 3
    
    # Save into OPRMAEST
    r8 = save_in_oprmaest(num_oper_3, payroll, username, PROCESS_THREE)
    
    # Save into OPRMOV1_BASE
    r9 = save_in_oprmov1_base(num_oper_3, payroll)

    # Save into OPRMOV1_DETALLE - Deductions
    r10 = save_in_oprmov1_details_deductions(num_oper_3, payroll)

    # Part 4

    # Save into OPRMAEST
    r11 = save_in_oprmaest(num_oper_4, payroll, username, PROCESS_FOUR)

    # Save into OPRMOV1_BASE
    r12 = save_in_oprmov1_base(num_oper_4, payroll)

    # Save into OPRMOV1_DETALLE - Work Benefits
    r13 = save_in_oprmov1_details_work_benefits(num_oper_4, payroll)

    # Save into the payroll table the num_oper..
    if r1 and r2 and r3 and r4 and r5 and r6 and r7 and r8 and r9 and r10 and r11 and r12 and r13
      # Update Number Operation
      payroll.num_oper = num_oper
      payroll.num_oper_2 = num_oper_2
      payroll.num_oper_3 = num_oper_3
      payroll.num_oper_4 = num_oper_4
      payroll.save
      # Update autoincrement number by company
      company = payroll.company
      company.inum += 1
      company.save
      result = true
    end
    result
  end

  # Get the number operation to save information into the database Firebird
  def self.get_number_operation

    # Get actual db
    current_database = ActiveRecord::Base.connection_config
    
    # Change the database and create the query
    co = ActiveRecord::Base.establish_connection :firebird
    result = co.connection.exec_query('SELECT GEN_ID(GEN_OPRMAEST_INUMOPER,1) FROM RDB$DATABASE').to_a

    # Restore the previous database
    ActiveRecord::Base.establish_connection(current_database)

    # Return the ID (INUMOPER)
    result[0][0]
  end

  # Save into Firebird: OPRMAEST (Part 1, Part 2, Part 3 and Part 4)
  def self.save_in_oprmaest(num_oper, payroll, username, process)

    date = DateTime.now

    transaction do
      oprm = Oprmaest.new
      oprm.iemp = payroll.company.code
      oprm.inumoper = num_oper
      oprm.fsoport = payroll.end_date.strftime("%d.%m.%Y")
      inumsop = Oprmaest.get_inumsop(payroll.end_date, payroll.company.inum)
      oprm.inumsop = inumsop

      if process == PROCESS_ONE
        oprm.itdoper = Oprmaest::ITDOPER
        # To do: Improve using relations and remove support_id and search
        support_id = payroll.payroll_type.cod_doc_payroll_support
        oprm.itdsop = Support.find(support_id).itdsop
        oprm.snumsop = payroll.payroll_type.mask_doc_payroll_support.split('-')[0] + "-#{inumsop}"
        oprm.tdetalle = "Costos de MDO de la planilla #{payroll.payroll_type.description} " + 
                        "del #{payroll.start_date} al #{payroll.end_date}"
        oprm.isucursal = Oprmaest::ISUCURSAL
        oprm.isede = Oprmaest::ISEDE
        oprm.iimagen = Oprmaest::IIMAGEN
        oprm.iws = Oprmaest::IWS
      end

      if process == PROCESS_TWO
        oprm.itdoper = Oprmaest::ITDOPER2
        # To do: Improve using relations and remove support_id and search
        support_id = payroll.payroll_type.cod_doc_accounting_support_mov
        oprm.itdsop = Support.find(support_id).itdsop
        oprm.snumsop = payroll.payroll_type.mask_doc_accounting_support_mov.split('-')[0] + "-#{inumsop}"
        oprm.tdetalle = "Otros Pagos de la planilla #{payroll.payroll_type.description} " +
                        "del #{payroll.start_date} al #{payroll.end_date}"
      end

      if process == PROCESS_THREE
        oprm.itdoper = Oprmaest::ITDOPER2
        # To do: Improve using relations and remove support_id and search
        support_id = payroll.payroll_type.cod_doc_accounting_support_mov
        oprm.itdsop = Support.find(support_id).itdsop
        oprm.snumsop = payroll.payroll_type.mask_doc_accounting_support_mov.split('-')[0] + "-#{inumsop}"
        oprm.tdetalle = "Deducciones de la planilla #{payroll.payroll_type.description} " + 
                        "del #{payroll.start_date} al #{payroll.end_date}"
      end

      if process == PROCESS_FOUR
        oprm.itdoper = Oprmaest::ITDOPER2
        # To do: Improve using relations and remove support_id and search
        support_id = payroll.payroll_type.cod_doc_accounting_support_mov
        oprm.itdsop = Support.find(support_id).itdsop
        oprm.snumsop = payroll.payroll_type.mask_doc_accounting_support_mov.split('-')[0] + "-#{inumsop}"
        oprm.tdetalle = "Prestaciones de la planilla #{payroll.payroll_type.description} " + 
                        "del #{payroll.start_date} al #{payroll.end_date}"
      end

      oprm.iclasifop = Oprmaest::ICLASIFOP
      oprm.fanio = payroll.end_date.year
      oprm.fmes = payroll.end_date.strftime("%m")
      oprm.fdia = payroll.end_date.strftime("%d")
      oprm.fsemana = payroll.end_date.cweek
      oprm.iusuarioult = username
      oprm.iprocess = Oprmaest::IPROCESS
      oprm.iestado = Oprmaest::IESTADO
      oprm.banulada = Oprmaest::BANULADA
      oprm.bimpresa = Oprmaest::BIMPRESA
      oprm.mdebitos = Oprmaest::MDEBITOS
      oprm.mcreditos = Oprmaest::MCREDITOS
      oprm.qmovcnt = Oprmaest::QMOVCNT
      oprm.qmovinv = Oprmaest::QMOVINV
      oprm.qmovord = Oprmaest::QMOVORD
      oprm.fcreacionusr = date
      oprm.fcreacion = date
      oprm.fultima = date
      oprm.iusuario = username
      oprm.iejecucion = Oprmaest::IEJECUCION
      oprm.imoneda = Oprmaest::IMONEDA
      oprm.bmovmanual = Oprmaest::BMOVMANUAL
      oprm.save
    end
  end

  # Save into Firebird: OPRPLA5_BASE (Part 1)
  def self.save_in_oprpla5_base(num_oper, payroll)
    transaction do
      oprpla5_base = Oprpla5Base.new
      oprpla5_base.iemp = payroll.company.code
      oprpla5_base.inumoper = num_oper
      oprpla5_base.bpagocxp = Oprpla5Base::BPAGOCXP
      oprpla5_base.itipocosteo = Oprpla5Base::ITIPOCOSTEO
      oprpla5_base.bprocesopordia = Oprpla5Base::BPROCESOPORDIA
      oprpla5_base.brendimcmp = Oprpla5Base::BRENDIMCMP
      oprpla5_base.qregctolabor = Oprpla5Base::QREGCTOLABOR
      oprpla5_base.qregctos = Oprpla5Base::QREGCTOS
      oprpla5_base.qregfpagodcto1 = Oprpla5Base::QREGFPAGODCTO1
      oprpla5_base.qregfpagodcto2 = Oprpla5Base::QREGFPAGODCTO2
      oprpla5_base.qregfpagodcto3 = Oprpla5Base::QREGFPAGODCTO3
      oprpla5_base.qregfpagodcto4 = Oprpla5Base::QREGFPAGODCTO4
      oprpla5_base.qregfpagopagador = Oprpla5Base::QREGFPAGOPAGADOR
      oprpla5_base.save
    end
  end

  # Save into Firebird: OPRPLA5_DETALLE (Part 1)
  def self.save_in_oprpla5_detalle(num_oper, payroll)
    count = 0
    transaction do      

      PayrollHistory.list_to_oprpla5_detalle(payroll.id).each do |a|
        od = Oprpla5Detalle.new
        od.iemp = payroll.company.code
        od.inumoper = num_oper
        od.ilinea = count
        od.itdcontrato = a[:payment_type]
        od.icclunes = a[:costs_center_id]
        od.iactividadlunes = a[:iactivity]
        od.ilaborlunes = a[:itask]
        od.qjorslunes = a[:time_worked]
        od.qcantlunes = [:performance]
        od.bcantdesclunes =  Oprpla5Detalle::BCANTDESCLUNES
        od.qtotaljors = a[:time_worked]
        od.qtotalcant = a[:performance]
        od.mvrtotal = a[:total]
        od.mtotalapagar = a[:total]
        od.qfactor =  a[:factor]
        od.ilineamov = Oprpla5Detalle::ILINEAMOV
        od.save
        count = count + 1
      end
    end
  end

  # Save into Firebird: OPRFPAGO (Part 1)
  def self.save_in_oprfpago(num_oper, payroll)
    transaction do
      oprfpago = Oprfpago.new
      oprfpago.iemp = payroll.company.code
      oprfpago.inumoper = num_oper
      oprfpago.itipofpago = Oprfpago::ITIPOFPAGO
      oprfpago.idfpago = Oprfpago::IDFPAGO
      oprfpago.id = Oprfpago::ID
      oprfpago.init = payroll.payroll_type.payer_employee.entity.entityid
      oprfpago.icuenta = payroll.payroll_type.ledger_account.iaccount
      oprfpago.mvalor = payroll.payroll_log.payroll_total
      oprfpago.save
    end
  end

  # Save into Firebird: OPRMOV1_BASE (Part 2, Part 3 and Part 4)
  def self.save_in_oprmov1_base(num_oper, payroll)
    transaction do
      oprmov1_base = Oprmov1Base.new
      oprmov1_base.iemp = payroll.company.code
      oprmov1_base.inumoper = num_oper
      oprmov1_base.save
    end
  end

  # Save into Firebird: OPRMOV1_DETALLE (Part 2)
  def self.save_in_oprmov1_details_other_payments(num_oper, payroll)
    
    count = 1
    total_other_payments = 0
    company_code = payroll.company.code

    inumsop = Oprmaest.get_inumsop(payroll.end_date, payroll.company.inum)
    snumsop = payroll.payroll_type.mask_doc_payroll_support.split('-')[0] + "-#{inumsop}"

    transaction do

      OtherPaymentPayment.where('payroll_id = ?', payroll.id).each do |opp|
        
        employee_code = opp.other_payment_employee.employee.entity.entityid

        od = Oprmov1Detalle.new
        od.iemp = company_code
        od.inumoper = num_oper
        od.ilinea = count
        od.icc = opp.other_payment_employee.other_payment.costs_center.icost_center
        od.icuenta = opp.other_payment_employee.other_payment.ledger_account.iaccount
        od.tdetalle = opp.other_payment_employee.other_payment.name
        od.init = employee_code
        od.fsoport = payroll.end_date.strftime("%d.%m.%Y")
        od.fpagocxx = payroll.payment_date.strftime("%d.%m.%Y")
        od.initcxx = employee_code
        od.mdebito = opp.payment
        od.save
        
        total_other_payments += opp.payment
        count += 1
      end

      od_last = Oprmov1Detalle.new
      od_last.iemp = company_code
      od_last.inumoper = num_oper
      od_last.ilinea = count
      od_last.icuenta = payroll.payroll_type.ledger_account.iaccount
      od_last.mcredito = total_other_payments
      od_last.initcxx = payroll.payroll_type.payer_employee.entity.entityid
      od_last.inumsopcxx = snumsop
      od_last.fsoport = payroll.end_date.strftime("%d.%m.%Y")
      od_last.fpagocxx = payroll.payment_date.strftime("%d.%m.%Y")
      od_last.save
    end
  end

  # Save into Firebird: OPRMOV1_DETALLE (Part 3) 
  def self.save_in_oprmov1_details_deductions(num_oper, payroll)

    transaction do
      count = 1
      total_deductions = DeductionPayment.where('payroll_id = ?', payroll.id).sum(:payment)
      inumsop = Oprmaest.get_inumsop(payroll.end_date, payroll.company.inum)

      DeductionPayment.where('payroll_id = ?', payroll.id).each do |dp|

        od = Oprmov1Detalle.new
        od.iemp = payroll.company.code
        od.inumoper = num_oper
        od.ilinea = count
        od.icuenta = payroll.payroll_type.ledger_account.iaccount if count == 1
        od.icuenta = dp.deduction_employee.deduction.ledger_account.iaccount unless count == 1
        od.tdetalle = dp.deduction_employee.deduction.description

        od.init = ''
        od.initcxx = ''
        if dp.deduction_employee.deduction.creditor_id
          creditor_id = dp.deduction_employee.deduction.creditor.creditor_id
          od.init = creditor_id
          od.initcxx = creditor_id
        end
        
        od.fsoport = payroll.end_date.strftime("%d.%m.%Y")
        od.fpagocxx = payroll.payment_date.strftime("%d.%m.%Y")
        od.mdebito = total_deductions if count == 1
        od.mcredito = dp.payment
        od.inumsopcxx = payroll.payroll_type.mask_doc_accounting_support_mov.split('-')[0] + "-#{inumsop}"
        od.save

        count = count + 1
      end

      od_last = Oprmov1Detalle.new
      od_last.iemp = payroll.company.code
      od_last.inumoper = num_oper
      od_last.ilinea = count
      od_last.init = payroll.payroll_type.payer_employee.entity.entityid
      od_last.fsoport = payroll.end_date.strftime("%d.%m.%Y")
      od_last.fpagocxx = payroll.payment_date.strftime("%d.%m.%Y")
      od_last.initcxx = payroll.payroll_type.payer_employee.entity.entityid
      od_last.save
    end
  end

  # Save into Firebird: Oprmov1_detalle (Part 4)
  def self.save_in_oprmov1_details_work_benefits(num_oper, payroll)
    
    count = 0

    inumsop = Oprmaest.get_inumsop(payroll.end_date, payroll.company.inum)
    inumsopcxx = payroll.payroll_type.mask_doc_accounting_support_mov.split('-')[0] + "-#{inumsop}"

    transaction do
      WorkBenefitsPayment.where('payroll_id = ?', payroll.id).each do |wb|

        od_debit = Oprmov1Detalle.new
        od_credit = Oprmov1Detalle.new
        work_benefit = wb.employee_benefit.work_benefit
        
        # D E B I T
        count += 1
        od_debit.iemp = payroll.company.code
        od_debit.inumoper = num_oper
        od_debit.ilinea = count
        od_debit.icc = work_benefit.costs_center.icost_center
        # To do: Improve using relations and remove search
        od_debit.icuenta = LedgerAccount.find(work_benefit.debit_account).iaccount
        od_debit.tdetalle = work_benefit.name
        od_debit.init = wb.employee_benefit.employee.entity.entityid
        od_debit.fsoport = payroll.end_date.strftime("%d.%m.%Y")
        od_debit.fpagocxx = payroll.payment_date.strftime("%d.%m.%Y")
        # To do: Improve using relations and remove search
        od_credit.initcxx = Creditor.find(work_benefit.creditor_id).creditor_id if work_benefit.creditor_id
        od_debit.mdebito = wb.payment
        od_debit.inumsopcxx = inumsopcxx
        od_debit.save
        
        # C R E D I T
        count += 1
        od_credit.iemp = payroll.company.code
        od_credit.inumoper = num_oper
        od_credit.ilinea = count
        od_credit.icc = work_benefit.costs_center.icost_center
        # To do: Improve using relations and remove search
        od_credit.icuenta = LedgerAccount.find(work_benefit.credit_account).iaccount if work_benefit.credit_account
        od_credit.tdetalle = work_benefit.name

        if work_benefit.pay_to_employee
          od_credit.init = wb.employee_benefit.employee.entity.entityid
        else
          # To do: Improve using relations and remove search
          od_credit.init = Creditor.find(work_benefit.creditor_id).creditor_id
        end

        od_credit.fsoport = payroll.end_date.strftime("%d.%m.%Y")
        od_credit.fpagocxx = payroll.payment_date.strftime("%d.%m.%Y")
        # To do: Improve using relations and remove search
        od_credit.initcxx = Creditor.find(work_benefit.creditor_id).creditor_id if work_benefit.creditor_id
        od_credit.mcredito = wb.payment
        od_credit.inumsopcxx = inumsopcxx
        od_credit.save
      end
    end
  end

  def self.search_payrolls_to_reports(start_date, end_date, company_id, page, per_page)
    query = ""
    params = []
    params.push(" start_date >= '#{start_date.to_date.strftime("%Y-%m-%d")}' ") unless start_date.empty?
    params.push(" end_date <= '#{end_date.to_date.strftime("%Y-%m-%d")}' ") unless end_date.empty?
    params.push(" state = 0 ")
    params.push(" company_id = '#{company_id}' ")
    query = build_query(params)
    @payrolls = Payroll.where(query).paginate(:page => page, :per_page => per_page)
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

  def self.get_main_calendar(d_start, d_end, company_id)
    Payroll.joins(:payroll_type, :payroll_log)
           .select('payroll_logs.id, payrolls.start_date, payrolls.end_date, 
                    payrolls.payment_date, payroll_types.description, payroll_types.calendar_color')
           .where("payrolls.start_date >= ? and payrolls.end_date <= ? and payrolls.company_id = '?' and payrolls.state = ?",
                  DateTime.parse(d_start), DateTime.parse(d_end), company_id, true)
  end
  
  # verifies deduction value does not overexceed the maximum deduction restriction
  # when payment type is percentage
  def self.check_maximum_deduction(amount, maximum_deduction)
    amount > maximum_deduction ? maximum_deduction : amount
  end
  
  def self.reopen_payroll(id)
    payroll = Payroll.includes(:payroll_log, :work_benefits_payments, :work_benefits_payments,
                              :deduction_payment => {:deduction_employee => :deduction}, 
                              :other_payment_payment => {:other_payment_employee => :other_payment})
                     .find(id)
    
    transaction do
    
      payroll.deduction_payment.each do |deduction_payment| 
        if deduction_payment.deduction_employee.deduction.state == :completed
          deduction_payment.deduction_employee.deduction.update_column :state, :active
        end
        
        if deduction_payment.deduction_employee.completed
          deduction_payment.deduction_employee.update_column :completed, false
        end
        
        deduction_payment.destroy
      end
      
      payroll.other_payment_payment.each do |other_payment|
        if other_payment.other_payment_employee.other_payment.state == :completed
          other_payment.other_payment_employee.other_payment.update_column :state, :active
        end
        
        if other_payment.other_payment_employee.completed
          other_payment.other_payment_employee.update_column :completed, false
        end
        
        other_payment.destroy
      end
      
      payroll.work_benefits_payments.destroy_all
      
      payroll.payroll_log.update_attributes :exchange_rate => nil
      payroll.update_column :state, true
    end
  end
end
