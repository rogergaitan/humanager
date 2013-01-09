require 'test_helper'

class PurchasePaymentOptionsControllerTest < ActionController::TestCase
  setup do
    @purchase_payment_option = purchase_payment_options(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:purchase_payment_options)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create purchase_payment_option" do
    assert_difference('PurchasePaymentOption.count') do
      post :create, purchase_payment_option: { amount: @purchase_payment_option.amount, number: @purchase_payment_option.number }
    end

    assert_redirected_to purchase_payment_option_path(assigns(:purchase_payment_option))
  end

  test "should show purchase_payment_option" do
    get :show, id: @purchase_payment_option
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @purchase_payment_option
    assert_response :success
  end

  test "should update purchase_payment_option" do
    put :update, id: @purchase_payment_option, purchase_payment_option: { amount: @purchase_payment_option.amount, number: @purchase_payment_option.number }
    assert_redirected_to purchase_payment_option_path(assigns(:purchase_payment_option))
  end

  test "should destroy purchase_payment_option" do
    assert_difference('PurchasePaymentOption.count', -1) do
      delete :destroy, id: @purchase_payment_option
    end

    assert_redirected_to purchase_payment_options_path
  end
end
