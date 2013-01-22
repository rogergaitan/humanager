require 'test_helper'

class DiscountProfilesControllerTest < ActionController::TestCase
  setup do
    @discount_profile = discount_profiles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:discount_profiles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create discount_profile" do
    assert_difference('DiscountProfile.count') do
      post :create, discount_profile: { description: @discount_profile.description }
    end

    assert_redirected_to discount_profile_path(assigns(:discount_profile))
  end

  test "should show discount_profile" do
    get :show, id: @discount_profile
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @discount_profile
    assert_response :success
  end

  test "should update discount_profile" do
    put :update, id: @discount_profile, discount_profile: { description: @discount_profile.description }
    assert_redirected_to discount_profile_path(assigns(:discount_profile))
  end

  test "should destroy discount_profile" do
    assert_difference('DiscountProfile.count', -1) do
      delete :destroy, id: @discount_profile
    end

    assert_redirected_to discount_profiles_path
  end
end
