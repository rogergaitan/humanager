class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.references :entity
      t.string :name
      t.string :occupation
      t.string :phone
      t.string :email
      t.string :skype

      t.timestamps
    end
    add_index :contacts, :entity_id
  end
end
