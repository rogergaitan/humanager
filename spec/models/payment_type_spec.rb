require 'rails_helper'

RSpec.describe PaymentType, :type => :model do

  it "crate data from firebird" do
    PaymentType.sync_fb
    
    expect(PaymentType.count).to be > 1
  end
    
  it "updates payroll data from firebird" do
    PaymentType.sync_fb
    
    labtdcto = Labtdcto.first
    labtdcto.ntdcontrato = "Pago por semana"
    labtdcto.save
    payment_type = PaymentType.find_by_company_id_and_contract_code(labtdcto.iemp, labtdcto.itdcontrato)
    
    PaymentType.sync_fb
    
    payment_type.reload
    
    expect(payment_type.name).to eq("Pago por semana")

  end
end
