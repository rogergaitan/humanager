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
    text "Orden OC-#{@order.id}", size: 30, style: :bold
    text "Proveedor: #{@order.vendor.entity.name}", size: 10
    text "Fecha Entrega #{@order.delivery_date}", size: 8
    text "Referencia #{@order.reference_info}", size: 8
  end
  
  def line_items
    move_down 20
    table line_item_rows do
      row(0).font_style = :bold
      row(0).size = 8
      columns(0..5).size = 8
      columns(2..5).align = :right
      columns(0).width = 50                 #CODE
      columns(1).width = 250                #DESCRIPTION
      columns(2..6).width = 55
      self.row_colors = ["DDDDDD", "FFFFFF"]
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