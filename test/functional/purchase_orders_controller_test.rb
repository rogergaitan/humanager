require 'test_helper'

class PurchaseOrdersControllerTest < ActionController::TestCase
  setup do
    @purchase_order = purchase_orders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:purchase_orders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create purchase_order" do
    assert_difference('PurchaseOrder.count') do
      post :create, purchase_order: { currency: @purchase_order.currency, delivery_date: @purchase_order.delivery_date, observation: @purchase_order.observation, reference_info: @purchase_order.reference_info, shipping_type: @purchase_order.shipping_type, subtotal: @purchase_order.subtotal, taxes: @purchase_order.taxes, total: @purchase_order.total }
    end

    assert_redirected_to purchase_order_path(assigns(:purchase_order))
  end

  test "should show purchase_order" do
    get :show, id: @purchase_order
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @purchase_order
    assert_response :success
  end

  test "should update purchase_order" do
    put :update, id: @purchase_order, purchase_order: { currency: @purchase_order.currency, delivery_date: @purchase_order.delivery_date, observation: @purchase_order.observation, reference_info: @purchase_order.reference_info, shipping_type: @purchase_order.shipping_type, subtotal: @purchase_order.subtotal, taxes: @purchase_order.taxes, total: @purchase_order.total }
    assert_redirected_to purchase_order_path(assigns(:purchase_order))
  end

  test "should destroy purchase_order" do
    assert_difference('PurchaseOrder.count', -1) do
      delete :destroy, id: @purchase_order
    end

    assert_redirected_to purchase_orders_path
  end
end
