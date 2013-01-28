require 'test_helper'

class OtherSalariesControllerTest < ActionController::TestCase
  setup do
    @other_salary = other_salaries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:other_salaries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create other_salary" do
    assert_difference('OtherSalary.count') do
      post :create, other_salary: { code: @other_salary.code, description: @other_salary.description, ledger_account_id: @other_salary.ledger_account_id }
    end

    assert_redirected_to other_salary_path(assigns(:other_salary))
  end

  test "should show other_salary" do
    get :show, id: @other_salary
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @other_salary
    assert_response :success
  end

  test "should update other_salary" do
    put :update, id: @other_salary, other_salary: { code: @other_salary.code, description: @other_salary.description, ledger_account_id: @other_salary.ledger_account_id }
    assert_redirected_to other_salary_path(assigns(:other_salary))
  end

  test "should destroy other_salary" do
    assert_difference('OtherSalary.count', -1) do
      delete :destroy, id: @other_salary
    end

    assert_redirected_to other_salaries_path
  end
end
