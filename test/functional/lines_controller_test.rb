require 'test_helper'

class LinesControllerTest < ActionController::TestCase
  setup do
    @line = lines(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lines)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create line" do
    assert_difference('Line.count') do
      post :create, line: { code: @line.code, description: @line.description, income: @line.income, inventory: @line.inventory, lost_adjustment: @line.lost_adjustment, name: @line.name, purchase_return: @line.purchase_return, purchase_tax: @line.purchase_tax, sale_cost: @line.sale_cost, sale_tax: @line.sale_tax, sales_return: @line.sales_return, utility_adjusment: @line.utility_adjusment }
    end

    assert_redirected_to line_path(assigns(:line))
  end

  test "should show line" do
    get :show, id: @line
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @line
    assert_response :success
  end

  test "should update line" do
    put :update, id: @line, line: { code: @line.code, description: @line.description, income: @line.income, inventory: @line.inventory, lost_adjustment: @line.lost_adjustment, name: @line.name, purchase_return: @line.purchase_return, purchase_tax: @line.purchase_tax, sale_cost: @line.sale_cost, sale_tax: @line.sale_tax, sales_return: @line.sales_return, utility_adjusment: @line.utility_adjusment }
    assert_redirected_to line_path(assigns(:line))
  end

  test "should destroy line" do
    assert_difference('Line.count', -1) do
      delete :destroy, id: @line
    end

    assert_redirected_to lines_path
  end
end
