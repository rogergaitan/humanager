class CreateCantons < ActiveRecord::Migration
  def change
    create_table :cantons do |t|
      t.integer :province_id
      t.string :canton

      t.timestamps
    end
  end
end
