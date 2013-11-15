class AddLabelsReportsToCompanies < ActiveRecord::Migration
  def change
  	rename_column :companies, :label_reports, :label_reports_1
  	add_column :companies, :label_reports_2, :text
  	add_column :companies, :label_reports_3, :text
  end
end
