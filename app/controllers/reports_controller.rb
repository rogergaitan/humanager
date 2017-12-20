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

        limitRows = 4
        list_deductions = Deduction.get_list_to_general_payment(@payroll_ids, limitRows)
        @t_d = list_deductions.length # Total deductions
        list_other_payments = OtherPayment.get_list_to_general_payment(@payroll_ids, limitRows)
        @t_o = list_other_payments.length # Total Other Payments

        @data = general_payroll_data(@payroll_ids, employees, list_deductions, list_other_payments, limitRows)

        if format.to_s == "pdf"
          respond_to do |format|
            format.pdf do
              pdf = GeneralPayrollPDF.new(@data, @payroll_ids, company_id, @t_d, @t_o)
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

  def general_payroll_data(payroll_ids, employees, list_deductions, list_other_payments, limitRows)

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
        total_earn = PayrollHistory.joins(:payroll_employees).select('sum(total) as total')
          .where('payroll_histories.payroll_log_id = ? and payroll_employees.employee_id = ?', payroll_id, employee_id)[0]
          .total.to_f
          
        # unless a.total.nil?
        #   total_earn = total_earn + a.total
        # end

        detail['Total Devengado'] = total_earn
        totals['Total Devengado'].blank? ? (totals['Total Devengado'] = total_earn) : (totals['Total Devengado'] += total_earn)
        # G E T   T O T A L   E A R N
          
        detail["Otros Pagos Constituye Salario"] = 0
        totals["Otros Pagos Constituye Salario"].blank? ? (totals["Otros Pagos Constituye Salario"] = 0) : nil
        
        total_other_payments_constitutes_salary = 0
        
        # Other Payments when Constitutes Salary
        OtherPaymentPayment.joins(:other_payment_employee)
        .where('other_payment_payments.payroll_id = ? and other_payment_employees.employee_id = ? and other_payment_payments.is_salary = ?',
                payroll_id, employee_id, true)
        .each do |other_payment|
          detail["Otros Pagos Constituye Salario"] += other_payment.payment.to_f
          totals["Otros Pagos Constituye Salario"] += other_payment.payment.to_f
          total_other_payments_constitutes_salary += other_payment.payment.to_f
        end
          
        # G E T   O T H E R  P A Y M E N T S
        # OtherPayment.where('id in (?)', list_other_payments).each do |d|
        #   list_desc_deductions["#{d.name[0...10]}.."] = "#{d.name[0...10]}.."
        #   detail["#{d.name[0...10]}.."] = 0
        #   totals["#{d.name[0...10]}.."].blank? ? (totals["#{d.name[0...10]}.."] = 0) : (totals["#{d.name[0...10]}.."] += 0)
        # end
        detail["Otros Pagos"] = 0
        totals["Otros Pagos"].blank? ? (totals["Otros Pagos"] = 0) : nil
        
        total_other_payments = 0
        OtherPaymentPayment.joins(:other_payment_employee)
        .where('other_payment_payments.payroll_id = ? and other_payment_employees.employee_id = ? and other_payment_payments.is_salary = ?', 
                payroll_id, employee_id, false)
        .each do |a|
          detail["Otros Pagos"] += a.payment.to_f
          totals["Otros Pagos"] += a.payment.to_f
          total_other_payments += a.payment.to_f
        end
          
        # G E T   D E D U C T I O N S
        # Set default values
        # Deduction.where('id in (?)', list_deductions).each do |d|
        #   list_desc_deductions["#{d.description[0...10]}.."] = "#{d.description[0...10]}.."
        #   detail["#{d.description[0...10]}.."] = 0
        #   totals["#{d.description[0...10]}.."].blank? ? (totals["#{d.description[0...10]}.."] = 0) : (totals["#{d.description[0...10]}.."] += 0)
        # end

        detail["Otras Deducciones"] = 0
        totals["Otras Deducciones"].blank? ? (totals["Otras Deducciones"] = 0) : nil

        total_deductions = 0
        DeductionPayment.joins(:deduction_employee)
          .where('deduction_payments.payroll_id = ? and deduction_employees.employee_id = ?',payroll_id, employee_id).each do |a|
            detail["Otras Deducciones"] += a.payment.to_f
            totals["Otras Deducciones"] += a.payment.to_f
            total_deductions += a.payment.to_f
        end

        list_desc_deductions["Otras Deducciones"] = "Otras Deducciones"
        # G E T   D E D U C T I O N S

   
        # G E T   O T H E R  P A Y M E N T S
        detail["Total"] = (total_earn-total_deductions+total_other_payments_constitutes_salary)
        if totals["Total"].blank?
          totals["Total"] = (total_earn-total_deductions+total_other_payments_constitutes_salary)
        else
          totals["Total"] += (total_earn-total_deductions+total_other_payments_constitutes_salary)
        end

        if(index.nil?)
          if detail['Total Devengado'] != 0
            list_payrolls << detail
          else
            employees_names.delete(name)
          end
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
