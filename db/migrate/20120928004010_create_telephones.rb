class CreateTelephones < ActiveRecord::Migration
  def change
    create_table :telephones do |t|
      t.references :person
      t.string :telephone
      t.column :typephone, :enum, :limit => [:phone, :cell]

      t.timestamps
    end
    add_index :telephones, :person_id
  end
end
