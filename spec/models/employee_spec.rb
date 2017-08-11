require 'rails_helper'

RSpec.describe Employee, :type => :model do
  
  it "saves employee data from firebird" do
    Employee.sync_fb
    
    expect(Employee.count).to be > 1
  end
  
  it "updates employee data from firebird" do
    entity = Entity.create name: "Test", surname: "Test", entityid: "4430109750003L"
    entity.create_address department: "Test", municipality: "Test", country: "Test", address: "Test"
    
    Employee.sync_fb
    
    entity.reload
    expect(entity.name).not_to eq("Test")
    expect(entity.surname).not_to eq("Test")
    expect(entity.address.department).not_to eq("Test")
    expect(entity.address.municipality).not_to eq("Test")
    expect(entity.address.country).not_to eq("Test")
    expect(entity.address.address).not_to eq("Test")
  end  
end
