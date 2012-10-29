class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :occupation
      t.string :phone
      t.string :email
      t.string :skype
      t.references :entity

      t.timestamps
    end
    add_index :contacts, :entity_id
  end
end
