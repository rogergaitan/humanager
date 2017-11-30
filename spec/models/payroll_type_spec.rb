require 'rails_helper'

RSpec.describe PayrollType, :type => :model do
  
  before do
    @payroll_type = PayrollType.create(company_id: 1, description: "test payroll",
                                 payroll_type: :plant, state: true, cod_doc_payroll_support: 1, mask_doc_payroll_support: "PTCI-",
                                 cod_doc_accounting_support_mov: 1, mask_doc_accounting_support_mov: "OP-@@", calendar_color: "#1a84d1")
    
    payroll = Payroll.new(company_id: 1, payroll_type_id: @payroll_type.id, start_date: Date.today, end_date: Date.tomorrow,
                     payment_date: Date.tomorrow, state: true, currency_id: 1)
    payroll.save(validate: false)  
  end
  
  it "checks payroll type can't be deleted with associated payroll" do
    expect(@payroll_type.check_associations_before_destroy).to eq(false)
  end
  
  it "checks payroll type can't be deleted with associated deduction" do
    PayrollTypeDeduction.create deduction_id: 1, payroll_type_id: @payroll_type.id
  
    expect(@payroll_type.check_associations_before_destroy).to eq(false)
  end
  
  it "checks payroll type can't be deleted with associated work benefit" do
    PayrollTypeBenefit.create work_benefit_id: 1, payroll_type_id: @payroll_type.id
    
    expect(@payroll_type.check_associations_before_destroy).to eq(false)
  end
  
  
  it "checks payroll type can't be deleted with associated other payment" do
    PayrollTypeOtherPayment.create other_payment_id: 1, payroll_type_id: @payroll_type.id
    
    expect(@payroll_type.check_associations_before_destroy).to eq(false)
  end
  
end
