class CreateTelephones < ActiveRecord::Migration
  def change
    create_table :telephones do |t|
      t.references :entity
      t.string :telephone
      t.column :typephone, :enum, :limit => [:personal, :home, :work]

      t.timestamps
    end
    add_index :telephones, :entity_id
  end
end
