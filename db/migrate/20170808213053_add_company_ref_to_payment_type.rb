class AddCompanyRefToPaymentType < ActiveRecord::Migration
  def change
    add_column :payment_types, :company_id, :integer
  end
  
  add_index :payment_types, :company_id
end
