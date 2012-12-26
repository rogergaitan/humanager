require 'test_helper'

class ProductApplicationsControllerTest < ActionController::TestCase
  setup do
    @product_application = product_applications(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_applications)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_application" do
    assert_difference('ProductApplication.count') do
      post :create, product_application: { name: @product_application.name }
    end

    assert_redirected_to product_application_path(assigns(:product_application))
  end

  test "should show product_application" do
    get :show, id: @product_application
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product_application
    assert_response :success
  end

  test "should update product_application" do
    put :update, id: @product_application, product_application: { name: @product_application.name }
    assert_redirected_to product_application_path(assigns(:product_application))
  end

  test "should destroy product_application" do
    assert_difference('ProductApplication.count', -1) do
      delete :destroy, id: @product_application
    end

    assert_redirected_to product_applications_path
  end
end
