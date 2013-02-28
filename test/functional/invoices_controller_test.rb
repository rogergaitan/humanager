require 'test_helper'

class InvoicesControllerTest < ActionController::TestCase
  setup do
    @invoice = invoices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:invoices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create invoice" do
    assert_difference('Invoice.count') do
      post :create, invoice: { closed: @invoice.closed, currency: @invoice.currency, discount_total: @invoice.discount_total, document_date: @invoice.document_date, document_number: @invoice.document_number, due_date: @invoice.due_date, payment_term: @invoice.payment_term, price_list: @invoice.price_list, sub_total_free: @invoice.sub_total_free, sub_total_taxed: @invoice.sub_total_taxed, tax_total: @invoice.tax_total, total: @invoice.total }
    end

    assert_redirected_to invoice_path(assigns(:invoice))
  end

  test "should show invoice" do
    get :show, id: @invoice
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @invoice
    assert_response :success
  end

  test "should update invoice" do
    put :update, id: @invoice, invoice: { closed: @invoice.closed, currency: @invoice.currency, discount_total: @invoice.discount_total, document_date: @invoice.document_date, document_number: @invoice.document_number, due_date: @invoice.due_date, payment_term: @invoice.payment_term, price_list: @invoice.price_list, sub_total_free: @invoice.sub_total_free, sub_total_taxed: @invoice.sub_total_taxed, tax_total: @invoice.tax_total, total: @invoice.total }
    assert_redirected_to invoice_path(assigns(:invoice))
  end

  test "should destroy invoice" do
    assert_difference('Invoice.count', -1) do
      delete :destroy, id: @invoice
    end

    assert_redirected_to invoices_path
  end
end
