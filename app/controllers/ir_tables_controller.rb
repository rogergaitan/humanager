class IrTablesController < ApplicationController
  
  def index
    @ir_tables = IrTable.all
  end
  
end
