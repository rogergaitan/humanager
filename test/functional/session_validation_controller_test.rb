require 'test_helper'

class SessionValidationControllerTest < ActionController::TestCase
  test "should get updateTime" do
    get :updateTime
    assert_response :success
  end

end
