class ChangeTypeidToEntities < ActiveRecord::Migration
  def change
  	change_column(:entities, :typeid, :enum, :limit => [:ced_nacional, :ced_residencia, :ced_juridica])
  end
end
