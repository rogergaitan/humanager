require 'test_helper'

class DetailPersonnelActionsControllerTest < ActionController::TestCase
  setup do
    @detail_personnel_action = detail_personnel_actions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:detail_personnel_actions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create detail_personnel_action" do
    assert_difference('DetailPersonnelAction.count') do
      post :create, detail_personnel_action: { value: @detail_personnel_action.value }
    end

    assert_redirected_to detail_personnel_action_path(assigns(:detail_personnel_action))
  end

  test "should show detail_personnel_action" do
    get :show, id: @detail_personnel_action
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @detail_personnel_action
    assert_response :success
  end

  test "should update detail_personnel_action" do
    put :update, id: @detail_personnel_action, detail_personnel_action: { value: @detail_personnel_action.value }
    assert_redirected_to detail_personnel_action_path(assigns(:detail_personnel_action))
  end

  test "should destroy detail_personnel_action" do
    assert_difference('DetailPersonnelAction.count', -1) do
      delete :destroy, id: @detail_personnel_action
    end

    assert_redirected_to detail_personnel_actions_path
  end
end
