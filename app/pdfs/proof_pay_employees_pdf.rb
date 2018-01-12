class ProofPayEmployeesPDF < Prawn::Document
  include ActionView::Helpers::NumberHelper

  def initialize(payroll, employees, msg, id_company)
    super(top_margin: 15, :left_margin => 20, :right_margin => 20)
    @payroll = payroll
    @currency_symbol = payroll.currency.symbol
    @employees = employees
    @total_accrued = 0 # Total Devengado
    @total_other_payments = 0 # Total Devengado
    @msg = msg
    @limit_records = 4
    @company = Company.find_by_code(id_company)
    start
  end

  def start

    list_payments_types = get_payments_types
    header = get_header()
    count = 0
    employee_ids = []

    @payroll_history_ids = PayrollHistory.select('id')
                                         .where('payroll_log_id = ?', @payroll.payroll_log.id).collect(&:id)

    if @payroll_history_ids.length == 0
      no_info
    else
      
      employee_ids = PayrollEmployee.select('DISTINCT(employee_id)')
                                    .where('payroll_history_id in (?) and employee_id in (?)', 
                                           @payroll_history_ids, @employees.map(&:to_i))
                                    .collect(&:employee_id)

      employee_ids.each do |employee_id|
        
        proof_pay_info
        move_down 5
        count += 1

        e = Employee.find(employee_id)
        co = @company

        move_down 20
        move_down 10 unless @msg.blank?

        employee =  "Empleado: #{e.entity.entityid} #{e.entity.surname} #{e.entity.name}"
        text employee, character_spacing: 1
        
        unless @msg.blank?
          text_box "Nota: " + @msg, :at => [0, 680], :size => 10, :style => :italic
        end

        define_grid(:columns => 3, :rows => 1, :gutter => 2)
        # grid.show_all
        
        data_salary = get_data_salary(list_payments_types, employee_id)
        data_deductions = get_data_deductions(employee_id)
        data_work_benefits = get_data_work_benefits(employee_id)
        data_other_payments_no_salary = get_data_other_payments(employee_id)
        total_other_payments = get_total_other_payments(employee_id)

        data_other_payments_salary = get_other_payments_filter(employee_id, true)
        t_rows = table_salary_earned(data_salary[0], data_salary[1], header, list_payments_types, 
                                     data_other_payments_salary, data_work_benefits)

        # Left
        grid([0,0],[0,1]).bounding_box do
          move_down 100
          move_down 10 unless @msg.blank?
          text "Salarios Devengados", character_spacing: 1, :align => :left
          tables_salary(t_rows, header)
        end

        # Center
        grid(0,2).bounding_box do
          move_down 100
          move_down 10 unless @msg.blank?
          text "Otros Pagos Aplicados", character_spacing: 1, :align => :right
          table_other_payments(data_other_payments_no_salary)
          
          move_down 100
          move_down 10 unless @msg.blank?
          text "Deducciones Aplicadas", character_spacing: 1, :align => :right
          table_deductions(data_deductions, data_other_payments_no_salary)
        end

        # Rigth
        grid(0,2).bounding_box do
        end

        if count != employee_ids.count
          print_date
          start_new_page()
        end

      end
    end
    
    print_date
  end

  def no_info
    text "No existen datos para mostrar"
  end

  def tables_salary(t_rows, header)
    t_rows.each do |rows|
      table(
        header + 
        rows.map do |row| row end, 
          :cell_style => {:size => 8, :height => 19, :border_color => "FFFFFF" },
          :position => :left
      ) do
        row(0).borders = [:bottom]
        row(0).border_width = 2
        row(0).font_style = :bold
        row(0).border_color = "000000"
      end
    end
  end

  def proof_pay_info

    font_size(10) do
      text_box "Comprobante de Pago de Salario", :align => :right, style: :bold, character_spacing: 1
      string = "Planilla #{@payroll.payroll_type.description} del #{@payroll.start_date} al #{@payroll.end_date}"
      text_box string, :align => :right, :at => [0, y - 50]
    end

    text "#{@company.label_reports_1}", :align => :left, style: :bold, character_spacing: 1, :size => 10
    text "#{@company.label_reports_2}", :align => :left, style: :bold, character_spacing: 1, :size => 10
    text "#{@company.label_reports_3}", :align => :left, style: :bold, character_spacing: 1, :size => 10
    move_down 20
  end

  def get_payments_types

    task_payment_type = [
      PaymentType::PAYMENT_ORDINARY,
      PaymentType::PAYMENT_EXTRA,
      PaymentType::PAYMENT_DOBLE      
    ]

    task_payment_type.uniq
  end

  def get_data_salary(list_payments_types, employee_id)

    result = []; data = []
    info_data = {}; info = {}
    
    totals = {
      'ordinario' => 0,
      'extra' => 0,
      'doble' => 0
    }
    
    payroll_history_ids = PayrollEmployee.where('employee_id = ?', employee_id).map(&:payroll_history_id)

    PayrollHistory.select("id, task_id, SUM(time_worked) as time_worked, payment_type_id, 
                          payroll_date, SUM(total) as total, task_unidad")
                  .where(:payroll_log_id => @payroll.id, :id => payroll_history_ids)
                  .group("payment_type_id, payroll_date").order("payroll_date").each do |p|

      obj = {}
      obj['labor'] = p.task.ntask
      obj['fecha'] = p.payroll_date

      if data.include?(obj)
        index = data.index(obj)

        if p.payment_type.payment_type.to_s == list_payments_types[0]
          result[index]['ordinario'] += p.time_worked.to_f
          totals['ordinario'] += p.total.to_f
        end
        
        if p.payment_type.payment_type.to_s == list_payments_types[1]
          result[index]['extra'] += p.time_worked.to_f
          totals['extra'] += p.total.to_f
        end

        if p.payment_type.payment_type.to_s == list_payments_types[2]
          result[index]['doble'] += p.time_worked.to_f
          totals['doble'] += p.total.to_f
        end
      else
        info_data['fecha'] = "#{p.payroll_date.strftime('%d')}/#{p.payroll_date.strftime('%m')}"
        info_data['labor'] = p.task.ntask
        info['fecha'] = info_data['fecha']
        info['labor'] = "#{p.task.ntask[0..20]}..."
        info['unidad'] = p.task_unidad
        info['ordinario'] = 0
        info['extra'] = 0
        info['doble'] = 0
        
        if p.payment_type.payment_type.to_s == list_payments_types[0]
          info['ordinario'] = p.time_worked.to_f
          totals['ordinario'] += p.total.to_f
        end
        
        if p.payment_type.payment_type.to_s == list_payments_types[1]
          info['extra'] = p.time_worked.to_f
          totals['extra'] += p.total.to_f
        end

        if p.payment_type.payment_type.to_s == list_payments_types[2]
          info['doble'] = p.time_worked.to_f
          totals['doble'] += p.total.to_f
        end

        result << info
        data << info_data
        info_data = {}
        info = {}
      end
    end
    
    [result, totals]
  end

  def get_header
    header = [[ 
      {:content => "Fecha", :font_style => :bold },
      {:content => "Labor", :font_style => :bold },
      {:content => "Unid", :font_style => :bold },
      {:content => "Ord", :font_style => :bold, :align => :right },
      {:content => "Ext", :font_style => :bold, :align => :right },
      {:content => "Dob",  :font_style => :bold, :align => :right }
    ]]
  end

  def table_salary_earned(data, totals, header, lpt, data_other_payments_salary, data_work_benefits)
    
    t_rows = []
    rows = []
    row = []
    total = 0 
    t_ordinario = 0
    t_extra = 0 
    t_doble = 0 
    c_rows = 0

    # Tasks
    data.each do |obj|
      c_rows += 1

      obj.each do |a,b|
        if a.capitalize == lpt[0] || a.capitalize == lpt[1] || a.capitalize == lpt[2]
          row << { :content => "#{number_to_format(b)}", :align => :center }
        else
          if is_numeric("#{b}")
            row << { :content => "#{b}", :align => :right }
          else
            row << { :content => "#{b}", :align => :left }
          end
        end
              
        t_ordinario += b.to_f if a.capitalize == I18n.t("payment_type.#{lpt[0]}")
        
        t_extra += b.to_f if a.capitalize == I18n.t("payment_type.#{lpt[1]}")

        t_doble += b.to_f if a.capitalize == I18n.t("payment_type.#{lpt[2]}")
      end

      rows << row
      row = []      

      if c_rows == 30
        t_rows << rows
        rows = []
        c_rows = 0
      end
    end

    # Cantidades Totales
    row << { :content => "Cantidades Totales", :colspan => 3, :align => :right, :font_style => :bold }
    row << { :content => "#{number_to_format(t_ordinario)}", :align => :right }
    row << { :content => "#{number_to_format(t_extra)}", :align => :right }
    row << { :content => "#{number_to_format(t_doble)}", :align => :right }
    rows << row
    row = []

    # Montos Totales
    row << { :content => "Montos Totales", :colspan => 3, :align => :right, :font_style => :bold }
    row << { :content => "#{number_to_format(totals['ordinario'])}", :align => :right }
    row << { :content => "#{number_to_format(totals['extra'])}", :align => :right }
    row << { :content => "#{number_to_format(totals['doble'])}", :align => :right }
    rows << row
    row = []

    # Other Payments
    ########################################################################################
    total_other_payments = 0
    sum_others = 0
    count = 0
    
    data_other_payments_salary.each do |o|
      count += 1
      if count <= @limit_records
        row << { :content => "#{o.other_payment_employee.other_payment.name}", :colspan => 3, :align => :right }
        row << { :content => "#{number_to_format(o.payment.to_f)}", :colspan => 3, :align => :right}
        total_other_payments += o.payment.to_f
        rows << row
        row = []
      else
        sum_others += o.payment.to_f
      end
    end

    if sum_others != 0
      row << { :content => "Otros", :colspan => 3, :align => :right }
      row << { :content => "#{number_to_format(sum_others)}", :colspan => 3, :align => :right}
      rows << row
      row = []
    else
      row << { :content => "N/A", :colspan => 3, :align => :right }
      row << { :content => "0.00", :colspan => 3, :align => :right}
      rows << row
      row = []
    end
    ########################################################################################
    
    # Otros pagos cuando costituyen salario
    row << { :content => "Otros Pagos", :colspan => 3, :align => :right, :font_style => :bold }
    row << { :content => "#{number_to_format(total_other_payments)}", :colspan => 3, :align => :right}
    rows << row
    row = []
    
    total_work_benefits = 0
    total_work_benefits_count = 0
    
    data_work_benefits.each do |work_benefit|
      if total_work_benefits_count < 3
        row << { :content => work_benefit.work_benefit_name, :colspan => 3, :align => :right }
        row << { :content => "#{number_to_format(work_benefit.payment.to_f)}", :colspan => 3, :align => :right}
        
        rows << row
        row = []
      end
      total_work_benefits += work_benefit.payment.to_f
      total_work_benefits_count += 1
    end

    # Total Devengado
    total_devengado = totals['ordinario'].to_f + totals['extra'].to_f + totals['doble'].to_f
    total_devengado += total_other_payments.to_f + total_work_benefits
    @total_accrued = total_devengado
    row << { :content => "Total Devengado", :colspan => 3, :align => :right, :font_style => :bold }  
    row << { :content => "#{@currency_symbol}#{number_to_format(total_devengado)}", :colspan => 3, :align => :right}
    rows << row
    row = []

    t_rows << rows
    rows = []
    
    t_rows
  end

  def get_data_other_payments(employee_id)
    
    row = []
    rows = []
    result = []
    total = 0
    total_others = 0
    count = 0
    
    dta = get_other_payments_filter(employee_id, false)

    dta.each do |o|
        count += 1
        total += o.payment.to_f

        if count >= @limit_records
          total_others += o.payment.to_f
        else
          if o.payment > 0
            row << "#{o.other_payment_employee.other_payment.name}"
            if o.other_payment_employee.other_payment.calculation_type.to_s == 'percentage'
              row << "#{o.other_payment_value}"
            else
              row << "N/A"
            end
            row << "#{number_to_format(o.payment.to_f)}"
          end
        end

        unless row.empty?
          if count < @limit_records
            rows << row
            row = []
          end
        end
    end

    if total_others != 0
      row = []
      row << "Otros"
      row << "0.00"
      row << total_others
      rows << row
    else
      row << "N/A"
      row << "0.00"
      row << "0.00"
      rows << row
    end
    @total_other_payments = total
    result << rows
    result << "#{total}"
  end

  def get_other_payments_filter(employee_id, is_salary)
    OtherPaymentPayment.joins(:other_payment_employee)
                       .where("other_payment_payments.payroll_id = ? and other_payment_employees.employee_id = ? 
                              and other_payment_payments.is_salary = ?", 
                              @payroll.id, employee_id, is_salary)
  end

  def get_total_other_payments(employee_id)
    a = OtherPaymentPayment.joins(:other_payment_employee)
                           .select('sum(other_payment_payments.payment) as total')
                           .where("other_payment_payments.payroll_id = ? and other_payment_employees.employee_id = ? 
                                  and other_payment_payments.is_salary = ?",
                                  @payroll.id, employee_id, true)
    a[0]['total']
  end

  def get_data_deductions(employee_id)
      
    rows = []
    row = []
    result = []
    total = 0
    total_others = 0
    count = 0

    DeductionPayment.includes(:deduction_employee => :deduction).where('payroll_id = ?', @payroll.id).each do |a|
      if a.deduction_employee.employee_id.to_f == employee_id.to_f
        count += 1
        
        if count >= @limit_records
          total_others += a.payment.to_f
          total += a.payment
        else
          if a.payment > 0
            row << "#{a.deduction_employee.deduction.description}"
            if a.deduction_employee.deduction.calculation_type.to_s == "percentage"
              row << "#{number_to_format(a.deduction_value)}"
            else
              row << "0.00"
            end
            row << "#{number_to_format(a.payment.to_f)}"
          end
          total += a.payment
        end
      end

      unless row.empty?
        if count < @limit_records
          rows << row
          row = []
        end
      end
    end

    if total_others != 0
      row = []
      row << "Otros"
      row << "0.00"
      row << total_others
      rows << row
    else
      row << "N/A"
      row << "0.00"
      row << "0.00"
      rows << row
    end

    result << rows
    result << "#{total}"
  end

  def table_deductions(data, data_other_payments_no_salary)
    receive = @total_accrued.to_f + data_other_payments_no_salary[1].to_f - data[1].to_f
    table([
      [
       { :content => "Deducción", :font_style => :bold },
       { :content => "%", :font_style => :bold }, 
       { :content => "Monto", :font_style => :bold }
      ]] +
      data[0].map do |row| row end +
      [[ {:content => "Total Deducciones:", :colspan => 2, :font_style => :bold }, 
      {:content => "#{@currency_symbol}#{number_to_format(data[1])}"} ],
      [ {:content => "Total a Recibir:", :colspan => 2, :font_style => :bold }, 
      {:content => "#{@currency_symbol}#{number_to_format(receive)}"} ]],
      :cell_style => { :align => :right, :size => 8, :height => 19, :border_color => "FFFFFF" },
      :position => :right
    ) do
      row(0).borders = [:bottom]
      row(0).border_width = 2
      row(0).font_style = :bold
      row(0).border_color = "000000"  
    end
  end

  def table_other_payments(data)
    table([
      [
        { :content => "Otros Pagos", :font_style => :bold },
        { :content => "%", :font_style => :bold },
        { :content => "Monto", :font_style => :bold }
      ]] +
      data[0].map do |row| row end +
      [[ {:content => "Total Otros Pagos:", :colspan => 2, :font_style => :bold }, 
      {:content => "#{@currency_symbol}#{number_to_format(data[1].to_f)}"} ]],
      :cell_style => { :align => :right, :size => 8, :height => 19, :border_color => "FFFFFF" },
      :position => :right
    ) do
      row(0).borders = [:bottom]
      row(0).border_width = 2
      row(0).font_style = :bold
      row(0).border_color = "000000"
    end    
  end

  def number_to_format(number)
    number_to_currency(number, :precision => 2, :format => "%u%n", :unit => "")
  end

  def is_numeric(string)
    /^[\d]+(\.[\d]+){0,1}$/ === string
  end
  
  def print_date
    bounding_box([0, 15], :width => 150) do
      text "#{DateTime.now.strftime("Impreso el %d/%m/%Y a las %I:%M %p")}", :size => 7
    end
  end
  
  def get_data_work_benefits(employee_id)
    WorkBenefitsPayment.non_provisioned(@payroll.id, employee_id)
  end

end
