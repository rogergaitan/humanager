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
    
    num_oper = get_number_operation
    puts 'num_oper'
    puts num_oper

    payroll = Payroll.find(payroll_id)
    puts 'part-1'

    # Save into OPRMAEST
    result_oprmaest =  save_in_oprmaest(num_oper, payroll)
    puts 'part-2'
    # Save into OPRMAEST
    
    # Save into Oprmov1Base
    result_oprmov1_base = save_in_oprmov1_base(num_oper)
    puts 'part-3'
    # Save into Oprmov1Base

    # Save into Oprmov1Detalle
    # result_oprmov1_detalle = save_in_oprmov1_detalle
    # Save into Oprmov1Detalle

    if result_oprmaest and result_oprmov1_base
      # INSERTAR DENTRO DEL PAYROLL EL NUM_OPER Y REFRESCAR LA PAGINA
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
      oprmaest.snumsop = "MRH-"+ (sprintf '%04d', payroll['id'])
      oprmaest.iclasifop = CONSTANTS[:FIREBIRD][0]['ICLASIFOP']
      # oprmaest.fanio = payroll['end_date'].year AUTOMATICO
      # oprmaest.fmes = payroll['end_date'].month AUTOMATICO
      # oprmaest.fdia = payroll['end_date'].day AUTOMATICO
      oprmaest.fsemana = payroll['end_date'].cweek
      oprmaest.tdetalle = payroll.payroll_type.description+" del "+payroll['start_date'].to_s+" al "+payroll['end_date'].to_s
      # oprmaest.iccbase = CONSTANTS[:FIREBIRD][0]['ICCBASE']
      oprmaest.imoneda = CONSTANTS[:FIREBIRD][0]['IMONEDA']
      oprmaest.isede = CONSTANTS[:FIREBIRD][0]['ISEDE']
      oprmaest.iusuarioult = CONSTANTS[:FIREBIRD][0]['IUSUARIOULT']
      # oprmaest.init = CONSTANTS[:FIREBIRD][0]['INIT']
      oprmaest.iprocess = CONSTANTS[:FIREBIRD][0]['IPROCESS']
      oprmaest.iestado = CONSTANTS[:FIREBIRD][0]['IESTADO']
      # oprmaest.inumoperultimp ['INUMOPERULTIMP'] = CONSTANTS[:FIREBIRD][0]['INUMOPERULTIMP']
      # oprmaest.fprocesam = CONSTANTS[:FIREBIRD][0]['FPROCESAM']
      # oprmaest.qerror = CONSTANTS[:FIREBIRD][0]['QERROR']
      # oprmaest.qwarning = CONSTANTS[:FIREBIRD][0]['QWARNING']
      # oprmaest.busdetail = CONSTANTS[:FIREBIRD][0]['BUSRDETAIL']
      # oprmaest.bnodesproceso = CONSTANTS[:FIREBIRD][0]['BNODESPROCESO']
      oprmaest.banulada = CONSTANTS[:FIREBIRD][0]['BANULADA']
      oprmaest.bimpresa = CONSTANTS[:FIREBIRD][0]['BIMPRESA']
      # oprmaest.qimpresiones = CONSTANTS[:FIREBIRD][0]['QIMPRESIONES']
      # oprmaest.mingresos = CONSTANTS[:FIREBIRD][0]['MINGRESOS']
      # oprmaest.megresos = CONSTANTS[:FIREBIRD][0]['MEGRESOS']
      oprmaest.mdebitos = CONSTANTS[:FIREBIRD][0]['MDEBITOS']
      oprmaest.mcreditos = CONSTANTS[:FIREBIRD][0]['MCREDITOS']
      oprmaest.qmovcnt = CONSTANTS[:FIREBIRD][0]['QMOVCNT']
      oprmaest.qmovinv = CONSTANTS[:FIREBIRD][0]['QMOVINV']
      oprmaest.qmovord = CONSTANTS[:FIREBIRD][0]['QMOVORD']
      # oprmaest.zlog = CONSTANTS[:FIREBIRD][0]['ZLOG']
      # oprmaest.zcomentar = CONSTANTS[:FIREBIRD][0]['ZCOMENTAR']
      # oprmaest.idrvversion = CONSTANTS[:FIREBIRD][0]['IDRVVERSION']
      oprmaest.iimagen = CONSTANTS[:FIREBIRD][0]['IIMAGEN']
      # oprmaest.irelease = CONSTANTS[:FIREBIRD][0]['IRELEASE']
      # oprmaest.sgrupousr = CONSTANTS[:FIREBIRD][0]['SGRUPOUSR']
      # oprmaest.itdformatoprinted = CONSTANTS[:FIREBIRD][0]['ITDFORMATOPRINTED']
      oprmaest.fcreacionusr = date
      # oprmaest.inumoperv3  = CONSTANTS[:FIREBIRD][0]['INUMOPERV3']
      oprmaest.iws = CONSTANTS[:FIREBIRD][0]['IWS']
      oprmaest.fcreacion = date
      # oprmaest.iwsult = CONSTANTS[:FIREBIRD][0]['IWSULT']
      oprmaest.fultima = date
      oprmaest.iusuario = CONSTANTS[:FIREBIRD][0]['IUSUARIO']
      oprmaest.iejecucion = CONSTANTS[:FIREBIRD][0]['IEJECUCION']
      oprmaest.bmovmanual = CONSTANTS[:FIREBIRD][0]['BMOVMANUAL']
      # oprmaest.isucurs = CONSTANTS[:FIREBIRD][0]['ISUCURS']
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

  def self.save_in_oprmov1_detalle(num_oper)

    # transaction do
    #   oprmov1_detalle = Oprmov1Detalle.new
    #   oprmov1_detalle.iemp = CONSTANTS[:FIREBIRD][0]['IEMP']
    #   oprmov1_detalle.inumoper = num_oper
    #   oprmov1_detalle.ilinea = 
    #   oprmov1_detalle.icc = 
    #   oprmov1_detalle.icuenta = 
    #   oprmov1_detalle.tdetalle = 
    #   oprmov1_detalle.mvrbase = 
    #   oprmov1_detalle.ibanco = 
    #   oprmov1_detalle.icheque = 
    #   oprmov1_detalle.init = 
    #   oprmov1_detalle.fsoport = 
    #   oprmov1_detalle.initcxx = 
    #   oprmov1_detalle.fpagocxx = 
    #   oprmov1_detalle.fvencimcxx = 
    #   oprmov1_detalle.mdebito = 
    #   oprmov1_detalle.mcredito = 
    #   oprmov1_detalle.iactivo = 
    #   oprmov1_detalle.inumsopcxx = 
    #   oprmov1_detalle.iflujoefec = 
    #   oprmov1_detalle.mvrotramoneda = 
    #   oprmov1_detalle.scomandos = 
    #   oprmov1_detalle.ilineamov = 
    #   oprmov1_detalle.valor1 = 
    #   oprmov1_detalle.valor2 = 
    #   oprmov1_detalle.clase1 = 
    #   oprmov1_detalle.clase2 = 
    # end # End transaction
  end


end