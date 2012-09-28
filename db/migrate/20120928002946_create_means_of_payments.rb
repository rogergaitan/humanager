class CreateMeansOfPayments < ActiveRecord::Migration
  def change
    create_table :means_of_payments do |t|
      t.string :description

      t.timestamps
    end
  end
end
