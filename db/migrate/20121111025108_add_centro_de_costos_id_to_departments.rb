class AddCentroDeCostosIdToDepartments < ActiveRecord::Migration
  def change
    add_column :departments, :centro_de_costos_id, :integer
  end
end
