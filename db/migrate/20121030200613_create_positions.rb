class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.string :position
      t.string :description
      t.string :codigo_ins
      t.string :codigo_ccss

      t.timestamps
    end
  end
end
