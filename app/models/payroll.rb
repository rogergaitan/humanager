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

  scope :activas, where(state: true)
  scope :inactivas, where(state: false)
  #consulta todas las planillas para un tipo de planilla especifico especifico
  #scope :tipo_planilla, lambda {|type_payroll| joins(:payroll_type).where("payroll_type = ?", type_payroll).
  #	select(['payroll_type', 'description']) }


  def self.close_payroll(payroll_id)
    
    list_employees_salary = get_salary_empoyees(payroll_id)
    list_employees_deductions = get_deductions_employees(list_employees_salary)
    list_employees_deductions
    
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

  # Get the deduction of each employee
  # FALTA terminar - Monto_Agotar preguntar si se termino de pagar...
  def self.get_deductions_employees(list_employees)
    
    deduction_details = {}
    list_deductions = []
    list_employees_deductions = {}

    list_employees.each do |id,salary|

      DeductionEmployee.where(:employee_id => id).each do |de|
        
        if de.deduction.state

          deduction_details['deduction_employee_id'] = de.id
          deduction_details['deduction_id'] = de.deduction.id
          deduction_details['deduction_description'] = de.deduction.description
          deduction_details['employee_name'] = de.employee.entity.name
          deduction_details['previous_balance'] = 0
          deduction_details['payment'] = 0
          deduction_details['current_balance'] = 0
          deduction_details['state'] = true

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
              
            # Monto_Agotar
            when CONSTANTS[:DEDUCTION][2]["name"].to_s

              # fija
              if de.deduction.calculation_type.to_s == CONSTANTS[:CALCULATION_TYPE][1]["name"].to_s
                if de.deduction.deduction_payrolls.blank?
                  deduction_details['previous_balance'] = de.deduction.amount_exhaust.to_f
                  deduction_details['current_balance'] = (de.deduction.amount_exhaust.to_f - de.deduction.calculation.to_f)
                else
                  deduction_details['previous_balance'] = de.deduction.deduction_payrolls.last.current_balance.to_f
                  deduction_details['current_balance'] = (de.deduction.deduction_payrolls.last.current_balance.to_f - de.deduction.calculation.to_f)
                end
                deduction_details['payment'] = de.deduction.calculation.to_f
              end
              
          end # end case

          list_deductions << deduction_details
          list_employees_deductions[id] = list_deductions
        end # end if

        deduction_details = {}
      end # end DeductionEmployee

      list_deductions = []
    end # end each list_employees

    list_employees_deductions
  end

  # Cheack salaries between deductions
  def self.check_salaries_deductions(list_saliaries, list_deductions)
    
    total_deductions = 0
    total_salary = 0
    detail_report = {}
    

    list_deductions.each do |id, details|

      total_salary = list_saliaries[id]

      details.each do |detail|
        total_deductions += detail['payment']
      end # End details

      if total_salary < total_deductions
        #detail_report[] = 
      end

    end # End list_deductions

  end

end