require 'rails_helper'

RSpec.describe Employee, :type => :model do
  
  it "saves employee data from firebird" do
    Employee.sync_fb
    
    expect(Employee.count).to be > 1
  end
  
  it "updates employee data from firebird" do
    Employee.sync_fb
    
    Employee.sync_fb
    
#     expect(entity.name).not_to eq("Test")
#     expect(entity.surname).not_to eq("Test")
#     expect(entity.address.department).not_to eq("Test")
#     expect(entity.address.municipality).not_to eq("Test")
#     expect(entity.address.country).not_to eq("Test")
#     expect(entity.address.address).not_to eq("Test")
#     
    expect(Entity.count).to eq(287)
    expect(Employee.count).to eq(287)
  end  
end
