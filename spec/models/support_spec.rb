require 'rails_helper'

RSpec.describe Support, :type => :model do
  
  it "saves data from firebird" do
    Support.sync_fb
    
    expect(Support.count).to be > 0
  end
  
  it "updates data from firebird" do
    Support.sync_fb
    
    abamtdsop = Abamtdsop.first
    abamtdsop.ntdsop = "N##"
    abamtdsop.smask = "S##"
    abamtdsop.save

    support = Support.find_by_itdsop(abamtdsop.itdsop)
    
    Support.sync_fb
    
    support.reload
 
    expect(support.ntdsop).to eq("N##")
    expect(support.smask).to eq("S##")
  end
end
