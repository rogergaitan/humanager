class AddIndividualToDeduction < ActiveRecord::Migration
  def change
  	add_column :deductions, :individual, :boolean, :default => 0
  end
end
