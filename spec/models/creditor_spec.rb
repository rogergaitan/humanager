require 'rails_helper'

RSpec.describe Creditor, :type => :model do
  
  it "saves creditor data from firebird" do
    Creditor.sync_fb
    
    expect(Creditor.count).to be > 0
  end
  
  it "update creditor data from firebird" do
    Creditor.sync_fb
    
    creditor = Creditor.first
    creditor.name = "Test"
    creditor.save
    
    Creditor.sync_fb
    
    creditor.reload
    expect(creditor.name).not_to eq("Test")
  end
  
end
