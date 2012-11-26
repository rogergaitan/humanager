class CreateFieldsPersonnelActions < ActiveRecord::Migration
  def change
    create_table :fields_personnel_actions do |t|
      t.string :name
      t.string :field_type

      t.timestamps
    end
  end
end
