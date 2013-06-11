class ProofPayEmployeesPDF < Prawn::Document
include ActionView::Helpers::NumberHelper

  def initialize(payroll, employees, msg)
    
    super(top_margin: 5, :left_margin => 90, :right_margin => 90, :page_size => [612,396])
    @payroll = payroll
    @employees = employees
    @total = 0
    @msg = msg
    start
  end

  def start

    list_task_unidad_payment_type = get_task_unidad_payment_type
    headers = get_heares(list_task_unidad_payment_type)

    @employees.each do |employee_id|
      
      proof_pay_info
      move_down 5

      e = Employee.find(employee_id)
      text "Empleado: #{e.entity.entityid} #{e.entity.surname} #{e.entity.name}", character_spacing: 1
      # move_down 5

      data_salary = get_data_salary(list_task_unidad_payment_type, employee_id)
      text "Detalle Salario Devengados:", character_spacing: 1
      # move_down 5

      table_salary_earned(headers, data_salary)
      move_down 5

      data_deductions = get_data_deductions(employee_id)
      text "Deducciones Aplicadas:", character_spacing: 1
      table_deductions(data_deductions, data_salary[1])

      text_box "#{@msg}",
      :at => [0, 140], :height => 150, :width => 230, character_spacing: 1

      move_down 5

      start_new_page()

    end # End each employees


  end

  def proof_pay_info

    font_size(10) do
      text_box "Agro Vicces S.A.", :align => :left, style: :bold, character_spacing: 1
      text_box "Comprobante de Pago de Salario", :align => :right, style: :bold, character_spacing: 1
    end
    move_down 20
    string = "Planilla #{@payroll.payroll_type.description} del #{@payroll.start_date} al #{@payroll.end_date}"
    text string, :align => :center, style: :bold, character_spacing: 1.5
  end

  def get_task_unidad_payment_type

    task_unidad = []
    result = []
    task_payment_type = [
      CONSTANTS[:PAYMENT][0]['name'].to_s, # Ordinario
      CONSTANTS[:PAYMENT][1]['name'].to_s, # Extra
      CONSTANTS[:PAYMENT][2]['name'].to_s  # Doble
    ]
    
    PayrollHistory.where('payroll_log_id = ?', @payroll.id).each do |p|
      task_unidad << p.task_unidad
    end
    result << task_unidad.uniq
    result << task_payment_type.uniq
  end

  def get_data_salary(list_task_unidad_payment_type, employee_id)

    task_unidad = {}
    task_payment_type = {}
    detail = {}
    data = []
    result = []
    total = 0

    list_task_unidad_payment_type[1].each do |payment_type|
      list_task_unidad_payment_type[0].each do |unidad|
        task_unidad[unidad] = 0
        detail['cantidad'] = 0
        detail['monto'] = 0
        PayrollHistory.where('payroll_log_id = ? and payment_type = ? and task_unidad = ?', @payroll.id, payment_type, unidad).each do |p|
          unless p.payroll_employees.where('employee_id = ?', employee_id).empty?
            detail['cantidad'] += p.time_worked.to_f
            detail['monto'] += p.total
            total += p.total.to_f
          end # End unless
        end # End each payroll
        detail['monto'] = "#{number_to_format(detail['monto'])}"
        task_unidad[unidad] = detail
        detail = {}
      end # End each unidad
      task_payment_type[payment_type] = task_unidad
      data << task_payment_type
      task_payment_type = {}
      task_unidad = {}
    end # End each payment_type
    result << data
    result << total
  end

  def get_heares(list_task_unidad_payment_type)

    header = [""]
    headers = []
    sub_header = [""]

    list_task_unidad_payment_type[0].each do |unidad|
      header << {:content => unidad, :colspan => 2, :font_style => :bold}
    end

    @total = ((header.count-1)*2)

    (1..@total).each do |num|
      if( num%2 == 0 )
        sub_header << {:content => "Monto", :font_style => :bold}
      else
        sub_header << {:content => "Cantidad", :font_style => :bold}
      end
    end

    headers << header
    headers << sub_header
  end

  def table_salary_earned(headers, data)
    
    rows = []
    row = []

    data[0].each do |index|
      index.each do |a|
        row << "#{a[0]}"
        a[1].each do |b, index2|
          row << index2['cantidad']
          row << index2['monto']
        end
        rows << row
        row = []
      end
    end # End each data

    total = number_to_format(data[1])

    table(
      headers +
      rows.map do |row| row end +
      [[ {:content => "Total(Colones): #{total}", :colspan => (@total+1), :font_style => :bold} ]],
      :cell_style => { :align => :right, :size => 10, :height => 19 },
      :position => :right
    )
  end

  def get_data_deductions(employee_id)
      
    rows = []
    row = []
    result = []
    total = 0
    total_others = 0
    count = 0

    WorkBenefitsPayment.where('payroll_id = ?', @payroll.id).each do |a|
      if a.employee_benefit.employee_id.to_f == employee_id.to_f
        count += 1
        if count >= 4
          total_others += a.payment.to_f
          total += a.payment
        else
          row << "#{a.employee_benefit.work_benefit.description}"
          row << "#{a.percentage}"
          row << "#{number_to_format(a.payment.to_f)}"
          total += a.payment
        end
      end

      unless row.empty?
        if count < 4
          rows << row
          row = []
        end
      end

    end

    if total_others != 0
      row = []
      row << "Otros"
      row << "0"
      row << total_others
      rows << row
    end

    result << rows
    result << "#{total}"
  end

  def table_deductions(data, total_salary)
      
    receive = total_salary.to_f - data[1].to_f  
    receive = number_to_format(receive)
      
    table([
      ["Deduccion", "%", "Monto"]] +
      data[0].map do |row| row end +
      [[ {:content => "Total_a_Recibir (Colones): #{receive}", :colspan => 3, :font_style => :bold } ]],
      :cell_style => { :align => :right, :size => 10, :height => 19 }, 
      :position => :right
    )
  end

  def number_to_format(number)
    number_to_currency(number, :precision => 2, :format => "%u%n", :unit => "")
  end

end