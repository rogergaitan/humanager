class Payroll < ActiveRecord::Base

  attr_accessible :end_date, :payment_date, :payroll_type_id, :start_date, :state
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
      
      #Work Benefits
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

                  deduction_details['previous_balance'] = de.deduction_payments.last.current_balance.to_f

                  if de.deduction_payments.last.current_balance.to_f >= de.deduction.calculation.to_f
                    deduction_details['current_balance'] = (de.deduction_payments.last.current_balance.to_f - de.deduction.calculation.to_f)
                  else
                    deduction_details['current_balance'] = de.deduction_payments.last.current_balance.to_f
                    deduction_details['payment'] = de.deduction_payments.last.current_balance.to_f
                    deduction_details['state'] = true
                    deduction_details['state_deduction_employee'] = true
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

        if deduction['state_deduction_employee']
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
        # work_benefits_details['description'] = eb.work_benefit.description
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

end