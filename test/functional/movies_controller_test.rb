# coding: utf-8
require 'test_helper'

class MoviesControllerTest < ActionController::TestCase
  setup do
    @movie = movies(:one)
    @update = {
      :title=>"EFTest", 
      :description => "This is a 测试",
      :image_url => "http://upload.wikimedia.org/wikipedia/en/5/59/Ef_-_the_first_tale._screenshot.jpg",
      :last_updated => DateTime.parse("2012-03-27"),
      :is_finished => true
     
    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:movies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create movie" do
    assert_difference('Movie.count') do
      post :create, :movie => @update #movie: @movie.attributes
    end

    assert_redirected_to movie_path(assigns(:movie))
  end

  test "should show movie" do
    get :show, id: @movie
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @movie
    assert_response :success
  end

  test "should update movie" do
    put :update, :id =>@movie.to_param, :movie => @update #id: @movie, movie: @movie.attributes
    assert_redirected_to movie_path(assigns(:movie))
  end

  test "should destroy movie" do
    assert_difference('Movie.count', -1) do
      delete :destroy, id: @movie
    end

    assert_redirected_to movies_path
  end
end
