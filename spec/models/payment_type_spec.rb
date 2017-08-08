require 'rails_helper'

RSpec.describe PaymentType, :type => :model do

  context "when payment types is empty" do
    it "crate data from firebird" do
      PaymentType.sync_fb
      
      expect(PaymentType.count).to be > 1
    end
  end
    
    
  context "when payment type exists" do
    it "updates data from firebird" do
      payment_type = PaymentType.create(company_id:  1, contract_code: 1,
                                      name: "test name", performance_unit: "test unit",
                                      factor: "test factor")
      
      PaymentType.sync_fb
      
      payment_type.reload
      
      expect(payment_type.name).not_to eq("test name")
      expect(payment_type.performance_unit).not_to eq("test unit")
      expect(payment_type.factor).not_to eq("test factor")
    end
  end
end
