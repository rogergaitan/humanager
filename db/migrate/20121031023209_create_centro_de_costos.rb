class CreateCentroDeCostos < ActiveRecord::Migration
  def change
    create_table :centro_de_costos do |t|
      t.string :iempresa
      t.string :icentro_costo
      t.string :nombre_cc
      t.string :icc_padre

      t.timestamps
    end
  end
end
