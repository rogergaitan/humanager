require 'test_helper'

class CentroDeCostosControllerTest < ActionController::TestCase
  setup do
    @centro_de_costo = centro_de_costos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:centro_de_costos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create centro_de_costo" do
    assert_difference('CentroDeCosto.count') do
      post :create, centro_de_costo: { icc_padre: @centro_de_costo.icc_padre, icentro_costo: @centro_de_costo.icentro_costo, iempresa: @centro_de_costo.iempresa, nombre_cc: @centro_de_costo.nombre_cc }
    end

    assert_redirected_to centro_de_costo_path(assigns(:centro_de_costo))
  end

  test "should show centro_de_costo" do
    get :show, id: @centro_de_costo
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @centro_de_costo
    assert_response :success
  end

  test "should update centro_de_costo" do
    put :update, id: @centro_de_costo, centro_de_costo: { icc_padre: @centro_de_costo.icc_padre, icentro_costo: @centro_de_costo.icentro_costo, iempresa: @centro_de_costo.iempresa, nombre_cc: @centro_de_costo.nombre_cc }
    assert_redirected_to centro_de_costo_path(assigns(:centro_de_costo))
  end

  test "should destroy centro_de_costo" do
    assert_difference('CentroDeCosto.count', -1) do
      delete :destroy, id: @centro_de_costo
    end

    assert_redirected_to centro_de_costos_path
  end
end
