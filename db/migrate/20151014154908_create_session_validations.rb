class CreateSessionValidations < ActiveRecord::Migration
  def change
    create_table :session_validations do |t|
    	t.references :user
    	t.references :model_name
    	t.integer :reference_id
    	t.string :ip_address

      t.timestamps
    end
    add_index :session_validations, :user_id
    add_index :session_validations, :model_name_id
  end
end
