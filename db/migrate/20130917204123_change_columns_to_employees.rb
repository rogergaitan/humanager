class ChangeColumnsToEmployees < ActiveRecord::Migration
  def change
  	change_column(:employees, :gender, :enum, :limit => [:masculino, :femenino])
  	change_column(:employees, :marital_status, :enum, :limit => [:soltero, :casado, :divorciado, 
                :viudo, :union_civil, :comprometido])
  end
end
