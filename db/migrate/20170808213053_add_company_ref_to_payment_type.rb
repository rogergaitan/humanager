class AddCompanyRefToPaymentType < ActiveRecord::Migration
  def change
    add_column :payment_types, :company_id, :integer
  end
end
