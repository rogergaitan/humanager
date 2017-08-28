require 'rails_helper'

RSpec.describe IrTablesController, :type => :controller do
  before do
    user = User.create username: 'testuser', name: 'test user', email: 'test@test.com',
                  password:'testpassword', password_confirmation:'testpassword'
    
    sign_in user  
  end
  
  describe "GET #index" do
    it "returns sucess status"  do
     get :index  
     
     expect(response).to be_success
    end
  end
  
  describe "GET #new" do
    it "returns success status" do
      get :new
      
      expect(response).to be_success
    end
  end
  
  describe "POST #create" do
    it "creates new ir table" do
      post :create,  ir_table: { name: "Test IR", start_date: Date.today, end_date: Date.tomorrow }
      
      expect(IrTable.count).to eq(1)
    end
  end
  
  describe "PUT #update" do
    it "updates ir table"  do
      ir_table = IrTable.create name: "Test IR", start_date: Date.today, end_date: Date.tomorrow
      
      put :update, {id: ir_table.id, ir_table: {name: "Updated Test IR", 
                                start_date: Date.today.end_of_week, end_date: Date.today.end_of_month}}
      
      ir_table.reload
      
      expect(ir_table.name).not_to eq("Test IR")
      expect(ir_table.start_date).not_to eq(Date.today)
      expect(ir_table.end_date).not_to eq(Date.tomorrow)
    end
  end
  
  describe "DELETE #destroy" do
     it "destroys ir table" do
       ir_table = IrTable.create name: "Test IR", start_date: Date.today, end_date: Date.tomorrow
       delete :destroy, id:  ir_table.id
       
       expect(IrTable.count).to eq(0)
     end
  end
  
end
