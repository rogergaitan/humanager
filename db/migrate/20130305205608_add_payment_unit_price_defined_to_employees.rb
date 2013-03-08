class AddPaymentUnitPriceDefinedToEmployees < ActiveRecord::Migration

  def change
	add_column :employees, :payment_unit_id, :integer
  	add_column :employees, :price_defined_work, :boolean
  	add_index :employees, :payment_unit_id
  end

end