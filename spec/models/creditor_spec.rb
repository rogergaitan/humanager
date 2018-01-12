require 'rails_helper'

RSpec.describe Creditor, :type => :model do
  
  it "saves creditor data from firebird" do
    Creditor.sync_fb
    
    expect(Creditor.count).to be > 0
  end
  
  it "updates creditor data from firebird" do
    Creditor.sync_fb
    
    abanit = Abanit.where(bproveedor: "T").first
    abanit.ntercero = "Test"
    abanit.save

    creditor = Creditor.find_by_creditor_id(abanit.init)
    
    Creditor.sync_fb
    
    creditor.reload
    expect(creditor.name).to eq("Test")
  end
  
end
