class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :email_type
      t.string :email
      t.references :entity

      t.timestamps
    end
    add_index :emails, :entity_id
  end
end
