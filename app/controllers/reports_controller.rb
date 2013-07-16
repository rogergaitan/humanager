class ReportsController < ApplicationController

  before_filter :resources, :only => [:index, :general_payroll]
	respond_to :html, :json, :js

	def index
    @payrolls = Payroll.where('state = ?', 0)
  end

	def search_payrolls
    @payrolls = Payroll.search_payrolls_to_reports(params[:start_date], params[:end_date], params[:page], 5)
    respond_with @payrolls
  end

  def show

    case params[:type].to_s
      
      when CONSTANTS[:REPORTS][0]['PAYMENT_PROOF']
        
        @employees = params[:employees].split(",")
        @payroll = Payroll.find(params[:payroll_id])
        @msg = params[:msg]
        
        respond_to do |format|
          format.pdf do
            pdf = ProofPayEmployeesPDF.new(@payroll, @employees, @msg)
            send_data pdf.render, filename: "prueba.pdf",
              type: "application/pdf", disposition: "inline"
          end
        end

      when CONSTANTS[:REPORTS][0]['GENERAL_PAYROLL']

        @employees = params[:employees].split(",")
        @payroll_ids = params[:payroll_ids].split(",")
        @format = params[:format]

        @data = general_payroll_data(@payroll_ids, @employees)

        if @format.to_s == "pdf"

          respond_to do |format|
            format.pdf do
              pdf = GeneralPayrollPDF.new(@data, @payroll_ids)
              send_data pdf.render, filename: "prueba.pdf",
                type: "application/pdf", disposition: "inline"
            end
          end
          
        else
          puts "format exel"
        end        

    end # End case
  end # End show

  def general_payroll
    # @payrolls = Payroll.where('state = ?', 0)
  end

  def resources
    @department = Department.all
    @superior = Employee.superior
    @employees = Employee.order_employees
  end

  def general_payroll_data(payroll_ids, employees)

    list_deductions = Deduction.get_list_to_general_payment
    list_desc_deductions = {}
    employees_names = []
    list_payrolls = []
    totals = {}

    payroll_ids.each do |payroll_id|
      employees.each do |employee_id|

        detail = {}

        # G E T   E M P L O Y E   N A M E
        e = Employee.find(employee_id)
        name = {}
        index = nil
        name['Nombre Empleado'] = "#{e.entity.surname} #{e.entity.name}"
        
        if( employees_names.include? name )
          index = employees_names.index(name)
        else
          detail['Nombre Empleado'] = "#{e.entity.surname} #{e.entity.name}"
          employees_names << name
        end
        totals['Nombre Empleado'] = "Total"
        # G E T   E M P L O Y E   N A M E
        
        # G E T   T O T A L   E A R N
        total_earn = 0
        PayrollHistory.where('payroll_log_id = ?', payroll_id).each do |p|
          unless p.payroll_employees.where('employee_id = ?', employee_id).empty?
            total_earn += p.total.to_f
          end
        end # End PayrollHistory
        detail['Total Devengado'] = total_earn
        if totals['Total Devengado'].blank?
          totals['Total Devengado'] = total_earn
        else
          totals['Total Devengado'] += total_earn
        end
        # G E T   T O T A L   E A R N

        # G E T   D E D U C T I O N S
        # Set default values
        list_deductions.each do |id|
          d = Deduction.find(id)
          list_desc_deductions["#{d.description}"] = "#{d.description}" #kalfaro
          detail["#{d.description}"] = 0
          if totals["#{d.description}"].blank?
            totals["#{d.description}"] = 0
          else
            totals["#{d.description}"] += 0
          end
        end

        detail["Otras Deducciones"] = 0
        if totals["Otras Deducciones"].blank?
          totals["Otras Deducciones"] = 0
        else
          totals["Otras Deducciones"] = 0
        end

        total_deductions = 0
        DeductionPayment.where('payroll_id = ?', payroll_id).each do |a|
          if a.deduction_employee.employee_id.to_f == employee_id.to_f
            if list_deductions.include?(a.deduction_employee.deduction.id)
              detail["#{a.deduction_employee.deduction.description}"] += a.payment.to_f
              totals["#{a.deduction_employee.deduction.description}"] += a.payment.to_f
              total_deductions += a.payment.to_f
            else
              if list_deductions.count < 4
                list_deductions.push a.deduction_employee.deduction.id
                detail["#{a.deduction_employee.deduction.description}"] = a.payment.to_f
                totals["#{a.deduction_employee.deduction.description}"] = a.payment.to_f
                total_deductions += a.payment.to_f
              else
                detail["Otras Deducciones"] += a.payment.to_f
                totals["Otras Deducciones"] += a.payment.to_f
                total_deductions += a.payment.to_f
              end
            end #End include
          end
        end # End WorkBenefitsPayment
        list_desc_deductions["Otras Deducciones"] = "Otras Deducciones"
        # G E T   D E D U C T I O N S

        detail["Total"] = (total_earn-total_deductions)
        if totals["Total"].blank?
          totals["Total"] = (total_earn-total_deductions)
        else
          totals["Total"] += (total_earn-total_deductions)
        end

        if(index.nil?)
          list_payrolls << detail
        else
          list_payrolls[index]["Total Devengado"] += detail["Total Devengado"]
          list_payrolls[index]["Total"] += detail["Total"]
          
          list_desc_deductions.each do |i, value|
            list_payrolls[index]["#{value}"] += detail["#{value}"]
          end
        end
      end # End employees
    end # End payroll_ids

    list_payrolls << totals
    list_payrolls
    
  end

end
