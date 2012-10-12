class ChangeEmployeeReferenceEntity < ActiveRecord::Migration
  def up
  	change_table :employees do |t|
    	t.references :entity
  	end
  	add_index :employees, :entity_id
  end
end
