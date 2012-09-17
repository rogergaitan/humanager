require 'test_helper'

class ProductPricingsControllerTest < ActionController::TestCase
  setup do
    @product_pricing = product_pricings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_pricings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_pricing" do
    assert_difference('ProductPricing.count') do
      post :create, product_pricing: { category: @product_pricing.category, product_id: @product_pricing.product_id, sell_price: @product_pricing.sell_price, type: @product_pricing.type, utility: @product_pricing.utility }
    end

    assert_redirected_to product_pricing_path(assigns(:product_pricing))
  end

  test "should show product_pricing" do
    get :show, id: @product_pricing
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product_pricing
    assert_response :success
  end

  test "should update product_pricing" do
    put :update, id: @product_pricing, product_pricing: { category: @product_pricing.category, product_id: @product_pricing.product_id, sell_price: @product_pricing.sell_price, type: @product_pricing.type, utility: @product_pricing.utility }
    assert_redirected_to product_pricing_path(assigns(:product_pricing))
  end

  test "should destroy product_pricing" do
    assert_difference('ProductPricing.count', -1) do
      delete :destroy, id: @product_pricing
    end

    assert_redirected_to product_pricings_path
  end
end
