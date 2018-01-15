class ReportsController < ApplicationController
  before_filter :resources, :only => [:index, :general_payroll, :payment_type_report, :accrued_wages_between_dates_report]
  before_filter :set_company, :only => [:search_payrolls]
  respond_to :html, :json, :js

  def index
    @payrolls = Payroll.where('state = ?', 0)
  end

  def search_payrolls
    @payrolls = Payroll.search_payrolls_to_reports(params[:start_date], params[:end_date], 
						   @company.id, params[:page], 5)
    
    respond_with @payrolls
  end

  def show

    company_id = current_user.company_id

    case params[:type].to_s
      
      when CONSTANTS[:REPORTS]['PAYMENT_PROOF']

        employees = params[:employees].split(",")
        payroll = Payroll.includes(:currency).find(params[:payroll_id])
        
        respond_to do |format|
          format.pdf do
            pdf = ProofPayEmployeesPDF.new(payroll, employees, params[:msg], company_id)
            send_data pdf.render, filename: "payment_proof.pdf",
              type: "application/pdf", disposition: "inline"
          end
        end

      when CONSTANTS[:REPORTS]['GENERAL_PAYROLL']

        employees = params[:employees].split(",")
        @payroll_ids = params[:payroll_ids].split(",")
        format = params[:format]

        limit_rows = 4
        list_deductions = Deduction.get_list_to_general_payment(@payroll_ids, limit_rows)
        @t_d = list_deductions.length # Total deductions
        list_other_payments = OtherPayment.get_list_to_general_payment(@payroll_ids, limit_rows)
        @t_o = list_other_payments.length # Total Other Payments

        @data = general_payroll_data(@payroll_ids, employees, list_deductions, list_other_payments, limit_rows)

        if format.to_s == "pdf"
          respond_to do |format|
            format.pdf do
              pdf = GeneralPayrollPDF.new(@data, @payroll_ids, company_id)
              send_data pdf.render, filename: "general_payroll.pdf",
                type: "application/pdf", disposition: "inline"
            end
          end
        else
          general_payroll_xls(@data, @payroll_ids, company_id)
        end

      when CONSTANTS[:REPORTS]['PAYMENT_TYPE_REPORT']
        
        format = params[:format]
        employees = params[:employees].split(",")
        payroll_ids = params[:payroll_ids].split(",")
        tasks = params[:tasks].split(",")
        order = params[:order]
        cc = params[:cc].split(",")
        report_currency = Currency.find params[:currency]
        
        if tasks.empty?
          tasks = Task.select(:id).collect(&:id)
        end

        if cc.empty?
          cc = CostsCenter.select(:id).collect(&:id)
        end
        
        @data = Employee.payment_types_report_data(employees, payroll_ids, tasks, order, cc, report_currency.currency_type)

        if format.to_s == "pdf"

          respond_to do |format|
            format.pdf do
              pdf = PaymentTypeReportPDF.new(@data, order, payroll_ids, company_id, report_currency.symbol)
              send_data pdf.render, filename: "payment_type_report.pdf",
                type: "application/pdf", disposition: "inline"
            end
          end
        else
          payment_type_report_xls(@data, payroll_ids, order, company_id, report_currency.symbol)
        end

      when CONSTANTS[:REPORTS]['ACCRUED_WAGES_DATES']
        
        employee_ids = params[:employee_ids].split(",")
        start_date = params[:start_date]
        end_date = params[:end_date]

        @data = accrued_wages_dates_date(employee_ids, start_date, end_date, company_id)

        if params[:format].to_s == "pdf"
          respond_to do |format|
            format.pdf do
              pdf = AccruedWagesDatesPDF.new(@data, company_id, start_date, end_date)
              send_data pdf.render, filename: "test.pdf",
                type: "application/pdf", disposition: "inline"
            end
          end
        else
          accrued_wages_dates_date_xls(@data, company_id, start_date, end_date)
        end

    end # End case
  end # End show

  def report_between_dates
  end

  def general_payroll
    # @payrolls = Payroll.where('state = ?', 0)
  end

  def payment_type_report
    @tasks = Task.all
    @cc = CostsCenter.all
    @currencies = Currency.all
  end

  def accrued_wages_between_dates_report
  end

  def resources
    @department = Department.all
    @superior = Employee.superior
    @employees = Employee.order_employees
    @companies = Company.all
  end

  def general_payroll_data(payroll_ids, employees, list_deductions, list_other_payments, limit_rows)

    list_desc_deductions = {}
    employees_names = []
    list_payrolls = []
    totals = {}

    payroll_ids.each do | payroll_id |
      employees.each do | employee_id |

        detail = {}

        # G E T   E M P L O Y E   N A M E
        e = Employee.find(employee_id)
        name = {}
        index = nil
        name['Nombre Empleado'] = "#{e.entity.surname} #{e.entity.name}"
          
        if employees_names.include?(name)
          index = employees_names.index(name)
        else
          detail['Nombre Empleado'] = "#{e.entity.surname} #{e.entity.name}"
          employees_names << name
        end
        totals['Nombre Empleado'] = "Total"
        # G E T   E M P L O Y E   N A M E
          
        # G E T   T O T A L   E A R N
        total_earn = 0
        total_earn = PayrollHistory.joins(:payroll_employees).select('sum(total) as total')
          .where('payroll_histories.payroll_log_id = ? and payroll_employees.employee_id = ?', payroll_id, employee_id)[0]
          .total.to_f
        
        total_other_payments_constitutes_salary = 0
        
        # Other Payments when Constitutes Salary
        OtherPaymentPayment.joins(:other_payment_employee)
          .where('other_payment_payments.payroll_id = ? and other_payment_employees.employee_id = ? 
                  and other_payment_payments.is_salary = ?', payroll_id, employee_id, true)
          .each do |other_payment|
            total_other_payments_constitutes_salary += other_payment.payment.to_f
        end
      
        total_work_benefits = 0
        
        work_benefits_payments = WorkBenefitsPayment.joins(:employee_benefit => :work_benefit)
                                                    .where('work_benefits_payments.payroll_id = ? and employee_benefits.employee_id = ? 
                                                            and work_benefits.provisioning = ?', payroll_id, employee_id, false)

	work_benefits_payments.each do |work_benefit_payment|
          total_work_benefits += work_benefit_payment.payment.to_f
        end
        
        total_earn = total_earn + total_other_payments_constitutes_salary + total_work_benefits
        detail['Total Devengado'] = total_earn
        totals['Total Devengado'].blank? ? (totals['Total Devengado'] = total_earn) : (totals['Total Devengado'] += total_earn)
          
        # G E T   O T H E R  P A Y M E N T S DON'T CONSTITUTE SALARY
        detail["Otros Pagos"] = {}
        totals["Total Otros Pagos"] = {} unless totals.has_key? "Total Otros Pagos"
        total_other_payments = 0

        other_payments = OtherPaymentPayment.joins(:other_payment_employee)
                                            .where('other_payment_payments.payroll_id = ? and other_payment_employees.employee_id = ? 
                                                    and other_payment_payments.is_salary = ?', payroll_id, employee_id, false)

       if other_payments.count == 0
          detail["Otros Pagos"]["N/A"] = 0
          detail["Otros Pagos"]["N/A 2"] = 0
          unless totals["Total Otros Pagos"].count == 2
            totals["Total Otros Pagos"]["N/A"] = 0
            totals["Total Otros Pagos"]["N/A 2"] = 0
	  end
        end
    
        other_payments.each do |other_payment|
          if other_payments.count == 1
            detail["Otros Pagos"][other_payment.other_payment_name] = other_payment.payment.to_f
            detail["Otros Pagos"]["N/A"] = 0
            
            if totals["Total Otros Pagos"].count == 0
              totals["Total Otros Pagos"][other_payment.other_payment_name] = other_payment.payment.to_f
              totals["Total Otros Pagos"]["N/A"] = 0
            elsif totals["Total Otros Pagos"].count == 2
              if totals["Total Otros Pagos"].has_key?(other_payment.other_payment_name)
                totals["Total Otros Pagos"][other_payment.other_payment_name] += other_payment.payment.to_f
              end
            end
            
	  elsif other_payments.count == 2
            detail["Otros Pagos"][other_payment.other_payment_name] = other_payment.payment.to_f
            
            if totals["Total Otros Pagos"].count < 2
              totals["Total Otros Pagos"][other_payment.other_payment_name] = other_payment.payment.to_f
            elsif totals["Total Otros Pagos"].count == 2
              if totals["Total Otros Pagos"].has_key?(other_payment.other_payment_name)
                totals["Total Otros Pagos"][other_payment.other_payment_name] += other_payment.payment.to_f
              end
            end
          elsif other_payments.count > 2 
            
            if detail["Otros Pagos"].count >= 1
              detail["Otros Pagos"]["Otros Pagos"] = 0 unless detail["Otros Pagos"].has_key?("Otros Pagos")
              detail["Otros Pagos"]["Otros Pagos"] += other_payment.payment.to_f
             
              if totals["Total Otros Pagos"].count == 2 && totals["Total Otros Pagos"].has_key?("Total Otros Pagos") 
                totals["Total Otros Pagos"]["Total Otros Pagos"] += other_payment.payment.to_f
              elsif totals["Total Otros Pagos"].count < 2
                totals["Total Otros Pagos"]["Total Otros Pagos"] = 0
                totals["Total Otros Pagos"]["Total Otros Pagos"] += other_payment.payment.to_f
              end

            else
              detail["Otros Pagos"][other_payment.other_payment_name] = other_payment.payment.to_f
              if totals["Total Otros Pagos"].count < 2
                totals["Total Otros Pagos"][other_payment.other_payment_name] = other_payment.payment.to_f
              elsif totals["Total Otros Pagos"].has_key?(other_payment.other_payment_name)
                totals["Total Otros Pagos"][other_payment.other_payment_name] += other_payment.payment.to_f
              end
            end
          end
	  total_other_payments += other_payment.payment.to_f
        end

        # G E T   D E D U C T I O N S
        detail["Deducciones"] = {}
        totals["Total Deducciones"] = {} unless totals.has_key? "Total Deducciones"
        total_deductions = 0
        
        deductions = DeductionPayment.joins(:deduction_employee)
                                     .where('deduction_payments.payroll_id = ? and deduction_employees.employee_id = ?',
	                                     payroll_id, employee_id)
	                                              
        if deductions.count == 0
          detail["Deducciones"]["N/A"] = 0
          detail["Deducciones"]["N/A 2"] = 0
          detail["Deducciones"]["N/A 3"] = 0
	  unless totals["Total Deducciones"].count == 3
            totals["Total Deducciones"]["N/A"] = 0
            totals["Total Deducciones"]["N/A 2"] = 0
            totals["Total Deducciones"]["N/A 3"] = 0
	  end
        end
          
        deductions.each do |deduction|
          if deductions.count == 1
            detail["Deducciones"][deduction.deduction_description] = deduction.payment.to_f
            detail["Deducciones"]["N/A"] = 0
            detail["Deducciones"]["N/A 2"] = 0
        
            if totals["Total Deducciones"].count < 3
              totals["Total Deducciones"][deduction.deduction_description] = deduction.payment.to_f
              totals["Total Deducciones"]["N/A"] = 0
              totals["Total Deducciones"]["N/A 2"] = 0
            elsif totals["Total Deducciones"].count == 3
              if totals["Total Deducciones"].has_key?(deduction.deduction_description)
                totals["Total Deducciones"][deduction.deduction_description] += deduction.payment.to_f
              end
            end
            
          elsif deductions.count == 2
            detail["Deducciones"][deduction.deduction_description] = deduction.payment.to_f
            
            if totals["Total Deducciones"].count < 3
              totals["Total Deducciones"][deduction.deduction_description] = deduction.payment.to_f
            elsif totals["Total Deducciones"].count == 3
              if totals["Total Deducciones"].has_key?(deduction.deduction_description)
                totals["Total Deducciones"][deduction.deduction_description] += deduction.payment.to_f
              else 
                totals["Total Deducciones"]["N/A"] = 0
              end
            end
            
            if detail["Deducciones"].count == 2
              detail["Deducciones"]["N/A"] = 0
            end

          elsif deductions.count == 3
            detail["Deducciones"][deduction.deduction_description] = deduction.payment.to_f
            
            if totals["Total Deducciones"].count < 3
              totals["Total Deducciones"][deduction.deduction_description] = deduction.payment.to_f
            elsif totals["Total Deducciones"].count == 3
              if totals["Total Deducciones"].has_key?(deduction.deduction_description)
                totals["Total Deducciones"][deduction.deduction_description] += deduction.payment.to_f
              end
            end
            
          elsif deductions.count > 3
            if detail["Deducciones"].count >= 2
              detail["Deducciones"]["Otras Deducciones"] = 0 unless detail["Deducciones"].has_key? "Otras Deducciones"
              detail["Deducciones"]["Otras Deducciones"] += deduction.payment.to_f
              
             if totals["Total Deducciones"].count == 3 && totals["Total Deducciones"].has_key?("Total Otras Deducciones")
               totals["Total Deducciones"]["Total Otras Deducciones"] += deduction.payment.to_f
             elsif totals["Total Deducciones"].count < 3
               totals["Total Deducciones"]["Total Otras Deducciones"] = 0
               totals["Total Deducciones"]["Total Otras Deducciones"] += deduction.payment.to_f
             end

            else
              detail["Deducciones"][deduction.deduction_description] = deduction.payment.to_f
              
              if totals["Total Deducciones"].count < 3
                totals["Total Deducciones"][deduction.deduction_description] = deduction.payment.to_f
              elsif totals["Total Deducciones"].count == 3
                if totals["Total Deducciones"].has_key?(deduction.deduction_description)
                  totals["Total Deducciones"][deduction.deduction_description] += deduction.payment.to_f
                end
              end
            end
          end
          total_deductions += deduction.payment.to_f
        end

        list_desc_deductions["Deducciones"] = "Deducciones"
   
        #SUM TOTALS
        detail["Total a Recibir"] = (total_earn + total_other_payments - total_deductions)
        if totals["Total"].blank?
          totals["Total"] = (total_earn-total_deductions)
        else
          totals["Total"] += (total_earn-total_deductions)
        end

        if index.nil?
          if detail['Total Devengado'] != 0
            list_payrolls << detail
          else
            employees_names.delete(name)
          end
        else
          list_payrolls[index]["Total Devengado"] += detail["Total Devengado"]
          list_payrolls[index]["Total"] += detail["Total"]
        end

      end # End employees
    end # End payroll_ids

    list_payrolls << totals
    list_payrolls
    
  end

  def general_payroll_xls(data, payroll_ids, company_id)
    @data = data
    @company =  Company.find_by_code(company_id)

    get_dates(payroll_ids)
    
    respond_to do |format|
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="general_payroll.xls"'
        render 'general_payroll'
      }
    end
  end

  def payment_type_report_xls(data, payroll_ids, order, company_id, currency_symbol)
    @data = data
    @order = order
    @company =  Company.find_by_code(company_id)
    @currency_symbol = currency_symbol

    get_dates(payroll_ids)
    
    respond_to do |format|
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="payment_type_report.xls"'
        render 'payment_type_report'
      }
    end
  end

  def get_dates(payroll_ids)
    @name_payrolls = nil
    Payroll.includes(:currency).where( :id => payroll_ids ).each do |p|
      @name_payrolls = "#{p.payroll_type.description}"
      @currency_symbol = p.currency.symbol
      
      if(@start_date.nil? and @end_date.nil?)
        @start_date = p.start_date
        @end_date = p.end_date
      else
        if(@start_date > p.start_date)
          @start_date = p.start_date
        end

        if(@end_date < p.end_date)
          @end_date = p.end_date
        end
      end
    end
    if payroll_ids.count > 1
      @name_payrolls = 'Varios'
    end
  end

  def accrued_wages_dates_date(employee_ids, start_date, end_date, company_id)
    
    payroll_ids = Payroll.where("(start_date >= ? or start_date <= ?) and (end_date >= ? or end_date <= ?) and state = ? and company_id = ?",
                                start_date, end_date, start_date, end_date, false, company_id).pluck(:id)

    payroll_log_ids = PayrollLog.where(id: payroll_ids).pluck(:id)

    data = {}
    list = []

    employee_ids.each do |employee_id|

      employee = Employee.find(employee_id)

      data['number_employee'] = employee.number_employee
      data['entityid'] = employee.entity.entityid
      data['full_name'] = "#{employee.entity.name} #{employee.entity.surname}"

      total_earn = 0
      payroll_log_ids.each do |payroll_id|
        PayrollHistory.where('payroll_log_id = ? and payroll_date BETWEEN ? and ?', payroll_id, start_date, end_date).each do |p|
          unless p.payroll_employees.where('employee_id = ?', employee_id).empty?
            total_earn += p.total.to_f
          end
        end # End PayrollHistory
      end
      data['total'] = total_earn
      list << data
      data = {}
    end # End Employee_ids

    list
  end

  def accrued_wages_dates_date_xls(data, company_id, start_date, end_date)
    @data = data
    @start_date = start_date
    @end_date = end_date
    @company =  Company.find(company_id)
    
    respond_to do |format|
      format.xls {
        response.headers['Content-Disposition'] = 'attachment; filename="accrued_wages_dates_date.xls"'
        render :template => 'xls/accrued_wages_dates_date_xls'
      }
    end
  end

  def set_company
    @company = Company.find_by_code(current_user.company_id)
  end

end
