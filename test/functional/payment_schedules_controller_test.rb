require 'test_helper'

class PaymentSchedulesControllerTest < ActionController::TestCase
  setup do
    @payment_schedule = payment_schedules(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:payment_schedules)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create payment_schedule" do
    assert_difference('PaymentSchedule.count') do
      post :create, payment_schedule: { description: @payment_schedule.description, end_date: @payment_schedule.end_date, initial_date: @payment_schedule.initial_date }
    end

    assert_redirected_to payment_schedule_path(assigns(:payment_schedule))
  end

  test "should show payment_schedule" do
    get :show, id: @payment_schedule
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @payment_schedule
    assert_response :success
  end

  test "should update payment_schedule" do
    put :update, id: @payment_schedule, payment_schedule: { description: @payment_schedule.description, end_date: @payment_schedule.end_date, initial_date: @payment_schedule.initial_date }
    assert_redirected_to payment_schedule_path(assigns(:payment_schedule))
  end

  test "should destroy payment_schedule" do
    assert_difference('PaymentSchedule.count', -1) do
      delete :destroy, id: @payment_schedule
    end

    assert_redirected_to payment_schedules_path
  end
end
