class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.string :position
      t.string :description

      t.timestamps
    end
  end
end
