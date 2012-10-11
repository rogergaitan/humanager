require 'test_helper'

class EmployeesControllerTest < ActionController::TestCase
  setup do
    @employee = employees(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:employees)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create employee" do
    assert_difference('Employee.count') do
      post :create, employee: { birthday: @employee.birthday, ccss_calculated: @employee.ccss_calculated, deparment_id: @employee.deparment_id, gender: @employee.gender, join_date: @employee.join_date, marital_status: @employee.marital_status, means_of_payment_id: @employee.means_of_payment_id, number_of_dependents: @employee.number_of_dependents, ocupation_id: @employee.ocupation_id, payment_frecuency_id: @employee.payment_frecuency_id, payment_method_id: @employee.payment_method_id, role_id: @employee.role_id, social_insurance: @employee.social_insurance, spouse: @employee.spouse, wage_payment: @employee.wage_payment }
    end

    assert_redirected_to employee_path(assigns(:employee))
  end

  test "should show employee" do
    get :show, id: @employee
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @employee
    assert_response :success
  end

  test "should update employee" do
    put :update, id: @employee, employee: { birthday: @employee.birthday, ccss_calculated: @employee.ccss_calculated, deparment_id: @employee.deparment_id, gender: @employee.gender, join_date: @employee.join_date, marital_status: @employee.marital_status, means_of_payment_id: @employee.means_of_payment_id, number_of_dependents: @employee.number_of_dependents, ocupation_id: @employee.ocupation_id, payment_frecuency_id: @employee.payment_frecuency_id, payment_method_id: @employee.payment_method_id, role_id: @employee.role_id, social_insurance: @employee.social_insurance, spouse: @employee.spouse, wage_payment: @employee.wage_payment }
    assert_redirected_to employee_path(assigns(:employee))
  end

  test "should destroy employee" do
    assert_difference('Employee.count', -1) do
      delete :destroy, id: @employee
    end

    assert_redirected_to employees_path
  end
end
