class CreatePersonalizedFields < ActiveRecord::Migration
  def change
    create_table :personalized_fields do |t|
      t.references :type_of_personnel_action
      t.references :fields_personnel_action

      t.timestamps
    end
    add_index :personalized_fields, :type_of_personnel_action_id
    add_index :personalized_fields, :fields_personnel_action_id
  end
end
