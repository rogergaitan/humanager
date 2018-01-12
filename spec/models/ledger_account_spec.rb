require 'rails_helper'

RSpec.describe LedgerAccount, :type => :model do
  
  it "saves amount of children" do
    credit_account = LedgerAccount.create iaccount: "1", naccount: "PASIVO CIRCULANTE", ifather: ""
    
    LedgerAccount.create iaccount: "1230", naccount: "Tarjetas de credito",  ifather: "1"
    
    credit_account.reload
    expect(credit_account.children_count).to eq(1)
  end

  it "updates data from firebird" do
    LedgerAccount.sync_fb
    
    cntpuc = Cntpuc.where(bvisible: "T").first
    cntpuc.ncuenta = "Test"
    cntpuc.ipadre = "500"
    cntpuc.save

    account = LedgerAccount.find_by_iaccount(cntpuc.icuenta)

    LedgerAccount.sync_fb

    account.reload
    
    expect(account.naccount).to eq("Test")
    expect(account.ifather).to eq("500")
  end
  
end
