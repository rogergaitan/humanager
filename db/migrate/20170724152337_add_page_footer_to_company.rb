class AddPageFooterToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :page_footer, :string
  end
end
