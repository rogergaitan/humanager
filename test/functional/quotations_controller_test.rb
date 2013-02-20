require 'test_helper'

class QuotationsControllerTest < ActionController::TestCase
  setup do
    @quotation = quotations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:quotations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create quotation" do
    assert_difference('Quotation.count') do
      post :create, quotation: { currency: @quotation.currency, discount_total: @quotation.discount_total, document_date: @quotation.document_date, document_number: @quotation.document_number, notes: @quotation.notes, payment_term: @quotation.payment_term, sub_total_free: @quotation.sub_total_free, sub_total_taxed: @quotation.sub_total_taxed, tax_total: @quotation.tax_total, total: @quotation.total, valid_to: @quotation.valid_to }
    end

    assert_redirected_to quotation_path(assigns(:quotation))
  end

  test "should show quotation" do
    get :show, id: @quotation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @quotation
    assert_response :success
  end

  test "should update quotation" do
    put :update, id: @quotation, quotation: { currency: @quotation.currency, discount_total: @quotation.discount_total, document_date: @quotation.document_date, document_number: @quotation.document_number, notes: @quotation.notes, payment_term: @quotation.payment_term, sub_total_free: @quotation.sub_total_free, sub_total_taxed: @quotation.sub_total_taxed, tax_total: @quotation.tax_total, total: @quotation.total, valid_to: @quotation.valid_to }
    assert_redirected_to quotation_path(assigns(:quotation))
  end

  test "should destroy quotation" do
    assert_difference('Quotation.count', -1) do
      delete :destroy, id: @quotation
    end

    assert_redirected_to quotations_path
  end
end
