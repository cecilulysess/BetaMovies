require 'test_helper'

class TrackingListsControllerTest < ActionController::TestCase
  setup do
    @tracking_list = tracking_lists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tracking_lists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tracking_list" do
    assert_difference('TrackingList.count') do
      post :create, tracking_list: @tracking_list.attributes
    end

    assert_redirected_to tracking_list_path(assigns(:tracking_list))
  end

  test "should show tracking_list" do
    get :show, id: @tracking_list
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tracking_list
    assert_response :success
  end

  test "should update tracking_list" do
    put :update, id: @tracking_list, tracking_list: @tracking_list.attributes
    assert_redirected_to tracking_list_path(assigns(:tracking_list))
  end

  test "should destroy tracking_list" do
    assert_difference('TrackingList.count', -1) do
      delete :destroy, id: @tracking_list
    end

    assert_redirected_to tracking_lists_path
  end
end
