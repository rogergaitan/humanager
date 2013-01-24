class RemoveCodeFromOtherSalaries < ActiveRecord::Migration
  def up
    remove_column :other_salaries, :code
  end

  def down
    add_column :other_salaries, :code, :string
  end
end
