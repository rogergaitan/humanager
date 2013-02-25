class ChangeDataTypeForKardexQuantity < ActiveRecord::Migration
  def self.up
  	change_table :kardexes do |t|
  		t.change :quantity, :float
  	end
  end

  def self.down
  	change_table :kardexes do |t|
  		t.change :quantity, :string
  	end
  end
end
