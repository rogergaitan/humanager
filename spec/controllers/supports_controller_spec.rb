require 'rails_helper'

RSpec.describe SupportsController, :type => :controller do
  
  before do
    user = User.create username: 'testuser', name: 'test user', email: 'test@test.com',
                  password:'testpassword', password_confirmation:'testpassword'
    
    sign_in user
  end

  describe "GET #index" do
    it "returns http success" do
      get :index, format: :json
      expect(response).to have_http_status(:success)
    end
  end

end
