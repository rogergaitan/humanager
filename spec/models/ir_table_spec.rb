require 'rails_helper'

RSpec.describe IrTable, :type => :model do
  
  it "checks ir table validation" do
    ir_table = IrTable.new name: "Test IR", start_date: Date.today, end_date: Date.tomorrow
    ir_table.ir_table_values << IrTableValue.new(from: 0.01, until: 100000.00, base: 0, percent: 0.00, excess: 0)
    ir_table.ir_table_values << IrTableValue.new(from: 100000.01, until: 200000.00, base: 0, percent: 15.00, excess: 100000)
    ir_table.ir_table_values << IrTableValue.new(from: 200000.01, until: 350000.00, base: 15000, percent: 20.00, excess: 200000)
    ir_table.ir_table_values << IrTableValue.new(from: 350000.01, until: 500000.00, base: 45000, percent: 25.00, excess: 350000)
    ir_table.ir_table_values << IrTableValue.new(from: 500000.01, until: 500000.02, base: 82500, percent: 30.00, excess: 50000.00)
    ir_table.save
    
    expect(ir_table.ir_table_values.count).to eq(5)
  end
  
  it "check ir table validation with invalid input" do
    ir_table = IrTable.new name: "Test IR", start_date: Date.today, end_date: Date.tomorrow
    ir_table.ir_table_values << IrTableValue.new(from: 0.01, until: 100000.00, base: 0, percent: 0.00, excess: 0)
    ir_table.ir_table_values << IrTableValue.new(from: 100000, until: 200000.00, base: 0, percent: 15.00, excess: 100000)
    ir_table.ir_table_values << IrTableValue.new(from: 200000.01, until: 350000.00, base: 15000, percent: 20.00, excess: 200000)
    ir_table.ir_table_values << IrTableValue.new(from: 350000.01, until: 500000.00, base: 45000, percent: 25.00, excess: 350000)
    ir_table.ir_table_values << IrTableValue.new(from: 500000.01, until: 500000.02, base: 82500, percent: 30.00, excess: 50000.00)
    ir_table.save
    
    expect(ir_table.ir_table_values.count).to eq(0)
  end
  
end
