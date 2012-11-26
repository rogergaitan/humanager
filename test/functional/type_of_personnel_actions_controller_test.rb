require 'test_helper'

class TypeOfPersonnelActionsControllerTest < ActionController::TestCase
  setup do
    @type_of_personnel_action = type_of_personnel_actions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:type_of_personnel_actions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create type_of_personnel_action" do
    assert_difference('TypeOfPersonnelAction.count') do
      post :create, type_of_personnel_action: { description: @type_of_personnel_action.description }
    end

    assert_redirected_to type_of_personnel_action_path(assigns(:type_of_personnel_action))
  end

  test "should show type_of_personnel_action" do
    get :show, id: @type_of_personnel_action
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @type_of_personnel_action
    assert_response :success
  end

  test "should update type_of_personnel_action" do
    put :update, id: @type_of_personnel_action, type_of_personnel_action: { description: @type_of_personnel_action.description }
    assert_redirected_to type_of_personnel_action_path(assigns(:type_of_personnel_action))
  end

  test "should destroy type_of_personnel_action" do
    assert_difference('TypeOfPersonnelAction.count', -1) do
      delete :destroy, id: @type_of_personnel_action
    end

    assert_redirected_to type_of_personnel_actions_path
  end
end
