require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  setup do
    @product = products(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product" do
    assert_difference('Product.count') do
      post :create, product: { address: @product.address, bar_code: @product.bar_code, category_id: @product.category_id, code: @product.code, cost: @product.cost, line_id: @product.line_id, make: @product.make, market_price: @product.market_price, max_cant: @product.max_cant, max_discount: @product.max_discount, min_cant: @product.min_cant, model: @product.model, name: @product.name, part_number: @product.part_number, status: @product.status, stock: @product.stock, subline_id: @product.subline_id, version: @product.version, year: @product.year }
    end

    assert_redirected_to product_path(assigns(:product))
  end

  test "should show product" do
    get :show, id: @product
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product
    assert_response :success
  end

  test "should update product" do
    put :update, id: @product, product: { address: @product.address, bar_code: @product.bar_code, category_id: @product.category_id, code: @product.code, cost: @product.cost, line_id: @product.line_id, make: @product.make, market_price: @product.market_price, max_cant: @product.max_cant, max_discount: @product.max_discount, min_cant: @product.min_cant, model: @product.model, name: @product.name, part_number: @product.part_number, status: @product.status, stock: @product.stock, subline_id: @product.subline_id, version: @product.version, year: @product.year }
    assert_redirected_to product_path(assigns(:product))
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete :destroy, id: @product
    end

    assert_redirected_to products_path
  end
end
