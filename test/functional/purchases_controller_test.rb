require 'test_helper'

class PurchasesControllerTest < ActionController::TestCase
  setup do
    @purchase = purchases(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:purchases)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create purchase" do
    assert_difference('Purchase.count') do
      post :create, purchase: { completed: @purchase.completed, currency: @purchase.currency, dai_tax: @purchase.dai_tax, document_number: @purchase.document_number, isc_tax: @purchase.isc_tax, local: @purchase.local, purchase_date: @purchase.purchase_date, subtotal: @purchase.subtotal, taxes: @purchase.taxes, total: @purchase.total }
    end

    assert_redirected_to purchase_path(assigns(:purchase))
  end

  test "should show purchase" do
    get :show, id: @purchase
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @purchase
    assert_response :success
  end

  test "should update purchase" do
    put :update, id: @purchase, purchase: { completed: @purchase.completed, currency: @purchase.currency, dai_tax: @purchase.dai_tax, document_number: @purchase.document_number, isc_tax: @purchase.isc_tax, local: @purchase.local, purchase_date: @purchase.purchase_date, subtotal: @purchase.subtotal, taxes: @purchase.taxes, total: @purchase.total }
    assert_redirected_to purchase_path(assigns(:purchase))
  end

  test "should destroy purchase" do
    assert_difference('Purchase.count', -1) do
      delete :destroy, id: @purchase
    end

    assert_redirected_to purchases_path
  end
end
