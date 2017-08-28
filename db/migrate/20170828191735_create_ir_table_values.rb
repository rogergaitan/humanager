class CreateIrTableValues < ActiveRecord::Migration
  def change
    create_table :ir_table_values do |t|
      t.decimal :from, precision: 10, scale: 2
      t.decimal :until, precision: 10, scale: 2
      t.decimal :percent, precision: 10, scale: 2
      t.decimal :base, precision: 10, scale: 2
      t.decimal :excess, precision: 10, scale: 2
      t.references :ir_table
    end
  end
end
