require 'test_helper'

class OtherPaymentsControllerTest < ActionController::TestCase
  setup do
    @other_payment = other_payments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:other_payments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create other_payment" do
    assert_difference('OtherPayment.count') do
      post :create, other_payment: { description: @other_payment.description }
    end

    assert_redirected_to other_payment_path(assigns(:other_payment))
  end

  test "should show other_payment" do
    get :show, id: @other_payment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @other_payment
    assert_response :success
  end

  test "should update other_payment" do
    put :update, id: @other_payment, other_payment: { description: @other_payment.description }
    assert_redirected_to other_payment_path(assigns(:other_payment))
  end

  test "should destroy other_payment" do
    assert_difference('OtherPayment.count', -1) do
      delete :destroy, id: @other_payment
    end

    assert_redirected_to other_payments_path
  end
end
