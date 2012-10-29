require 'test_helper'

class MeansOfPaymentsControllerTest < ActionController::TestCase
  setup do
    @means_of_payment = means_of_payments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:means_of_payments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create means_of_payment" do
    assert_difference('MeansOfPayment.count') do
      post :create, means_of_payment: { description: @means_of_payment.description, name: @means_of_payment.name }
    end

    assert_redirected_to means_of_payment_path(assigns(:means_of_payment))
  end

  test "should show means_of_payment" do
    get :show, id: @means_of_payment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @means_of_payment
    assert_response :success
  end

  test "should update means_of_payment" do
    put :update, id: @means_of_payment, means_of_payment: { description: @means_of_payment.description, name: @means_of_payment.name }
    assert_redirected_to means_of_payment_path(assigns(:means_of_payment))
  end

  test "should destroy means_of_payment" do
    assert_difference('MeansOfPayment.count', -1) do
      delete :destroy, id: @means_of_payment
    end

    assert_redirected_to means_of_payments_path
  end
end
