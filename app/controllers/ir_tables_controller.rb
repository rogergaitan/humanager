class IrTablesController < ApplicationController
  
  before_filter :set_ir_table, only: [:update, :destroy, :edit]
  
  def index
    @ir_tables = IrTable.all
  end
  
  def new
    @ir_table = IrTable.new
    @ir_table.ir_table_values.build
  end
  
  def create
    @ir_table = IrTable.new params[:ir_table]
    if @ir_table.save
      redirect_to ir_tables_path, notice: "Tabla IR creada correctamente."
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @ir_table.update_attributes params[:ir_table]
      redirect_to ir_tables_path, notice: "Tabla IR actualizada correctamente."  
    else
      render :edit
    end
  end
  
  def destroy
    @ir_table.destroy
    redirect_to ir_tables_path, notice: "Tabla IR eliminada correctamente."
  end
  
  private 
  
    def set_ir_table
      @ir_table = IrTable.find params[:id]
    rescue ActiveRecord::RecordNotFound
      redirect_to ir_tables_path, notice: "El registro que busca no existe."
    end
  
end
