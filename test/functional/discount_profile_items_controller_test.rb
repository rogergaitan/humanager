require 'test_helper'

class DiscountProfileItemsControllerTest < ActionController::TestCase
  setup do
    @discount_profile_item = discount_profile_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:discount_profile_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create discount_profile_item" do
    assert_difference('DiscountProfileItem.count') do
      post :create, discount_profile_item: { category: @discount_profile_item.category, discount: @discount_profile_item.discount, discount_profile_id: @discount_profile_item.discount_profile_id, item_id: @discount_profile_item.item_id, item_type: @discount_profile_item.item_type }
    end

    assert_redirected_to discount_profile_item_path(assigns(:discount_profile_item))
  end

  test "should show discount_profile_item" do
    get :show, id: @discount_profile_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @discount_profile_item
    assert_response :success
  end

  test "should update discount_profile_item" do
    put :update, id: @discount_profile_item, discount_profile_item: { category: @discount_profile_item.category, discount: @discount_profile_item.discount, discount_profile_id: @discount_profile_item.discount_profile_id, item_id: @discount_profile_item.item_id, item_type: @discount_profile_item.item_type }
    assert_redirected_to discount_profile_item_path(assigns(:discount_profile_item))
  end

  test "should destroy discount_profile_item" do
    assert_difference('DiscountProfileItem.count', -1) do
      delete :destroy, id: @discount_profile_item
    end

    assert_redirected_to discount_profile_items_path
  end
end
