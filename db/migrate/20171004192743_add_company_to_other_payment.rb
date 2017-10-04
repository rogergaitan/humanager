class AddCompanyToOtherPayment < ActiveRecord::Migration
  def change
    change_table :other_payments do |t|
     t.references  :company
    end
  end
end
