class PurchasePDF < Prawn::Document

  def initialize(purchase, view = nil)
    super(top_margin: 70)
    @purchase = purchase
    @view = view
    purchase_info
    line_items
  end

  def purchase_info
    text "Compra: C-#{@purchase.id}", size: 20, style: :bold
    text "Proveedor: #{@purchase.vendor.entity.name}", size: 10
    text "Moneda: #{@purchase.currency}", size: 8
    text "Tipo: #{@purchase.purchase_type}", size: 8
    text "Referencia: #{@purchase.document_number}", size: 8
  end

  def line_items
    move_down 2
    table line_item_rows do
      row(0).font_style = :bold
      row(0).size = 8
      columns(0..6).size = 8
      columns(2).align = :left
      columns(3..6).align = :right
      columns(0..1).width = 50                 
      columns(2).width = 215                
      columns(3..6).width = 55
      self.row_colors = ["d2e3ed", "FFFFFF"]
      self.header = true
      self.cells.border_width = 0
    end
  end

  def line_item_rows
    [["BODEGA", "CODIGO", "DESCRIPCION", "CANT","DESC", "C/UNIT", "C/TOTAL"]] +
    @purchase.purchase_items.map do |item|
      [item.warehouse_id, item.product_id, item.description, item.quantity, item.discount, item.cost_unit, item.cost_total]
    end
  end

end
