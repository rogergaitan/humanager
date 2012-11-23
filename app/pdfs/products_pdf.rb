class ProductsPDF < Prawn::Document
  
  def initialize(variable)
    super(top_margin: 70)
    @variable = variable
    line_items
  end
  
  def line_items
    move_down 20
    table line_item_rows do
      row(0).font_style = :bold
      self.row_colors = ["FFFFFF", "DDDDDD"]
      self.header = true
      self.cells.border_width = 0
    end
  end

  def line_item_rows
    [["ID", "NOMBRE","NUMERO PARTE"]] +
    @variable.map do |d, item|
      [item["code"],item["description"], item["part_number"]]
    end
  end
  
end
