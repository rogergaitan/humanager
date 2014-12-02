class CreateOccupations < ActiveRecord::Migration
  def change
    create_table :occupations do |t|
      t.string :description
      t.string :ins_code
      t.string :ccss_code

      t.timestamps
    end
  end
end
