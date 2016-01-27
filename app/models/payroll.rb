class Payroll < ActiveRecord::Base

  attr_accessible :end_date, :payment_date, :payroll_type_id, :start_date, :state, :num_oper, :num_oper_2, :company_id
  belongs_to :payroll_type
  belongs_to :deduction_payment
  belongs_to :company
  has_many :deduction_payrolls, :dependent => :destroy
  has_many :deductions, :through => :deduction_payrolls

  # OTHER PAYMENTS
  has_many :other_payment_payrolls, :dependent => :destroy
  has_many :other_payments, :through => :other_payment_payrolls

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
  scope :inactivas, ->(company_id){ where(state: false, company_id: company_id)}
  
  #consulta todas las planillas para un tipo de planilla especifico especifico
  #scope :tipo_planilla, lambda {|type_payroll| joins(:payroll_type).where("payroll_type = ?", type_payroll).
  #	select(['payroll_type', 'description']) }

  # Close the payroll
  def self.close_payroll(payroll_id)

    payroll_log = PayrollLog.find_by_payroll_id(payroll_id)
    list_employees_salary = get_salary_empoyees(payroll_log)
    list_other_payment = get_other_payment(list_employees_salary, payroll_log)
    list_employees_salary = sum_other_payments_salary(list_employees_salary, list_other_payment)
    list_employees_deductions = get_deductions_employees(list_employees_salary, payroll_log)
    list_employees_work_benefits = get_work_benefits(list_employees_salary, payroll_log)
    detail_report = check_salaries_deductions(list_employees_salary,list_employees_deductions)
    
    result = {}

    if detail_report.empty?
      # Save information, close the payroll and close deductions
      ActiveRecord::Base.transaction do

        # Get date
        date = payroll_log.payroll.payment_date

        # Deductions
        save_deduction_payments(date, payroll_id, list_employees_deductions)
        
        # Work Benefits
        save_work_benefits_payments(date, payroll_id, list_employees_work_benefits)
        
        # Other Payments
        save_other_payment_payments(date, payroll_id, list_other_payment)

        p = payroll_log.payroll
        p.update_attributes(:state => false)

        result['status'] = true
        result['data'] = true
      end
    else
      result['status'] = false
      result['data'] = detail_report
    end
    result
  end

  # Get the salary of each employee
  def self.get_salary_empoyees(payroll_log)
    list_employees_salary = {}

    payroll_log.payroll_histories.each do |h|
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

  # Get Other Payments of each employee
  def self.get_other_payment(list_employees, payroll_log)

    other_payment_details = {}
    list_other_payments = []
    list_employee_other_payments = {}
    
    list_employees.each do |id, salary|

      OtherPaymentEmployee.where(:employee_id => id).each do |ope|
        
        if ope.other_payment.state === CONSTANTS[:PAYROLLS_STATES]['ACTIVE'].to_sym and !ope.completed

          other_payment_details['other_payment_employee_id'] = ope.id
          other_payment_details['other_payment_id'] = ope.other_payment.id
          other_payment_details['other_payment_name'] = ope.other_payment.description
          other_payment_details['payment'] = 0
          other_payment_details['constitutes_salary'] = ope.other_payment.constitutes_salary
          other_payment_details['state'] = true
          other_payment_details['state_other_payment_employee'] = true
          add = true

          case ope.other_payment.deduction_type.to_s
            # Constante
            when CONSTANTS[:DEDUCTION]["CONSTANTE"].to_s

              if ope.other_payment.payroll_type_ids.include? payroll_log.payroll.payroll_type_id
                # porcentual
                if ope.other_payment.calculation_type.to_s == CONSTANTS[:CALCULATION_TYPE]['PORCENTUAL'].to_s
                  other_payment_details['payment'] = (salary.to_f*ope.calculation.to_f/100)
                end

                # fija
                if ope.other_payment.calculation_type.to_s == CONSTANTS[:CALCULATION_TYPE]['FIJA'].to_s
                  other_payment_details['payment'] = ope.calculation.to_f
                end
              else
                add = false
              end

            # Unica
            when CONSTANTS[:DEDUCTION]["UNICA"].to_s

              if ope.other_payment.payroll_ids.include? payroll_log.payroll_id.to_i

                # porcentual
                if ope.other_payment.calculation_type.to_s == CONSTANTS[:CALCULATION_TYPE]['PORCENTUAL'].to_s
                  other_payment_details['payment'] = (salary.to_f*ope.calculation.to_f/100)
                end

                # fija
                if ope.other_payment.calculation_type.to_s == CONSTANTS[:CALCULATION_TYPE]['FIJA'].to_s
                  other_payment_details['payment'] = ope.calculation.to_f
                end
                other_payment_details['state'] = false
                other_payment_details['state_other_payment_employee'] = false
              else
                add = false
              end
          end # End Case

          if add
            list_other_payments << other_payment_details
            list_employee_other_payments[id] = list_other_payments
          end
        end # End if states
        other_payment_details = {}
      end # OtherPaymentEmployee
      list_other_payments = []
    end # list_employees

    list_employee_other_payments
  end

  # Sum other payments to the salary only if ("is_salary") 
  def self.sum_other_payments_salary(list_employees, list_other_payments)

    new_list_employee_salary = {}
    
    list_employees.each do |employee_id, salary|
      
      new_list_employee_salary[employee_id] = salary.to_f
      
      if list_other_payments.key?(employee_id)
        list_other_payments[employee_id].each do |other_payment|
          if other_payment['constitutes_salary']
            if new_list_employee_salary.has_key?(employee_id)
              new_list_employee_salary[employee_id] += other_payment['payment'].to_f
            else
              new_list_employee_salary[employee_id] = other_payment['payment'].to_f
            end
          end
        end
      end
    end

    new_list_employee_salary
  end

  # Get the deduction of each employee (Calculations)
  def self.get_deductions_employees(list_employees, payroll_log)
    
    deduction_details = {}
    list_deductions = []
    list_employees_deductions = {}

    list_employees.each do |id, salary|

      DeductionEmployee.where(:employee_id => id).each do |de|
        
        if de.deduction.state === CONSTANTS[:PAYROLLS_STATES]['ACTIVE'].to_sym and !de.completed

          deduction_details['deduction_employee_id'] = de.id
          deduction_details['deduction_id'] = de.deduction.id
          deduction_details['deduction_description'] = de.deduction.description
          deduction_details['employee_name'] = de.employee.entity.name
          deduction_details['previous_balance'] = 0
          deduction_details['payment'] = 0
          deduction_details['current_balance'] = 0
          deduction_details['state'] = true
          deduction_details['state_deduction_employee'] = true
          add = true

          case de.deduction.deduction_type.to_s
            
            # Constante
            when CONSTANTS[:DEDUCTION]["CONSTANTE"].to_s
              
              if de.deduction.payroll_type_ids.include? payroll_log.payroll.payroll_type_id

                # porcentual
                if de.deduction.calculation_type.to_s == CONSTANTS[:CALCULATION_TYPE]['PORCENTUAL'].to_s
                  deduction_details['payment'] = (salary.to_f*de.calculation.to_f/100)
                end

                # fija
                if de.deduction.calculation_type.to_s == CONSTANTS[:CALCULATION_TYPE]['FIJA'].to_s
                  deduction_details['payment'] = de.calculation.to_f
                end
              else
                add = false
              end

            # Unica
            when CONSTANTS[:DEDUCTION]["UNICA"].to_s

              if de.deduction.payroll_ids.include? payroll_log.payroll_id.to_i

                # porcentual
                if de.deduction.calculation_type.to_s == CONSTANTS[:CALCULATION_TYPE]['PORCENTUAL'].to_s
                  deduction_details['payment'] = (salary.to_f*de.calculation.to_f/100)
                end

                # fija
                if de.deduction.calculation_type.to_s == CONSTANTS[:CALCULATION_TYPE]['FIJA'].to_s
                  deduction_details['payment'] = de.calculation.to_f
                end

                deduction_details['state'] = false
                deduction_details['state_deduction_employee'] = false
              else
                add = false
              end

            # Monto_Agotar
            when CONSTANTS[:DEDUCTION]["MONTO_AGOTAR"].to_s
              
              if de.deduction.payroll_type_ids.include? payroll_log.payroll.payroll_type_id
                # fija
                if de.deduction.calculation_type.to_s == CONSTANTS[:CALCULATION_TYPE]['FIJA'].to_s

                  if de.deduction_payments.blank?
                    deduction_details['previous_balance'] = de.deduction.amount_exhaust.to_f
                    deduction_details['current_balance'] = (de.deduction.amount_exhaust.to_f - de.calculation.to_f)
                    deduction_details['payment'] = de.calculation.to_f
                  else
                    if de.deduction_payments.last.current_balance.to_f >= de.calculation.to_f
                      deduction_details['current_balance'] = (de.deduction_payments.last.current_balance.to_f - de.calculation.to_f)
                      deduction_details['payment'] = de.calculation.to_f
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
              else
                add = false
              end
          end # end case
          
          if add
            list_deductions << deduction_details
            list_employees_deductions[id] = list_deductions
          end
        end # end if states

        deduction_details = {}
      end # end DeductionEmployee

      list_deductions = []
    end # end each list_employees

    list_employees_deductions
  end

  # Get the work benefits (Calculations)
  def self.get_work_benefits(list_employees, payroll_log)

    work_benefits_details = {}
    list_work_benefits = []
    list_employees_work_benefits = {}

    list_employees.each do |id, salary|

      EmployeeBenefit.where(:employee_id => id).each do |eb|
        
        if eb.work_benefit.state === CONSTANTS[:PAYROLLS_STATES]['ACTIVE'].to_sym and !eb.completed
          if eb.work_benefit.payroll_type_ids.include? payroll_log.payroll.payroll_type_id
            work_benefits_details['employee_benefits_id'] = eb.id
            work_benefits_details['percentage'] = eb.work_benefit.percentage.to_f
            work_benefits_details['payment'] = (salary.to_f*eb.work_benefit.percentage.to_f/100)
            list_work_benefits << work_benefits_details
          end
        end
        work_benefits_details = {}
      end # End each work_benefits

      list_employees_work_benefits[id] = list_work_benefits
      list_work_benefits = []
    end # End each list_employees

    list_employees_work_benefits
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
  def self.save_deduction_payments(date, payroll_id, list_employees_deductions)

    list_employees_deductions.each do |id, deductions|

      deductions.each do |deduction|

        deduction_payment = DeductionPayment.new
        deduction_payment.deduction_employee_id = deduction['deduction_employee_id']
        deduction_payment.payment_date = date
        deduction_payment.previous_balance = deduction['previous_balance']
        deduction_payment.payment = deduction['payment']
        deduction_payment.current_balance = deduction['current_balance']
        deduction_payment.payroll_id = payroll_id.to_i
        deduction_payment.save

        if deduction['state'] == false
          d = Deduction.find(deduction['deduction_id'])
          d.update_attributes(:state => CONSTANTS[:PAYROLLS_STATES]['COMPLETED'])
        end

        if deduction['state_deduction_employee'] == false
          de = DeductionEmployee.find(deduction['deduction_employee_id'])
          de.update_attributes(:completed => true)
        end
      end # End each deductions
    end # End each list_employees_deductions
  end

  # Save the work benefits
  def self.save_work_benefits_payments(date, payroll_id, list_employees_work_benefits)

    list_employees_work_benefits.each do |id, work_benefits|
      
      work_benefits.each do |benefits|

        work_benefits_payments = WorkBenefitsPayment.new
        work_benefits_payments.employee_benefits_id = benefits['employee_benefits_id'].to_i
        work_benefits_payments.payroll_id = payroll_id.to_i
        work_benefits_payments.payment_date = date
        work_benefits_payments.percentage = benefits['percentage']
        work_benefits_payments.payment = benefits['payment']
        work_benefits_payments.save
      end # End each work_benefits
    end # End each list_employees_work_benefits
  end

  # Save the other payments
  def self.save_other_payment_payments(date, payroll_id, list_other_payments)
    
    list_other_payments.each do |id, other_payments|

      other_payments.each do |other_payment|

        other_payment_payments = OtherPaymentPayment.new
        other_payment_payments.other_payment_employee_id = other_payment['other_payment_employee_id']
        other_payment_payments.payroll_id = payroll_id
        other_payment_payments.payment_date = date
        other_payment_payments.payment = other_payment['payment']
        other_payment_payments.is_salary = other_payment['constitutes_salary']
        other_payment_payments.save

        if other_payment['state'] == false
          op = OtherPayment.find(other_payment['other_payment_id'])
          op.update_attributes(:state => CONSTANTS[:PAYROLLS_STATES]['COMPLETED'])
        end

        if other_payment['state_other_payment_employee'] == false
          ope = OtherPaymentEmployee.find(other_payment['other_payment_employee_id'])
          ope.update_attributes(:completed => true)
        end
      end # End each other_payments
    end # End each list_other_payments
  end
  
  ##################################################################################################
  ##################################################################################################
  
  # Send the information to Firebird.
  def self.send_to_firebird(payroll_id, username)

    ############### E M P E Z A M O S ###############
    result = true
    num_oper = get_number_operation
    num_oper_2 = get_number_operation

    payroll = Payroll.find(payroll_id)
    num_count = DeductionPayment.where('payroll_id = ?', payroll.id).count
    num_count = num_count + 2

    # Save into OPRMAEST
    r1 = save_in_oprmaest(num_oper, payroll, username)

    # Save into Oprmov1Base
    r2 = save_in_oprmov1_base(num_oper)

    # Save into Oprmov1Detalle - Deductions
    r3 = save_in_oprmov1_details_deductions(num_oper, payroll)

    # Save into Oprmov1Detalle - Work Benefits
    r4 = save_in_oprmov1_details_work_benefits(num_oper, payroll, num_count)

    # Save into Oprmov1Detalle - Other Payments
    r5 = save_in_oprmov1_details_other_payments(num_oper, payroll, num_count) # KALFARO

    # Save into OPRMAEST (Process number 2)
    r6 = save_in_oprmaest_2(num_oper_2, payroll, username)

    # Save into OPRPLA5_BASE (Process number 2)
    r7 = save_in_oprpla5_base(num_oper_2, payroll)

    # Save into OPRPLA5_DETALLE (Process number 2)
    r8 = save_in_oprpla5_detalle(num_oper_2, payroll)

    # Save into the payroll table the num_oper and num_oper_2
    if r1 and r2 and r3 and r4 and r5 and r6 and r7 and r8
      payroll.num_oper = num_oper
      payroll.num_oper_2 = num_oper_2
      payroll.save
      result = true
    else 
      result = false
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

  # Save into Firebird: Oprmaest
  def self.save_in_oprmaest(num_oper, payroll, username)

    t = Time.new
    date = t.strftime("%d.%m.%Y, %T.%L")

    transaction do
      oprm = Oprmaest.new
      oprm.iemp = payroll.company.code
      oprm.inumoper = num_oper
      oprm.fsoport = payroll['end_date'].strftime("%d.%m.%Y")
      oprm.itdoper = CONSTANTS[:FIREBIRD][0]['ITDOPER']
      oprm.itdsop = payroll.payroll_type.cod_doc_payroll_support
      oprm.inumsop = payroll['id']
      oprm.snumsop = "#{payroll.payroll_type.mask_doc_payroll_support}-" + (sprintf '%04d', payroll['id'])
      oprm.iclasifop = CONSTANTS[:FIREBIRD][0]['ICLASIFOP']
      oprm.fsemana = payroll['end_date'].cweek
      oprm.tdetalle = "Otros Calculos Planilla " + payroll.payroll_type.description + " del " + payroll['start_date'].to_s + " hasta " + payroll['end_date'].to_s
      oprm.imoneda = CONSTANTS[:FIREBIRD][0]['IMONEDA']
      oprm.isede = CONSTANTS[:FIREBIRD][0]['ISEDE']
      oprm.iusuarioult = username
      oprm.iprocess = CONSTANTS[:FIREBIRD][0]['IPROCESS']
      oprm.iestado = CONSTANTS[:FIREBIRD][0]['IESTADO']
      oprm.banulada = CONSTANTS[:FIREBIRD][0]['BANULADA']
      oprm.bimpresa = CONSTANTS[:FIREBIRD][0]['BIMPRESA']
      oprm.mdebitos = CONSTANTS[:FIREBIRD][0]['MDEBITOS']
      oprm.mcreditos = CONSTANTS[:FIREBIRD][0]['MCREDITOS']
      oprm.qmovcnt = CONSTANTS[:FIREBIRD][0]['QMOVCNT']
      oprm.qmovinv = CONSTANTS[:FIREBIRD][0]['QMOVINV']
      oprm.qmovord = CONSTANTS[:FIREBIRD][0]['QMOVORD']
      oprm.iimagen = CONSTANTS[:FIREBIRD][0]['IIMAGEN']
      oprm.fcreacionusr = date
      oprm.iws = CONSTANTS[:FIREBIRD][0]['IWS']
      oprm.fcreacion = date
      oprm.fultima = date
      oprm.iusuario = username
      oprm.iejecucion = CONSTANTS[:FIREBIRD][0]['IEJECUCION']
      oprm.bmovmanual = CONSTANTS[:FIREBIRD][0]['BMOVMANUAL']
      oprm.save
    end
  end

  # Save into Firebird: Oprmov1_base
  def self.save_in_oprmov1_base(num_oper)

    transaction do
      oprmov1_base = Oprmov1Base.new
      oprmov1_base.iemp = CONSTANTS[:FIREBIRD][0]['IEMP']
      oprmov1_base.inumoper = num_oper
      oprmov1_base.save
    end
  end

  # Save into Firebird: Oprmov1_detalle (Part 1)
  def self.save_in_oprmov1_details_deductions(num_oper, payroll)

    # DEDUCTIONS
    transaction do
      count = 1
      total_deductions = 0

      DeductionPayment.where('payroll_id = ?', payroll.id).each do |dp|

        od = Oprmov1Detalle.new
        od.iemp = payroll.company.code
        od.inumoper = num_oper
        od.ilinea = count
        od.icuenta = dp.deduction_employee.deduction.ledger_account.iaccount
        od.init = dp.deduction_employee.employee.entity.entityid
        od.fsoport = payroll['end_date'].strftime("%d.%m.%Y")

        if dp.deduction_employee.deduction.is_beneficiary
          od.initcxx = dp.deduction_employee.employee.entity.entityid
        else
          od.initcxx = dp.deduction_employee.deduction.beneficiary_id
        end

        od.fpagocxx = payroll['payment_date'].strftime("%d.%m.%Y")
        od.mcredito = dp.payment
        total_deductions = total_deductions + dp.payment
        od.inumsopcxx = "MRH-" + (sprintf '%04d', payroll['id'])
        od.save

        count = count + 1
      end # End each DeductionPayment

      od_last = Oprmov1Detalle.new
      od_last.iemp = payroll.company.code
      od_last.inumoper = num_oper
      od_last.ilinea = count
      od_last.icuenta = payroll.payroll_type.ledger_account.iaccount
      od_last.fsoport = payroll['end_date'].strftime("%d.%m.%Y")
      od_last.fpagocxx = payroll['payment_date'].strftime("%d.%m.%Y")
      od_last.mdebito = total_deductions
      od_last.inumsopcxx = "MRH-" + (sprintf '%04d', payroll['id'])
      od_last.save

    end # End transaction
    # DEDUCTIONS
  end

  # Save into Firebird: Oprmov1_detalle (Part 2)
  def self.save_in_oprmov1_details_work_benefits(num_oper, payroll, num_count)
    
    # WORK BENEFITS
    count = num_count

    transaction do
      WorkBenefitsPayment.where('payroll_id = ?', payroll.id).each do |wb|

        od_debit = Oprmov1Detalle.new
        od_credit = Oprmov1Detalle.new

        # D E B I T
        od_debit.iemp = payroll.company.code
        od_debit.inumoper = num_oper
        od_debit.ilinea = count
        od_debit.icc = CostsCenter.find(wb.employee_benefit.work_benefit.costs_center_id).icost_center
        od_debit.icuenta =  LedgerAccount.find(wb.employee_benefit.work_benefit.debit_account).iaccount
        od_debit.init = wb.employee_benefit.employee.entity.entityid
        od_debit.fsoport = payroll['end_date'].strftime("%d.%m.%Y")
        od_debit.fpagocxx = payroll['payment_date'].strftime("%d.%m.%Y")
        od_debit.mdebito = wb.payment
        od_debit.inumsopcxx = "MRH-" + (sprintf '%04d', payroll['id'])
        od_debit.save
        # D E B I T
        
        # C R E D I T
        od_credit.iemp = payroll.company.code
        od_credit.inumoper = num_oper
        od_credit.ilinea = (count + 1)
        od_credit.icc = CostsCenter.find(wb.employee_benefit.work_benefit.costs_center_id).icost_center
        od_credit.icuenta = LedgerAccount.find(wb.employee_benefit.work_benefit.credit_account).iaccount

        if wb.employee_benefit.work_benefit.is_beneficiary
          od_credit.init = wb.employee_benefit.employee.entity.entityid
          od_credit.initcxx = wb.employee_benefit.employee.entity.entityid
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

  # Save into Firebird: Oprmov1_detalle (Part 3)
  def self.save_in_oprmov1_details_other_payments(num_oper, payroll, num_count)
    
    count = num_count
    total_other_payments = 0

    transaction do

      OtherPaymentPayment.where('payroll_id = ?', payroll.id).each do |opp|
        od = Oprmov1Detalle.new
        od.iemp = payroll.company.code
        od.inumoper = num_oper
        od.ilinea = count
        od.icc = opp.other_payment_employee.other_payment.costs_center.icost_center
        od.icuenta = opp.other_payment_employee.other_payment.ledger_account.iaccount
        od.init = opp.other_payment_employee.employee.entity.entityid
        od.fsoport = payroll.end_date.strftime("%d.%m.%Y")
        od.fpagocxx = payroll.payment_date.strftime("%d.%m.%Y")
        od.mdebito = opp.payment
        total_other_payments += opp.payment
        count += 1
      end # End each OtherPaymentPayment

      od_last = Oprmov1Detalle.new
      od_last.iemp = payroll.company.code
      od_last.inumoper = num_oper
      od_last.ilinea = count
      od_last.icuenta = payroll.payroll_type.ledger_account.iaccount
      od_last.fsoport = payroll.end_date.strftime("%d.%m.%Y")
      od_last.fpagocxx = payroll.payment_date.strftime("%d.%m.%Y")
      od_last.mdebito = total_other_payments
    end # End transaction
  end

  # Save into Firebird: Oprmaest (Process number 2)
  def self.save_in_oprmaest_2(num_oper, payroll, username)
    t = Time.new
    date = t.strftime("%d.%m.%Y, %T.%L")

    transaction do
      oprm = Oprmaest.new
      oprm.iemp = payroll.company.code
      oprm.inumoper = num_oper
      oprm.fsoport = payroll['end_date'].strftime("%d.%m.%Y")
      oprm.itdoper = CONSTANTS[:FIREBIRD][0]['ITDOPER2']
      oprm.itdsop = payroll.payroll_type.cod_doc_accounting_support_mov
      oprm.inumsop = payroll['id']
      oprm.snumsop = "#{payroll.payroll_type.mask_doc_accounting_support_mov}-" + (sprintf '%04d', payroll['id'])
      oprm.iclasifop = CONSTANTS[:FIREBIRD][0]['ICLASIFOP']
      oprm.fsemana = payroll['end_date'].cweek
      oprm.tdetalle = "Costos de MDO de la planilla " + payroll.payroll_type.description + " del " + payroll['start_date'].to_s + " al " + payroll['end_date'].to_s
      oprm.isede = CONSTANTS[:FIREBIRD][0]['ISEDE']
      oprm.iusuarioult = username
      oprm.iprocess = CONSTANTS[:FIREBIRD][0]['IPROCESS']
      oprm.iestado = CONSTANTS[:FIREBIRD][0]['IESTADO']
      oprm.banulada = CONSTANTS[:FIREBIRD][0]['BANULADA']
      oprm.bimpresa = CONSTANTS[:FIREBIRD][0]['BIMPRESA']
      oprm.mdebitos = CONSTANTS[:FIREBIRD][0]['MDEBITOS']
      oprm.mcreditos = CONSTANTS[:FIREBIRD][0]['MCREDITOS']
      oprm.qmovcnt = CONSTANTS[:FIREBIRD][0]['QMOVCNT']
      oprm.qmovinv = CONSTANTS[:FIREBIRD][0]['QMOVINV']
      oprm.qmovord = CONSTANTS[:FIREBIRD][0]['QMOVORD']
      oprm.fcreacionusr = date
      oprm.fcreacion = date
      oprm.fultima = date
      oprm.iusuario = username
      oprm.iejecucion = CONSTANTS[:FIREBIRD][0]['IEJECUCION']
      oprm.imoneda = CONSTANTS[:FIREBIRD][0]['IMONEDA']
      oprm.bmovmanual = CONSTANTS[:FIREBIRD][0]['BMOVMANUAL']
      oprm.save
    end
  end

  # Save into Firebird: OPRPLA5_BASE (Process number 2)
  def self.save_in_oprpla5_base(num_oper, payroll)
    
    transaction do
      oprpla5_base = Oprpla5Base.new
      oprpla5_base.iemp = payroll.company.code
      oprpla5_base.inumoper = num_oper
      oprpla5_base.icuentacaja = payroll.payroll_type.ledger_account.iaccount
      oprpla5_base.bpagocxp = CONSTANTS[:FIREBIRD][0]['BPAGOCXP']
      oprpla5_base.itipocosteo = CONSTANTS[:FIREBIRD][0]['ITIPOCOSTEO']
      oprpla5_base.bprocesopordia = CONSTANTS[:FIREBIRD][0]['BPROCESOPORDIA']
      oprpla5_base.brendimcmp = CONSTANTS[:FIREBIRD][0]['BRENDIMCMP']
      oprpla5_base.qregctolabor = CONSTANTS[:FIREBIRD][0]['QREGCTOLABOR']
      oprpla5_base.qregctos = CONSTANTS[:FIREBIRD][0]['QREGCTOS']
      oprpla5_base.qregfpagodcto1 = CONSTANTS[:FIREBIRD][0]['QREGFPAGODCTO1']
      oprpla5_base.qregfpagodcto2 = CONSTANTS[:FIREBIRD][0]['QREGFPAGODCTO2']
      oprpla5_base.qregfpagodcto3 = CONSTANTS[:FIREBIRD][0]['QREGFPAGODCTO3']
      oprpla5_base.qregfpagodcto4 = CONSTANTS[:FIREBIRD][0]['QREGFPAGODCTO4']
      oprpla5_base.qregfpagopagador = CONSTANTS[:FIREBIRD][0]['QREGFPAGOPAGADOR']
      oprpla5_base.save
    end # End transaction
  end

  # Save into Firebird: OPRPLA5_DETALLE (Process number 2)
  def self.save_in_oprpla5_detalle(num_oper, payroll)

    count = 0
    transaction do      

      PayrollHistory.list_to_oprpla5_detalle(payroll['id']).each do |a|

        od = Oprpla5Detalle.new
        od.iemp = payroll.company.code
        od.inumoper = num_oper
        od.ilinea = count
        od.itdcontrato = a['payment_type']
        od.icclunes = a['costs_center_id']
        od.iactividadlunes = CONSTANTS[:FIREBIRD][0]['IACTIVIDADLUNES']
        od.ilaborlunes = a['itask']
        od.qjorslunes = a['time_worked']
        od.qcantlunes = CONSTANTS[:FIREBIRD][0]['QCANTLUNES']
        od.bcantdesclunes = CONSTANTS[:FIREBIRD][0]['BCANTDESCLUNES']
        od.qtotaljors = a['time_worked']
        od.mvrtotal = a['total']
        od.mtotalapagar = a['total']
        od.qfactor = CONSTANTS[:FIREBIRD][0]['QFACTOR']
        od.ilineamov = CONSTANTS[:FIREBIRD][0]['ILINEAMOV']
        od.save
        count = count + 1
      end # End each PayrollHistory
    end # End transaction
  end

  def self.search_payrolls_to_reports(start_date, end_date, company_id, page, per_page)
      
      query = ""
      params = []
      params.push(" start_date >= '#{start_date}' ") unless start_date.empty?
      params.push(" end_date <= '#{end_date}' ") unless end_date.empty?
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
    
    where =  "payrolls.start_date BETWEEN '#{DateTime.parse(d_start)}' and '#{DateTime.parse(d_end)}' or "
    where += "payrolls.end_date BETWEEN '#{DateTime.parse(d_start)}' and '#{DateTime.parse(d_end)}' and "
    where += "payrolls.company_id = #{company_id} and "
    where += "payrolls.state = true"

    Payroll.joins(:payroll_type, :payroll_log)
    .select('payroll_logs.id, payrolls.start_date, payrolls.end_date, payrolls.payment_date, payroll_types.description')
    .where(where)
  end

end
