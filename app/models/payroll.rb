class Payroll < ActiveRecord::Base

  attr_accessible :end_date, :payment_date, :payroll_type_id, :start_date, :state, :num_oper
  belongs_to :payroll_type
  belongs_to :deduction_payment
  has_many :deduction_payrolls, :dependent => :destroy
  has_many :deductions, :through => :deduction_payrolls
  validates :payroll_type_id, :presence => true
  validates :start_date, :presence => true
  validates :end_date, :presence => true
  validates :payment_date, :presence => true

  has_one :payroll_log, :dependent => :destroy
  
  accepts_nested_attributes_for :payroll_log

  has_many :payroll_logs
  has_many :work_benefits_payments

  scope :activas, where(state: true)
  scope :inactivas, where(state: false)
  #consulta todas las planillas para un tipo de planilla especifico especifico
  #scope :tipo_planilla, lambda {|type_payroll| joins(:payroll_type).where("payroll_type = ?", type_payroll).
  #	select(['payroll_type', 'description']) }

  # Close the payroll
  def self.close_payroll(payroll_id)

    list_employees_salary = get_salary_empoyees(payroll_id)
    list_employees_deductions = get_deductions_employees(list_employees_salary)
    list_employees_work_benefits = get_work_benefits(list_employees_salary)
    detail_report = check_salaries_deductions(list_employees_salary,list_employees_deductions)

    result = {}

    if detail_report.empty?
      # Save information, close the payroll and close deductions

      # Deductions
      save_information_payroll(payroll_id, list_employees_deductions)
      
      # Work Benefits
      save_work_benefits_payments(payroll_id, list_employees_work_benefits)

      result['status'] = true
      result['data'] = true

    else
      result['status'] = false
      result['data'] = detail_report
    end
    result
  end

  # Get the salary of each employee
  def self.get_salary_empoyees(payroll_id)
    
    payroll_log = PayrollLog.find_by_payroll_id(payroll_id)

    list_histories = payroll_log.payroll_histories
    list_employees_salary = {}

    list_histories.each do |h|
      h.payroll_employees.each do |e|
        if list_employees_salary.has_key?(e.employee_id)
          list_employees_salary[e.employee_id] += h.total.to_f
        else
          list_employees_salary[e.employee_id] = h.total.to_f
        end
      end # end each h.payroll_employees
    end # end each list_histories
    list_employees_salary    
  end

  # Get the deduction of each employee (Calculations)
  def self.get_deductions_employees(list_employees)
    
    deduction_details = {}
    list_deductions = []
    list_employees_deductions = {}

    list_employees.each do |id, salary|

      DeductionEmployee.where(:employee_id => id).each do |de|
        
        if de.deduction.state and de.state

          deduction_details['deduction_employee_id'] = de.id
          deduction_details['deduction_id'] = de.deduction.id
          deduction_details['deduction_description'] = de.deduction.description
          deduction_details['employee_name'] = de.employee.entity.name
          deduction_details['previous_balance'] = 0
          deduction_details['payment'] = 0
          deduction_details['current_balance'] = 0
          deduction_details['state'] = true
          deduction_details['state_deduction_employee'] = true

          case de.deduction.deduction_type.to_s
            
            # Constante
            when CONSTANTS[:DEDUCTION][0]["name"].to_s

              # porcentual
              if de.deduction.calculation_type.to_s == CONSTANTS[:CALCULATION_TYPE][0]["name"].to_s
                deduction_details['payment'] = (salary.to_f*de.deduction.calculation.to_f/100)
              end

              # fija
              if de.deduction.calculation_type.to_s == CONSTANTS[:CALCULATION_TYPE][1]["name"].to_s
                deduction_details['payment'] = de.deduction.calculation.to_f
              end

            # Unica
            when CONSTANTS[:DEDUCTION][1]["name"].to_s

              # fija
              if de.deduction.calculation_type.to_s == CONSTANTS[:CALCULATION_TYPE][1]["name"].to_s
                deduction_details['payment'] = de.deduction.calculation.to_f
              end

              deduction_details['state'] = false
              deduction_details['state_deduction_employee'] = false
              
            # Monto_Agotar
            when CONSTANTS[:DEDUCTION][2]["name"].to_s

              # fija
              if de.deduction.calculation_type.to_s == CONSTANTS[:CALCULATION_TYPE][1]["name"].to_s

                if de.deduction_payments.blank?
                  deduction_details['previous_balance'] = de.deduction.amount_exhaust.to_f
                  deduction_details['current_balance'] = (de.deduction.amount_exhaust.to_f - de.deduction.calculation.to_f)
                  deduction_details['payment'] = de.deduction.calculation.to_f
                else

                  if de.deduction_payments.last.current_balance.to_f >= de.deduction.calculation.to_f
                    deduction_details['current_balance'] = (de.deduction_payments.last.current_balance.to_f - de.deduction.calculation.to_f)
                    deduction_details['payment'] = de.deduction.calculation.to_f
                    deduction_details['previous_balance'] = de.deduction_payments.last.current_balance.to_f
                  else
                    deduction_details['current_balance'] = 0
                    deduction_details['payment'] = de.deduction_payments.last.current_balance.to_f
                    deduction_details['previous_balance'] = de.deduction_payments.last.current_balance.to_f
                  end 

                  if deduction_details['current_balance'].to_f == 0
                    deduction_details['state_deduction_employee'] = false
                    deduction_details['state'] = false
                  end

                end

              end
              
          end # end case

          list_deductions << deduction_details
          list_employees_deductions[id] = list_deductions
        end # end if states

        deduction_details = {}
      end # end DeductionEmployee

      list_deductions = []
    end # end each list_employees

    list_employees_deductions
  end

  # Cheack salaries between deductions
  def self.check_salaries_deductions(list_saliaries, list_deductions)
    
    detail_report = {}
    total_salary = 0
    
    list_deductions.each do |id, details|

      total_salary = list_saliaries[id]
      total_deductions = 0
      detail_employee = {}

      details.each do |detail|
        total_deductions += detail['payment']
        detail_employee['employee_name'] = detail['employee_name']
      end # End details

      if total_salary < total_deductions
        detail_employee['total_salary'] = total_salary 
        detail_employee['total_deductions'] = total_deductions
        detail_report[id] = detail_employee
      end

    end # End list_deductions
    detail_report
  end

  # Save the deductions information
  def self.save_information_payroll(payroll_id, list_employees_deductions)
    
    date = Payroll.find(payroll_id, :select=>"payment_date")

    list_employees_deductions.each do |id, deductions|

      deductions.each do |deduction|

        deduction_payment = DeductionPayment.new
        deduction_payment.deduction_employee_id = deduction['deduction_employee_id']
        deduction_payment.payment_date = date['payment_date']
        deduction_payment.previous_balance = deduction['previous_balance']
        deduction_payment.payment = deduction['payment']
        deduction_payment.current_balance = deduction['current_balance']
        deduction_payment.payroll_id = payroll_id
        deduction_payment.save

        if deduction['state'] == false
          d = Deduction.find(deduction['deduction_id'])
          d.update_attributes(:state => false)
        end

        if deduction['state_deduction_employee'] == false
          de = DeductionEmployee.find(deduction['deduction_employee_id'])
          de.update_attributes(:state => false)
        end
      
      end # End each deductions

      p = Payroll.find(payroll_id)
      p.update_attributes(:state => false)

    end # End each list_employees_deductions
  end

  # Get the work benefits (Calculations)
  def self.get_work_benefits(list_employees)

    work_benefits_details = {}
    list_work_benefits = []
    list_employees_work_benefits = {}

    list_employees.each do |id, salary|

      EmployeeBenefit.where(:employee_id => id).each do |eb|
        
        work_benefits_details['employee_benefits_id'] = eb.id
        work_benefits_details['percentage'] = eb.work_benefit.percentage.to_f
        work_benefits_details['payment'] = (salary.to_f*eb.work_benefit.percentage.to_f/100)

        list_work_benefits << work_benefits_details
        work_benefits_details = {}
      end # End each work_benefits

      list_employees_work_benefits[id] = list_work_benefits
      list_work_benefits = []

    end # End each list_employees

    list_employees_work_benefits
  end

  # Save the work benefits
  def self.save_work_benefits_payments(payroll_id, list_employees_work_benefits)

    date = Payroll.find(payroll_id, :select=>"payment_date")

    list_employees_work_benefits.each do |id, work_benefits|
      
      work_benefits.each do |benefits|

        work_benefits_payments = WorkBenefitsPayment.new
        work_benefits_payments.employee_benefits_id = benefits['employee_benefits_id'].to_i
        work_benefits_payments.payroll_id = payroll_id.to_i
        work_benefits_payments.payment_date = date['payment_date']
        work_benefits_payments.percentage = benefits['percentage']
        work_benefits_payments.payment = benefits['payment']
        work_benefits_payments.save

      end # End each work_benefits
    end # End each list_employees_work_benefits
  end

  def self.send_to_firebird(payroll_id)
    puts '############### E M P E Z A M O S ###############'
    num_oper = get_number_operation
    puts 'num_oper'
    puts num_oper

    payroll = Payroll.find(payroll_id)

    # Save into OPRMAEST
    r1 =  save_in_oprmaest(num_oper, payroll)
    
    # Save into Oprmov1Base
    r2 = save_in_oprmov1_base(num_oper)

    # Save into Oprmov1Detalle
    r3 = save_in_oprmov1_detalle_deductions(num_oper, payroll)
    puts 'oprmov1_deductions'
    puts r3

    count = DeductionPayment.where('payroll_id = ?', payroll.id).count
    count = count + 1

    r4 = save_in_oprmov1_detalle_work_benefits(num_oper, payroll, count)
    puts 'oprmov1_benefits'
    puts r4

    puts '############### T E R M I N A M O S  ###############'

    # Save into Oprmov1Detalle

    if r1 and r2 and r3 and r4
      puts 'todo BIEN salvado'
      # INSERTAR DENTRO DEL PAYROLL EL NUM_OPER Y REFRESCAR LA PAGINA
    else 
      puts 'todo MAL salvado'
    end

  end

  # Get the number operation to save information into the database firebird
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

  def self.save_in_oprmaest(num_oper, payroll)

    t = Time.new
    date = t.strftime("%d.%m.%Y, %T.%L")

    transaction do
      oprmaest = Oprmaest.new
      oprmaest.iemp = CONSTANTS[:FIREBIRD][0]['IEMP']
      oprmaest.inumoper = num_oper
      oprmaest.fsoport = payroll['end_date'].strftime("%d.%m.%Y")
      oprmaest.itdoper = CONSTANTS[:FIREBIRD][0]['ITDOPER']
      oprmaest.itdsop = CONSTANTS[:FIREBIRD][0]['ITDSOP']
      oprmaest.inumsop = payroll['id']
      oprmaest.snumsop = "MRH-" + (sprintf '%04d', payroll['id'])
      oprmaest.iclasifop = CONSTANTS[:FIREBIRD][0]['ICLASIFOP']
      oprmaest.fsemana = payroll['end_date'].cweek
      oprmaest.tdetalle = payroll.payroll_type.description + " del " + payroll['start_date'].to_s + " al " + payroll['end_date'].to_s
      oprmaest.imoneda = CONSTANTS[:FIREBIRD][0]['IMONEDA']
      oprmaest.isede = CONSTANTS[:FIREBIRD][0]['ISEDE']
      oprmaest.iusuarioult = CONSTANTS[:FIREBIRD][0]['IUSUARIOULT']
      oprmaest.iprocess = CONSTANTS[:FIREBIRD][0]['IPROCESS']
      oprmaest.iestado = CONSTANTS[:FIREBIRD][0]['IESTADO']
      oprmaest.banulada = CONSTANTS[:FIREBIRD][0]['BANULADA']
      oprmaest.bimpresa = CONSTANTS[:FIREBIRD][0]['BIMPRESA']
      oprmaest.mdebitos = CONSTANTS[:FIREBIRD][0]['MDEBITOS']
      oprmaest.mcreditos = CONSTANTS[:FIREBIRD][0]['MCREDITOS']
      oprmaest.qmovcnt = CONSTANTS[:FIREBIRD][0]['QMOVCNT']
      oprmaest.qmovinv = CONSTANTS[:FIREBIRD][0]['QMOVINV']
      oprmaest.qmovord = CONSTANTS[:FIREBIRD][0]['QMOVORD']
      oprmaest.iimagen = CONSTANTS[:FIREBIRD][0]['IIMAGEN']
      oprmaest.fcreacionusr = date
      oprmaest.iws = CONSTANTS[:FIREBIRD][0]['IWS']
      oprmaest.fcreacion = date
      oprmaest.fultima = date
      oprmaest.iusuario = CONSTANTS[:FIREBIRD][0]['IUSUARIO']
      oprmaest.iejecucion = CONSTANTS[:FIREBIRD][0]['IEJECUCION']
      oprmaest.bmovmanual = CONSTANTS[:FIREBIRD][0]['BMOVMANUAL']
      oprmaest.save
    end
  end

  def self.save_in_oprmov1_base(num_oper)

    transaction do
      oprmov1_base = Oprmov1Base.new
      oprmov1_base.iemp = CONSTANTS[:FIREBIRD][0]['IEMP']
      oprmov1_base.inumoper = num_oper
      oprmov1_base.save
    end
  end

  def self.save_in_oprmov1_detalle_deductions(num_oper, payroll)

    # DEDUCTIONS

    transaction do
      count = 1
      total_deductions = 0

      DeductionPayment.where('payroll_id = ?', payroll.id).each do |dp|

        od = Oprmov1Detalle.new
        od.iemp = CONSTANTS[:FIREBIRD][0]['IEMP']
        od.inumoper = num_oper
        od.ilinea = count
        od.icuenta = dp.deduction_employee.deduction_id
        od.init = dp.deduction_employee.employee_id
        od.fsoport = payroll['end_date'].strftime("%d.%m.%Y")

        if dp.deduction_employee.deduction.is_beneficiary
          od.initcxx = dp.deduction_employee.employee_id
        else
          od.initcxx = dp.deduction_employee.deduction.beneficiary_id
        end

        od.fpagocxx = payroll['payment_date'].strftime("%d.%m.%Y")
        od.mdebito = dp.payment
        total_deductions = total_deductions + dp.payment
        od.inumsopcxx = "MRH-" + (sprintf '%04d', payroll['id'])
        od.save

        count = count + 1
      end # End each DeductionPayment

      od_last = Oprmov1Detalle.new
      od_last.iemp = CONSTANTS[:FIREBIRD][0]['IEMP']
      od_last.inumoper = num_oper
      od_last.ilinea = count + 1
      od_last.icuenta = CONSTANTS[:FIREBIRD][0]['ICUENTA']
      od_last.fsoport = payroll['end_date'].strftime("%d.%m.%Y")
      od_last.fpagocxx = payroll['payment_date'].strftime("%d.%m.%Y")
      od_last.mdebito = total_deductions
      od_last.inumsopcxx = "MRH-" + (sprintf '%04d', payroll['id'])
      od_last.save
    end # End transaction

    # DEDUCTIONS
  end

  def self.save_in_oprmov1_detalle_work_benefits(num_oper, payroll, count)
    
    # WORK BENEFITS

    transaction do
      count = count
      WorkBenefitsPayment.where('payroll_id = ?', payroll.id).each do |wb|

        od_debit = Oprmov1Detalle.new
        od_credit = Oprmov1Detalle.new

        # D E B I T
        od_debit.iemp = CONSTANTS[:FIREBIRD][0]['IEMP']
        od_debit.inumoper = num_oper
        od_debit.ilinea = count
        od_debit.icuenta = wb.employee_benefit.work_benefit.debit_account
        od_debit.init = wb.employee_benefit.employee_id
        od_debit.fsoport = payroll['end_date'].strftime("%d.%m.%Y")
        od_debit.fpagocxx = payroll['payment_date'].strftime("%d.%m.%Y")
        od_debit.mdebito = wb.payment
        od_debit.inumsopcxx = "MRH-" + (sprintf '%04d', payroll['id'])
        od_debit.save
        # D E B I T
        
        # C R E D I T
        od_credit.iemp = CONSTANTS[:FIREBIRD][0]['IEMP']
        od_credit.inumoper = num_oper
        od_credit.ilinea = count + 1
        od_credit.icuenta = wb.employee_benefit.work_benefit.credit_account

        if wb.employee_benefit.work_benefit.is_beneficiary
          od_credit.init = wb.employee_benefit.employee_id
          od_credit.initcxx = wb.employee_benefit.employee_id
        else
          od_credit.init = wb.employee_benefit.work_benefit.beneficiary_id
          od_credit.initcxx = wb.employee_benefit.work_benefit.beneficiary_id
        end
        od_credit.fsoport = payroll['end_date'].strftime("%d.%m.%Y")
        od_credit.fpagocxx = payroll['payment_date'].strftime("%d.%m.%Y")
        od_credit.mcredito = wb.payment
        od_credit.inumsopcxx = "MRH-" + (sprintf '%04d', payroll['id'])
        od_credit.save
        # C R E D I T
        
        count = count + 2
      end # End each WorkBenefitsPayments
    end # End transaction

    # WORK BENEFITS
  end

end