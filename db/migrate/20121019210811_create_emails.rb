class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.references :entity
      t.string :email
      t.column :typeemail, :enum, :limit => [:personal, :work]

      t.timestamps
    end
    add_index :emails, :entity_id
  end
end
