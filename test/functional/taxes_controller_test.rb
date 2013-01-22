require 'test_helper'

class TaxesControllerTest < ActionController::TestCase
  setup do
    @taxis = taxes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:taxes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create taxis" do
    assert_difference('Taxis.count') do
      post :create, taxis: { amount: @taxis.amount, cc_id: @taxis.cc_id, name: @taxis.name }
    end

    assert_redirected_to taxis_path(assigns(:taxis))
  end

  test "should show taxis" do
    get :show, id: @taxis
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @taxis
    assert_response :success
  end

  test "should update taxis" do
    put :update, id: @taxis, taxis: { amount: @taxis.amount, cc_id: @taxis.cc_id, name: @taxis.name }
    assert_redirected_to taxis_path(assigns(:taxis))
  end

  test "should destroy taxis" do
    assert_difference('Taxis.count', -1) do
      delete :destroy, id: @taxis
    end

    assert_redirected_to taxes_path
  end
end
