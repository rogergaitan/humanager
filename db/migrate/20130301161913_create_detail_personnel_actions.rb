class CreateDetailPersonnelActions < ActiveRecord::Migration
  def change
    create_table :detail_personnel_actions do |t|
      t.references :type_of_personnel_action
      t.references :fields_personnel_action
      t.string :value

      t.timestamps
    end
    add_index :detail_personnel_actions, :type_of_personnel_action_id
    add_index :detail_personnel_actions, :fields_personnel_action_id
  end
end
