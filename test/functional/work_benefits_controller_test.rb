require 'test_helper'

class WorkBenefitsControllerTest < ActionController::TestCase
  setup do
    @work_benefit = work_benefits(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:work_benefits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create work_benefit" do
    assert_difference('WorkBenefit.count') do
      post :create, work_benefit: { calculation_method: @work_benefit.calculation_method, description: @work_benefit.description, frequency: @work_benefit.frequency }
    end

    assert_redirected_to work_benefit_path(assigns(:work_benefit))
  end

  test "should show work_benefit" do
    get :show, id: @work_benefit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @work_benefit
    assert_response :success
  end

  test "should update work_benefit" do
    put :update, id: @work_benefit, work_benefit: { calculation_method: @work_benefit.calculation_method, description: @work_benefit.description, frequency: @work_benefit.frequency }
    assert_redirected_to work_benefit_path(assigns(:work_benefit))
  end

  test "should destroy work_benefit" do
    assert_difference('WorkBenefit.count', -1) do
      delete :destroy, id: @work_benefit
    end

    assert_redirected_to work_benefits_path
  end
end
