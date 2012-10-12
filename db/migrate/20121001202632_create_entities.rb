class CreateEntities < ActiveRecord::Migration
  def change
    create_table :entities do |t|
      t.string :name
      t.string :surname
      t.integer :entityid
      t.column :typeid, :enum, :limit =>[:nacional, :extranjero, :juridico] 
      
      t.timestamps
    end
  end
end
