require 'test_helper'

class PurchaseOrderPaymentsControllerTest < ActionController::TestCase
  setup do
    @purchase_order_payment = purchase_order_payments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:purchase_order_payments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create purchase_order_payment" do
    assert_difference('PurchaseOrderPayment.count') do
      post :create, purchase_order_payment: { amount: @purchase_order_payment.amount, number: @purchase_order_payment.number }
    end

    assert_redirected_to purchase_order_payment_path(assigns(:purchase_order_payment))
  end

  test "should show purchase_order_payment" do
    get :show, id: @purchase_order_payment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @purchase_order_payment
    assert_response :success
  end

  test "should update purchase_order_payment" do
    put :update, id: @purchase_order_payment, purchase_order_payment: { amount: @purchase_order_payment.amount, number: @purchase_order_payment.number }
    assert_redirected_to purchase_order_payment_path(assigns(:purchase_order_payment))
  end

  test "should destroy purchase_order_payment" do
    assert_difference('PurchaseOrderPayment.count', -1) do
      delete :destroy, id: @purchase_order_payment
    end

    assert_redirected_to purchase_order_payments_path
  end
end
