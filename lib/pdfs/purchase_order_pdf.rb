class PurchaseOrderPDF < Prawn::Document

  def initialize(order, view = nil)
    super(top_margin: 70)
    @order = order
    @view = view
    order_info
    line_items
    order_notes
  end

  def order_info
    # define_grid(:columns => 5, :rows => 8, :gutter => 10)
    # grid([0,0], [1,1]).bounding_box do
    #   text "Orden OC-#{@order.id}", :size => 18
    #   text "Fecha: #{Date.today.to_s}", :align => :left
    #   move_down 2

    #   text "Attn: To whom it may concern "
    #   text "Company Name"
    #   text "Tel No: 1"
    #   text "Fax No: 0` 1"
    # end
    text "Orden OC-#{@order.id}", size: 20, style: :bold
    text "Proveedor: #{@order.vendor.entity.name}", size: 10
    text "Fecha Entrega #{@order.delivery_date}", size: 8
    text "Referencia #{@order.reference_info}", size: 8
  end

  def line_items
    move_down 2
    table line_item_rows do
      row(0).font_style = :bold
      row(0).size = 8
      columns(0..5).size = 8
      columns(2..5).align = :right
      columns(0).width = 50                 #CODE
      columns(1).width = 250                #DESCRIPTION
      columns(2..6).width = 55
      self.row_colors = ["d2e3ed", "FFFFFF"]
      self.header = true
      self.cells.border_width = 0
    end
  end

  def line_item_rows
    [["CODIGO", "DESCRIPCION","CANTIDAD", "DESC", "C/UNIT", "C/TOTAL"]] +
    @order.items_purchase_order.map do |item|
      [item.product, item.description, item.quantity, item.discount, item.cost_unit, item.cost_total]
    end
  end

  def order_notes
    move_down 15
    text "Observaciones: #{@order.observation}", size: 10
  end

end

=begin
  pdf = Prawn::Document.new
  pdf.font "Helvetica"

# Defining the grid
# See http://prawn.majesticseacreature.com/manual.pdf
pdf.define_grid(:columns => 5, :rows => 8, :gutter => 10)

pdf.grid([0,0], [1,1]).bounding_box do
  pdf.text "INVOICE", :size => 18
  pdf.text "Invoice No: 0001", :align => :left
  pdf.text "Date: #{Date.today.to_s}", :align => :left
  pdf.move_down 10
  
  pdf.text "Attn: To whom it may concern "
  pdf.text "Company Name"
  pdf.text "Tel No: 1"
  pdf.text "Fax No: 0` 1"
end

pdf.grid([0,3.6], [1,4]).bounding_box do
  # Assign the path to your file name first to a local variable.
  logo_path = File.expand_path('../../image/gravatar.jpg', __FILE__)

  # Displays the image in your PDF. Dimensions are optional.
  pdf.image logo_path, :width => 50, :height => 50, :position => :left

  # Company address
  pdf.move_down 10
  pdf.text "Awesomeness Ptd Ltd", :align => :left
  pdf.text "Address", :align => :left
  pdf.text "Street 1", :align => :left
  pdf.text "40300 Shah Alam", :align => :left
  pdf.text "Selangor", :align => :left
  pdf.text "Tel No: 42", :align => :left
  pdf.text "Fax No: 42", :align => :left
end

pdf.text "Details of Invoice", :style => :bold_italic
pdf.stroke_horizontal_rule


temp_arr = [{:name => 'Unit 1', :price => "10.00"},
            {:name => 'Unit 2', :price => "12.00"}]

pdf.move_down 10
items = [["No","Description", "Qt.", "RM"]]
items += temp_arr.each_with_index.map do |item, i|
  [
    i + 1,
    item[:name],
    "1",
    item[:price],
  ]
end
items += [["", "Total", "", "22.00"]]


pdf.table items, :header => true,
  :column_widths => { 0 => 50, 1 => 350, 3 => 100}, :row_colors => ["d2e3ed", "FFFFFF"] do
    style(columns(3)) {|x| x.align = :right }
end


pdf.move_down 40
pdf.text "Terms & Conditions of Sales"
pdf.text "1. All cheques should be crossed and made payable to Awesomeness Ptd Ltd"

pdf.move_down 40
pdf.text "Received in good condition", :style => :italic

pdf.move_down 20
pdf.text "..............................."
pdf.text "Signature/Company Stamp"

pdf.move_down 10
pdf.stroke_horizontal_rule

pdf.bounding_box([pdf.bounds.right - 50, pdf.bounds.bottom], :width => 60, :height => 20) do
  pagecount = pdf.page_count
  pdf.text "Page #{pagecount}"
=end

