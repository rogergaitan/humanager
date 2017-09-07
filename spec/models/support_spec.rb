require 'rails_helper'

RSpec.describe Support, :type => :model do
  
  it "saves data from firebird" do
    Support.sync_fb
    
    expect(Support.count).to be > 0
  end
  
  it "updates data from firebird" do
   
    Support.sync_fb
    
    support = Support.first
    support.update_attributes({smask: "$##",  ntdsop: "test"} )
    support.save
    
    total = Support.count
    
    Support.sync_fb
    
    support.reload
    expect(Support.count).to eq(total)
    expect(support.ntdsop).not_to eq("test")
    expect(support.smask).not_to eq("$##")
  end
end
