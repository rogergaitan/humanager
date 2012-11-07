require 'test_helper'

class PayrollTypesControllerTest < ActionController::TestCase
  setup do
    @payroll_type = payroll_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:payroll_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create payroll_type" do
    assert_difference('PayrollType.count') do
      post :create, payroll_type: { description: @payroll_type.description }
    end

    assert_redirected_to payroll_type_path(assigns(:payroll_type))
  end

  test "should show payroll_type" do
    get :show, id: @payroll_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @payroll_type
    assert_response :success
  end

  test "should update payroll_type" do
    put :update, id: @payroll_type, payroll_type: { description: @payroll_type.description }
    assert_redirected_to payroll_type_path(assigns(:payroll_type))
  end

  test "should destroy payroll_type" do
    assert_difference('PayrollType.count', -1) do
      delete :destroy, id: @payroll_type
    end

    assert_redirected_to payroll_types_path
  end
end
