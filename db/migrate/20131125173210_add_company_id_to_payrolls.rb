class AddCompanyIdToPayrolls < ActiveRecord::Migration
  def change
  	add_column :payrolls, :company_id, :integer
  end
end
