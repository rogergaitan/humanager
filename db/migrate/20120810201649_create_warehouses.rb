# -*- encoding : utf-8 -*-
class CreateWarehouses < ActiveRecord::Migration
  def change
    create_table :warehouses do |t|
      t.string :code
      t.string :name
      t.string :description
      t.string :manager
      t.string :address

      t.timestamps
    end
  end
end
