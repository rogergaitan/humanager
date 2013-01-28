class CreateTypeOfPersonnelActions < ActiveRecord::Migration
  def change
    create_table :type_of_personnel_actions do |t|
      t.string :description

      t.timestamps
    end
  end
end
