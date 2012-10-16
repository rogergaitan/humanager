require 'test_helper'

class PaymentFrequenciesControllerTest < ActionController::TestCase
  setup do
    @payment_frequency = payment_frequencies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:payment_frequencies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create payment_frequency" do
    assert_difference('PaymentFrequency.count') do
      post :create, payment_frequency: { description: @payment_frequency.description, name: @payment_frequency.name }
    end

    assert_redirected_to payment_frequency_path(assigns(:payment_frequency))
  end

  test "should show payment_frequency" do
    get :show, id: @payment_frequency
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @payment_frequency
    assert_response :success
  end

  test "should update payment_frequency" do
    put :update, id: @payment_frequency, payment_frequency: { description: @payment_frequency.description, name: @payment_frequency.name }
    assert_redirected_to payment_frequency_path(assigns(:payment_frequency))
  end

  test "should destroy payment_frequency" do
    assert_difference('PaymentFrequency.count', -1) do
      delete :destroy, id: @payment_frequency
    end

    assert_redirected_to payment_frequencies_path
  end
end
