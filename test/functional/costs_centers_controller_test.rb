require 'test_helper'

class CostsCentersControllerTest < ActionController::TestCase
  setup do
    @costs_center = costs_centers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:costs_centers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create costs_center" do
    assert_difference('CostsCenter.count') do
      post :create, costs_center: {  }
    end

    assert_redirected_to costs_center_path(assigns(:costs_center))
  end

  test "should show costs_center" do
    get :show, id: @costs_center
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @costs_center
    assert_response :success
  end

  test "should update costs_center" do
    put :update, id: @costs_center, costs_center: {  }
    assert_redirected_to costs_center_path(assigns(:costs_center))
  end

  test "should destroy costs_center" do
    assert_difference('CostsCenter.count', -1) do
      delete :destroy, id: @costs_center
    end

    assert_redirected_to costs_centers_path
  end
end
