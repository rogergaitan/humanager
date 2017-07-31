class ChangeOccupationFields < ActiveRecord::Migration
  def change
    rename_column :occupations, :ins_code, :inss_code
    rename_column :occupations, :ccss_code, :other_code
  end
end
