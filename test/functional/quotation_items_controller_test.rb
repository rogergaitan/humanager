require 'test_helper'

class QuotationItemsControllerTest < ActionController::TestCase
  setup do
    @quotation_item = quotation_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:quotation_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create quotation_item" do
    assert_difference('QuotationItem.count') do
      post :create, quotation_item: { code: @quotation_item.code, description: @quotation_item.description, discount: @quotation_item.discount, quantity: @quotation_item.quantity, tax: @quotation_item.tax, total: @quotation_item.total, unit_price: @quotation_item.unit_price }
    end

    assert_redirected_to quotation_item_path(assigns(:quotation_item))
  end

  test "should show quotation_item" do
    get :show, id: @quotation_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @quotation_item
    assert_response :success
  end

  test "should update quotation_item" do
    put :update, id: @quotation_item, quotation_item: { code: @quotation_item.code, description: @quotation_item.description, discount: @quotation_item.discount, quantity: @quotation_item.quantity, tax: @quotation_item.tax, total: @quotation_item.total, unit_price: @quotation_item.unit_price }
    assert_redirected_to quotation_item_path(assigns(:quotation_item))
  end

  test "should destroy quotation_item" do
    assert_difference('QuotationItem.count', -1) do
      delete :destroy, id: @quotation_item
    end

    assert_redirected_to quotation_items_path
  end
end
