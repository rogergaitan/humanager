require 'test_helper'

class DocumentNumbersControllerTest < ActionController::TestCase
  setup do
    @document_number = document_numbers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:document_numbers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create document_number" do
    assert_difference('DocumentNumber.count') do
      post :create, document_number: { description: @document_number.description, document_type: @document_number.document_type, mask: @document_number.mask, number_type: @document_number.number_type, start_number: @document_number.start_number, terminal_restriction: @document_number.terminal_restriction }
    end

    assert_redirected_to document_number_path(assigns(:document_number))
  end

  test "should show document_number" do
    get :show, id: @document_number
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @document_number
    assert_response :success
  end

  test "should update document_number" do
    put :update, id: @document_number, document_number: { description: @document_number.description, document_type: @document_number.document_type, mask: @document_number.mask, number_type: @document_number.number_type, start_number: @document_number.start_number, terminal_restriction: @document_number.terminal_restriction }
    assert_redirected_to document_number_path(assigns(:document_number))
  end

  test "should destroy document_number" do
    assert_difference('DocumentNumber.count', -1) do
      delete :destroy, id: @document_number
    end

    assert_redirected_to document_numbers_path
  end
end
