require 'rails_helper'

RSpec.describe CreditorsController, :type => :controller do
  describe "GET #index"  do
    
    before do
      let(:user) { User.create username: 'testuser', name: 'test user', email: 'test@test.com',
                          password:'testpassword', password_confirmation:'testpassword' }
      
      sign_in user  
      
      let(:creditor) { Creditor.create name: "Test", creditor_id: 1 }
    end
    
    it "returns creditors listing" do
      get :index, format: :json
      
      expect(response).to be_success
      expect(response.body).to eq(creditor)
    end
  end
end
