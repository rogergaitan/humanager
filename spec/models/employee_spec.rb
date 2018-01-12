require 'rails_helper'

RSpec.describe Employee, :type => :model do
  
  it "saves employee data from firebird" do
    Employee.sync_fb
    
    expect(Employee.count).to be > 1
  end
  
  it "updates employee data from firebird" do
    Employee.sync_fb

    abanit = Abanit.limit(100).last
    abanit.ntercero = "test"
    abanit.save
    
    employee = Entity.find_by_entityid abanit.init
    
    Employee.sync_fb
    
    employee.reload

    expect(employee.name).to eq("test")
    
    expect(Entity.count).to eq(287)
    expect(Employee.count).to eq(287)
  end  
end
