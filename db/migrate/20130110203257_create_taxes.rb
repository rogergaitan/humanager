class CreateTaxes < ActiveRecord::Migration
  def change
    create_table :taxes do |t|
      t.string :name
      t.float :amount
      t.string :cc_id

      t.timestamps
    end
  end
end
