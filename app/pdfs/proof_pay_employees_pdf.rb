class ProofPayEmployeesPDF < Prawn::Document

  def initialize(payroll, employees)
    
    super(top_margin: 50)
    @payroll = payroll
    @employees = employees
    start
    # line_items
  end

  def start

    @employees.each do |employee_id|
      proof_pay_info
      move_down 20
      e = Employee.find(employee_id)
      text "Empleado: #{e.entity.entityid} #{e.entity.name} #{e.entity.surname}", character_spacing: 1
      move_down 20
      line_item_rows
      start_new_page()
    end # End each employees
  end

  def proof_pay_info

    font_size(10) do
      text_box "Agro Vicces S.A.", :align => :left, style: :bold, character_spacing: 1
      text_box "Comprobante de Pago de Salario", :align => :right, style: :bold, character_spacing: 1
    end
    move_down 30
    string = "Planilla #{@payroll.payroll_type.description} del #{@payroll.start_date} al #{@payroll.end_date}"
    text string, :align => :center, style: :bold, character_spacing: 1.5
  end

  def wages_earned() #Salarios Devengados
    
  end

  # def doc_canvas
  #   canvas do
  #     fill_circle [bounds.left, bounds.top],     30
  #     fill_circle [bounds.right, bounds.top],    30
  #     fill_circle [bounds.right, bounds.bottom], 30
  #     fill_circle [0,0],                         30
  #   end
  # end







  






  # def line_items
  #   move_down 2
  #   table line_item_rows do
  #     row(0).font_style = :bold
  #     row(0).size = 8
  #     columns(0..6).size = 8
  #     columns(2).align = :left
  #     columns(3..6).align = :right
  #     columns(0..1).width = 50
  #     columns(2).width = 215
  #     columns(3..6).width = 55
  #     self.row_colors = ["d2e3ed", "FFFFFF"]
  #     self.header = true
  #     self.cells.border_width = 0
  #   end
  # end

  def line_item_rows
    table([
      [{:content => "blah1", :colspan => 2}, {:content => "blah2", :colspan => 2}, {:content => "blah3", :colspan => 2}],
      ["1","2","3","4","5","6",]
    ])
    

    # @purchase.purchase_items.map do |item|
    #   [item.warehouse_id, item.product_id, item.description, item.quantity, item.discount, item.cost_unit, item.cost_total]
    # end


  end

end