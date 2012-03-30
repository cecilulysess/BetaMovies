require 'test_helper'

class TrackingItemsControllerTest < ActionController::TestCase
  setup do
    @tracking_item = tracking_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tracking_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tracking_item" do
    assert_difference('TrackingItem.count') do
      # post :create, tracking_item: @tracking_item.attributes
      pose :create, :movie_id => movies(:one).id
    end

    assert_redirected_to tracking_list_path(assigns(:tracking_item).tracking_list)
  end

  test "should show tracking_item" do
    get :show, id: @tracking_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tracking_item
    assert_response :success
  end

  test "should update tracking_item" do
    put :update, id: @tracking_item, tracking_item: @tracking_item.attributes
    assert_redirected_to tracking_item_path(assigns(:tracking_item))
  end

  test "should destroy tracking_item" do
    assert_difference('TrackingItem.count', -1) do
      delete :destroy, id: @tracking_item
    end

    assert_redirected_to tracking_items_path
  end
end
